trigger SPR_CreditReport on Credit_Report__c (After insert , After Update) {
    
    
    if(trigger.isAfter && trigger.isInsert){
        SPR_CreditReportTriggerHelper.InsertDocument(Trigger.New);        
    }
    if(trigger.isAfter && trigger.isUpdate){
        SPR_CreditReportTriggerHelper.UpdateDocument(Trigger.New ,Trigger.OldMap);
    }
    

}