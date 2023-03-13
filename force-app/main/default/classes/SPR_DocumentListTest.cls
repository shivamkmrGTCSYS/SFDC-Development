@isTest
public class SPR_DocumentListTest { 
    @isTest
    public static void testPostMethod(){
         
        Lead le = new Lead();         
        le.Web_UUID__c = 'HTI8G83WKG';
        le.LastName = 'Test';
        le.Company = 'Test Company';
        insert le;
        
        
        
        String requestData='{"lead_uuid":"HTI8G83WKG"}';
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
         baseUrl+='services/apexrest/sf/documents/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        	database.leadConvert lc = new database.leadConvert();
        	lc.setLeadId(le.id);
        
        	leadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
        
        	Document__c doc = New Document__c();             
            doc.Name = 'documentname';
            doc.Required__c = true;
            doc.Opportunity__c =le.ConvertedOpportunityId;
            insert doc;
        
        	SPR_DocumentList.postRequestHandler();
          Test.stopTest();
        
        System.assertEquals(200, res.statusCode);
    
            }
    
    @isTest
    public static void testPostMethodleadnotfound(){
         
        Lead le = new Lead();         
        le.Web_UUID__c = '';
        le.LastName = 'Test';
        le.Company = 'Test Company';
        insert le;
        
        
        
        String requestData='{"lead_uuid":" "}';
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
         baseUrl+='services/apexrest/sf/documents/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        	database.leadConvert lc = new database.leadConvert();
        	lc.setLeadId(le.id);
        
        	leadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
        
        	Document__c doc = New Document__c();             
            doc.Name = 'documentname';
            doc.Required__c = true;
            doc.Opportunity__c =le.ConvertedOpportunityId;
            insert doc;
        
        	SPR_DocumentList.postRequestHandler();
             Test.stopTest();
        
            System.assertEquals(403, res.statusCode);
    
            }
    
    
     @isTest
     public static void testPostMethodleadnotcovert(){
         
        Lead le = new Lead();         
        le.Web_UUID__c = 'HTI8G83WKG';
        le.LastName = 'Test';
        le.Company = 'Test Company';
        insert le;
        
        
        
        String requestData='{"lead_uuid":"HTI8G83WKG"}';
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
         baseUrl+='services/apexrest/sf/documents/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        	
        	Document__c doc = New Document__c();             
            doc.Name = 'documentname';
            doc.Required__c = true;
            doc.Opportunity__c =le.ConvertedOpportunityId;
            insert doc;
        
        	SPR_DocumentList.postRequestHandler();
          Test.stopTest();
        
        System.assertEquals(403, res.statusCode);
    
            }
    
    
     @isTest
    public static void testPostMethodreferalnotpass(){
         
        Lead le = new Lead();         
        le.Web_UUID__c = 'HTI8G83WKG';
        le.LastName = 'Test';
        le.Company = 'Test Company';
        insert le;
        
        
        
        String requestData='{"lead_uuid":"HTI8G83WKG"}';
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
         baseUrl+='services/apexrest/sf/documents/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('test',Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        	database.leadConvert lc = new database.leadConvert();
        	lc.setLeadId(le.id);
        
        	leadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
        
        	Document__c doc = New Document__c();             
            doc.Name = 'documentname';
            doc.Required__c = true;
            doc.Opportunity__c =le.ConvertedOpportunityId;
            insert doc;
        
        	SPR_DocumentList.postRequestHandler();
          Test.stopTest();
        
        System.assertEquals(406, res.statusCode);
    
            }
    
    
    
    
}