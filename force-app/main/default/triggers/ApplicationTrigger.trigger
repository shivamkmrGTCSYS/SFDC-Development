trigger ApplicationTrigger on Application__c (after insert,after update,before insert, before update ) {
    
    System.debug('SPR_TriggerUtility.ByPassAllTrigger-->'+SPR_TriggerUtility.ByPassAllTrigger);
    if(SPR_TriggerUtility.ByPassAllTrigger) return ;
    
    if(Trigger.isBefore && ( Trigger.isUpdate || Trigger.isInsert ) ){
    	ApplicationTriggerUtility.updateNumToWords(Trigger.New, Trigger.oldMap );
        ApplicationTriggerUtility.fillPropertyFromApplicationLead(Trigger.New, Trigger.oldMap );
        
    }
    
    /*if(Trigger.isBefore && ( Trigger.isUpdate ) ){
    	ApplicationTriggerUtility.updateSyncToWeb(Trigger.New );
    }*/
    
    if(Trigger.isAfter && (Trigger.isInsert ) ){
        ApplicationTriggerUtility.updateLeadStatus(Trigger.New, Trigger.OldMap);
    }
    
    if(Trigger.isAfter && (Trigger.isUpdate ) ){
        ApplicationTriggerUtility.updateLeadStatusApplying(Trigger.New, Trigger.OldMap);
        ApplicationTriggerUtility.convertLead(Trigger.New, Trigger.OldMap);
        ApplicationTriggerUtility.processLinkedProperty(Trigger.New, Trigger.OldMap);
        ApplicationTriggerUtility.UpdateDocument(Trigger.New, Trigger.OldMap);       
        
    }  
    
     
}