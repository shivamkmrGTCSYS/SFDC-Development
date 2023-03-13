public class SPR_DomaFetchOrderDetailBatch implements Database.Batchable<sObject>, Schedulable,Database.stateful,Database.AllowsCallouts{

    public Database.QueryLocator start(Database.BatchableContext BC){
             
        List<String> OrderStatus = new List<String>{'OPENED','CTC','CTCPPO','CLOSING','SIGNINGCOMPLETE','POLICYISSUED' } ;
        String query='Select Id,Transaction_ID__c,Order_Status__c From Title_and_Escrow__c Where Transaction_ID__c!=null ';
        query+=' AND Order_Status__c IN:OrderStatus';
        return Database.getQueryLocator(query);
    }
    
    public void execute( Database.BatchableContext BC,  List<Title_and_Escrow__c> scope){
        
        System.debug('scope-->'+scope);
        String recordId ='';
        if(scope.size()>0){ 
            SPR_DomaAPIUtil.getOrderDetail(scope[0]);             
        }
       
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    public void execute(SchedulableContext SC){
         Database.executeBatch(new SPR_DomaFetchOrderDetailBatch(),1);
    }
    
    
}