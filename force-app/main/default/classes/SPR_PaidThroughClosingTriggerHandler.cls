public class SPR_PaidThroughClosingTriggerHandler {

    public static void updateOpportunityWorksheet(List<Paid_Through_Closing__c> ptcList, Map<Id,Paid_Through_Closing__c> ptcMap){
        
        Set<String> oppWSIds = new Set<String>();
        
        for(Paid_Through_Closing__c ptc: ptcList){
            oppWSIds.add(ptc.Opportunity_Worksheet__c);             
        }
        
        if(oppWSIds.size()>0){
             
            List<Opportunity_Worksheet__c> owList = [Select Id,PTC_Total__c,Collections_Total__c,
                                                     (Select Id,Balance__c,RecordTypeId, Good_Through_Date__c From Payoffs__r)
                                                     From Opportunity_Worksheet__c];
            SPR_OpportunityWorksheetUtil.updateOpportunityWorksheet(owList);
        }
        
    }
    
    
}