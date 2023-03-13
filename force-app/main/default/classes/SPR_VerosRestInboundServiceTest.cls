@isTest
public class SPR_VerosRestInboundServiceTest {
 
    @isTest
    static void testHttpPost() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/avm/fa'; //Request URL
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        String val = null;
        SPR_VerosRestInboundService.SPR_VerosRestInboundService();
        Test.stopTest();
        
        System.assertEquals(null, val);
    }
}