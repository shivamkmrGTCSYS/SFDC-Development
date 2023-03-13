global class SPR_LeadSevice{
    global cls_LeadRequest leadRequest;
    global cls_LeadResponse leadResponse;
    
    global class cls_LeadRequest {
        global String firstname;
        global String lastname;
        global String email;
        global String phone;
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
          
        global String BrokerAccount; 
        global String LoanOfficer;  
        global String AccountExecutive; 
        global String RecordType; 
        global String creditScore;  
        
    }
    
    global class cls_LeadResponse{
        global Boolean success;
        global String sfid;
        global String filenumber;
        global String message;
        global Integer statusCode;
    }
}