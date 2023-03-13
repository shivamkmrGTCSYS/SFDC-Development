trigger SPR_Document on Document__c (after update) {

    if(SPR_TriggerUtility.ByPassAllTrigger) return ;
    
    if(Trigger.isUpdate && Trigger.isAfter){
        SPR_SyncApplicationToWebUtility.sendRejectedStatus(Trigger.New, Trigger.oldMap);
    }
    
}