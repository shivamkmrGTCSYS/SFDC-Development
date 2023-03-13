@isTest
public class SPR_CalculatorVersionCloneControllerTest {

    @isTest
    public static void getCalculatorVersionDetailTest(){
         
        Calculator_Version__c cv = new Calculator_Version__c(Name='test',Version__c='1');
        insert cv ;
        
        Test.startTest();
        	SPR_CalculatorVersionCloneController.getCalculatorVersionDetail(cv.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void cloneCalculatorVersionTest(){
         
        Calculator_Version__c cv = new Calculator_Version__c(Name='test',Version__c='1');
        insert cv ;
        
        Consumer_Price_Config__c cpc = new Consumer_Price_Config__c();
        cpc.Calculator_Version__c = cv.Id;
        insert cpc;
        
        Test.startTest();
        	SPR_CalculatorVersionCloneController.cloneCalculatorVersion(cv.Id,'testv');
        Test.stopTest();
    }
    
    
}