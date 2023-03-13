trigger SPR_CollectionTrigger on Collection__c (after insert, after update, after delete) {

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)){
        if((Trigger.isInsert || Trigger.isUpdate))
        	SPR_CollectionTriggerHelper.updateOpportunityWorksheet(Trigger.New,Trigger.oldMap);
        if(Trigger.isDelete)
        	SPR_CollectionTriggerHelper.updateOpportunityWorksheet(Trigger.Old, Trigger.oldMap);
        
    }
    if(Trigger.isAfter && Trigger.isInsert){
        SPR_CollectionTriggerHelper.insertDocument(Trigger.New);
    }
     if(Trigger.isAfter && Trigger.isUpdate){
        SPR_CollectionTriggerHelper.updateDocument(Trigger.New , Trigger.OldMap);
    }
}