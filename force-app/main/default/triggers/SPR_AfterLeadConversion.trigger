trigger SPR_AfterLeadConversion on Lead (before insert, before update, after insert, after update) {
    
    if(SPR_LeadTriggerHelperCntrl.ByPassAllTrigger) return;
    if(SPR_TriggerUtility.ByPassAllTrigger)  return;
    if(trigger.isBefore){
        if(trigger.isInsert) {
            SPR_LeadTriggerHelperCntrl.generateFileNumber(trigger.new);
            SPR_LeadTriggerHelperCntrl.createPropertyRecord(trigger.new);  
        } else if(trigger.isUpdate){
            SPR_LeadTriggerHelperCntrl.createPropertyRecord(trigger.new);  
        }
    } 
      
    if(trigger.isAfter && trigger.isUpdate)
        SPR_LeadTriggerHelperCntrl.leadConversion(trigger.newMap, trigger.oldMap);
    
    if(trigger.isAfter && (trigger.isInsert || Trigger.isUpdate)){
        SPR_LeadTriggerHelperCntrl.updatePlaceKey(trigger.new);
    }
}