@isTest
public class SPR_WebsiteLeadServiceTest {

    @isTest
    public static void testGetMethod(){
         
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        RestRequest request = new RestRequest();
         
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/Lead/record/*' ;
        request.requestURI=baseUrl;
        request.addParameter('leadUUID','HTI8G83WKG');
        request.httpMethod='GET';
                
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLeadService.leadExistRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
    @isTest
    public static void testGetMethod404(){
         
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        RestRequest request = new RestRequest();
         
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/Lead/record/*' ;
        request.requestURI=baseUrl;
        request.addParameter('leadUUID','HTI8G83WKG');
        request.httpMethod='GET';
        request.addHeader('Referer', Label.SPR_API_Referer);
                
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLeadService.leadExistRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
}