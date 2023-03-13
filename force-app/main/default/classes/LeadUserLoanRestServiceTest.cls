@isTest
 public class LeadUserLoanRestServiceTest{
     
      @isTest
    public static void getLeadUserLoan(){
        
        RestRequest request = new RestRequest(); 
        RestResponse ressponse = new RestResponse();
        
        request.requestURI = '/services/apexrest/LeadLoanUserService/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serializePretty(getSampleRequestGet(true)));
        request.addHeader('Referer', Label.SPR_API_Referer);
        RestContext.request = request;
        RestContext.response= ressponse;
        
        Test.startTest();
        LeadUserLoanRestService.PostLeadInfo();
        Test.stopTest();
    }
     @isTest
    public static void getLeadUserLoan1(){
        
        RestRequest request = new RestRequest(); 
        RestResponse ressponse = new RestResponse();
        
        request.requestURI = '/services/apexrest/LeadLoanUserService/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serializePretty(getSampleRequestGet(true)));
        
        RestContext.request = request;
        RestContext.response= ressponse;
        
        Test.startTest();
        LeadUserLoanRestService.PostLeadInfo();
        Test.stopTest();
    }
   
     
      public static leadAppConOppRapper.getLead getSampleRequestGet(Boolean isValid){
        leadAppConOppRapper.getLead reqGet = new leadAppConOppRapper.getLead();
        if(isValid){
            
            Property__c pro = new Property__c();
            pro.Street__c  = '123 Main St';
            pro.City__c = 'San Francisco';
            pro.Zip_Postal_Code__c= '94111';
            insert pro;
            
            
            
            Opportunity opp = new Opportunity();
            opp.Name = 'test1';
            opp.StageName= 'processing';
       
            insert opp;
            
            contact con =new contact();
            con.Email = 'stest@test.com';
            con.LastName='test';
            insert con;
            
            Lead lead = new Lead();
            lead.FirstName = 'test';
            lead.LastName = 'Utest';
            lead.Email = 'stest@test.com';
            lead.Phone = '95614';
            lead.Company = 'testabc';
            lead.Status = 'Inquiring';
            lead.Place_Key__c='plaekey';
            
            //lead.ConvertedOpportunityId = opp.Id;
            insert lead;
            
            Application__c app= new Application__c();
            app.Email__c = 'stest@test.com';
            app.State__c = 'CA test';
            app.Property__c=pro.Id;    
            app.Lead__c=lead.Id;
            insert app;
            
            reqGet.Street = '123 Main St';
            reqGet.City = 'San Francisco';
            reqGet.State = 'CA test';
            reqGet.PostalCode = '94111';
            reqGet.Email = 'stest@test.com';
            reqGet.placeKey='plaekey';
            
        }
        
        return reqGet;
        
    }
     
     @isTest
    public static void updateLead(){
        
        RestRequest request = new RestRequest(); 
        RestResponse ressponse = new RestResponse();
        
        request.requestURI = '/services/apexrest/LeadLoanUserService/';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JSON.serializePretty(getSampleRequest(true)));
      	request.addHeader('Referer', Label.SPR_API_Referer);
        RestContext.request = request;
        RestContext.response= ressponse;
        
        Test.startTest();
        LeadUserLoanRestService.UpdateLead();
        Test.stopTest();
    }
      @isTest
    public static void coverLeadCreate406(){
        
        RestRequest request = new RestRequest(); 
        RestResponse ressponse = new RestResponse();
        
        request.requestURI = '/services/apexrest/LeadLoanUserService/';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JSON.serializePretty(getSampleRequest(true)));
      //  request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request = request;
        RestContext.response= ressponse;
        
        Test.startTest();
        LeadUserLoanRestService.UpdateLead();
        Test.stopTest();
    }
   
    public static leadAppConOppRapper.updateLeadRequest getSampleRequest(Boolean isValid){
        leadAppConOppRapper.updateLeadRequest req = new leadAppConOppRapper.updateLeadRequest();
        if(isValid){
            Property__c pro = new Property__c();
            pro.Street__c  = '123 Main St';
            pro.City__c = 'San Francisco';
            pro.Zip_Postal_Code__c= '94111';
            insert pro;
            
            
            
            Opportunity opp = new Opportunity();
            opp.Name = 'test1';
            opp.StageName= 'processing';
       
            insert opp;
            
            contact con =new contact();
            con.Email = 'stest@test.com';
            con.LastName='test';
            insert con;
            
            Lead lead = new Lead();
            lead.FirstName = 'test';
            lead.LastName = 'Utest';
            lead.Email = 'stest@test.com';
            lead.Phone = '95614';
            lead.Company = 'testabc';
            lead.Status = 'Inquiring';
            lead.Place_Key__c='plaekey';
            //lead.ConvertedOpportunityId = opp.Id;
            insert lead;
             
            Application__c app= new Application__c();
            app.Email__c = 'stest@test.com';
            app.State__c = 'CA test';
            app.Property__c=pro.Id;   
            app.Lead__c=lead.Id;
            insert app;
            
            req.firstname = 'test1';
            req.lastname = 'test';
            req.email = 'stest@test.com';
            req.phone = '99231';
            req.status = 'Inquiring';
            req.sfid = lead.Id;
            req.placeKey='plaekey';
             
        }
        return req;
    }

 }