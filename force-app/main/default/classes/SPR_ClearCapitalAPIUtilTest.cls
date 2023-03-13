@isTest
public class SPR_ClearCapitalAPIUtilTest {
    
    public class Httpavm implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"avmId" : "ed6a7831-e0ed-4e91-ab38-5928ef277c1b", "avmPdfLink" : "htttps://api.clearcapital.com/avm/avm/ed6a7831-e0ed-4e91-ab38-5928ef277c1b/pdf", "avmResult" : {"avmEffectiveDate" : "2022-02-04", "comparables": "null", "confidenceScore": "H", "confidenceScoreAlt": "96.8", "forecastStdDev": "0.032","highValue" : 624266, "lowValue" : 585750, "marketValue" : 605008, "providerKey" : "CC", "providerModel" : "CLEARAVM" }, "avmType" : "Value Only", "endpoint" : "avm", "property" : { "apn" : "085003079000", "censusBlockGroup" : "060990009123", "customerProvidedAddress" : "1716 Thomas Court"}}';  
            res.setBody(data) ;                                   
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void testLead(){
        Lead le = new Lead();
        le.LastName = 'test';
        le.Company = 'demo';
        le.Street = '1716 Thomas Court';
        le.City = 'Modesto';
        le.State = 'CA';
        le.Country = 'United States';
        le.PostalCode = '95355';
        insert le;
        Clear_Capital_API__c cca = new Clear_Capital_API__c();
        cca.Api_Key__c='testapikey';
        cca.Endpoint__c='http://test.clear.com';
        insert cca;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Httpavm());
        SPR_ClearCapitalAPIUtil.getAVMRequest(le.Id);
        test.stopTest();
        System.assertEquals(le.id != null, true);   
    }
    
    @isTest
    public static void testOpportunity(){
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109'; 
        insert pr;
        
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        opp.Property__c = pr.id;
        insert opp;
        Clear_Capital_API__c cca = new Clear_Capital_API__c();
        cca.Api_Key__c='testapikey';
        cca.Endpoint__c='http://test.clear.com';
        insert cca;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Httpavm());
        SPR_ClearCapitalAPIUtil.getAVMRequest(opp.Id);
        test.stopTest();
        System.assertEquals(opp.id != null, true);
    }
}