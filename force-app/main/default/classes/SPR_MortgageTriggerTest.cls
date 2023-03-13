@isTest
public class SPR_MortgageTriggerTest {
    
    
    @isTest
    public static void insertDocumentTest(){
         
        Opportunity_Worksheet__c OppWork = new Opportunity_Worksheet__c();
        insert OppWork;
        
        Opportunity opp = new Opportunity();        
        opp.Opportunity_Worksheet__c =OppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        opp.Hybrid_Appraisal_Required__c='Yes';
        opp.Application_Status1__c='Denied';
        insert opp;
        
        Credit_Report__c  cr = new Credit_Report__c();
        cr.Opportunity_Worksheet__c= OppWork.Id;
        //cr.Name = 'test';
        insert cr;
        
        Mortgage__c mort = new Mortgage__c();
        mort.Credit_Report__c = cr.Id;
        mort.Account_Number__c =12345;
        
        Test.startTest();         
        	insert mort;
        Test.stopTest();
        

    }
}