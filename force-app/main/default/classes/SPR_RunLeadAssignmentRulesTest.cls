@isTest
public class SPR_RunLeadAssignmentRulesTest {

    
    @testSetup
    static void loadData(){
        Lead l = new Lead(
            LastName='Test',
            Company='Test',
            LeadSource='Website',
            Portal_Lead__c=true
        );
        insert l;
    }
    
    @isTest
    static void testLead(){
         
        List<Id> ids = new List<Id>();
         
        Lead l = [SELECT Id, OwnerId FROM Lead];
        ids.add(l.Id);
         
        test.startTest();
        SPR_RunLeadAssignmentRules.assignLeads(ids);
        test.stopTest();
         
    }
}