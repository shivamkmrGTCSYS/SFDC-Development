trigger SPR_ExceptionTrigger on Exception__c (after insert, after update, after delete) {

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)){
        if((Trigger.isInsert || Trigger.isUpdate))
        	SPR_ExceptionTriggerHelper.updateSeniorLinesAndTitleCleanOnOW(Trigger.New,Trigger.oldMap);
        if(Trigger.isDelete)
        	SPR_ExceptionTriggerHelper.updateSeniorLinesAndTitleCleanOnOW(Trigger.Old, Trigger.oldMap);
        
    }
    
     if(Trigger.isAfter && Trigger.isInsert){
        SPR_ExceptionTriggerHelper.InsertDocument(Trigger.New );
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        SPR_ExceptionTriggerHelper.updateDocument(Trigger.New  , Trigger.OldMap);
    }
}