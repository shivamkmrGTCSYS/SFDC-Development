public class SPR_RecordedInstrumentsTriggerHelper {
    
    public static void insertDocument(List<Recorded_Instruments__c>riList){
        
        Set<String> oppWorkIdset = New Set<String>();
        for(Recorded_Instruments__c ri :riList){
            if(ri.Opportunity_Worksheet__c!=null  && 
               ((ri.Oddities__c !=null && ri.Oddities__c.split(';').indexOf('Interest Only')!=-1) || (ri.Riders__c!=null &&ri.Riders__c.split(';').indexOf('Adjustable Rate')!=-1))){
                   oppWorkIdset.add(ri.Opportunity_Worksheet__c); 
               }            
        }
        System.debug('oppWorkIdset-->'+oppWorkIdset);
        if(oppWorkIdset.size()>0){
            List<Opportunity> oppList = [Select Id , Name From Opportunity Where Opportunity_Worksheet__c IN: oppWorkIdset ];
            
            SPR_DocumentUtility.updateDocument(oppList ) ;
        }
    }
    
    public static void updateDocument(List<Recorded_Instruments__c>riList, Map<Id ,Recorded_Instruments__c>OldMap){
        
        Set<String> OppWorkIdSet = New Set<String>();
        for(Recorded_Instruments__c ri :riList){
            if(ri.Opportunity_Worksheet__c!=null &&
              (ri.Oddities__c!=null && ri.Oddities__c!=OldMap.get(ri.Id).Oddities__c)||
               (ri.Riders__c!=null && ri.Riders__c!=OldMap.get(ri.Id).Riders__c )){
                   OppWorkIdSet.add(ri.Opportunity_Worksheet__c);   
                }
        }
        System.debug('oppWorkIdset-->'+oppWorkIdset);
        if(OppWorkIdSet.size()>0){
             List<Opportunity> oppList = [Select Id , Name From Opportunity Where Opportunity_Worksheet__c IN: OppWorkIdSet ];
            
            SPR_DocumentUtility.updateDocument(oppList ) ;    
        }
        
    }
    
}