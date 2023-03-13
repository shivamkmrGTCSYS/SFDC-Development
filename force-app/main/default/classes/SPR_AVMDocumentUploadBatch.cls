public class SPR_AVMDocumentUploadBatch implements Database.Batchable<sObject>, Schedulable,Database.stateful,Database.AllowsCallouts{

    public Database.QueryLocator start(Database.BatchableContext BC){
                 
        String query='Select Id,Name From Valuation__c Where Amazon_S3_File__c=null';
        return Database.getQueryLocator(query);
    }
    
    public void execute( Database.BatchableContext BC,  List<Valuation__c> scope){
        
        System.debug('scope-->'+scope);
        String recordId ='';
        if(scope.size()>0){
            recordId=scope[0].Id;
            String recordName = scope[0].Name;
            String folderName=SPR_AWSService.getFolderName('avm');
            String objectLabel=SPR_AWSService.findObjectNameFromRecordIdPrefix(recordId);
            String methodName='PUT';
            String filepath = objectLabel+'/'+recordName+'/'+folderName  ;
            AWS_Setting__c AWS_Setting = AWS_Setting__c.getOrgDefaults();
            SPR_AWSService aws = new SPR_AWSService(AWS_Setting.aws_key__c,AWS_Setting.aws_secret__c,AWS_Setting.bucket_name__c,methodName,AWS_Setting.host__c,filepath);
            aws.UploadDocuments(recordId);
        }
       
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    public void execute(SchedulableContext SC){
         Database.executeBatch(new SPR_AVMDocumentUploadBatch(),1);
    }
    
    
}