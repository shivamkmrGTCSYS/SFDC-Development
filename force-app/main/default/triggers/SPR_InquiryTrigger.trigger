trigger SPR_InquiryTrigger on Inquiry__c (after insert ,after update) {
    
    if(trigger.isAfter && trigger.isInsert){
        SPR_InquiryTriggerHelper.insertDocument(Trigger.New);
    }
     if(trigger.isAfter && trigger.isUpdate){
        SPR_InquiryTriggerHelper.updateDocument(Trigger.New ,Trigger.OldMap);
    }

}