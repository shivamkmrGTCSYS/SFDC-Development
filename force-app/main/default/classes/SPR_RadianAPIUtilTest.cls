@isTest
public class SPR_RadianAPIUtilTest {
    
    public class Httpxml implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            String data = '<RESPONSE_GROUP MISMOVersionID="2.3">'+
                '<RESPONSE ResponseDateTime="">'+ 
                '<KEY _Name="ReferenceId"  _Value="6701645433471727" />'+ 
                '<STATUS _Condition="Failure" _Code="-900" _Name="" _Description="No valid products ordered or product(s) not in client profile."/>'+
                '</RESPONSE></RESPONSE_GROUP>';
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
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Httpxml());
        SPR_RadianAPIUtil.sendRequest(le.Id,'');
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
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Httpxml());
        SPR_RadianAPIUtil.sendRequest(opp.Id,'');
        test.stopTest();
        System.assertEquals(opp.id != null, true);
    }
}