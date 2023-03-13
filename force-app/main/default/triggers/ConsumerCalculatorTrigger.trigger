trigger ConsumerCalculatorTrigger on Consumer_Calculator__c (before insert, before update,after insert, after update) {
    
    if(trigger.isBefore){
        if(Trigger.IsInsert || Trigger.isUpdate){
            ConsumerCalculatorTriggerHandler.validateOpportunity(trigger.new, trigger.oldMap);
            ConsumerCalculatorTriggerHandler.validateOpportunityWorksheet(trigger.new, trigger.oldMap);
        }
        if(trigger.isInsert){
            ConsumerCalculatorTriggerHandler.beforeInsert(trigger.new);
        }else if(trigger.isUpdate){
            ConsumerCalculatorTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
        } 
        
        
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            ConsumerCalculatorTriggerHandler.updateOpportunity(trigger.new, trigger.oldMap);
            ConsumerCalculatorTriggerHandler.updateOpportunityWorksheet(trigger.new, trigger.oldMap);
        }   
    }
}