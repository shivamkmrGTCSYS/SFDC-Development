trigger SPR_OpportunityWorksheetTrigger on Opportunity_Worksheet__c (after insert, after update, after delete) {

    if(SPR_TriggerUtility.ByPassAllTrigger) return ;
    if(Trigger.isAfter && (Trigger.isUpdate )){
         SPR_OpportunityWorksheetTriggerHelper.UpdateDocument(Trigger.New ,Trigger.OldMap);
    }
   
    
}