@isTest
public class ApplicationTriggerTest {
    
    @isTest
    public static void leadinsertTest(){
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        ld.Status='New';
        insert ld;
        
        Application__c app = new Application__c(Lead__c=ld.Id, Investment_Amount__c=123.45);
        
        Test.startTest();
        insert app;
        Test.stopTest();
        
        // Asserts
        Lead leadTest = [Select Id, Status From Lead Where id=:ld.Id Limit 1] ;
        System.assertEquals('Inquiring', leadTest.Status);
        
        
    }
    @isTest
    public static void leadUpdateTest(){
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        ld.Status='New';
        insert ld;
        
        Application__c app = new Application__c(Lead__c=ld.Id);
        insert app;
        
        app.Status__c='Applying';
        app.Application_Started__c=true;
        app.Application_Question_Completed__c=true;
        app.Step_1_Completion_Time__c=Date.today();
        Test.startTest();
        update app;
        Test.stopTest();
        
        // Asserts
        Lead leadTest = [Select Id, Status From Lead Where id=:ld.Id Limit 1] ;
        //System.assertEquals('Applying', leadTest.Status);
        
        
    }
    @isTest
    public static void convertLeadTest(){
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        ld.Status='New';
        insert ld;
        
        Application__c app = new Application__c(Lead__c=ld.Id);
        insert app;
        
        app.Application_Completed__c=true;
        app.Step_7_Completion_Time__c=Date.today();
        Test.startTest();
        update app;
        Test.stopTest();
        
        // Asserts
        Lead leadTest = [Select Id, Status From Lead Where id=:ld.Id Limit 1] ;
        //System.assertEquals('Applying', leadTest.Status);
        
        
    }
    
    @isTest
    public static void DocumentUpdateTest(){        
         
        Application__c app = New Application__c();
        app.x1st_Loan_Mod__c= 'Yes';
        app.X2nd_Loan_Mod__c= 'Yes';
        app.Marital_Status__c= 'Married';
        app.Number_of_Co_Owners_excluding_yourself__c= 1;
        app.Vesting_Type__c='Through a Trust';        
        app.Property_listed_or_under_contract__c='Yes';        
        app.HERO_or_PACE_loan__c='No';
        app.Solar_or_Energy_Efficient_Loan__c='Yes';         
        
        insert app;
                
        Opportunity opp = New Opportunity();
        opp.Application__c = app.Id;
        opp.Name ='test';
        opp.StageName ='Pre-Approving';
        opp.CloseDate = Date.today();
        insert opp;        
         
        Document__c doc = New Document__c();
        doc.Opportunity__c =opp.Id;
        doc.Name = 'test';
        doc.Required__c =true;
        insert doc;
        
        Test.startTest();
        	app.HERO_or_PACE_loan__c='Yes';
        	update app;
        Test.stopTest();
        
    }
}