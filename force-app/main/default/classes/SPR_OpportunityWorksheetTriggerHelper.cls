public class SPR_OpportunityWorksheetTriggerHelper {
    
    public static void UpdateDocument(List<Opportunity_Worksheet__c> OppWorkList, Map<Id, Opportunity_Worksheet__c> OldMap){
        
        Set<String> OppWorkIdSet = New Set<String>();  
        for(Opportunity_Worksheet__c oppWork :OppWorkList){
            if(oppWork.AVM_Eligible__c !=OldMap.get(oppWork.Id).AVM_Eligible__c) {
                OppWorkIdSet.add(oppWork.Id);
            }   
        }
        if(OppWorkIdSet.size()>0) {
             
            List<Opportunity> oppList = [Select Id , Name from Opportunity Where Opportunity_Worksheet__c IN: OppWorkIdSet ];
            SPR_DocumentUtility.updateDocument(oppList ) ; 
        }  
        
        
    }
}