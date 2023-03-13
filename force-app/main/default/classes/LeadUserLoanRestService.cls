@RestResource(urlMapping='/LeadLoanUserService/*')

global class LeadUserLoanRestService {
    
    @HttpPost
    global static void PostLeadInfo(){
        
        RestResponse resp = RestContext.response;
        RestRequest Req = RestContext.request; 
        
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            response.put('success','false');
            resp.responseBody = Blob.valueOf(JSON.serialize(response));
            resp.statusCode = 406;
            
            return;
        }
        
        
        leadAppConOppRapper.getLead jsonFile = (leadAppConOppRapper.getLead)JSON.deserialize(jsonPayload,leadAppConOppRapper.getLead.class);
        System.debug('jsonFile-->'+jsonFile);
                
        
        List<contact> conList = [SELECT id, Name, MobilePhone, Email, MailingStreet, MailingCity,
                                 MailingState, MailingPostalCode, Address__c FROM Contact WHERE 
                                 Email=: jsonFile.Email];
        
        
        system.debug('conList::'+conList);
        List<leadAppConOppRapper.ContactResult> conResultList = new List<leadAppConOppRapper.ContactResult>();
        
        for(contact con : conList){
            leadAppConOppRapper.ContactResult conn = new leadAppConOppRapper.ContactResult();
            conn.Id = con.Id;
            conn.Name = con.Name;
            conn.MobilePhone = con.MobilePhone;
            conn.Email = con.Email;
            conn.MailingStreet = con.MailingStreet;
            conn.MailingCity = con.MailingCity;
            conn.MailingState = con.MailingState;
            conn.MailingPostalCode = con.MailingPostalCode;
            conn.Address = con.Address__c;
            conResultList.add(conn);
        }
        
        List<Lead> leadlist =[SELECT id, Name, Phone, Email, Status, Street, City,
                              State, PostalCode, Hmac_Id__c, Address, 
                              Place_Key__c, Web_UUID__c, 
                              ConvertedOpportunityId, ConvertedOpportunity.Name, ConvertedOpportunity.StageName, 
                              ConvertedOpportunity.Contact_Phone__c, ConvertedOpportunity.Owner_Email__c, 
                              ConvertedOpportunity.Owner_Alt_Email__c, ConvertedOpportunity.Property__r.Street__c,
                              ConvertedOpportunity.Property__r.City__c, ConvertedOpportunity.Property__r.State_Province__c,
                              ConvertedOpportunity.Property__r.Zip_Postal_Code__c
                              FROM Lead
                              WHERE Email=: jsonFile.Email 
                              		AND ((Hmac_Id__c =:jsonFile.HmacId AND Hmac_Id__c!=null AND Hmac_Id__c!='')
                                   	OR (Place_Key__c =:jsonFile.PlaceKey AND Place_Key__c !=null AND Place_Key__c !='') 
                                   	OR (Street =: jsonFile.Street 
                                    AND City = : jsonFile.City
                                    AND PostalCode = :jsonFile.PostalCode 
                                    AND State = : jsonFile.State)) ];
        
        system.debug('leadlist::'+leadlist);
        /*
        List<contact> conList = [SELECT id, Name, MobilePhone, Email, MailingStreet, MailingCity,
        MailingState, MailingPostalCode, Address__c FROM Contact WHERE 
        Email=: jsonFile.Email AND 
        (MailingStreet =: jsonFile.Street AND MailingCity = : jsonFile.City AND 
        MailingPostalCode = :jsonFile.PostalCode AND MailingState = : jsonFile.State)];
        */
        /*  
            List<Opportunity> oppList  = [SELECT Id, Name, StageName, Contact_Phone__c, Owner_Email__c, Owner_Alt_Email__c, Property__r.Street__c,
            Property__r.City__c, Property__r.State_Province__c,Property__r.Zip_Postal_Code__c
            FROM Opportunity 
            WHERE  Owner_Email__c =: jsonFile.Email  
            AND(Property__r.Street__c =:jsonFile.Street 
            AND Property__r.City__c=:jsonFile.City 
            AND Property__r.State_Province__c=:jsonFile.State 
            AND Property__r.Zip_Postal_Code__c=:jsonFile.PostalCode)];
		*/
        
        list<leadAppConOppRapper.OpportunityResult> oppResultList = new list<leadAppConOppRapper.OpportunityResult>();
        list<leadAppConOppRapper.LeadResult> leadResultList = new list<leadAppConOppRapper.LeadResult>();
        
        List<String> ledIds = new List<String>();
        for(Lead le : leadlist){
            
            leadAppConOppRapper.LeadResult lead = new leadAppConOppRapper.LeadResult();
            leadAppConOppRapper.OpportunityResult opp = new leadAppConOppRapper.OpportunityResult();
            
            lead.Id = le.Id;
            lead.Name = le.Name;
            lead.Phone = le.Phone;
            lead.Email = le.Email;
            lead.Status = le.Status;
            lead.Street = le.Street;
            lead.City = le.City;
            lead.State = le.State;
            lead.PostalCode = le.PostalCode;
            lead.HmacId = le.Hmac_Id__c;
            lead.Address = le.Address;
            lead.PlaceKey = le.Place_Key__c;
            lead.WebUUID = le.Web_UUID__c;
            ledIds.add(le.Id);
            
            if(le.ConvertedOpportunityId!=null){
                opp.Id = le.ConvertedOpportunityId;
                opp.Name = le.ConvertedOpportunity.Name;
                opp.StageName = le.ConvertedOpportunity.StageName;
                opp.ContactPhone =le.ConvertedOpportunity.Contact_Phone__c;
                opp.OwnerEmail = le.ConvertedOpportunity.Owner_Email__c;
                opp.OwnerAltEmail  = le.ConvertedOpportunity.Owner_Alt_Email__c;
                opp.PropertyStreet = le.ConvertedOpportunity.Property__r.Street__c;
                opp.PropertyCity = le.ConvertedOpportunity.Property__r.City__c;
                opp.PropertyStateProvince = le.ConvertedOpportunity.Property__r.State_Province__c;
                opp.PropertyZipPostalCode = le.ConvertedOpportunity.Property__r.Zip_Postal_Code__c;                
                
                oppResultList.add(opp);
            }
            leadResultList.add(lead);
        }
        System.debug('ledIds-->'+ledIds);
        List<Application__c> Applist =[SELECT id, Name, Phone_Number__c, Email__c, Web_UUID__c, Status__c, Street__c, City__c,
                                       State__c, Zip_Postal_Code__c, Property_Address__c,
                                       Step_1_Completion_Status__c, Step_2_Completion_Status__c, 
                                       Step_3_Completion_Status__c, Step_4_Completion_Status__c,
                                       Step_5_Completion_Status__c, Step_6_Completion_Status__c,
                                       Step_7_Completion_Status__c 
                                       FROM Application__c
                                       WHERE Lead__c IN :ledIds /*Email__c=: jsonFile.Email 
                                       AND Street__c =: jsonFile.Street 
                                       AND City__c = : jsonFile.City 
                                       AND Zip_Postal_Code__c = :jsonFile.PostalCode 
                                       AND State__c = : jsonFile.State*/];
        
        system.debug('Applist::'+Applist);
        
        List<leadAppConOppRapper.ApplicationResult> appResultList = new List<leadAppConOppRapper.ApplicationResult>();
        for(Application__c app : Applist){
            leadAppConOppRapper.ApplicationResult appl = new leadAppConOppRapper.ApplicationResult();
            appl.Id = app.Id;
            appl.Name = app.Name;
            appl.PhoneNumber = app.Phone_Number__c;
            appl.Email = app.Email__c;
            appl.Status = app.Status__c;
            appl.Street = app.Street__c;
            appl.City = app.City__c;
            appl.State = app.State__c;
            appl.ZipPostalCode = app.Zip_Postal_Code__c;
            appl.Step1CompletionStatus = app.Step_1_Completion_Status__c;
            appl.Step2CompletionStatus = app.Step_2_Completion_Status__c;
            appl.Step3CompletionStatus = app.Step_3_Completion_Status__c;
            appl.Step4CompletionStatus = app.Step_4_Completion_Status__c;
            appl.Step5CompletionStatus = app.Step_5_Completion_Status__c;
            appl.Step6CompletionStatus = app.Step_6_Completion_Status__c;
            appl.Step7CompletionStatus = app.Step_7_Completion_Status__c;
            appl.PropertyAddress = app.Property_Address__c;
            appl.WebUUID = app.Web_UUID__c;
            
            appResultList.add(appl);
        }
        
        system.debug('conList::'+conList);
        
        Map<String,Object> response = new Map<String,Object>(); 
        
        Map<String,Object> LeadConAppoppResponse = new Map<String,Object>(); 
        LeadConAppoppResponse.put('Lead',leadResultList); // LeadList
        LeadConAppoppResponse.put('Loan',appResultList); // LoanList
        LeadConAppoppResponse.put('User',conResultList); // conList
        LeadConAppoppResponse.put('opportunity',oppResultlist); // oppList
        LeadConAppoppResponse.put('success','true');
        system.debug('LeadConAppoppResponse::'+LeadConAppoppResponse);
        
        response.put('data',LeadConAppoppResponse);
        
        resp.responseBody = Blob.valueOf(JSON.serialize(response));
        resp.statusCode = 200;
        
        return;
    }
    
    
    
    @HttpPut
    global static void UpdateLead(){
        
        
        RestResponse resp = RestContext.response;
        RestRequest Req = RestContext.request; 
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            response.put('success','false');
            response.put('statusCode','400');
            resp.responseBody = Blob.valueOf(JSON.serialize(response));
            
            return ;
        }
        
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
        
        leadAppConOppRapper.updateLeadRequest jsonFile = (leadAppConOppRapper.updateLeadRequest)JSON.deserialize(jsonPayload,leadAppConOppRapper.updateLeadRequest.class);
        System.debug('jsonFile-->'+jsonFile);
        
        Map<string, string> paramsMap = RestContext.request.params;
        List<Lead> ledList = [Select Id From Lead Where id=:jsonFile.sfid] ;
        System.debug('jsonFile.sfid ---->'+ jsonFile.sfid);
        if(ledList.size()==0){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Lead Id'); 
            response.put('success','false');
            response.put('statusCode','400');
            resp.responseBody = Blob.valueOf(JSON.serialize(response));
            
            
            return ;
        }
        string LeadId = jsonFile.sfid;
        
        Lead updateLead = new Lead();
        
        updateLead.id = jsonFile.sfid;
        
        if(jsonFile.firstname != null)updateLead.FirstName = jsonFile.firstname;
        if(jsonFile.lastname != null)updateLead.LastName = jsonFile.lastname;
        if(jsonFile.email != null)updateLead.Email = jsonFile.email;
        
        system.debug('jsonFile.Status::'+jsonFile.Status);
        if(jsonFile.status != null)updateLead.Status = jsonFile.status;
        
        if(jsonFile.phone != null)updateLead.Phone = jsonFile.phone;
        if(jsonFile.firstname != null && jsonFile.lastname != null )updateLead.Company = jsonFile.firstname+' '+jsonFile.lastname; 
        if(jsonFile.street != null)updateLead.Street = jsonFile.street;
        if(jsonFile.city != null)updateLead.City = jsonFile.city;
        if(jsonFile.state != null)updateLead.State = jsonFile.state;
        if(jsonFile.zipcode != null)updateLead.PostalCode = jsonFile.zipcode;
        if(jsonFile.preQualificationValue != null)updateLead.Prequalification_Amount__c = jsonFile.preQualificationValue;
        if(jsonFile.fundRequiredTimeline != null)updateLead.Timeline_To_Fund__c = jsonFile.fundRequiredTimeline;
        if(jsonFile.leadUuid != null)updateLead.Web_UUID__c = jsonFile.leadUuid;
        if(jsonFile.refferedBy != null)updateLead.hear_about_us__c = jsonFile.refferedBy;
        if(jsonFile.homeEstimatedPrice != null)updateLead.Est_Home_Value__c = jsonFile.homeEstimatedPrice;
        if(jsonFile.investmentAmount != null)updateLead.Est_Home_Value_Zillow__c = jsonFile.investmentAmount;
        if(jsonFile.user_account_creation_link != null)updateLead.User_Account_Creation_Link__c = jsonFile.user_account_creation_link;
        if(jsonFile.getReportID != null)updateLead.Get_Report_Id__c = jsonFile.getReportID;
        if(jsonFile.exportReportID != null)updateLead.Export_Report_Id__c = jsonFile.exportReportID;
        if(jsonFile.hmacID != null)updateLead.Hmac_Id__c = jsonFile.hmacID;
        if(jsonFile.placeKey != null)updateLead.Place_Key__c = jsonFile.placeKey;
        if(jsonFile.firstEstimatedOpenLienBalance != null)updateLead.First_Estimated_Open_Lien_Balance__c = jsonFile.firstEstimatedOpenLienBalance!=null?Decimal.valueOf(jsonFile.firstEstimatedOpenLienBalance):0;
        if(jsonFile.secondEstimatedOpenLienBalance != null)updateLead.Second_Estimated_Open_Lien_Balance__c = jsonFile.secondEstimatedOpenLienBalance!=null?Decimal.valueOf(jsonFile.secondEstimatedOpenLienBalance):0;
        if(jsonFile.leadSource != null)updateLead.LeadSource =  jsonFile.leadSource;
        if(jsonFile.estHomeValueC != null)updateLead.Est_Home_Value__c = jsonFile.estHomeValueC!=null?Decimal.valueOf(jsonFile.estHomeValueC):0;
        if(jsonFile.estHomeValueZillowC != null)updateLead.Est_Home_Value_Zillow__c = jsonFile.estHomeValueZillowC!=null?Decimal.valueOf(jsonFile.estHomeValueZillowC):0;
        if(jsonFile.repotedLienAmountsC != null)updateLead.Reported_Lien_Amounts__c = jsonFile.repotedLienAmountsC!=null?Decimal.valueOf(jsonFile.repotedLienAmountsC):0;
        if(jsonFile.timelineToFundC != null)updateLead.Timeline_To_Fund__c = jsonFile.timelineToFundC;
        if(jsonFile.company != null)updateLead.Company = jsonFile.company;
        if(jsonFile.hearAboutUs != null)updateLead.How_Did_You_Hear_About_Us__c = jsonFile.hearAboutUs;
        if(jsonFile.landuse != null)updateLead.Property_Type_First_AM__c = jsonFile.landuse;
        if(jsonFile.PropertyId != null)updateLead.Property_Id__c = jsonFile.PropertyId;
        if(jsonFile.ownersAll != null)updateLead.Owner_of_Record_tax__c = jsonFile.ownersAll;
        if(jsonFile.ownerRightsVestingCode != null)updateLead.Vesting__c = jsonFile.ownerRightsVestingCode;
        if(jsonFile.county != null)updateLead.County__c = jsonFile.county;
        if(jsonFile.legalDescription != null)updateLead.Legal_Description__c = jsonFile.legalDescription;
        if(jsonFile.APNFormatted != null)updateLead.APN__c = jsonFile.APNFormatted;
        if(jsonFile.latitude != null)updateLead.First_American_Lat_Long__Latitude__s = jsonFile.latitude!=null?Decimal.valueOf(jsonFile.latitude):0;
        if(jsonFile.longitude != null)updateLead.First_American_Lat_Long__Longitude__s = jsonFile.longitude!=null?Decimal.valueOf(jsonFile.longitude):0;
        if(jsonFile.ACRES != null)updateLead.Lot_Size_acres__c = jsonFile.ACRES;
        if(jsonFile.FloodZoneCode != null)updateLead.Flood_Zone__c = jsonFile.FloodZoneCode;
        if(jsonFile.BuildingAreaSqft != null)updateLead.Square_Feet__c = jsonFile.BuildingAreaSqft;
        if(jsonFile.sumOfBedRooms != null)updateLead.Beds__c = jsonFile.sumOfBedRooms;
        if(jsonFile.fullBaths != null)updateLead.Baths__c = jsonFile.fullBaths;
        if(jsonFile.halfBaths != null)updateLead.Half_Bath__c = jsonFile.halfBaths;
        if(jsonFile.yearBuilt != null)updateLead.Year_Built__c = jsonFile.yearBuilt;
        if(jsonFile.ownerStatus != null)updateLead.Occupancy_Status__c = jsonFile.ownerStatus;
        if(jsonFile.utm_source != null)updateLead.utm_source__c = jsonFile.utm_source;
        if(jsonFile.utm_medium != null)updateLead.utm_medium__c = jsonFile.utm_medium;
        if(jsonFile.utm_campaign != null)updateLead.utm_campaign__c = jsonFile.utm_campaign;
        if(jsonFile.utm_term != null)updateLead.utm_term__c = jsonFile.utm_term;
        if(jsonFile.utm_content != null)updateLead.utm_content__c = jsonFile.utm_content;
        if(jsonFile.ipAddress != null)updateLead.SubmitterIP__c = jsonFile.ipAddress;
        if(jsonFile.pageUuid != null)updateLead.UnbouncePageID__c = jsonFile.pageUuid;
        if(jsonFile.variant != null)updateLead.UnbouncePageVariant__c = jsonFile.variant;
        if(jsonFile.timeSubmitted != null)updateLead.UnbounceSubmissionTime__c = jsonFile.timeSubmitted;
        if(jsonFile.dateSubmitted != null)updateLead.UnbounceSubmissionDate__c = date.parse(jsonFile.dateSubmitted);
        if(jsonFile.pageUrl != null)updateLead.UnbouncePageID__c = jsonFile.pageUrl; 
        if(jsonFile.source != null)updateLead.Source__c = jsonFile.source;
        
        Map<String,Object> response = new Map<String,Object>(); 
        
        response.put('data',updateLead);
        
        
        try{
            update updateLead;
            response.put('message','Lead Updated Successfully'); 
            response.put('success','true');
            response.put('statusCode','200');
            
            resp.responseBody = Blob.valueOf(JSON.serialize(response));
            
        }catch(StringException e){
            
            response.put('message',e.getMessage()); 
            response.put('success','false');
            response.put('statusCode','400'); 
            resp.responseBody = Blob.valueOf(JSON.serialize(response));
        }catch(Exception e){
            
            response.put('message',e.getMessage()); 
            response.put('success','false');
            response.put('statusCode','400'); 
            resp.responseBody = Blob.valueOf(JSON.serialize(response));    
        }
        //response.put('data',LeadConAppoppResponse);
        
        //return updateLead; 
    }
    
}