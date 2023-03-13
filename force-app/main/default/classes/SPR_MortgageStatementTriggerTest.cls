@isTest
public class SPR_MortgageStatementTriggerTest {
    
    @isTest
    public static void insertDocumentTest(){
        
        Opportunity_Worksheet__c oppWork = New Opportunity_Worksheet__c();
        oppWork.AVM_Eligible__c ='No';
        insert oppWork;
        
        
        
        Opportunity opp = New Opportunity();        
        opp.Opportunity_Worksheet__c =oppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        
        Document__c doc = New Document__c();
        doc.Opportunity__c =opp.Id;
        doc.Name = 'test';
        doc.Required__c =true;
        insert doc;
        
        Mortgage_Statement__c ms = New Mortgage_Statement__c();
        ms.Opportunity_Worksheet__c= oppWork.Id;
        ms.Deferred_Amount__c=100;
        ms.Deferred_Amount_to_payoff__c=700;
        //ms.Name='test'; 
        
        Test.startTest();         
        	insert ms;
        Test.stopTest();
    }
    
}