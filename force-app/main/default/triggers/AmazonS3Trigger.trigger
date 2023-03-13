trigger AmazonS3Trigger on Amazon_S3_Files__c (before insert, after insert) {

    
    if(SPR_TriggerUtility.ByPassAllTrigger) return ;
    
    if(Trigger.isInsert && Trigger.isAfter){
        AmazonS3TriggerHandler.updateDocumentCheckList(Trigger.New, Trigger.oldMap);
    }
}