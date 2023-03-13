trigger SPR_MortgageTrigger on Mortgage__c (After insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        SPR_MortgageTriggerHelper.insertDocument(Trigger.New);
    }

}