@isTest
public class SPR_SyncApplicationToWebBatchTest {

     
    public class HttpApplicationMockResponse implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"success":true,"message":{"resUpdateUser":"","resUpdateLoan":"","resCreateUser":"user created successfully","resCreateLoan":"loan created successfully","name":null,"errors":null}}';
            res.setBody(data) ;                                   
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void SyncApplicationToWebBatchTest(){
        
        SyncApplication__c sa = new SyncApplication__c();
        sa.Access_Key__c = 'AccessKey'; 
        sa.Access_Token_End_Point__c = 'https://test.token.com/api/';
        sa.Web_End_Point__c = 'https://test.com/api/';
        insert sa;
        
        Application__c app = new Application__c( );
        app.Sync_to_Web__c=false;
        insert app;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpApplicationMockResponse());
        System.schedule('SPR_SyncApplicationToWebBatch', '0 0 23 * * ?', new SPR_SyncApplicationToWebBatch()); 
        test.stopTest();
        
    }
    @isTest
    public static void SyncApplicationToWebTest(){
        
        SyncApplication__c sa = new SyncApplication__c();
        sa.Access_Key__c = 'AccessKey'; 
        sa.Access_Token_End_Point__c = 'https://test.token.com/api/';
        sa.Web_End_Point__c = 'https://test.com/api/';
        insert sa;
        
        Application__c app = new Application__c( );
        app.Sync_to_Web__c=false;
        insert app;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpApplicationMockResponse());
         
        ApplicationResponse response = SPR_SyncApplicationToWebUtility.SyncApplicationToWeb(app.Id);
            
        ApplicationResponse.message m = new ApplicationResponse.message();
        m.resUpdateUser = '';
        m.resCreateLoan = '';
        m.resCreateUser = '';
        m.resUpdateLoan = '';
        m.name = '';
        
        response.message = m;
        
        ApplicationResponse.errors e = new ApplicationResponse.errors();
        e.origin = '';
        e.validatorKey = '';
        e.value = '';
        e.validatorName = '';
        e.type = '';
        e.message = '';
        
        test.stopTest();
        
    }
    
}