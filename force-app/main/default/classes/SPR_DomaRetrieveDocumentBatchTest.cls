@isTest
public class SPR_DomaRetrieveDocumentBatchTest {

    public class HttpDoma implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String data ='{"filename":"ordertest.pdf","content":"sfsjfhskjfhdkhfkshfdhfd"}';
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
        
        //Select Id,Document_Id__c,Document_Type__c,Href__c,Title_and_Escrow__c,Order_Id__c 
        //From Title_and_Valuation_Document__c Where Status__c=false
        Title_and_Valuation_Document__c tvd = new Title_and_Valuation_Document__c();
        tvd.Document_Id__c='doc_3543785544';
        tvd.Document_Type__c='SETTLEMENT_STATEMENT'; 
        tvd.Href__c='/orders/order_2211322727/documents/doc_3543785544';
        tvd.Title_and_Escrow__c=te.Id;
        tvd.Order_Id__c='order_2211322727';
        tvd.Status__c=False;
        insert tvd;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDoma());
        SPR_DomaRetrieveDocumentBatch dodb = new SPR_DomaRetrieveDocumentBatch();   
        String chron = '0 0 23 * * ?';        
        String jobid = System.schedule('testDOMOBatch', chron,dodb);
         
        Test.stopTest();
        
    }
    
}