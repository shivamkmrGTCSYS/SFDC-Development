@isTest
public class SPR_OpportunityTriggerTest {

    
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
        
        opportunity opp2 = new opportunity();
        opp2.Name = 'test 2';
        opp2.StageName = 'Processing';
        opp2.CloseDate =system.today().addDays(30);
        opp2.Backend_partner_selected__c=True;
        oppList.add(opp2);
        
        opportunity opp3 = new opportunity();
        opp3.Name = 'test 3';
        opp3.StageName = 'Underwriting';
        opp3.CloseDate =system.today().addDays(30);
        opp3.Backend_partner_selected__c=True;
        oppList.add(opp3);
        
        opportunity opp4 = new opportunity();
        opp4.Name = 'test 4';
        opp4.StageName = 'Closing';
        opp4.CloseDate =system.today().addDays(30);
        opp4.Backend_partner_selected__c=True;
        oppList.add(opp4);
        
        Test.startTest();
        	insert oppList;
        	oppList = [Select Id,Create_Capitol_Markets__c From Opportunity ];
        	oppList[0].Create_Capitol_Markets__c='Redwood Trust';
        	oppList[0].Backend_partner_selected__c=True;
        	oppListUpdate.add(oppList[0]);
        	oppList[1].Create_Capitol_Markets__c='Kingsbridge';
        	oppList[1].Backend_partner_selected__c=True;
        	oppListUpdate.add(oppList[1]);
        	update oppListUpdate;
        Test.stopTest();
        
    }
    
    @isTest 
    public static  void testActionPlan(){
        
        SyncApplication__c sa = new SyncApplication__c();
        sa.Access_Key__c = 'AccessKey'; 
        sa.Access_Token_End_Point__c = 'https://test.token.com/api/';
        sa.Web_End_Point__c = 'https://test.com/api/';
        sa.Web_End_Point_Opp_Stage_Update__c = 'https://test.com/api/';
        insert sa;
        
        ActionPlanTemplate apt = new ActionPlanTemplate();
        apt.Name = 'Underwriting';
        apt.ActionPlanType='Industries';
        apt.TargetEntityType ='Opportunity';
         
        insert apt;
        
		opportunity opp = new opportunity();
        opp.Name = 'test 3';
        opp.StageName = 'Underwriting';
        opp.CloseDate =system.today().addDays(30);
        opp.Backend_partner_selected__c=True;
        
       
         
		Test.startTest();
			insert opp ;
        Test.stopTest();   
        
    }
    
    
    
    @isTest 
    public static  void testActionPlanUpdate(){
        
        SyncApplication__c sa = new SyncApplication__c();
        sa.Access_Key__c = 'AccessKey'; 
        sa.Access_Token_End_Point__c = 'https://test.token.com/api/';
        sa.Web_End_Point__c = 'https://test.com/api/';
        sa.Web_End_Point_Opp_Stage_Update__c = 'https://test.com/api/';
        insert sa;
       
		opportunity opp = new opportunity();
        opp.Name = 'test 3';
        opp.StageName = 'Underwriting';
        opp.CloseDate =system.today().addDays(30);
        opp.Backend_partner_selected__c=True;
        insert opp ;
        
        /*
        ActionPlan ap = new ActionPlan();
        ap.ActionPlanState = 'In Progress';
        ap.ActionPlanType = 'Industries';
        ap.Name = 'testAp';
        ap.TargetId = opp.Id;
        ap.StartDate = System.Date.today();
        //ap.ActionPlanTemplateVersionId = [SELECT Id FROM ActionPlanTemplateVersion LIMIT 1 ].Id;
        insert ap;*/
        /*
        ActionPlanTemplate apt = new ActionPlanTemplate();
        apt.ActionPlanType = 'Industries';
        apt.Name = 'TestAPT';
        apt.TargetEntityType = 'Opportunity';
        apt.UniqueName = 'TestAptDemo';
        insert apt;
        
         ActionPlanTemplateVersion templateVersion = [SELECT Id, ActionPlanTemplateId, Name, Status, Version 
                                                      FROM ActionPlanTemplateVersion WHERE ActionPlanTemplateId =:apt.Id];
        system.debug('templateVersion ## '+templateVersion);
       
        
        ActionPlanTemplateItem templateItem2 = new ActionPlanTemplateItem();
        templateItem2.Name = 'Test Action Task 2';
        templateItem2.ItemEntityType = 'Task';
        templateItem2.IsActive=true;
        templateItem2.UniqueName = 'Test2_1_448a9990_6501_11ed_8a0a_213b76b4dbca';
        templateItem2.ActionPlanTemplateVersionId = templateVersion.Id;

        insert templateItem2;
        
         ActionPlanTemplateItemValue templateItem2value1 = new ActionPlanTemplateItemValue();
        templateItem2value1.ActionPlanTemplateItemId = templateItem2.Id;
        templateItem2value1.ItemEntityFieldName = 'Task.Subject';
        templateItem2value1.Name = 'templateItem2value1';
        templateItem2value1.ValueLiteral = 'Test Action Task Value 2';
        insert templateItem2value1;
        
           ActionPlanTemplateItemValue templateItem2value2 = new ActionPlanTemplateItemValue();
        templateItem2value2.ActionPlanTemplateItemId = templateItem2.Id;
        templateItem2value2.ItemEntityFieldName = 'Task.Priority';
        templateItem2value2.Name = 'templateItem2value2';
        templateItem2value2.ValueLiteral = 'Normal';
        insert templateItem2value2;

        ActionPlanTemplateItemValue templateItem2value3 = new ActionPlanTemplateItemValue();
        templateItem2value3.ActionPlanTemplateItemId = templateItem2.Id;
        templateItem2value3.ItemEntityFieldName = 'Task.ActivityDate';
        templateItem2value3.Name = 'templateItem2value3';
        templateItem2value3.ValueFormula = 'StartDate + 10';
        insert templateItem2value3;

        templateVersion.Status = 'Final';
        update templateVersion;
        
         ActionPlan ap = new ActionPlan();
        ap.ActionPlanState = 'Completed';
        ap.ActionPlanType = 'Industries';
        ap.Name = 'testAp';
        ap.TargetId = opp.Id;
        ap.StartDate = System.Date.today();
        ap.ActionPlanTemplateVersionId =templateVersion.Id;
        insert ap;
        
       */
        
        
        
        opp.StageName='Processing';
        opp.Processor__c = UserInfo.getUserId();
       
		Test.startTest();
			update opp;
		Test.stopTest();   
 }
    
   
}