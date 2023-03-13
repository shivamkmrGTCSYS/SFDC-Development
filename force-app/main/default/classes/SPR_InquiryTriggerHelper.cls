public class SPR_InquiryTriggerHelper {
    
    public static void insertDocument(List<Inquiry__c>InqList){
        
        Set<String> CreditIds = new Set<String>();
        for(Inquiry__c inq :InqList){
            if(inq.Date__c >= Date.today().addDays(-120)){
                CreditIds.add(inq.Credit_Report__c	);  
            }
        }
        if(CreditIds.size()>0){
            List<Credit_Report__c> creditList =[Select Id ,Name,Opportunity_Worksheet__c from Credit_Report__c Where id IN:CreditIds AND Opportunity_Worksheet__c!=NULL];
            
            Set<String> oppWorkset = new Set<String>();
            for(Credit_Report__c cr :creditList ){
                
                oppWorkset.add(cr.Opportunity_Worksheet__c);
            } 
            if(oppWorkset.size()>0){
                List<Opportunity> oppList = [Select Id , Name From 
                                             Opportunity Where Opportunity_Worksheet__c 
                                             IN: oppWorkset ];
                
                SPR_DocumentUtility.updateDocument(oppList ) ;          
            }
            
        }
        
    }
    
    public static void updateDocument(List<Inquiry__c>InqList ,Map<Id, Inquiry__c> OldMap){
        
        Set<String> creditIds = new Set<String>();
        for(Inquiry__c inq : InqList){
            if(inq.Date__c != OldMap.get(inq.Id).Date__c){
                creditIds.add(inq.Credit_Report__c);
            }
        }
        if(creditIds.size()>0){
            List<Credit_Report__c> creditList =[Select Id ,Name,Opportunity_Worksheet__c 
                                                From Credit_Report__c Where id 
                                                IN:creditIds and Opportunity_Worksheet__c!=null ];
            
            Set<String> oppWorkset = new Set<String>();
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