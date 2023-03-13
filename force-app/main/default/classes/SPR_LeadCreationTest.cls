@isTest
public class SPR_LeadCreationTest {

    @isTest
    public static void coverLeadCreate406(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/sprleadcreate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serializePretty(getSampleRequest(true)));
        req.addHeader('Referer', 'https://ok0geojkfk.execute-api.us-east-1.amazonaws.com/dev');
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        SPR_LeadCreation.createLead();
        Test.stopTest();
    }
    
     @isTest
    public static void coverLeadCreate(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/sprleadcreate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serializePretty(getSampleRequest(true)));
        req.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        SPR_LeadCreation.createLead();
        Test.stopTest();
    }
    
    @isTest
    public static void coverLeadCreateWithError(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/sprleadcreate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serializePretty(getSampleRequest(false)));
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        SPR_LeadCreation.createLead();
        Test.stopTest();
    }
    
    @isTest
    public static void coverLeadCreateWithError1(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/sprleadcreate/';
        req.httpMethod = 'POST';
        req.addHeader('Referer', Label.SPR_API_Referer);
        SPR_LeadSevice.cls_leadRequest reqBody = new SPR_LeadSevice.cls_leadRequest();
        
        reqBody.firstname = 'Rahul';
        reqBody.lastname = 'RahulMM';
        reqBody.email = 'Rahul@test.com';
        reqBody.phone = '32323';
        reqBody.noOpps=true;
        reqBody.dateSubmitted='11/01/2022';
        reqBody.RecordType ='Wholesale';	
        
        req.requestBody = Blob.valueOf(JSON.serializePretty(reqBody));
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Account objAcc = new Account();
        objAcc.Name = 'Test';
        insert objAcc;
        
        Contact objCon = new contact();
        objCon.LastName = 'Test';
        insert objCon;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        user u;
       // Insert as current user
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            u = new User(alias = 'jsmith', email='jsmith@testacme.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id,
                timezonesidkey='America/Los_Angeles', 
                username='jsmit33433h@acmteste.com');
            insert u;
        }
        
        Test.startTest();
        SPR_LeadCreation.createLead();
        
        //to cover account if
        reqBody.BrokerAccount = objAcc.Id;
        req.requestBody = Blob.valueOf(JSON.serializePretty(reqBody));
        SPR_LeadCreation.createLead();
        
        //to cover contact if
        reqBody.LoanOfficer = objCon.Id;
        req.requestBody = Blob.valueOf(JSON.serializePretty(reqBody));
        SPR_LeadCreation.createLead();
        
        //to cover user if
        reqBody.AccountExecutive = u.Id;
        req.requestBody = Blob.valueOf(JSON.serializePretty(reqBody));
        SPR_LeadCreation.createLead();
        
        //to cover insert success
        reqBody.Company ='Test';
        req.requestBody = Blob.valueOf(JSON.serializePretty(reqBody));
        SPR_LeadCreation.createLead();
        
        Test.stopTest();
    }
    
    public static SPR_LeadSevice.cls_leadRequest getSampleRequest(Boolean isValid){
        SPR_LeadSevice.cls_leadRequest req = new SPR_LeadSevice.cls_leadRequest();
        if(isValid){
            req.firstname = 'Rahul';
            req.lastname = 'RahulMM';
            req.email = 'Rahul@test.com';
            req.phone = '32323';
            req.noOpps=true;
            req.dateSubmitted='11/01/2022';
        }
        
        return req;
        
    }

}