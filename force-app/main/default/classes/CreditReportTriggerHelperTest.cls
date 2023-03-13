@isTest
public class CreditReportTriggerHelperTest {
    
    @isTest
    public static void updateCreditScoreTest(){
        List<Credit_Report__c> crList = new List<Credit_Report__c>();
        Credit_Report__c cr1 = new Credit_Report__c(Equifax_Score__c=100,Experian_Score__c=20,Transunion_Score__c=30);
        crList.add(cr1);
        Credit_Report__c cr2 = new Credit_Report__c(Equifax_Score__c=60,Experian_Score__c=20);
        crList.add(cr2);
        Credit_Report__c cr3 = new Credit_Report__c(Equifax_Score__c=20,Transunion_Score__c=100); 
        crList.add(cr3);
        Credit_Report__c cr4 = new Credit_Report__c(Experian_Score__c=40,Transunion_Score__c=100); 
        crList.add(cr4);
        Credit_Report__c cr5 = new Credit_Report__c(Equifax_Score__c=100 );
        crList.add(cr5);        
        Credit_Report__c cr6 = new Credit_Report__c( Experian_Score__c=150 );
        crList.add(cr6);        
        Credit_Report__c cr7 = new Credit_Report__c(  Transunion_Score__c=130);
        crList.add(cr7);        
        Credit_Report__c cr8 = new Credit_Report__c();
        crList.add(cr8);
        
        Test.startTest();
        	insert crList; 
        Test.stopTest();
        
        cr1 = [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c!=null AND Experian_Score__c!=null AND Transunion_Score__c!=null ];        
        System.assertEquals(30, cr1.Credit_Score__c);
        
        cr2 = [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c!=null AND Experian_Score__c!=null AND Transunion_Score__c=null ];        
        System.assertEquals(40, cr2.Credit_Score__c);
        
        cr3 = [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c!=null AND Experian_Score__c=null AND Transunion_Score__c!=null ];        
        System.assertEquals(60, cr3.Credit_Score__c);        
        
        cr4 = [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c=null AND Experian_Score__c!=null AND Transunion_Score__c!=null ];        
        System.assertEquals(70, cr4.Credit_Score__c);
        
        cr5 = [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c!=null AND Experian_Score__c=null AND Transunion_Score__c=null ];        
        System.assertEquals(100, cr5.Credit_Score__c);
        
        cr6 = [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c=null AND Experian_Score__c!=null AND Transunion_Score__c=null ];        
        System.assertEquals(150, cr6.Credit_Score__c);        
        
        cr7= [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c=null AND Experian_Score__c=null AND Transunion_Score__c!=null ];        
        System.assertEquals(130, cr7.Credit_Score__c);
        
        cr8= [Select Id, Credit_Score__c From Credit_Report__c Where Equifax_Score__c=null AND Experian_Score__c=null AND Transunion_Score__c=null ];        
        System.assertEquals(null, cr8.Credit_Score__c);
        
    }
    
}