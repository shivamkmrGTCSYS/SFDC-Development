@isTest
public class SPR_DocumentUtilityTest {
    @isTest
    public static void testSPRdocUtility(){
        
        Application__c app =New Application__c();
        app.x1st_Loan_Mod__c='Yes';
        app.X2nd_Loan_Mod__c='Yes';
        app.Marital_Status__c='Married';
        app.Number_of_Co_Owners_excluding_yourself__c= 2;
        app.Vesting_Type__c='Through a Trust';
        app.Property_listed_or_under_contract__c ='Yes';
        app.Status__c='Applying'; 
        app.HERO_or_PACE_loan__c='Yes';
        
        insert app;
        
        Property__c pro = New Property__c();
        pro.Number_Of_Owner__c=2;
        pro.Flood_Zone__c ='A';
        
        insert pro;
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
        OppWork.AVM_Eligible__c = 'Yes';
        //OppWork.Credit_Report__c= 'test';
        insert OppWork;
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Opportunity_Worksheet__c=OppWork.Id;
        ri.Oddities__c='Interest Only';
        insert ri ;
        
        Mortgage_Statement__c ms = new Mortgage_Statement__c();
        ms.Opportunity_Worksheet__c=OppWork.Id;
        ms.Deferred_Amount__c=100;
        ms.Deferred_Amount_to_payoff__c=120;
        insert ms;
        
        DQ_History__c dq = New DQ_History__c();
        dq.Opportunity_Worksheet__c = OppWork.Id;
        //dq.Name ='test';
        dq.Extenuating_Circumstances__c ='Yes';
        insert dq;
        
        Credit_Report__c cr = New Credit_Report__c();
        
        cr.Opportunity_Worksheet__c=OppWork.id;
        insert cr;
        
        Collection__c cc  = New Collection__c();
        cc.Credit_Report__c = cr.Id;
        cc.Account_Number__c= 123345678;
        cc.Settlement_Amount__c =9000;
        insert cc;
        
        List<Mortgage__c> mortList = new List<Mortgage__c>();
        Mortgage__c mort = new Mortgage__c();
        mort.Credit_Report__c = cr.Id;
        mortList.add(mort);
        
        Mortgage__c mort1 = new Mortgage__c();
        mort1.Credit_Report__c = cr.Id;
        mortList.add(mort1);
        
        insert mortList ;
        
        Inquiry__c Inq = New Inquiry__c();
        Inq.Credit_Report__c = cr.Id;
        Inq.Date__c = Date.today().addDays(-5);
        insert Inq;
        
        Title_Report__c  tr = New Title_Report__c();
        tr.Opportunity_Worksheet__c= OppWork.Id;
        //tr.Name = 'test';
        
        insert tr;
        
        List<Exception__c> excpList = new List<Exception__c>();
        Exception__c exc = New Exception__c();
        exc.Title_Report__c = tr.Id;
        //exc.Name ='test';
        exc.Type__c='Mortgage';
        excpList.add(exc);
        
        Exception__c exc1 = New Exception__c();
        exc1.Title_Report__c = tr.Id;
        //exc1.Name ='test';
        exc1.Type__c='Other';
        excpList.add(exc1);
        
        insert excpList; 
        
        Release__c rel = New Release__c();
        rel.Title_Report__c = tr.Id;
        rel.Type__c = '	Hero/Pace';
        insert rel;
        Release__c release = New Release__c();
        release.Title_Report__c = tr.Id;
        release.Type__c = '	Easement';
        release.Payoff_Required__c = 'Yes';
        insert release;
        
        Release__c releas = New Release__c();
        releas.Title_Report__c = tr.Id;
        releas.Type__c = 'Property Taxes';
        releas.Payoff_Required__c = 'Yes';
        insert releas;
        
        Release__c relea = New Release__c();
        relea.Title_Report__c = tr.Id;
        relea.Type__c = 'Judgment';
        relea.Payoff_Required__c = 'No';
        insert relea;
        
        Release__c rele = New Release__c();
        rele.Title_Report__c = tr.Id;
        rele.Type__c = 'Solar';
        rele.Payoff_Required__c = 'No';
        insert rele;
        
        Opportunity opp = New Opportunity();
        opp.Application__c = app.Id;
        opp.Property__c =pro.Id;
        opp.Opportunity_Worksheet__c =OppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Prospecting';
        opp.CloseDate=Date.today().addDays(3);
        opp.Hybrid_Appraisal_Required__c='Yes';
        opp.Application_Status1__c='Denied';
        Test.startTest();
        	insert Opp;
         
        	Opportunity oppUpdate = [Select Id From Opportunity Where Id=:Opp.Id];
        	Update oppUpdate;
        
        	 
        Test.stopTest();
    }
    
    @isTest
    public static void testSPRdocUtility1(){
        
        Application__c app =New Application__c();
        app.x1st_Loan_Mod__c='Yes';
        app.X2nd_Loan_Mod__c='Yes';
        app.Marital_Status__c='Married';
        app.Number_of_Co_Owners_excluding_yourself__c= 2;
        app.Vesting_Type__c='Through a Trust';
        app.Property_listed_or_under_contract__c ='Yes';
        app.Status__c='Applying';
        app.HERO_or_PACE_loan__c='Yes';
        
        insert app;
        
        Property__c pro = New Property__c();
        pro.Number_Of_Owner__c=2;
        pro.Flood_Zone__c ='A';
        
        insert pro;
        
        Opportunity_Worksheet__c OppWork = New Opportunity_Worksheet__c();
        OppWork.AVM_Eligible__c = 'Yes';
        //OppWork.Credit_Report__c= 'test';
        insert OppWork;
        
        Recorded_Instruments__c ri = new Recorded_Instruments__c();
        ri.Opportunity_Worksheet__c=OppWork.Id;
        ri.Oddities__c='Interest Only';
        insert ri ;
        
        Mortgage_Statement__c ms = new Mortgage_Statement__c();
        ms.Opportunity_Worksheet__c=OppWork.Id;
        ms.Deferred_Amount__c=100;
        ms.Deferred_Amount_to_payoff__c=120;
        insert ms;
        
        DQ_History__c dq = New DQ_History__c();
        dq.Opportunity_Worksheet__c = OppWork.Id;
        //dq.Name ='test';
        dq.Extenuating_Circumstances__c ='Yes';
        insert dq;
        
        Credit_Report__c cr = New Credit_Report__c();
        
        cr.Opportunity_Worksheet__c=OppWork.id;
        insert cr;
        
        Collection__c cc  = New Collection__c();
        cc.Credit_Report__c = cr.Id;
        cc.Account_Number__c= 123345678;
        cc.Settlement_Amount__c =9000;
        insert cc;
        
        List<Mortgage__c> mortList = new List<Mortgage__c>();
        Mortgage__c mort = new Mortgage__c();
        mort.Credit_Report__c = cr.Id;
        mortList.add(mort);
        
        Mortgage__c mort1 = new Mortgage__c();
        mort1.Credit_Report__c = cr.Id;
        mortList.add(mort1);
        
        insert mortList ;
        
        Inquiry__c Inq = New Inquiry__c();
        Inq.Credit_Report__c = cr.Id;
        Inq.Date__c = Date.today().addDays(-5);
        insert Inq;
        
        Title_Report__c  tr = New Title_Report__c();
        tr.Opportunity_Worksheet__c= OppWork.Id;
        //tr.Name = 'test';
        
        insert tr;
        
        List<Exception__c> excpList = new List<Exception__c>();
        Exception__c exc = New Exception__c();
        exc.Title_Report__c = tr.Id;
        //exc.Name ='test';
        exc.Type__c='Mortgage';
        excpList.add(exc);
        
        Exception__c exc1 = New Exception__c();
        exc1.Title_Report__c = tr.Id;
        //exc1.Name ='test';
        exc1.Type__c='Other';
        excpList.add(exc1);
        
        insert excpList; 
        
        Release__c rel = New Release__c();
        rel.Title_Report__c = tr.Id;
        rel.Type__c = '	Hero/Pace';
        insert rel;
        Release__c release = New Release__c();
        release.Title_Report__c = tr.Id;
        release.Type__c = '	Easement';
        release.Payoff_Required__c = 'Yes';
        insert release;
        
        Release__c releas = New Release__c();
        releas.Title_Report__c = tr.Id;
        releas.Type__c = '	Property Taxes';
        releas.Payoff_Required__c = 'Yes';
        insert releas;
         
        Release__c relea = New Release__c();
        relea.Title_Report__c = tr.Id;
        relea.Type__c = 'Judgment';
        relea.Payoff_Required__c = 'No';
        insert relea;
        
        Release__c rele = New Release__c(); 
        rele.Title_Report__c = tr.Id;
        rele.Type__c = 'Solar';
        rele.Payoff_Required__c = 'No';
        insert rele;
        
        Opportunity opp = New Opportunity();
        opp.Application__c = app.Id;
        opp.Property__c =pro.Id;
        opp.Opportunity_Worksheet__c =OppWork.Id;
        opp.Name ='test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate=Date.today().addDays(3);
        opp.Hybrid_Appraisal_Required__c='Yes';
        opp.Application_Status1__c='Denied';
        Test.startTest();
        	insert Opp;
        
        	Opportunity oppUpdate = [Select Id From Opportunity Where Id=:Opp.Id];
        	oppUpdate.StageName = 'Processing';
        	Update oppUpdate;
        Test.stopTest();
    }

}