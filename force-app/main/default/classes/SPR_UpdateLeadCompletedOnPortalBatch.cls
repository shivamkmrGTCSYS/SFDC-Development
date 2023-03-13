public class SPR_UpdateLeadCompletedOnPortalBatch implements Database.Batchable<sObject>, Database.AllowsCallouts , Schedulable {

    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        String query ='Select Id, Application_Completed__c, Lead__c From Application__c Where Application_Completed__c=true AND Lead__c!=null AND Lead__r.Application_Completed_on_Portal__c=False';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Application__c> scope){
          
        Map<String,Lead> ledMap = new Map<String,Lead>();
        for(Application__c app: scope){
            if(app.Lead__c!=null && !ledMap.containsKey(app.Lead__c)){
                Lead led = new Lead(Id=app.Lead__c,Application_Completed_on_Portal__c=True);
                ledMap.put(app.Lead__c,led);
            }	
        }
          
        if(ledMap.size()>0){
            SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=true;
            update ledMap.values();
            SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=false;
        }
                 
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    
    public void execute(SchedulableContext SC){
          Database.executeBatch(new SPR_UpdateLeadCompletedOnPortalBatch(),200);
    }
}