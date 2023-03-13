trigger SPR_RecordedInstrumentsTrigger on Recorded_Instruments__c (After insert , After update) {
    
    if(trigger.isAfter && trigger.isInsert){
        SPR_RecordedInstrumentsTriggerHelper.insertDocument(Trigger.New);
       
    }
    
    if(trigger.isAfter && trigger.isUpdate){
         SPR_RecordedInstrumentsTriggerHelper.updateDocument(Trigger.New, Trigger.OldMap);
    }

}