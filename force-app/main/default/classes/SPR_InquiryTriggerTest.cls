@isTest
public class SPR_InquiryTriggerTest {
    @isTest
    public static void insertDocumentTest(){
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
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
        
        Inquiry__c inq = new Inquiry__c();
        inq.Credit_Report__c = cr.Id;
        inq.Date__c = Date.today().addDays(-10);
        
        Test.startTest();
        insert inq;
        Test.stopTest();
    }
    
    @isTest
    public static void updateDocumentTest(){
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
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
        
        Inquiry__c inq = new Inquiry__c();
        inq.Date__c = Date.today().addDays(-210);
        inq.Credit_Report__c=cr.Id;
        insert inq;
        
        Test.startTest();
            inq.Date__c = Date.today().addDays(-20);
            update inq;
        Test.stopTest();
    }
    
    
    
    
}