/**
 * @description       : 
 * @author            : Ashwani Soni (Sundae)
 * @group             : 
 * @last modified on  : 03-27-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   12-02-2020   Ashwani Soni (Sundae)   Initial Version
**/
public  class SUN_UploadFileToAwsS3Controller {

    public static AWS_Setting__c AWS_Setting = AWS_Setting__c.getOrgDefaults();
    //This method inserts file information to Custom Attachment object
    @AuraEnabled
    public static Boolean insertAttachmentRecord (Id parentId, String objectname, String fileName, String fileType, String fileKey, String etag, Integer size,String foldername){
        
        System.debug(' FileKEy: '+fileKey);
        List<Amazon_S3_Files__c> s3List = [SELECT id, File_Name__c, File_Path__c, AWS_File_Key__c, File_Type__c 
                                           FROM Amazon_S3_Files__c 
                                           WHERE AWS_File_Key__c=:fileKey];
        
        if(s3List.size() == 0)
        {
              
            system.debug(' insert block ');
            Amazon_S3_Files__c attachment = new Amazon_S3_Files__c();
            String fieldApiName = objectname ; 
            if(fieldApiName=='Payoffs__c'){
                
            }else{
                fieldApiName=fieldApiName.replace('s__c', '__c')  ;
            }
            
            if(!fieldApiName.contains('__c')){                
                fieldApiName = fieldApiName+'__c';
            }
            attachment.put(fieldApiName,parentId);
            attachment.File_Path__c = ('https://' + AWS_Setting.bucket_name__c + '.' + AWS_Setting.host__c +'/'+ fileKey);//.replaceAll(' ','+');
            attachment.File_Name__c =  fileName.right(79);
            attachment.File_Type__c = fileType;
            attachment.Folder__c = foldername;
            attachment.Folder_Name__c = [Select Id, Name From Folder__c WHERE Id=:foldername LIMIT 1].Name; // @ashwani. Temporary code. Need to depricate field.
            attachment.AWS_File_Key__c = fileKey;//.replaceAll(' ','+');
            attachment.ETag__c = etag;
            attachment.Size_In_Bytes__c = Decimal.valueOf(size);
            system.debug(' rec name '+attachment);
            insert attachment; 
        } 
        
        return true;
    }

    @AuraEnabled
    public static Map<String, String> getUploadConfiguration(Id parentId, String objectname, String fileName, String folderName, String fileType)
    {
        System.debug('parentId=' + parentId);
        System.debug('strfileName=' + fileName);
        System.debug('fileType=' + fileType);
        System.debug('objectname=' + objectname);

        Sobject sobjectRecord = Database.query('SELECT id, Name, Splitero_File_Number__c FROM '+objectname+' WHERE id=:parentId LIMIT 1');
        String objectLabel = parentId.getSobjectType().getDescribe().getLabel();

        //String filepath = objectLabel+'/'+sobjectRecord.get('Name')+'/'+folderName+'/' + fileName;
        String filepath = 'public/'+sobjectRecord.get('Splitero_File_Number__c')+'/'+folderName+'/'+ fileName;
        
        String endPoint = 'https://' + AWS_Setting.bucket_name__c + '.' + AWS_Setting.host__c +'/'+ filepath;

        Map<String, String> configuration = new Map<String, String>();
        
        configuration.put('host', AWS_Setting.host__c);
        configuration.put('bucket', AWS_Setting.bucket_name__c);
        configuration.put('key', AWS_Setting.aws_key__c);
        configuration.put('secret', AWS_Setting.aws_secret__c);
        configuration.put('region', AWS_Setting.region__c);
		configuration.put('path', filepath);   
        return configuration;
    }

    //This method retrieves Attachment record based on OpportunityId
    @AuraEnabled
    public static List<Amazon_S3_Files__c> displayUploadedFiles(Id parentId){
        return [SELECT Id, File_Name__c, File_Path__c FROM Amazon_S3_Files__c
                WHERE Lead__c =:parentId];
    }
    
    @AuraEnabled
    public static List<Folder__c> getAllFolderName(String recordId, String objectname){
        System.debug('objectname-->'+objectname);
        List<Folder__c> allFolderList = new List<Folder__c>();
        if(objectname!=''){
            allFolderList = [Select Id, Name From Folder__c Where Object_Name__c=:objectname Order By Name ASC] ;
        }        
        return allFolderList ;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static  Sobject getRecordDetail(String recordId, String objectname ){
        System.debug(' here....getRecordDetails');
        System.debug(' recordId-->'+recordId);
        System.debug(' objectname-->'+objectname);
         
        Sobject sobjectRecord = Database.query('SELECT id, Name,Splitero_File_Number__c FROM '+objectname+' WHERE id=:recordId LIMIT 1');
        
        return sobjectRecord ;
        
    }
    
}