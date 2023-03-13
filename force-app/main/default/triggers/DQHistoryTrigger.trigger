trigger DQHistoryTrigger on DQ_History__c (before insert, after insert, after update) {
/*
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            DQHistoryTriggerHandler.beforeInsert(Trigger.New);
        }
    }
    else if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            DQHistoryTriggerHandler.afterInsert(Trigger.New);
        }
    }
*/
     if(trigger.isAfter && trigger.isInsert){
        DQHistoryTriggerHandler.insertDocument(Trigger.New);
    }
    if(trigger.isAfter && trigger.isUpdate){
        DQHistoryTriggerHandler.updateDocument(Trigger.New ,Trigger.OldMap);
    }
}