@isTest
public class SPR_ReleaseTriggerTest {
    
    @isTest
    public static void insertDocumentTest(){
        
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
        //OppWork.Title_Report__c= ;
        insert OppWork;
        
        Opportunity opp = New Opportunity();        
        opp.Opportunity_Worksheet__c =OppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        opp.Hybrid_Appraisal_Required__c='Yes';
        opp.Application_Status1__c='Denied';
        insert opp;
        
        Title_Report__c  tr = New Title_Report__c();
        tr.Opportunity_Worksheet__c= OppWork.Id;
        //tr.Name = 'test';
        insert tr;
        
        Release__c r =  New Release__c();
        r.Title_Report__c= tr.Id;
        r.Type__c='Hero/Pace';         
        r.Payoff_Required__c='Yes';
        r.Payoff_Required__c='No';  
        
        Test.startTest();
        	insert r;
        Test.stopTest();
        
        
    }
    
    @isTest
    public static void updateDocumentTest(){
        
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
        //OppWork.Title_Report__c= ;
        insert OppWork;
        
        Opportunity opp = New Opportunity();        
        opp.Opportunity_Worksheet__c =OppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        opp.Hybrid_Appraisal_Required__c='Yes';
        opp.Application_Status1__c='Denied';
        insert opp;
        
        Title_Report__c  tr = New Title_Report__c();
        tr.Opportunity_Worksheet__c= OppWork.Id;
        //tr.Name = 'test';
        insert tr;
        
        Release__c r =  New Release__c();
        r.Title_Report__c= tr.Id;
        r.Type__c='Hero/Pace';         
        r.Payoff_Required__c='Yes';
        r.Payoff_Required__c='No';  
        insert r;
        
        Test.startTest();
        	r.Type__c='Solar';   
        	update r;
        Test.stopTest();
        
        
    }
    
}