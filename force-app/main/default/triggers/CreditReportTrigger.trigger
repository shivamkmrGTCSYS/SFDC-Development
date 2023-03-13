trigger CreditReportTrigger on Credit_Report__c (before insert,before update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        CreditReportTriggerHelper.updateCreditScore(Trigger.New, Trigger.OldMap);
    }
    
}