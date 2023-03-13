global class leadAppConOppRapper {
   
    global updateLeadRequest leadRequest;
    global getLead leadResponces;
    
     global class updateLeadRequest {
        global string sfid;
        global String firstname;
        global String lastname;
        global String email;
        global String phone;
        global string status;
        global String street;
        global String city;
        global String state;
        global String zipCode;
        global Decimal investmentAmount;
        global Decimal homeEstimatedPrice;
        global Decimal preQualificationValue;
        global String fundRequiredTimeline;
        global String leadUuid;
        global String refferedBy;
        global String user_account_creation_link;
        global String getReportID;
        global String exportReportID;
        global String hmacID;
        global String placeKey;
        global Boolean noOpps;
        
        global String firstEstimatedOpenLienBalance;
        global String secondEstimatedOpenLienBalance;
        global String leadSource;
        global String estHomeValueC;
        global String estHomeValueZillowC;
        global String repotedLienAmountsC;
        global String timelineToFundC;
        global String company;
        global String hearAboutUs;
        global String landuse;
        global String PropertyId;
        global String ownersAll;
        global String ownerRightsVestingCode;
        global String county;
        global String legalDescription;
        global String APNFormatted;
        global String latitude;
        global String longitude;
        global String ACRES;
        global String FloodZoneCode;
        global String BuildingAreaSqft;
        global String sumOfBedRooms;
        global String fullBaths;
        global String halfBaths;
        global String yearBuilt;
        global String ownerStatus;
        global String utm_source;
        global String utm_medium;
        global String utm_campaign;
        global String utm_term;
        global String utm_content;
        global String ipAddress;
        global String pageUuid;
        global String variant;
        global String timeSubmitted;
        global String dateSubmitted;
        global String pageUrl;
        global String source;
     }
     global class getLead{
        global String Street;
        global String City;
        global String State;
        global String PostalCode;
        global String HmacId;
        global String PlaceKey;
        global String Email;
        
    } 
    
    global class LeadResult{
        global String Id;
        global String Name; 
        global String Phone;
        global String Email;
        global String Status;
        global String Street;
        global String City;
        global String State;
        global String PostalCode;
        global String HmacId;
        global address Address;
        global String PlaceKey;
        global String WebUUID; 
       
        
    }
    global class OpportunityResult{
        global String Id;
        global String Name;
        global String StageName;
        global String ContactPhone;
        global String OwnerEmail;
        global String OwnerAltEmail;
        global String PropertyStreet;
        global String PropertyCity;
        global String PropertyStateProvince;
        global String PropertyZipPostalCode;        
    }
     
    global class ApplicationResult{
        global String Id;
        global String Name;
        global String PhoneNumber;
        global String Email;
        global String Status;
        global String Street;
        global String City;
        global String State;
        global String ZipPostalCode;
        global String Step1CompletionStatus;
        global String Step2CompletionStatus;
        global String Step3CompletionStatus;
        global String Step4CompletionStatus;
        global String Step5CompletionStatus;
        global String Step6CompletionStatus;
        global String Step7CompletionStatus;
        global String PropertyAddress;
        global String WebUUID; 
       
                
    }
    global class ContactResult{
        global String Id;
        global String Name;
        global String MobilePhone;
        global String Email;
        global String MailingStreet;
        global String MailingCity;
        global String MailingState;
        global String MailingPostalCode;
        global String Address;            
    } 
        
}