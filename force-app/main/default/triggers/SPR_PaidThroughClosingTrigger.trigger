trigger SPR_PaidThroughClosingTrigger on Paid_Through_Closing__c (after insert, after update, after delete) {

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)){
        if((Trigger.isInsert || Trigger.isUpdate))
        	SPR_PaidThroughClosingTriggerHandler.updateOpportunityWorksheet(Trigger.New,Trigger.oldMap);
        if(Trigger.isDelete)
        	SPR_PaidThroughClosingTriggerHandler.updateOpportunityWorksheet(Trigger.Old, Trigger.oldMap);
        
    }
    
}