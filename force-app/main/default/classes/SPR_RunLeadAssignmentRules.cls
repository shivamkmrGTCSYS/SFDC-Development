public class SPR_RunLeadAssignmentRules {

    @InvocableMethod
    public static void assignLeads(List<Id> leadIds){
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = TRUE;
        List<Lead> toAssign = [SELECT Id FROM Lead WHERE Id = :leadIds];
        System.debug('toAssign-->'+toAssign);
        SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=true;
        Database.update(toAssign,dmo);
        SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=false;
    }
}