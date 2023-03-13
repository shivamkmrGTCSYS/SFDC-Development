public class SPR_DomaRetrieveDocumentBatch implements Database.Batchable<sObject>, Schedulable,Database.stateful,Database.AllowsCallouts{

    public Database.QueryLocator start(Database.BatchableContext BC){
                 
        String query='Select Id,Document_Id__c,Document_Type__c,Href__c,Title_and_Escrow__c,Order_Id__c From Title_and_Valuation_Document__c Where Status__c=false  ';
        return Database.getQueryLocator(query);
    }
    
    public void execute( Database.BatchableContext BC,  List<Title_and_Valuation_Document__c> scope){
        
        System.debug('scope-->'+scope);
        String recordId ='';
        if(scope.size()>0){ 
            SPR_DomaAPIUtil.getDocumentAndSave(scope[0]);             
        }
       
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    public void execute(SchedulableContext SC){
         Database.executeBatch(new SPR_DomaRetrieveDocumentBatch(),1);
    }
    
    
}