@isTest
public class SPR_RadianRestInboundServiceTest {
    
    @isTest
    static void testHttpPost() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/avm/demo'; //Request URL
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        String val = null;
        SPR_RadianRestInboundService.requestHandler();
        Test.stopTest();
        
        System.assertEquals(null, val);
    }
}