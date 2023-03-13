@isTest
public class SPR_OpportunityWorksheetTriggerTest {
   @isTest
    public static void updatedocumentTest(){
         
        Opportunity_Worksheet__c oppWork = New Opportunity_Worksheet__c();
        oppWork.AVM_Eligible__c ='No';
        insert oppWork;
        
        Opportunity opp = New Opportunity();
        opp.Opportunity_Worksheet__c = oppWork.Id;
        opp.Name ='test';
        opp.StageName ='Pre-Approving';
        opp.CloseDate = Date.today();
        insert opp;
        
        Document__c doc = New Document__c();
        doc.Opportunity__c =opp.Id;
        doc.Name = 'test';
        doc.Required__c =true;
        insert doc ;
        
        Test.startTest();
        	oppWork.AVM_Eligible__c='Yes';
        	update oppWork;       
        
        Test.stopTest();
    }
}