public class SPR_CollectionTriggerHelper {
    
    public static void updateOpportunityWorksheet(List<Collection__c> ptcList, Map<Id,Collection__c> ptcMap){
        
        Set<String> oppWSIds = new Set<String>();
        
        for(Collection__c collection: ptcList){
            oppWSIds.add(collection.Opportunity_Worksheet__c);             
        }
        
        if(oppWSIds.size()>0){
            
            List<Opportunity_Worksheet__c> owList = [Select Id,PTC_Total__c,Collections_Total__c,
                                                     (Select Id,Good_Through_Date__c,Balance__c,RecordTypeId From Payoffs__r),
                                                     (Select Id,Good_Through_Date__c From Paid_Through_Closings__r),
                                                     (Select Id,Good_Through_Date__c From Collections__r)
                                                     From Opportunity_Worksheet__c Where Id IN:oppWSIds];
            SPR_OpportunityWorksheetUtil.updateOpportunityWorksheet(owList);            
        }
        
    }
    
    public static void insertDocument(List<Collection__c> ccList){
        
        Set<String> CreditrIds = New Set<String>();
        for(Collection__c cc :ccList ){
            if(cc.Settlement_Amount__c != null){
                CreditrIds.add(cc.Credit_Report__c);
            }
        }
        
        if(CreditrIds.size()>0){ 
            List<Credit_Report__c> creditList =[Select Id ,Name,Opportunity_Worksheet__c 
                                                From Credit_Report__c 
                                                Where id IN:CreditrIds and Opportunity_Worksheet__c!=null];
            
            Set<String> oppWorkset = New Set<String>();
            for(Credit_Report__c cr :creditList ){                
                oppWorkset.add(cr.Opportunity_Worksheet__c);
            } 
            if(oppWorkset.size()>0){
                List<Opportunity> oppList = [Select Id , Name 
                                             From Opportunity Where 
                                             Opportunity_Worksheet__c IN: oppWorkset ];
                SPR_DocumentUtility.updateDocument(oppList ) ;                
            }
        }
        
    }
    
    public static void updateDocument(List<Collection__c> ccList ,Map<Id,Collection__c> ccMap){
        
        Set<String> crIds = New Set<String>();
        for(Collection__c  cc : ccList){
            if( cc.Settlement_Amount__c != ccMap.get(cc.Id).Settlement_Amount__c){
                crIds.add(cc.Credit_Report__c);  
            }
        }
        if(crIds.size()>0){
            List<Credit_Report__c> creditList =[Select Id ,Name,Opportunity_Worksheet__c From
                                                Credit_Report__c Where id IN:crIds
                                                AND Opportunity_Worksheet__c!=null];
            
            Set<String> oppWorkset = New Set<String>();
            for(Credit_Report__c cr :creditList ){                
                oppWorkset.add(cr.Opportunity_Worksheet__c);
            } 
            if(oppWorkset.size()>0){
                List<Opportunity> oppList = [Select Id , Name From Opportunity Where
                                             Opportunity_Worksheet__c IN: oppWorkset ];                
                SPR_DocumentUtility.updateDocument(oppList ) ;  
            }
        }
    }
    
}