public class SPR_MortgageTriggerHelper {
    
    public static void insertDocument(List<Mortgage__c>NewList){
        
        Set<String> CrIdsSet  =  New Set<String>();
        for(Mortgage__c ms :NewList){
            if(ms.Credit_Report__c!=null){                
               CrIdsSet.add(ms.Credit_Report__c); 
            }
        }
        
        if(CrIdsSet.size()>0){
             List<Credit_Report__c> crList =[Select Id ,Name,Opportunity_Worksheet__c 
                                              From Credit_Report__c 
                                              Where id IN:CrIdsSet AND Opportunity_Worksheet__c!=null];
            
            Set<String> oppWorkset = New Set<String>();
            for(Credit_Report__c tr :crList ){            
                oppWorkset.add(tr.Opportunity_Worksheet__c);
            } 
            if(oppWorkset.size()>0){
                List<Opportunity> oppList = [Select Id , Name 
                                             From Opportunity 
                                             Where Opportunity_Worksheet__c IN: oppWorkset ];
                
                SPR_DocumentUtility.updateDocument(oppList ) ; 
        }        
        
    }

}
}