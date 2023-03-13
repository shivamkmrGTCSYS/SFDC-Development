@RestResource(urlMapping = '/sprleadcreate/*')
global without sharing class SPR_LeadCreation {
    
    @HttpPost
    global static SPR_LeadSevice.cls_leadResponse createLead() {
        SPR_LeadSevice.cls_leadResponse response = new SPR_LeadSevice.cls_leadResponse();
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
         
        if(jsonReferer!=Label.SPR_API_Referer){ 
            response.statusCode = 400;
            response.message='Invalid Referer';
            response.success=false;
            return response;
        }
         
        try{ 
            RestRequest req = RestContext.request;
            Blob body = req.requestBody;
            String requestBody = body.toString();
            
            SPR_LeadSevice.cls_leadRequest lReq = (SPR_LeadSevice.cls_leadRequest)JSON.deserialize(requestBody, SPR_LeadSevice.cls_leadRequest.class);
            System.debug('lReq-->'+lReq);  
            List<RecordType> rtList = [Select Id, DeveloperName From RecordType Where sObjectType='Lead' and DeveloperName=:lReq.RecordType];
            Lead lRecord = generateLeadData(lReq);
            if(rtList.size()==0){
                response.statusCode = 400;
                response.message='Invalid Record Type';
                response.success=false;
                return response;
            }
            
            if(lReq.RecordType=='Wholesale'){                
                 
                List<Account> accList = [Select Id From Account Where Id=:lReq.BrokerAccount];
                if(accList.size()==0){
                    response.statusCode = 400;
                    response.message='Invalid Broker Account';
                    response.success=false;
                    return response; 
                }
                
                List<Contact> contactList = [Select Id From Contact Where Id=:lReq.LoanOfficer];
                if(contactList.size()==0){
                    response.statusCode = 400;
                    response.message='Invalid Loan Officer';
                    response.success=false;
                    return response;
                }
                List<User> userList = [Select Id From User Where Id=:lReq.AccountExecutive];
                if(userList.size()==0){
                    response.statusCode = 400;
                    response.message='Invalid Account Executive';
                    response.success=false;
                    return response;                
                }
            }else{
                lRecord.Timeline_To_Fund__c = lReq.fundRequiredTimeline;
            }
                        
            lRecord.RecordTypeId=rtList[0].Id;
            System.debug('lReq-->'+lRecord); 
            try{
                insert lRecord;
                response.statusCode = 200;
                response.success = true;
                response.sfid = lRecord.Id;
                response.message='Lead created successfully';
                response.filenumber= [SELECT Splitero_File_Number__c FROM Lead WHERE Id=:lRecord.Id].Splitero_File_Number__c;
            }catch(Exception e){
                response.statusCode = 400;
                response.success = false;                 
                response.message=e.getMessage(); 
                System.debug('response.message-->'+e.getMessage()); 
            }
            
        }catch(Exception e) { 
            response.statusCode = 400;
            response.success = false;
            response.message = e.getMessage();  
        }
        
        return response;
    }
    
    public static Lead generateLeadData(SPR_LeadSevice.cls_leadRequest lReq){
        Lead lRecord = new Lead();
        lRecord.FirstName = lReq.firstname;
        lRecord.LastName = lReq.lastname;
        lRecord.Email = lReq.email;
        lRecord.Phone = lReq.phone;
        lRecord.Company = lReq.firstname+' '+lReq.lastname; 
        lRecord.Street = lReq.street;
        lRecord.City = lReq.city;
        lRecord.State = lReq.state;
        lRecord.PostalCode = lReq.zipcode;
        lRecord.Prequalification_Amount__c = lReq.preQualificationValue;
        
        lRecord.Web_UUID__c = lReq.leadUuid;
        lRecord.hear_about_us__c = lReq.refferedBy;
        lRecord.Est_Home_Value__c = lReq.homeEstimatedPrice;
        lRecord.Est_Home_Value_Zillow__c = lReq.investmentAmount;
        lRecord.User_Account_Creation_Link__c = lReq.user_account_creation_link;
        lRecord.Get_Report_Id__c = lReq.getReportID;
        lRecord.Export_Report_Id__c = lReq.exportReportID;
        lRecord.Hmac_Id__c = lReq.hmacID;
        lRecord.Place_Key__c = lReq.placeKey;
        System.debug('lReq.noOpps-->'+lReq.noOpps); 
        if(lReq.noOpps==true){
            lRecord.Status='Lost - No Opp';
        }
        
        lRecord.First_Estimated_Open_Lien_Balance__c = lReq.firstEstimatedOpenLienBalance!=null?Decimal.valueOf(lReq.firstEstimatedOpenLienBalance):0;
        lRecord.Second_Estimated_Open_Lien_Balance__c = lReq.secondEstimatedOpenLienBalance!=null?Decimal.valueOf(lReq.secondEstimatedOpenLienBalance):0;
        lRecord.LeadSource =  lReq.leadSource;
        lRecord.Est_Home_Value__c = lReq.estHomeValueC!=null?Decimal.valueOf(lReq.estHomeValueC):0;
        lRecord.Est_Home_Value_Zillow__c = lReq.estHomeValueZillowC!=null?Decimal.valueOf(lReq.estHomeValueZillowC):0;
        lRecord.Reported_Lien_Amounts__c = lReq.repotedLienAmountsC!=null?Decimal.valueOf(lReq.repotedLienAmountsC):0;
        lRecord.Timeline_To_Fund__c = lReq.timelineToFundC;
        lRecord.Company = lReq.company;
        lRecord.How_Did_You_Hear_About_Us__c = lReq.hearAboutUs;
        lRecord.Property_Type_First_AM__c = lReq.landuse;
        lRecord.Property_Id__c = lReq.PropertyId;
        lRecord.Owner_of_Record_tax__c = lReq.ownersAll;
        lRecord.Vesting__c = lReq.ownerRightsVestingCode;
        lRecord.County__c = lReq.county;
        lRecord.Legal_Description__c = lReq.legalDescription;
        lRecord.APN__c = lReq.APNFormatted;
        lRecord.First_American_Lat_Long__Latitude__s = lReq.latitude!=null?Decimal.valueOf(lReq.latitude):0;
        lRecord.First_American_Lat_Long__Longitude__s = lReq.longitude!=null?Decimal.valueOf(lReq.longitude):0;
        lRecord.Lot_Size_acres__c = lReq.ACRES;
        lRecord.Flood_Zone__c = lReq.FloodZoneCode;
        lRecord.Square_Feet__c = lReq.BuildingAreaSqft;
        lRecord.Beds__c = lReq.sumOfBedRooms;
        lRecord.Baths__c = lReq.fullBaths;
        lRecord.Half_Bath__c = lReq.halfBaths;
        lRecord.Year_Built__c = lReq.yearBuilt;
        lRecord.Occupancy_Status__c = lReq.ownerStatus;
        lRecord.utm_source__c = lReq.utm_source;
        lRecord.utm_medium__c = lReq.utm_medium;
        lRecord.utm_campaign__c = lReq.utm_campaign;
        lRecord.utm_term__c = lReq.utm_term;
        lRecord.utm_content__c = lReq.utm_content;
        lRecord.SubmitterIP__c = lReq.ipAddress;
        lRecord.UnbouncePageID__c = lReq.pageUuid;
        lRecord.UnbouncePageVariant__c = lReq.variant;
        lRecord.UnbounceSubmissionTime__c = lReq.timeSubmitted;
        lRecord.UnbounceSubmissionDate__c = date.parse(lReq.dateSubmitted);
        lRecord.UnbouncePageID__c = lReq.pageUrl; 
        lRecord.Source__c = lReq.source;
        
        lRecord.Broker_Account__c = lReq.BrokerAccount;
        lRecord.Loan_Officer__c = lReq.LoanOfficer;
        lRecord.How_Did_You_Hear_About_Us__c = lReq.hearAboutUs;
        lRecord.Account_Executive__c = lReq.AccountExecutive;        
        lRecord.User_Submitted_Credit_Score__c = lReq.creditScore;
          
        return lRecord;
    }
    
}