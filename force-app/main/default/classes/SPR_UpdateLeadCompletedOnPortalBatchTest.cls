@isTest
public class SPR_UpdateLeadCompletedOnPortalBatchTest {

    @isTest
    public static void testBatch(){
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        ld.Application_Completed_on_Portal__c=false;
        insert ld;
        
        Application__c app = new Application__c(Lead__c=ld.Id,Application_Completed__c=true);
        
        insert app;
        
        Test.startTest();
        	System.schedule('SPR_UpdateLeadCompletedOnPortalBatch', '0 0 23 * * ?', new SPR_UpdateLeadCompletedOnPortalBatch());        	   
        Test.stopTest();
        
    }
    
}