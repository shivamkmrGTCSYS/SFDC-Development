@isTest
public class SPR_RunCaOppsWsTest {
	
    public class Httpavm implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"avmId" : "ed6a7831-e0ed-4e91-ab38-5928ef277c1b", "avmPdfLink" : "htttps://api.clearcapital.com/avm/avm/ed6a7831-e0ed-4e91-ab38-5928ef277c1b/pdf", "avmResult" : {"avmEffectiveDate" : "2022-02-04", "comparables": "null", "confidenceScore": "12", "confidenceScoreAlt": "96.8", "forecastStdDev": "0.032","highValue" : 624266, "lowValue" : 585750, "marketValue" : 605008, "providerKey" : "CC", "providerModel" : "CLEARAVM" }, "avmType" : "Value Only", "endpoint" : "avm", "property" : { "apn" : "085003079000", "censusBlockGroup" : "060990009123", "customerProvidedAddress" : "1716 Thomas Court"}}';  
            res.setBody(data) ;                                   
            res.setStatusCode(200);
            return res;
        }
    }
    
        @isTest
    public static void testGetAVMRequestOpportunity(){
        
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
         
        Opportunity_Worksheet__c ow = new Opportunity_Worksheet__c();
        ow.Opportunity__c=opp.Id;
        insert ow;
        
        Clear_Capital_Black_Night_API__c cca = new Clear_Capital_Black_Night_API__c();
        cca.Api_Key__c='testapikey';
        cca.Endpoint__c='http://test.clear.com';
        insert cca;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Httpavm());
        SPR_RunCaOppsWs.getAVMRequest(ow.Id);
        test.stopTest();
                
    }
    
    
}