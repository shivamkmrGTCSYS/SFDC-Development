@isTest
public class DQHistoryTriggerTest {

    @isTest
    public static void dqHistoryTest(){
        
        Id bankruptcyRecordTypeId = Schema.SObjectType.DQ_History__c
                                .getRecordTypeInfosByName()
                                .get('Bankruptcy')
                                .getRecordTypeId();
    
    	Id foreclosureRecordTypeId = Schema.SObjectType.DQ_History__c
                                .getRecordTypeInfosByName()
                                .get('Foreclosure or Deed-In-Lieu')
                                .getRecordTypeId();
        
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109'; 
        insert pr;
        
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        opp.Property__c = pr.id;
        insert opp;
        
        Opportunity_Worksheet__c ow = new Opportunity_Worksheet__c();
        ow.Opportunity__c=opp.Id;
        insert ow;
        
        Opportunity_Worksheet__c ow1 = new Opportunity_Worksheet__c();
        ow1.Opportunity__c=opp.Id;
        insert ow1;
        
        List<DQ_History__c> dqHistoryList = new List<DQ_History__c>();
        
        DQ_History__c dqHistory = new DQ_History__c();
        
        dqHistory.Discharge_Date_Bankruptcy__c =Date.today().addDays(10);
        dqHistory.Discharge_Date_Bankruptcy__c =Date.today().addDays(20);
        dqHistory.Discharge_Date_Bankruptcy__c =Date.today().addDays(30);
        dqHistory.Discharge_Date_Bankruptcy__c =Date.today().addDays(40);
        dqHistory.Discharge_Date_Bankruptcy__c =Date.today().addDays(50);
        
        dqHistory.Dismissal_Date_Bankruptcy__c=Date.today().addDays(15);
        dqHistory.Dismissal_Date_Bankruptcy__c=Date.today().addDays(25);
        dqHistory.Dismissal_Date_Bankruptcy__c=Date.today().addDays(35);
        dqHistory.Dismissal_Date_Bankruptcy__c=Date.today().addDays(45);
        dqHistory.Dismissal_Date_Bankruptcy__c=Date.today().addDays(55);
        
        dqHistory.Extenuating_Circumstances__c='Yes';
        dqHistory.Opportunity_Worksheet__c=ow.Id;
        dqHistory.RecordTypeId=bankruptcyRecordTypeId;
        
        dqHistoryList.add(dqHistory);
            
        DQ_History__c dqHistory1 = new DQ_History__c(Opportunity_Worksheet__c=ow.Id);
        DQ_History__c dqHistory2 = new DQ_History__c(Opportunity_Worksheet__c=ow.Id);
        DQ_History__c dqHistory3 = new DQ_History__c(Opportunity_Worksheet__c=ow.Id);
        DQ_History__c dqHistory4 = new DQ_History__c(Opportunity_Worksheet__c=ow.Id);
        DQ_History__c dqHistory5 = new DQ_History__c(Opportunity_Worksheet__c=ow.Id);
        
        dqHistory1.Discharge_Date_Bankruptcy__c =Date.today().addDays(10);
        dqHistory2.Discharge_Date_Bankruptcy__c =Date.today().addDays(20);
        dqHistory3.Discharge_Date_Bankruptcy__c =Date.today().addDays(30);
        dqHistory4.Discharge_Date_Bankruptcy__c =Date.today().addDays(40);
        dqHistory5.Discharge_Date_Bankruptcy__c =Date.today().addDays(50);
        
        dqHistory1.Dismissal_Date_Bankruptcy__c=Date.today().addDays(15);
        dqHistory2.Dismissal_Date_Bankruptcy__c=Date.today().addDays(25);
        dqHistory3.Dismissal_Date_Bankruptcy__c=Date.today().addDays(35);
        dqHistory4.Dismissal_Date_Bankruptcy__c=Date.today().addDays(45);
        dqHistory5.Dismissal_Date_Bankruptcy__c=Date.today().addDays(55);
        
        dqHistory1.Extenuating_Circumstances__c='Yes';
        dqHistory2.Extenuating_Circumstances__c='Yes';
        dqHistory3.Extenuating_Circumstances__c='Yes';
        dqHistory4.Extenuating_Circumstances__c='Yes';
        dqHistory5.Extenuating_Circumstances__c='Yes';
        
        dqHistory2.Completion_Date__c=Date.today().addDays(12);
        dqHistory1.Completion_Date__c=Date.today().addDays(22);
        dqHistory1.Completion_Date__c=Date.today().addDays(32);
        
        dqHistory1.Type_Foreclosure_Or_Deed_In_Lieu__c='Foreclosure';
        dqHistory2.Type_Foreclosure_Or_Deed_In_Lieu__c='Foreclosure';
        dqHistory1.Type_Foreclosure_Or_Deed_In_Lieu__c='Foreclosure';
        
        
        
        dqHistory1.Opportunity_Worksheet__c=ow1.Id;
        dqHistory1.RecordTypeId=foreclosureRecordTypeId;
        
        dqHistoryList.add(dqHistory1);
        dqHistoryList.add(dqHistory2);
        dqHistoryList.add(dqHistory3);
        dqHistoryList.add(dqHistory4);
        dqHistoryList.add(dqHistory5);
        
        insert dqHistoryList ;
        Test.startTest();
            SPR_OpportunityWorksheetUtil.setOpportunityWorksheetDQHistory(ow1.Id);
        Test.stopTest();
        
        
    }
    
    @isTest static void insertDocument(){
        
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
        List<DQ_History__c> dqHisList = new List<DQ_History__c>();
        DQ_History__c dqh = new DQ_History__c();         
        dqh.Extenuating_Circumstances__c='Yes';
        dqHisList.add(dqh);         
        DQ_History__c dqh1 = new DQ_History__c();         
        dqh1.Extenuating_Circumstances__c='Yes';
        dqHisList.add(dqh1); 
        Test.startTest();
        	insert dqHisList;
        Test.stopTest(); 
        
    }
    
    @isTest
    public static void UpdateDocument(){
        
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
        
        DQ_History__c dqh = new DQ_History__c();
         
        dqh.Extenuating_Circumstances__c='No';
        dqh.Opportunity_Worksheet__c=OppWork.Id;
        insert dqh;
        
        DQ_History__c dqh1 = new DQ_History__c();
         
        dqh1.Extenuating_Circumstances__c='No';
        dqh1.Opportunity_Worksheet__c=OppWork.Id;
        insert dqh1;
        
        Test.startTest();
        	DQ_History__c dqhTest = [Select Id From DQ_History__c Where Id=:dqh.Id ] ;
        	dqhTest.Extenuating_Circumstances__c='Yes';
        	Update dqhTest;
        Test.stopTest(); 
        
    }

    @isTest
    public static void UpdateDocument1(){
        
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
        
        List<DQ_History__c> dqHisList = new List<DQ_History__c>();
        DQ_History__c dqh = new DQ_History__c();
         
        dqh.Extenuating_Circumstances__c='No';
        dqh.Opportunity_Worksheet__c=OppWork.Id;
        dqHisList.add(dqh);
        
        DQ_History__c dqh1 = new DQ_History__c();
         
        dqh1.Extenuating_Circumstances__c='Yes';
        dqh1.Opportunity_Worksheet__c=OppWork.Id;
        dqHisList.add(dqh1);
        DQ_History__c dqh2 = new DQ_History__c();
         
        dqh2.Extenuating_Circumstances__c='Yes';
        dqh2.Opportunity_Worksheet__c=OppWork.Id;
        dqHisList.add(dqh2);
        
        insert dqHisList ;
        Test.startTest();
        	 DQHistoryTriggerHandler.Foreclosure ff = new DQHistoryTriggerHandler.Foreclosure(dqHisList);
        	 
        Test.stopTest(); 
        
    }

}