@isTest
public class SPR_CreateOppConsumerCalculatorTest {

    @testSetup 
    public static void setupMethod() {
        List<Consumer_Price_Config__c> recordToInsert = new   List<Consumer_Price_Config__c>();
        Consumer_Price_Config__c cpc = new Consumer_Price_Config__c();
        cpc.Name = 'FICO';
        cpc.Category__c = 'FICO';
        cpc.Start_Range__c = 740;
        cpc.End_Range__c = 850;
        cpc.Multiple__c = 2.5;
        cpc.Starting_Point__c = 87; 
        cpc.Cap__c = 12.99;
        cpc.Origination_Fee__c = 1.99;
        cpc.Max_OLTV__c = 0;
        recordToInsert.add(cpc);
        
        Consumer_Price_Config__c cpc1 = new Consumer_Price_Config__c();
        cpc1.Name = 'Occupancy';
        cpc1.Category__c = 'Occupancy';
        cpc1.Multiple__c = 0;
        cpc1.Starting_Point__c = 0; 
        cpc1.Cap__c = 0;
        cpc1.Origination_Fee__c = 0;
        cpc1.Max_OLTV__c = 0;
        cpc1.Variable__c = 'OO';
        recordToInsert.add(cpc1);
        
        Consumer_Price_Config__c cpc2 = new Consumer_Price_Config__c();
        cpc2.Name = 'Check Size';
        cpc2.Category__c = 'Check Size (K)';
        cpc2.Multiple__c = 0;
        cpc2.Starting_Point__c = -1; 
        cpc2.Cap__c = 1;
        cpc2.Origination_Fee__c = 0;
        cpc2.Max_OLTV__c = 0;
        cpc2.Start_Range__c = 350;
        cpc2.End_Range__c = 500;
        recordToInsert.add(cpc2);
        
        Consumer_Price_Config__c cpc3 = new Consumer_Price_Config__c();
        cpc3.Name = 'Check Size1';
        cpc3.Category__c = 'Check Size (K)';
        cpc3.Multiple__c = 0;
        cpc3.Starting_Point__c = 0; 
        cpc3.Cap__c = 0;
        cpc3.Origination_Fee__c = 0;
        cpc3.Max_OLTV__c = 0;
        cpc3.Start_Range__c = 0;
        cpc3.End_Range__c = 350;
        recordToInsert.add(cpc3);
        
        Consumer_Price_Config__c cpc4 = new Consumer_Price_Config__c();
        cpc4.Name = 'OLTV';
        cpc4.Category__c = 'OLTV';
        cpc4.Multiple__c = 0.3;
        cpc4.Starting_Point__c = -1.5; 
        cpc4.Cap__c = 1.5;
        cpc4.Origination_Fee__c = 0;
        cpc4.Max_OLTV__c = 0;
        cpc4.Start_Range__c = 75;
        cpc4.End_Range__c = 80;
        recordToInsert.add(cpc4);
        
        Consumer_Price_Config__c cpc5 = new Consumer_Price_Config__c();
        cpc5.Name = 'Property Type';
        cpc5.Category__c = 'Property Type';
        cpc5.Multiple__c = 0;
        cpc5.Starting_Point__c = 0; 
        cpc5.Cap__c = 0;
        cpc5.Origination_Fee__c = 0;
        cpc5.Max_OLTV__c = 0;
        cpc5.Variable__c = 'SFH';
        recordToInsert.add(cpc5);
        
        Consumer_Price_Config__c cpc6 = new Consumer_Price_Config__c();
        cpc6.Name = 'Property Type1';
        cpc6.Category__c = 'Property Type';
        cpc6.Multiple__c = 0;
        cpc6.Starting_Point__c = -2; 
        cpc6.Cap__c = 0.5;
        cpc6.Origination_Fee__c = 0.5;
        cpc6.Max_OLTV__c = -5;
        cpc6.Variable__c = 'HOA';
        recordToInsert.add(cpc6);
        
        Consumer_Price_Config__c cpc7 = new Consumer_Price_Config__c();
        cpc7.Name = 'Property Type2';
        cpc7.Category__c = 'Property Type';
        cpc7.Multiple__c = 0;
        cpc7.Starting_Point__c = -3; 
        cpc7.Cap__c = 1;
        cpc7.Origination_Fee__c = 1;
        cpc7.Max_OLTV__c = -10;
        cpc7.Variable__c = 'Other';
        recordToInsert.add(cpc7);
        
        insert recordToInsert;
    }
    
    @isTest
    public static void createConsumerCalculatorTest(){
         
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Pre-Approving';
        opp.CloseDate =system.today().addDays(30);
        opp.Bankruptcy_Time_Since__c='Seasoned';
        opp.Initial_Appraised_Value_Source__c = 'AVM';
        opp.AVM_Final_Confidence_Score__c=100;
        opp.Est_Home_Value_Zillow__c=122;
        opp.Est_Home_Value__c=100;
        insert opp;
         
        Test.startTest();
        	SPR_CreateOppConsumerCalculator.createConsumerCalculator(opp.Id);
        Test.stopTest();
    }
    
    
}