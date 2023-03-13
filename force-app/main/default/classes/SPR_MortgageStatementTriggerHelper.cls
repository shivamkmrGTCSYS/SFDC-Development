public class SPR_MortgageStatementTriggerHelper {
    
    public static void insertDocument(List<Mortgage_Statement__c>msList){
        
        Set<String> oppWorkIdsSet = New Set<String>();
        for(Mortgage_Statement__c ms :msList){
            if(ms.Opportunity_Worksheet__c!=null &&(ms.Deferred_Amount__c!=null ||ms.Deferred_Amount_to_payoff__c!=null)){
                oppWorkIdsSet.add(ms.Opportunity_Worksheet__c);    
            }
        }
        
        if(oppWorkIdsSet.size()>0){
            
            List<Opportunity> oppList = [Select Id , Name From Opportunity 
                                         Where Opportunity_Worksheet__c IN: oppWorkIdsSet ];
            
            SPR_DocumentUtility.updateDocument(oppList ) ;
        }
        
    }
    
}