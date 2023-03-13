trigger PropertyTrigger on Property__c (before insert,before update ,After Update) {
    
    if( trigger.isBefore && trigger.isInsert ){
        PropertyTriggerHandler.populateSpliteroProperty(TRIGGER.NEW);
    }
    if( trigger.isBefore && trigger.isUpdate ){
        PropertyTriggerHandler.populateSpliteroProperty(TRIGGER.NEW, TRIGGER.OldMap);
    }
    if(trigger.isAfter && trigger.isUpdate){
        PropertyTriggerHandler.UpdateDocument(Trigger.New , Trigger.OldMap);
    }
}