@isTest
public class SPR_WebsiteUserInboundServiceTest {

    @isTest
    public static void testPostMethod406(){
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        String requestData='{"cognito_key":"cognito_key","first_name":"gbd443","last_name":"m 3sansi44","email":"gb3d.sansi121442@gmail.com","phone":"12345367843224","birthdate":"02/07/1983","citizenship":"US Citizen","marital_status":"married","intention_to_use_fund":"intention_to_use_fund","reffered_by":"reffered_by","lead_uuid":"HTI8G83WKG"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/user/webuser/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteUserInboundService.postRequestHandler();
        
        Test.stopTest();
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testPostMethod(){
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        String requestData='{"cognito_key":"cognito_key","first_name":"gbd443","last_name":"m 3sansi44","email":"gb3d.sansi121442@gmail.com","phone":"12345367843224","birthdate":"02/07/1983","citizenship":"US Citizen","marital_status":"married","intention_to_use_fund":"intention_to_use_fund","reffered_by":"reffered_by","lead_uuid":"HTI8G83WKG"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/user/webuser/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteUserInboundService.postRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
    
    @isTest
    public static void testPutMethod406(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        String requestData='{"sfid":"'+con.Id+'","cognito_key":"cognito_key","first_name":"gbd443","last_name":"m 3sansi44","email":"gb3d.sansi121442@gmail.com","phone":"12345367843224","birthdate":"02/07/1983","citizenship":"US Citizen","marital_status":"married","intention_to_use_fund":"intention_to_use_fund","reffered_by":"reffered_by","lead_uuid":"HTI8G83WKG"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/user/webuser/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteUserInboundService.putRequestHandler();
        
        Test.stopTest();
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testPutMethod(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        String requestData='{"sfid":"'+con.Id+'","cognito_key":"cognito_key","first_name":"gbd443","last_name":"m 3sansi44","email":"gb3d.sansi121442@gmail.com","phone":"12345367843224","birthdate":"02/07/1983","citizenship":"US Citizen","marital_status":"married","intention_to_use_fund":"intention_to_use_fund","reffered_by":"reffered_by","lead_uuid":"HTI8G83WKG"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/user/webuser/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteUserInboundService.putRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
    
    
    @isTest
    public static void testGetMethod406(){
        
        User u1 = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id, LastName = 'u1', Email = 'u1@email.com',Username = 'u1@email.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US' );
        insert u1;
        SYstem.debug('u1->>'+u1.Id);  
        
        RestRequest request = new RestRequest();
         
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/user/webuser/*' ;
        request.requestURI=baseUrl;
        request.addParameter('sfid', u1.Id);
        request.httpMethod='GET';
                
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteUserInboundService.advisorRequestHandler();
        
        Test.stopTest();
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testGetMethod(){
        
        User u1 = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id, LastName = 'u1', Email = 'u1@email.com',Username = 'u1@email.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US' );
        insert u1;
        SYstem.debug('u1->>'+u1.Id);  
        
        RestRequest request = new RestRequest();
         
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/user/webuser/*' ;
        request.requestURI=baseUrl;
        request.addParameter('sfid', u1.Id);
        request.httpMethod='GET';
        request.addHeader('Referer', Label.SPR_API_Referer);
                
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteUserInboundService.advisorRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
    
    
}