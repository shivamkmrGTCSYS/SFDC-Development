public class SPR_CreditReportTriggerHelper {
    
    public static void InsertDocument(List<Credit_Report__c> crList){
        
        Set<String> OppWorkSet = New Set<String>();
        for(Credit_Report__c cr : crList){
            if(cr.Opportunity_Worksheet__c !=null && cr.SSN_DOB_Address_Mismatch__c=='Yes'||cr.Expiration_Date__c!=null){
                OppWorkSet.add(cr.Opportunity_Worksheet__c);
            }
        }
         if(OppWorkSet.size()>0){ 
            List<Opportunity> oppList = [Select Id , Name 
                                         From Opportunity 
                                         Where Opportunity_Worksheet__c IN: OppWorkSet ]; 
            System.debug('oppList-->'+oppList);
            SPR_DocumentUtility.updateDocument(oppList ) ;  
        }
    }
    
    public static void UpdateDocument(List<Credit_Report__c> crList , Map<Id, Credit_Report__c> OldMap){
        Set<String> OppWorkSet = New Set<String>();
         for(Credit_Report__c cr : crList){ 
            if(cr.Opportunity_Worksheet__c !=null && cr.SSN_DOB_Address_Mismatch__c!= OldMap.get(cr.Id).SSN_DOB_Address_Mismatch__c ||cr.Expiration_Date__c!=OldMap.get(cr.Id).Expiration_Date__c){
                OppWorkSet.add(cr.Opportunity_Worksheet__c);
            }
        }
         if(OppWorkSet.size()>0){ 
            List<Opportunity> oppList = [Select Id , Name 
                                         From Opportunity 
                                         Where Opportunity_Worksheet__c IN: OppWorkSet ]; 
            System.debug('oppList-->'+oppList);
            SPR_DocumentUtility.updateDocument(oppList ) ;  
        }
    }
    

}