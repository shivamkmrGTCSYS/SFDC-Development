public class SPR_ReleaseTriggerHelper {

     public static void InsertDocument(List<Release__c> RelList){
        
        Set<String> TitleIdSet = New Set<String>();
        for(Release__c r : RelList){
            if(r.Title_Report__c !=null && 
               (r.Type__c=='Hero/Pace' || 
               r.Type__c=='Solar' || 
               (r.Type__c!='Easement' && r.Payoff_Required__c=='Yes') ||
               (r.Type__c=='Property Taxes' && r.Payoff_Required__c=='Yes') || 
               (r.Type__c=='Judgment' && r.Payoff_Required__c=='No') 
                )
              ){
                   TitleIdSet.add(r.Title_Report__c);     
               }   
        }
        System.debug('TitleIdSet-->'+TitleIdSet);
        List<Title_Report__c> titleList =[Select Id ,Name,Opportunity_Worksheet__c 
                                          From Title_Report__c 
                                          Where Id IN:TitleIdSet AND Opportunity_Worksheet__c!=null];
        System.debug('titleList-->'+titleList);
        Set<String> oppWorkset = New Set<String>();
        for(Title_Report__c tr :titleList ){            
            oppWorkset.add(tr.Opportunity_Worksheet__c);
        } 
        System.debug('oppWorkset-->'+oppWorkset);
        if(oppWorkset.size()>0){ 
            List<Opportunity> oppList = [Select Id , Name 
                                         From Opportunity 
                                         Where Opportunity_Worksheet__c IN: oppWorkset ]; 
            System.debug('oppList-->'+oppList);
            SPR_DocumentUtility.updateDocument(oppList ) ;  
        }
    }
    
    public static void UpdateDocument(List<Release__c> ReleaseList, Map<Id, Release__c> OldMap){
        
        List<String> titleIds = New List<String>();
        for(Release__c rel :ReleaseList){
            if(rel.Type__c !=OldMap.get(rel.Id).Type__c ||rel.Payoff_Required__c != OldMap.get(rel.Id).Payoff_Required__c){
                titleIds.add(rel.Title_Report__c); 
            }
            
        }     
        
        if(titleIds.size()>0){
            system.debug('release');
            List<Title_Report__c> titleList =[Select Id ,Name,Opportunity_Worksheet__c 
                                              From Title_Report__c 
                                              Where id IN:titleIds AND Opportunity_Worksheet__c!=null];
            
            Set<String> oppWorkset = New Set<String>();
            for(Title_Report__c tr :titleList ){                
                oppWorkset.add(tr.Opportunity_Worksheet__c); 
            } 
            
            List<Opportunity> oppList = [Select Id , Name From Opportunity 
                                         Where Opportunity_Worksheet__c IN: oppWorkset];
            
            SPR_DocumentUtility.updateDocument(oppList ) ;   
        }
        
        
    }
    
}