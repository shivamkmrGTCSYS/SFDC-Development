@isTest
public class SPR_DomaFetchOrderDetailBatchTest {

    public class HttpDoma implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"id":"order_6199211497","order_status":"OPENED","loan_amount":"12.12","documents":[{"id":"doc_3543785544","created_date":"2022-08-18 00:35:19.325759+00:00","created_by":"states_title","href":"/orders/order_2211322727/documents/doc_3543785544","type":"SETTLEMENT_STATEMENT"}] }';
            res.setBody(data) ;                                   
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void testBatch(){
        
        SPR_Doma_API__c dt = new SPR_Doma_API__c();
        dt.Client_Id__c = 'DTAPI_Splitero_UAT';
        dt.Client_Secret__c = 'SpliteroDTAPI1@UAT';
        dt.Access_Token_API_Domain__c = 'https://dtapiuat.datatree.com/api/';
        dt.Access_Token_API_Domain__c = 'https://dtapiuat.datatree.com/api/';
        insert dt;
        
        Title_and_Escrow__c te = new Title_and_Escrow__c();
        te.Transaction_ID__c='12121212';
        te.Status__c=false;
        te.Order_Status__c='OPENED';
        insert te;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaFetchOrderDetailBatch dodb = new SPR_DomaFetchOrderDetailBatch();   
        String chron = '0 0 23 * * ?';        
        String jobid = System.schedule('testDOMOBatch', chron,dodb);
         
        Test.stopTest();
        
    }
    
    
}