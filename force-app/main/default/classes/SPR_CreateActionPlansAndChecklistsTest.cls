@isTest
public class SPR_CreateActionPlansAndChecklistsTest {

        @isTest 
    public static  void testClosingDate(){        
        
        List<opportunity> oppList = new List<opportunity>();
        List<opportunity> oppListUpdate = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate =system.today().addDays(30);
        opp.Discharge_Date_Bankruptcy_1__c=System.today().addDays(15);
        opp.Discharge_Date_Bankruptcy_2__c=System.today().addDays(16);
        opp.Discharge_Date_Bankruptcy_3__c=System.today().addDays(17);
        opp.Discharge_Date_Bankruptcy_4__c=System.today().addDays(18);
        opp.Discharge_Date_Bankruptcy_5__c=System.today().addDays(19);
        
        opp.Dismissal_Date_Bankruptcy_1__c = System.today().addDays(15);
        opp.Dismissal_Date_Bankruptcy_2__c=System.today().addDays(16);
        opp.Dismissal_Date_Bankruptcy_3__c=System.today().addDays(17);
        opp.Dismissal_Date_Bankruptcy_4__c=System.today().addDays(18);
        opp.Dismissal_Date_Bankruptcy_5__c=System.today().addDays(19);
        
        opp.Type_Required_Bankruptcy_1__c = 'Chapter 7';
        
        oppList.add(opp);
        
        opportunity opp1 = new opportunity();
        opp1.Name = 'test 1';
        opp1.StageName = 'Intent to Proceed';
        opp1.CloseDate =system.today().addDays(30);
        opp1.Backend_partner_selected__c=True;
        oppList.add(opp1);
         
         
         
        SPR_TriggerUtility.ByPassAllTrigger=true;
        insert oppList;
        SPR_TriggerUtility.ByPassAllTrigger=false;
        Test.startTest();
        	 Database.executeBatch(new SPR_CreateActionPlansAndChecklists(),100);
        Test.stopTest();
        
    }
    
    
}