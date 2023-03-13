@isTest
public class SPR_DownloadApplicationControllerTest {

    public class HttpDoma implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"success": true,"signed_url": "https://test.spltiro.com/public/download"}';
            res.setBody(data) ;                                   
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void downloadApplicationURLTest(){          
         
        Download_Application__c da = new Download_Application__c();
        da.API_Url__c = 'http://test.com';
        da.X_API_Key__c = 'X_API_Key__c@UAT';
        
        insert da;
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        insert ld;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        String url = SPR_DownloadApplicationController.downloadApplicationURL(ld.Id);
        test.stopTest(); 
        SYstem.assertEquals('https://test.spltiro.com/public/download', url);
    }
    
}