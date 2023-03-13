trigger SPR_OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {

    System.debug('Opportunity Trigger-->');
    System.debug('Opportunity Trigger-->'+SPR_TriggerUtility.ByPassAllTrigger);
    if(SPR_TriggerUtility.ByPassAllTrigger) return ;
	    
    // Before saving the record
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        SPR_OpportunityTriggerHelper.updateCloseDate(Trigger.new, Trigger.oldMap);
        SPR_OpportunityTriggerHelper.setFeeValues(Trigger.new, Trigger.oldMap);
        SPR_OpportunityTriggerHelper.calculateForeclosueAndBanruptcy(Trigger.new, Trigger.oldMap);
        SPR_OpportunityUtilityTriggerHandler.updateTotalBookedRevenue(Trigger.New);
    }
    if(Trigger.isAfter && Trigger.isInsert ){
        SPR_OpportunityTriggerHelper.createActionPlan(Trigger.new, Trigger.oldMap);
        SPR_OpportunityTriggerHelper.createDocument(Trigger.new );
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        SPR_OpportunityTriggerHelper.updateActionPlan(Trigger.new, Trigger.oldMap);   
       
        
        SPR_OpportunityTriggerHelper.updateActionPlanTask(Trigger.new, Trigger.oldMap );
        SPR_OpportunityTriggerHelper.updateDocument(Trigger.new );
        SPR_OpportunityTriggerHelper.updateStageToPortal(Trigger.new, Trigger.oldMap);
        
    }
    
}