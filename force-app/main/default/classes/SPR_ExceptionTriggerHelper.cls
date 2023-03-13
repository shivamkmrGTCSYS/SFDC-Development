public class SPR_ExceptionTriggerHelper {
    
    public static void updateSeniorLinesAndTitleCleanOnOW(List<Exception__c> excpList,Map<Id,Exception__c> excpMap){
        
        Set<String> oppWSIds = new Set<String>();
        system.debug('excpMap 11## '+excpMap);
        for(Exception__c excp: excpList){
            if((Trigger.isInsert || Trigger.isDelete) || (Trigger.isUpdate && excp.Type__c!=excpMap.get(excp.Id).Type__c)){
                oppWSIds.add(excp.Opportunity_Worksheet__c);             
            }
        }
        
        if(oppWSIds.size()>0){ 
            List<Opportunity_Worksheet__c> owList = [Select Id,(Select Id, Type__c From Exception__r) 
                                                     From Opportunity_Worksheet__c Where Id IN:oppWSIds];
            SPR_OpportunityWorksheetUtil.updateSeniorLinesAndTitleCleanOnOW(owList);                       
        }
    }
    
    public static void InsertDocument(List<Exception__c> excpList){
        Set<String> titleIds = New Set<String>();
        for(Exception__c ex :excpList){
            if(ex.Title_Report__c !=null && (ex.Type__c=='Mortgage'||ex.Type__c=='Other')) {
                titleIds.add(ex.Title_Report__c);    
            }   
        }
        if(titleIds.size()>0){            
            
            List<Title_Report__c> titleList =[Select Id ,Name,Opportunity_Worksheet__c 
                                              From Title_Report__c 
                                              Where id IN:titleIds AND Opportunity_Worksheet__c!=null];
            
            Set<String> oppWorkset = New Set<String>();
            for(Title_Report__c tr :titleList ){            
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
    
    public static void updateDocument(List<Exception__c> excpList,Map<Id,Exception__c> excpMap){
        
        Set<String> titlereportIds = New Set<String>();
        for(Exception__c exc :excpList){
            if(exc.Type__c !=excpMap.get(exc.Id).Type__c ){
                titlereportIds.add(exc.Title_Report__c); 
            }    
        }
        if(titlereportIds.size()>0){
            List<Title_Report__c> titleList =[Select Id ,Name,Opportunity_Worksheet__c 
                                              From Title_Report__c 
                                              Where id IN:titlereportIds AND Opportunity_Worksheet__c!=null];
            
            Set<String> oppWorkset = New Set<String>();
            for(Title_Report__c tr :titleList ){                
                oppWorkset.add(tr.Opportunity_Worksheet__c);
            } 
            System.debug('oppWorkset-->'+oppWorkset);
            if(oppWorkset.size()>0){
                List<Opportunity> oppList = [Select Id , Name From Opportunity Where
                                             Opportunity_Worksheet__c IN: oppWorkset ];
                 
                SPR_DocumentUtility.updateDocument(oppList ) ;         
            }
            
            
        }
    }
    
}