trigger SPR_MortgageStatementTrigger on Mortgage_Statement__c (After insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        SPR_MortgageStatementTriggerHelper.insertDocument(Trigger.New);
    }

}