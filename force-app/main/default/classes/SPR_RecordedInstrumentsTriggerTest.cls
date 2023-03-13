@isTest
public class SPR_RecordedInstrumentsTriggerTest {

    @isTest
    public static void insertTest(){
        
        Opportunity_Worksheet__c oppWork1 = new Opportunity_Worksheet__c();
        insert oppWork1;
        Opportunity opp = new Opportunity();        
        opp.Opportunity_Worksheet__c =oppWork1.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        insert opp;
        
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Oddities__c='Interest Only';
        ri.Opportunity_Worksheet__c = oppwork1.Id;
     
        
        Test.startTest();         
        	insert ri;
        Test.stopTest();
    }
    
    @isTest
    public static void updateTest(){
        
        Opportunity_Worksheet__c oppWork = new Opportunity_Worksheet__c();
        insert oppWork;
        
        Opportunity opp = new Opportunity();        
        opp.Opportunity_Worksheet__c =oppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        insert opp;
        
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Oddities__c='Balloon';
        ri.Opportunity_Worksheet__c = oppWork.Id;
        insert ri;
        
        Test.startTest();         
            
        	ri.Oddities__c='Interest Only';
        	update ri;
        Test.stopTest();
    }
}