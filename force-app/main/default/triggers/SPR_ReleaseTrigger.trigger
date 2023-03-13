trigger SPR_ReleaseTrigger on Release__c (After insert , After Update) {
    
    if(trigger.isAfter && trigger.isInsert){
        SPR_ReleaseTriggerHelper.InsertDocument(Trigger.New);        
    }
    if(trigger.isAfter && trigger.isUpdate){
        SPR_ReleaseTriggerHelper.UpdateDocument(Trigger.New ,Trigger.OldMap);
    }
    
    
}