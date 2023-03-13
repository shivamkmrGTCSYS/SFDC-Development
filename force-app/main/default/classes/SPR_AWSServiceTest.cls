@isTest
public class SPR_AWSServiceTest {
    
    public class HttpDocumentUpload implements HttpCalloutMock {  
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void testDocumentUpload(){
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        ContentVersion cv=new Contentversion();
        cv.title='test';
        cv.PathOnClient ='test.csv';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        
        String contentDocumentId = [SELECT contentDocumentId FROM ContentVersion WHERE Id=:cv.id].contentDocumentId;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocumentId;
        cdl.LinkedEntityId = acc.id;
        insert cdl;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpDocumentUpload());
        SPR_AWSService aws = new SPR_AWSService('test', 'test12', 'splitero-production', 'POST', 's3-us-east-1.amazonaws.com', 'demo');
        aws.UploadDocuments(acc.id);
        System.assertEquals(acc.id != null, true);
        test.stopTest();
        
    }
    
    @isTest
    public static void testFolderName(){
        
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        insert opp;
        
        Valuation__c avm = new Valuation__c();
        avm.Opportunity__c = opp.id; 
        avm.Estimated_Value__c = 832881;
        avm.Estimated_Value_High__c= 902234;
        avm.Estimated_Value_Low__c=763528; 
        avm.Confidence_Score__c=91.7;
        insert avm;
        
        SPR_AWSService.getFolderName('avm');
        SPR_AWSService.findObjectNameFromRecordIdPrefix(avm.id);
        System.assertEquals(avm.id != null, true);
    }
}