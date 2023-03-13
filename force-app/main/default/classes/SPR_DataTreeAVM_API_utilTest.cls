@isTest
public class SPR_DataTreeAVM_API_utilTest {
    
    public class Httpavm implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"StatusDescription":"Report generation completed.","MaxResultsCount":1,"LitePropertyList":null,"Reports":[{"PropertyId":19514046,"ReportName":"DataTreeAVM","ReportStatus":"Ready","ReferenceId":"78271645763503493","OrderItemId":19589141,"Data":{"SubjectProperty":{"PropertyId":19514046}, "ValuationSummary" : {"ConfidenceScore":"80", "EstimatedValue":"585921.0", "EstimatedValueHigh":"677192.0", "EstimatedValueLow":"494651.0", "StandardDeviation":"0.15577284738331482"}}}]}';
            res.setBody(data) ;                                   
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void testLead(){
        
        DTAPI__c dt = new DTAPI__c();
        dt.User_Name__c = 'DTAPI_Splitero_UAT';
        dt.Password__c = 'SpliteroDTAPI1@UAT';
        dt.Endpoint__c = 'https://dtapiuat.datatree.com/api/';
        insert dt;
        
        Lead le = new Lead();
        le.LastName = 'test';
        le.Company = 'demo';
        le.Street = '1716 Thomas Court';
        le.City = 'Modesto';
        le.State = 'CA';
        le.Country = 'United States';
        le.PostalCode = '95355';
        insert le;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Httpavm());
        SPR_DataTreeAVM_API_util.doCallout(le.Id);
        test.stopTest();
        System.assertEquals(le.id != null, true);   
    }
    
    @isTest
    public static void testOpportunity(){
        DTAPI__c dt = new DTAPI__c();
        dt.User_Name__c = 'DTAPI_Splitero_UAT';
        dt.Password__c = 'SpliteroDTAPI1@UAT';
        dt.Endpoint__c = 'https://dtapiuat.datatree.com/api/';
        insert dt;
        
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
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Httpavm());
        SPR_DataTreeAVM_API_util.doCallout(opp.Id);
        test.stopTest();
        System.assertEquals(opp.id != null, true);
    }
}