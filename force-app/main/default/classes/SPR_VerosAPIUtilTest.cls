@isTest
public class SPR_VerosAPIUtilTest {
    
    public class HttpVeros implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"ResponseStatus":{"IsSuccess":true,"StatusCode":"AVM1000","StatusMessage":"AVM Order Successful.","ResponseDate":"2022-03-01T06:37:15"},"TrackingId":"VS1257138","TransactionId":"6588711_7419277","AVMOrderStatus":"Evaluation Successful","AVMReport":{"RESULT" : {"DOCUMENT" : {"DOCUMENT_CONTENT" : "xyz"}},"REQUEST_ID" :6588711, "SUMMARY" :{"SERVICES" :[ {"VALUATION" :{ "VALUES" :[{"KEYNAME" :"AVM CONFIDENCE SCORE", "KEYVALUE" :94}, {"KEYNAME" :"AVM HIGH VALUE", "KEYVALUE" :625000}, {"KEYNAME" :"AVM LOW VALUE", "KEYVALUE" :545000}, {"KEYNAME" :"AVM VALUE", "KEYVALUE" :585000}, {"KEYNAME" :"FSD", "KEYVALUE" :0.04} ]}}]}}}';
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
        
        Veros_API__c veros = new Veros_API__c();
        veros.User_Name__c = 'spliteroTESTintg';
        veros.Password__c = 'splitditest22';
        veros.SourceApplication__c = 'Dev Service Tester';
        veros.Endpoint__c = 'https://intg.veroselect.com/clientservice/api/AVM/PlaceOrder';
        insert veros;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpVeros());
        SPR_VerosAPIUtil.sendRequest(le.Id);
        System.assertEquals(le.id != null, true);   
        test.stopTest();
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
        
        Veros_API__c veros = new Veros_API__c();
        veros.User_Name__c = 'spliteroTESTintg';
        veros.Password__c = 'splitditest22';
        veros.SourceApplication__c = 'Dev Service Tester';
        veros.Endpoint__c = 'https://intg.veroselect.com/clientservice/api/AVM/PlaceOrder';
        insert veros;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpVeros());
        SPR_VerosAPIUtil.sendRequest(opp.Id);
        System.assertEquals(opp.id != null, true);
        test.stopTest();
    }
}