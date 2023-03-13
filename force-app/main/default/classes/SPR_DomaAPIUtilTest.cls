@isTest
public class SPR_DomaAPIUtilTest {
    private static string data {get;set;}
    private static integer statusCode{get;set;}
    @testSetup static void setup() {
        SPR_Doma_API__c dt = new SPR_Doma_API__c();
        dt.Client_Id__c = 'DTAPI_Splitero_UAT';
        dt.Client_Secret__c = 'SpliteroDTAPI1@UAT';
        dt.Access_Token_API_Domain__c = 'https://dtapiuat.datatree.com/api/';
        dt.Access_Token_API_Domain__c = 'https://dtapiuat.datatree.com/api/';
        insert dt;
        
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109';
        pr.Property_Address__c='test address';
        pr.County__c='county';
        insert pr;
        
        Lead le = new Lead();
        le.LastName = 'test';
        le.Company = 'demo';
        le.Street = '1716 Thomas Court';
        le.City = 'Modesto';
        le.State = 'CA';
        le.Country = 'United States';
        le.PostalCode = '95355';
        le.Property__c=pr.Id;
        le.Alternate_Phone_2__c='0989098902';
        le.Co_Owner_Phone__c='0987654321';
        le.Phone='9876543210';
        le.Splitero_File_Number__c='SPLITEROF';
        le.Email='test@test.com';
        insert le;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.Email = 'test@1234gmail.com';
        con.Phone = '012345610';
        insert con;
        
        
        
        opportunity opp1 = new opportunity();
        opp1.Name = 'test 1';
        opp1.StageName = 'Intent to Proceed';
        opp1.CloseDate =system.today().addDays(30);
        opp1.Backend_partner_selected__c=True;
        opp1.Investment_Amount__c = 100;
        opp1.OwnerId = userInfo.getUserId();
        opp1.Primary_Contact__c = con.Id;
        opp1.Processor__c = userInfo.getUserId();
        insert opp1;
        
        
        Application__c application = new Application__c();
        application.Legal_First_Name__c = 'test';
        application.Legal_Middle_Name__c = '2';
        application.Legal_Last_Name__c = 'record';
        application.Email__c = 'test@12012gmail.com';
        application.Phone_Number__c = '233-223-2323';
        application.Opportunity__c = opp1.Id;
        application.Social_Security_Number__c = '121-21-2211';
        insert application;
        
        Title_and_Escrow__c tes = new Title_and_Escrow__c();
        tes.Title_and_Escrow_Source__c = 'Doma';
        insert tes;
    }
    
    
    
    
  
    @isTest
    public static void submitOrderForOpportunity(){
       Opportunity opp = [SELECT Id,Name,Investment_Amount__c,Primary_Contact__c,OwnerId FROM Opportunity limit 1];
        statusCode = 200;
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaAPIUtil.submitOrder(opp.Id);
        
        test.stopTest(); 
    }
    
      @isTest
    public static void submitOrderForLead(){
       Lead oLead = [SELECT Id,Name From Lead limit 1];
        statusCode = 200;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaAPIUtil.submitOrder(oLead.Id);
        test.stopTest(); 
    }
     @isTest
    public static void runDomaOppWsSubmitOrderForOpp_Test(){
         
        Opportunity opp = [SELECT Id,Name,Investment_Amount__c,Primary_Contact__c,OwnerId FROM Opportunity limit 1];
        Opportunity_Worksheet__c ow = new Opportunity_Worksheet__c();
        ow.Opportunity__c=opp.Id;
        insert ow;
        
        statusCode = 200;
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaAPIUtil.runDomaOppWsSubmitOrder(ow.Id);
        test.stopTest(); 
          
    }
     @isTest
    public static void Test422ErrorPart(){
        
        Opportunity opp = [SELECT Id,Name,Contact_Phone__c,Investment_Amount__c,Primary_Contact__c,OwnerId FROM Opportunity limit 1];
        
        Opportunity_Worksheet__c ow = new Opportunity_Worksheet__c();
        ow.Opportunity__c=opp.Id;
        insert ow;
        
        statusCode = 422;
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaAPIUtil.runDomaOppWsSubmitOrder(ow.Id);
        test.stopTest(); 
          
    }
     @isTest
    public static void Test422ErrorPartSubmitOrder(){
        
        Opportunity opp = [SELECT Id,Name,Contact_Phone__c,Investment_Amount__c,Primary_Contact__c,OwnerId FROM Opportunity limit 1];
        statusCode = 422;
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaAPIUtil.submitOrder(opp.Id);
        test.stopTest(); 
          
    }
    
     @isTest
    public static void runDomaOppWsSubmitOrderForLead_Test(){
         
           Lead oLead = [SELECT Id,Name From Lead limit 1];
        statusCode = 200;
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaAPIUtil.runDomaOppWsSubmitOrder(oLead.Id);
        test.stopTest(); 
          
    }
      @isTest
    public static void getDocumentAndSave_Test(){
         
        //Lead oLead = [SELECT Id,Name From Lead limit 1];
        
        Title_and_Escrow__c tes = [SELECT Id,Transaction_ID__c from Title_and_Escrow__c limit 1];
      
        Title_and_Valuation_Document__c tvd = new Title_and_Valuation_Document__c();
        tvd.Document_Id__c='doc_3543785544';
        tvd.Document_Type__c='SETTLEMENT_STATEMENT'; 
        tvd.Href__c='/orders/order_2211322727/documents/doc_3543785544';
        tvd.Title_and_Escrow__c=tes.Id;
        tvd.Order_Id__c='order_2211322727';
        tvd.Status__c=False;
        insert tvd;
        statusCode = 200;
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaAPIUtil.getDocumentAndSave(tvd); 
        test.stopTest(); 
           
    }
    
      @isTest
    public static void getOrderDetail_Test(){
         
        //Lead oLead = [SELECT Id,Name From Lead limit 1];
        
        Title_and_Escrow__c tes = [SELECT Id,Transaction_ID__c from Title_and_Escrow__c limit 1];
      
         
        statusCode = 200; 
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
         
        SPR_DomaAPIUtil.getOrderDetail(tes);
        test.stopTest(); 
           
    }
    
    public class HttpDoma implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
           String data ='{"filename" : "test.csv","content" : "Unit Test Attachment Body","id":"order_6199211497","order_status":"SUBMITTED","mortgage_type":"CONV","property_usage_type":"PRIMARY","transaction_type":"HELOC","loan_amount":"1000","address":"4114 Gresham St, San Diego, CA, 92109","unit":"","city":"San Diego","county":"US","state":"CA","zip_code":"92109","loan_number":"12456"}';
            
            res.setBody(data) ;                                   
            res.setStatusCode(statusCode);
            return res;
        }
    }
    
}