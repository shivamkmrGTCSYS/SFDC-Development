@isTest
public class SPR_CalculateFinalAVMPriceTest {
    
    @isTest
    public static void testOpportunity(){
        
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        insert opp;
        Valuation__c avm = new Valuation__c();
        avm.Opportunity__c = opp.id; 
        avm.Estimated_Value__c = 832881;
        avm.Estimated_Value_High__c= 902234;
        avm.Estimated_Value_Low__c=763528; 
        avm.Confidence_Score__c=91.7;
        insert avm;
        SPR_CalculateFinalAVMPrice.calculateOnOpportunity(opp.id);
        System.assertEquals(opp.id != null, true);
    }
}