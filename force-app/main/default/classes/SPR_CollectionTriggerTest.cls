@isTest
public class SPR_CollectionTriggerTest {
    @isTest
    public static void insertDocumentTest(){
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
        insert OppWork;
        
        Opportunity opp = New Opportunity();        
        opp.Opportunity_Worksheet__c =OppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        opp.Hybrid_Appraisal_Required__c='Yes';
        opp.Application_Status1__c='Denied';
        insert opp;
        
        Credit_Report__c  cr = New Credit_Report__c();
        cr.Opportunity_Worksheet__c= OppWork.Id;
        
        insert cr;
        
        Collection__c Coll = New Collection__c();
        Coll.Credit_Report__c =cr.Id;
        //Coll.Account_Number__c = '12345';
        Coll.Settlement_Amount__c =100;
        
        Test.startTest();
        insert Coll;
        Test.stopTest();
    }
    
    @isTest
    public static void updateDocumentTest(){
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
        insert OppWork;
        
        Opportunity opp = New Opportunity();        
        opp.Opportunity_Worksheet__c =OppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        opp.Hybrid_Appraisal_Required__c='Yes';
        opp.Application_Status1__c='Denied';
        insert opp;
        
        Credit_Report__c  cr = New Credit_Report__c();
        cr.Opportunity_Worksheet__c= OppWork.Id;
        //cr.Name = 'test';
        insert cr; 
        
        Collection__c Coll = New Collection__c();
        Coll.Credit_Report__c =cr.Id;
        Coll.Account_Number__c = 12345;
        Coll.Settlement_Amount__c =100;
        insert Coll;
        
        Test.startTest();
        Coll.Account_Number__c = 654321;
        Coll.Settlement_Amount__c=1000;
        update Coll;
        Test.stopTest();
    }
    
    
}