@istest
public class SPR_ExceptionTriggerHelperTest {
    
    @TestSetup
    static void loadData(){
               
        List<Opportunity_Worksheet__c> oppList = new List<Opportunity_Worksheet__c>();
        Opportunity_Worksheet__c oppwk1 = new Opportunity_Worksheet__c();
        oppwk1.Prime_Rate__c=1;
        oppList.add(oppwk1);
         
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppList.add(oppwk2);
        
        Opportunity_Worksheet__c oppwk3 = new Opportunity_Worksheet__c();
        oppwk3.Prime_Rate__c=3;
        oppList.add(oppwk3);

		Opportunity_Worksheet__c oppwk4 = new Opportunity_Worksheet__c();
        oppwk4.Prime_Rate__c=4;
        oppList.add(oppwk4);
        
        insert oppList;
        
        Payoffs__c py = new Payoffs__c( Balance__c=100,Opportunity_Worksheet__c=oppwk2.Id);
        insert py;
        
        Paid_Through_Closing__c ptc = new Paid_Through_Closing__c();
		ptc.Opportunity_Worksheet__c = oppwk2.Id;
        ptc.Good_Through_Date__c= System.today();
        ptc.Payoff__c=py.Id;
        insert ptc;
        
        Paid_Through_Closing__c ptc2 = new Paid_Through_Closing__c();
		ptc2.Opportunity_Worksheet__c = oppwk2.Id;
        ptc2.Good_Through_Date__c= System.today()-1;
        ptc2.Payoff__c=py.Id;
        insert ptc2;
        
        Credit_Report__c cr = new Credit_Report__c(  First_Name__c='Test FN', Last_Name__c='Test LN');
        insert cr;
        
        Collection__c col = new Collection__c(  Opportunity_Worksheet__c=oppwk2.Id, 
                                              Good_Through_Date__c=System.today(),Credit_Report__c=cr.Id);
        insert col;
        
        Collection__c col2 = new Collection__c(  Opportunity_Worksheet__c=oppwk2.Id, 
                                               Good_Through_Date__c=System.today()-1,Credit_Report__c=cr.Id);
        insert col2;
        
        
        Title_Report__c tr = new Title_Report__c();
        tr.Final_Vesting_is_Trust_LLC__c = 'Yes';
        //tr.Name='Test';
        insert tr;
        List<Exception__c> excpList = new List<Exception__c>();
        Exception__c exObject = new Exception__c();
        exObject.Type__c = 'Mortgage';
        exObject.Opportunity_Worksheet__c = oppwk2.Id;
        exObject.Title_Report__c=tr.Id;
        excpList.add(exObject);
        
        Exception__c exObject1 = new Exception__c();
        exObject1.Type__c = 'Mortgage';
        exObject1.Opportunity_Worksheet__c = oppwk1.Id;
        exObject1.Title_Report__c=tr.Id;
        excpList.add(exObject1);
        
        Exception__c exObject2 = new Exception__c();
        exObject2.Type__c = 'Mortgage';
        exObject2.Opportunity_Worksheet__c = oppwk3.Id;
        exObject2.Title_Report__c=tr.Id;
        excpList.add(exObject2);
        
        Exception__c exObject3 = new Exception__c();
        exObject3.Type__c = 'Mortgage';
        exObject3.Opportunity_Worksheet__c = oppwk3.Id;
        exObject3.Title_Report__c=tr.Id;
        excpList.add(exObject3);
        
        Exception__c exObject4 = new Exception__c();
        exObject4.Type__c = 'Mortgage';
        exObject4.Opportunity_Worksheet__c = oppwk3.Id;
        exObject4.Title_Report__c=tr.Id;
        excpList.add(exObject4);
        
        insert excpList;        
        
        List<Mortgage_Statement__c> msList = new List<Mortgage_Statement__c>();
        Mortgage_Statement__c ms = new Mortgage_Statement__c();
        ms.Principal_Balance_or_maximum_if_HELOC__c=100;
        ms.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms.Opportunity_Worksheet__c = oppwk2.Id;
        ms.Interest_Rate__c=3;
        ms.Has_Default_Foreclosure_Notice__c = 'Yes';
        ms.Is_Private_Mortgage__c='No';
        msList.add(ms);
            
        Mortgage_Statement__c ms1 = new Mortgage_Statement__c();
        ms1.Principal_Balance_or_maximum_if_HELOC__c=100;
        ms1.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms1.Opportunity_Worksheet__c = oppwk1.Id;
        ms1.Interest_Rate__c=3;
        ms1.Is_Private_Mortgage__c='Yes';
        ms1.Has_Default_Foreclosure_Notice__c = 'Yes';
        msList.add(ms1);
        
        Mortgage_Statement__c ms2 = new Mortgage_Statement__c();
        ms2.Principal_Balance_or_maximum_if_HELOC__c=100;
        ms2.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms2.Opportunity_Worksheet__c = oppwk1.Id;
        ms2.Interest_Rate__c=4;
        ms2.Is_Private_Mortgage__c='Yes';
        msList.add(ms2);
        
        Mortgage_Statement__c ms3 = new Mortgage_Statement__c();
        ms3.Principal_Balance_or_maximum_if_HELOC__c=1000;
        ms3.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms3.Opportunity_Worksheet__c = oppwk3.Id;
        ms3.Interest_Rate__c=5;
        ms3.Is_Private_Mortgage__c='Yes';
        ms3.Has_Default_Foreclosure_Notice__c = 'Yes';
        msList.add(ms3);
        
		insert msList;        
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Oddities__c='Balloon';
        ri.Opportunity_Worksheet__c = oppwk1.Id;
        insert ri;
        
        Recorded_Instruments__c ri1 = new Recorded_Instruments__c();
        ri1.Oddities__c='Balloon';
        ri1.Opportunity_Worksheet__c = oppwk3.Id;
        insert ri1;
    }
    
    @istest
    private static void updateSeniorLinesAndTitleCleanOnOWTest1(){
        Opportunity_Worksheet__c oppwk =[SELECT Id,Name FROM Opportunity_Worksheet__c LIMIT 1];
        
        Title_Report__c tr = new Title_Report__c();
        tr.Final_Vesting_is_Trust_LLC__c = 'Yes';
        //tr.Name='Test';
        insert tr;
        
        Exception__c exObject = new Exception__c();
        exObject.Type__c = 'Mortgage';
        exObject.Title_Report__c = tr.Id;
        exObject.Opportunity_Worksheet__c = oppwk.Id;
        
        Test.startTest();
        insert exObject;
        Test.stopTest();
    }
    
    @istest
    private static void updateSeniorLinesAndTitleCleanOnOWTest2(){
        Opportunity_Worksheet__c oppwk =[SELECT Id,Name FROM Opportunity_Worksheet__c Where Prime_Rate__c=2 LIMIT 1];
        
        Exception__c exObject = [SELECT Id FROM Exception__c WHERE Opportunity_Worksheet__c =:oppwk.Id];
        
        Test.startTest();
        
         delete exObject;
       
        Test.stopTest();
    }
    
    @istest
    private static void updateSeniorLinesAndTitleCleanOnOWTest(){
    	Opportunity_Worksheet__c oppwk =[SELECT Id,Name FROM Opportunity_Worksheet__c Where Prime_Rate__c=2 LIMIT 1];
        
        Exception__c exObject = [SELECT Id FROM Exception__c WHERE Opportunity_Worksheet__c =:oppwk.Id];
        
        List<Opportunity_Worksheet__c> owList = [Select Id,PTC_Total__c,Collections_Total__c,Prime_Rate__c,
                                                 	(Select Id, Type__c From Exception__r),
                                                     (Select Id,Good_Through_Date__c,Balance__c,RecordTypeId From Payoffs__r),
                                                     (Select Id,Good_Through_Date__c From Paid_Through_Closings__r),
                                                     (Select Id,Good_Through_Date__c From Collections__r)
                                                     From Opportunity_Worksheet__c Where Id =:oppwk.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.updateSeniorLinesAndTitleCleanOnOW(owList); 
        Test.stopTest();
    }
    
    @istest
    private static void updateOpportunityWorksheetTest(){
    	Opportunity_Worksheet__c oppwk =[SELECT Id,Name FROM Opportunity_Worksheet__c Where Prime_Rate__c=2 LIMIT 1];
        
        Exception__c exObject = [SELECT Id FROM Exception__c WHERE Opportunity_Worksheet__c =:oppwk.Id];
        
        List<Opportunity_Worksheet__c> owList = [Select Id,PTC_Total__c,Collections_Total__c,
                                                 	(Select Id, Type__c From Exception__r),
                                                     (Select Id,Good_Through_Date__c From Paid_Through_Closings__r),
                                                     (Select Id,Good_Through_Date__c From Collections__r),
                                                 	(Select Id,Good_Through_Date__c,Balance__c,RecordTypeId From Payoffs__r)
                                                     From Opportunity_Worksheet__c Where Id =:oppwk.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.updateOpportunityWorksheet(owList);
        
        Test.stopTest();
    }
    
    @istest
    private static void setOpportunityWorksheetDataTest(){
    	Opportunity_Worksheet__c oppwk =[SELECT Id,Name FROM Opportunity_Worksheet__c Where Prime_Rate__c=2 LIMIT 1];
        
        Exception__c exObject = [SELECT Id FROM Exception__c WHERE Opportunity_Worksheet__c =:oppwk.Id];
        
        List<Opportunity_Worksheet__c> owList = [Select Id,PTC_Total__c,Collections_Total__c,
                                                 	(Select Id, Type__c From Exception__r),
                                                     (Select Id,Good_Through_Date__c From Paid_Through_Closings__r),
                                                     (Select Id,Good_Through_Date__c From Collections__r),
                                                     (Select Id,Good_Through_Date__c,Balance__c,RecordTypeId From Payoffs__r)
                                                     From Opportunity_Worksheet__c Where Id =:oppwk.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.setOpportunityWorksheetData(oppwk.Id);
        Test.stopTest();
    }
    
    @istest
    private static void setOpportunityWorksheetDQHistoryTest(){
    	Opportunity_Worksheet__c oppwk =[SELECT Id,Name FROM Opportunity_Worksheet__c Where Prime_Rate__c=2 LIMIT 1];
        
        Exception__c exObject = [SELECT Id FROM Exception__c WHERE Opportunity_Worksheet__c =:oppwk.Id];
        
        List<Opportunity_Worksheet__c> owList = [Select Id,PTC_Total__c,Collections_Total__c,
                                                 	(Select Id, Type__c From Exception__r),
                                                     (Select Id,Good_Through_Date__c From Paid_Through_Closings__r),
                                                     (Select Id,Good_Through_Date__c From Collections__r),
                                                     (Select Id,Good_Through_Date__c,Balance__c,RecordTypeId From Payoffs__r)
                                                     From Opportunity_Worksheet__c Where Id =:oppwk.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.setOpportunityWorksheetDQHistory(oppwk.Id);
        Test.stopTest();
    }
    
    @isTest
    private static void calculateExceptionsTest(){
        
        Opportunity_Worksheet__c op = [Select Id From Opportunity_Worksheet__c Where Prime_Rate__c=2 LIMIT 1 ];
        Opportunity_Worksheet__c op2 = [Select Id From Opportunity_Worksheet__c Where Prime_Rate__c=1 LIMIT 1 ];
        Opportunity_Worksheet__c op3 = [Select Id From Opportunity_Worksheet__c Where Prime_Rate__c=3 LIMIT 1 ];
        Opportunity_Worksheet__c op4 = [Select Id From Opportunity_Worksheet__c Where Prime_Rate__c=4 LIMIT 1 ];
        Test.startTest();
        	SPR_OpportunityWorksheetUtil.calculateExceptions(op.Id);
        	SPR_OpportunityWorksheetUtil.calculateExceptions(op2.Id);
        	SPR_OpportunityWorksheetUtil.calculateExceptions(op3.Id);
        	SPR_OpportunityWorksheetUtil.calculateExceptions(op4.Id);
        Test.stopTest();
    }
    
    @isTest
    private static void calculateSeniorLienTypeTest2(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='2';
        insert oppwk2;   
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,Senior_Lien_Type__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList); 
        Test.stopTest();
    }
    
    @isTest
    private static void calculateSeniorLienTypeTest21(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='2';
        insert oppwk2;              
         
        Mortgage_Statement__c ms3 = new Mortgage_Statement__c();
        ms3.Principal_Balance_or_maximum_if_HELOC__c=1000;
        ms3.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms3.Opportunity_Worksheet__c = oppwk2.Id;
        ms3.Interest_Rate__c=5;
        ms3.Is_Private_Mortgage__c='No';
        ms3.Has_Default_Foreclosure_Notice__c = 'Yes';
         
        insert ms3;
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,Senior_Lien_Type__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList); 
        Test.stopTest();
    }
    
    @isTest
    private static void calculateSeniorLienTypeTest22(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='2';
        insert oppwk2;              
         
        Mortgage_Statement__c ms3 = new Mortgage_Statement__c();
        ms3.Principal_Balance_or_maximum_if_HELOC__c=1000;
        ms3.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms3.Opportunity_Worksheet__c = oppwk2.Id;
        ms3.Interest_Rate__c=5;
        ms3.Is_Private_Mortgage__c='Yes';
        ms3.Has_Default_Foreclosure_Notice__c = 'Yes';
         
        insert ms3;
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Oddities__c='Balloon';
        ri.Opportunity_Worksheet__c = oppwk2.Id;
        insert ri;
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList); 
        Test.stopTest();
    }
    
    
    @isTest
    private static void calculateSeniorLienTypeTest3(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='3';
        insert oppwk2;   
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,Senior_Lien_Type__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList); 
        Test.stopTest();
    }
    
    @isTest
    private static void calculateSeniorLienTypeTest31(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='3';
        insert oppwk2;              
         
        Mortgage_Statement__c ms3 = new Mortgage_Statement__c();
        ms3.Principal_Balance_or_maximum_if_HELOC__c=1000;
        ms3.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms3.Opportunity_Worksheet__c = oppwk2.Id;
        ms3.Interest_Rate__c=5;
        ms3.Is_Private_Mortgage__c='No';
        ms3.Has_Default_Foreclosure_Notice__c = 'Yes';
         
        insert ms3;
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,Senior_Lien_Type__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList); 
        Test.stopTest();
    }
    
    @isTest
    private static void calculateSeniorLienTypeTest32(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='3';
        insert oppwk2;              
         
        Mortgage_Statement__c ms3 = new Mortgage_Statement__c();
        ms3.Principal_Balance_or_maximum_if_HELOC__c=1000;
        ms3.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms3.Opportunity_Worksheet__c = oppwk2.Id;
        ms3.Interest_Rate__c=5;
        ms3.Is_Private_Mortgage__c='Yes';
        ms3.Has_Default_Foreclosure_Notice__c = 'Yes';
         
        insert ms3;
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Oddities__c='Balloon';
        ri.Opportunity_Worksheet__c = oppwk2.Id;
        insert ri;
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList); 
        Test.stopTest();
    }
    
    @isTest
    private static void calculateSeniorLienTypeTest123(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='3';
        insert oppwk2;              
         
        Mortgage_Statement__c ms3 = new Mortgage_Statement__c();
        ms3.Principal_Balance_or_maximum_if_HELOC__c=1000;
        ms3.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms3.Opportunity_Worksheet__c = oppwk2.Id;
        ms3.Interest_Rate__c=5;
        ms3.Is_Private_Mortgage__c='No';
        ms3.Has_Default_Foreclosure_Notice__c = 'Yes';
         
        insert ms3;
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Oddities__c='Private';
        ri.Opportunity_Worksheet__c = oppwk2.Id;
        insert ri;
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList); 
        Test.stopTest();
    }
    
    @isTest
    private static void updateSeniorLinesAndTitleCleanOnOWTestNew(){
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c();
        oppwk2.Prime_Rate__c=2;
        oppwk2.Investment_Position__c='3';
        insert oppwk2;              
         
        Mortgage_Statement__c ms3 = new Mortgage_Statement__c();
        ms3.Principal_Balance_or_maximum_if_HELOC__c=1000;
        ms3.Mortgage_Payoff_Required_or_Requested__c='No'; 
        ms3.Opportunity_Worksheet__c = oppwk2.Id;
        ms3.Interest_Rate__c=5;
        ms3.Is_Private_Mortgage__c='No';
        ms3.Has_Default_Foreclosure_Notice__c = 'Yes';
         
        insert ms3;
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Oddities__c='Private';
        ri.Opportunity_Worksheet__c = oppwk2.Id;
        insert ri;
        
        
        Title_Report__c tr = new Title_Report__c();
        tr.Final_Vesting_is_Trust_LLC__c = 'Yes';
        tr.Opportunity_Worksheet__c = oppwk2.Id;
        insert tr;
        
        Exception__c excp = new Exception__c();
        excp.Type__c='Judgment';
        excp.Title_Report__c=tr.Id;
        insert excp;
        
        Release__c rel = new Release__c();
        rel.Type__c='Easement'; 
        rel.Title_Report__c=tr.Id;
        insert rel;
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Prime_Rate__c,Investment_Position__c,
                                                (Select Id, Type__c From Exception__r),
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                From Mortgage_Statements__r),                                                 
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
                                                (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
                                                From Opportunity_Worksheet__c Where Id=:oppwk2.Id];
        
        Test.startTest();
        SPR_OpportunityWorksheetUtil.updateSeniorLinesAndTitleCleanOnOW(owList); 
        Test.stopTest();
    }
    
    @isTest
    private static void calculateHybridAppraisalTest(){
        
        List<Opportunity_Worksheet__c> owList = [Select Id,(Select Id, Principal_Balance_or_maximum_if_HELOC__c,
                                                Mortgage_Payoff_Required_or_Requested__c From Mortgage_Statements__r) 
                                                From Opportunity_Worksheet__c ];
        
        Id Hybrid_Appraisal = Schema.SObjectType.Valuation__c
                                .getRecordTypeInfosByName()
                                .get('Hybrid Appraisal')
                                .getRecordTypeId();
        
        Valuation__c  val = new Valuation__c(Estimated_Value__c=100,Effective_Date__c=Date.today(),RecordTypeId=Hybrid_Appraisal);
        val.Opportunity_Worksheet__c=owList[0].Id;
        insert val;
        
        Valuation__c  val1 = new Valuation__c(Estimated_Value__c=100,Effective_Date__c=Date.today().addDays(5),RecordTypeId=Hybrid_Appraisal);
        val1.Opportunity_Worksheet__c=owList[0].Id;
        insert val1;
        
        Opportunity_Worksheet__c owTest = [Select Id From Opportunity_Worksheet__c Where Id=:owList[0].Id];
        Test.startTest();
        	SPR_OpportunityWorksheetUtil.calculateHybridAppraisal(owTest.Id);
        Test.stopTest();
    }
    @isTest
    public static void  InsertDocumentTest(){
        
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
        
        Exception__c exce = New Exception__c();
        exce.Title_Report__c = tr.Id;
        exce.Type__c = 'Other';
         
        
        Test.startTest();
        	insert exce;
        Test.stopTest();
        
        
        
        
    }
    
    @isTest
    public static void  UpdateDocumentTest(){
        
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
        
        Exception__c exce = New Exception__c();
        exce.Title_Report__c = tr.Id;
        exce.Type__c = 'Judgment';
        insert exce;
        
        Test.startTest();
          exce.Type__c = 'Other';
        	update exce;
        Test.stopTest();
        
        
        
        
    }
}