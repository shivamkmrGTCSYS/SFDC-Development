@isTest
public class SPR_WebsiteFileInboundServiceTest {

    @isTest
    public static void testPostMethod406(){
        
        Application__c app = new Application__c( );
        
        insert app;
        String requestData='{"aws_file_key":"aws file key1","aws_file_full_path":"aws file full path1","document_key":"document key1","loan_sfid":"'+app.Id+'"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/file/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteFileInboundService.postRequestHandler();
        
        Test.stopTest();
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testPostMethod(){
        
        Application__c app = new Application__c( );
        
        insert app;
        String requestData='{"aws_file_key":"aws file key1","aws_file_full_path":"aws file full path1","document_key":"document key1","loan_sfid":"'+app.Id+'"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/file/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteFileInboundService.postRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
    
    @isTest
    public static void testPutMethod406(){
        
        Application__c app = new Application__c( );
        
        insert app;
        Amazon_S3_Files__c a3files = new Amazon_S3_Files__c();
         
        a3files.AWS_File_Key__c='aws_file_key';
        a3files.File_Path__c='aws_file_full_path';
        a3files.Document_Key__c='document_key';
        a3files.Application__c=app.Id;
        insert a3files;
        
        String requestData='{"sfid":"'+a3files.Id+'","aws_file_key":"aws file key1","aws_file_full_path":"aws file full path1","document_key":"document key1","loan_sfid":"'+app.Id+'"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/file/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='PUT';
        request.requestBody=Blob.valueOf(requestData);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteFileInboundService.putRequestHandler();
        
        Test.stopTest();
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testPutMethod(){
        
        Application__c app = new Application__c( );
        
        insert app;
        Amazon_S3_Files__c a3files = new Amazon_S3_Files__c();
         
        a3files.AWS_File_Key__c='aws_file_key';
        a3files.File_Path__c='aws_file_full_path';
        a3files.Document_Key__c='document_key';
        a3files.Application__c=app.Id;
        insert a3files;
        
        String requestData='{"sfid":"'+a3files.Id+'","aws_file_key":"aws file key1","aws_file_full_path":"aws file full path1","document_key":"document key1","loan_sfid":"'+app.Id+'"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/file/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='PUT';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteFileInboundService.putRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
    
    
    @isTest
    public static void testDeleteMethod406(){
        
        Application__c app = new Application__c( );
        
        insert app;
        Amazon_S3_Files__c a3files = new Amazon_S3_Files__c();
         
        a3files.AWS_File_Key__c='aws_file_key';
        a3files.File_Path__c='aws_file_full_path';
        a3files.Document_Key__c='document_key';
        a3files.Application__c=app.Id;
        insert a3files;
        
        String requestData='{"sfid":"'+a3files.Id+'","aws_file_key":"aws file key1","aws_file_full_path":"aws file full path1","document_key":"document key1","loan_sfid":"'+app.Id+'"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/file/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='DELETE';
        request.requestBody=Blob.valueOf(requestData);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteFileInboundService.deleteRequestHandler();
        
        Test.stopTest();
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testDeleteMethod(){
        
        Application__c app = new Application__c( );
        
        insert app;
        Amazon_S3_Files__c a3files = new Amazon_S3_Files__c();
         
        a3files.AWS_File_Key__c='aws_file_key';
        a3files.File_Path__c='aws_file_full_path';
        a3files.Document_Key__c='document_key';
        a3files.Application__c=app.Id;
        insert a3files;
        
        String requestData='{"sfid":"'+a3files.Id+'","aws_file_key":"aws file key1","aws_file_full_path":"aws file full path1","document_key":"document key1","loan_sfid":"'+app.Id+'"}';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/file/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='DELETE';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteFileInboundService.deleteRequestHandler();
        
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    
    }
    
    
}