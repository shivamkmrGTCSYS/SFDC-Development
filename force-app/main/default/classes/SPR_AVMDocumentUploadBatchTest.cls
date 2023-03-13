@isTest
public class SPR_AVMDocumentUploadBatchTest {
    
    @isTest
    public static void testDocumentUpload(){
        
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
        
        Test.startTest();
        
        SPR_AVMDocumentUploadBatch avmBatch = new SPR_AVMDocumentUploadBatch();   
        String chron = '0 0 23 * * ?';        
        String jobid = System.schedule('testAVMBatch', chron, avmBatch);
        
        System.assertEquals(jobid != null, true);
        Test.stopTest();
        
    }
}