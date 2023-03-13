trigger SPR_Sync_AfterInsertAndUpdLeadTrigger on Lead (after insert, after update) {
    set<String> setofIds = new Set<String>();
    if(Trigger.isInsert){
        for(lead ld : Trigger.new ){
            setofIds.add(Ld.Id);
        }
        SPR_Sync_AfterInsertAndUpdLeadController.syncLeadFromSF(setofIds);
    }
    
}