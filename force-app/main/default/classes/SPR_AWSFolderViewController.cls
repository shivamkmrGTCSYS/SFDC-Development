/**
 * @description       : 
 * @author            : Ashwani Soni (Splitero)
 * @group             : 
 * @last modified on  : 12-09-2020
 * @last modified by  : Ashwani Soni (Splitero)
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   12-09-2020   Ashwani Soni (Splitero)   Initial Version
**/
public with sharing class SPR_AWSFolderViewController 
{
    
    public static AWS_Setting__c AWS_Setting = AWS_Setting__c.getOrgDefaults();
    
    @auraenabled 
    public static Map<String, String> getAWSConfiguration(Id recordId, String objectname) 
    {
        System.debug('recordId-->'+recordId);
        
        objectname = findObjectNameFromRecordIdPrefix(recordId);
                     
        Sobject sobjectRecord = Database.query('SELECT id, Name, Splitero_File_Number__c FROM '+objectname+' WHERE id=:recordId LIMIT 1');
        String objectLabel = recordId.getSobjectType().getDescribe().getLabel();
           
        String filepath = 'public/'+sobjectRecord.get('Splitero_File_Number__c')+'/';
        String SpliteroFileNumber=String.valueOf(sobjectRecord.get('Splitero_File_Number__c'));
        Map<String, String> configuration = new Map<String, String>();
        configuration.put('host', AWS_Setting.host__c);
        configuration.put('bucket', AWS_Setting.bucket_name__c);
        configuration.put('key', AWS_Setting.aws_key__c);
        configuration.put('secret', AWS_Setting.aws_secret__c);
        configuration.put('region', AWS_Setting.region__c);
        configuration.put('objectlabel', objectLabel);
        configuration.put('objectapiname',objectname);
        configuration.put('name', ''+sobjectRecord.get('Name'));
        configuration.put('SpliteroFileNumber', SpliteroFileNumber);
        
        
        //configuration.put('folderNames', folderList);
        
        return configuration;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Folder__c> getFolderList(Id recordId, String objectname){
        System.debug('recordId-->'+recordId);
        
        objectname = findObjectNameFromRecordIdPrefix(recordId);
        // find the list of all folders of object
 		
        Folder_Configuration__c  fc = [Select Id, Name From Folder_Configuration__c Where Object_Name__c=:objectname] ;
         
        System.debug('fc-->'+fc);
        
        List<Folder__c> folderList= [Select Id, Name From Folder__c Where Folder_Configuration__c=:fc.Id ] ;
        System.debug('folderList-->'+folderList);
        
        return folderList;
    }
    
    @AuraEnabled
    public static Map<String, String> getAWSConfigurationDetails(String objectname) 
    {                 
        SObjectType sObjectType = Schema.getGlobalDescribe().get(objectname);

		DescribeSObjectResult describe = sObjectType.getDescribe();
        String objectLabel = describe.getLabel(); 	 
        
        Map<String, String> configuration = new Map<String, String>(); 
        
        configuration.put('host', AWS_Setting.host__c);
        configuration.put('bucket', AWS_Setting.bucket_name__c);
        configuration.put('key', AWS_Setting.aws_key__c);
        configuration.put('secret', AWS_Setting.aws_secret__c);
        configuration.put('region', AWS_Setting.region__c);
        configuration.put('objectlabel', objectLabel); 

        return configuration;
    }

    @AuraEnabled
    public static void updateAwsFile( List<FileWrapper> awsFileList){
         
        Map<String,Amazon_S3_Files__c> s3FileMap = new Map<String,Amazon_S3_Files__c>();        
        // Map<String,Document_Checklist__c> s3DocumentChkMap = new Map<String,Document_Checklist__c>();
        Map<String,String>  folderNameIdMap = new Map<String,String>();
        Map<String,String>  recordNameIdMap = new Map<String,String>();         
        Set<String> folderNameSet = new Set<String>();
        Set<String> recordNameSet = new Set<String>();
        
        String recordId ='';
        String objectApiName ='';
        
        for(FileWrapper fw : awsFileList){
            System.debug('fw-->'+fw);
            FileWrapper convertedData = (FileWrapper)JSON.deserialize(JSON.serialize(fw),FileWrapper.Class); 
            recordNameSet.add(convertedData.getRecordname()); 
            folderNameSet.add(convertedData.getFoldername());
            recordId = convertedData.getRecordId();
            objectApiName = convertedData.getObjectApiname();
        }
        
        if(recordNameSet.size()>0){
            System.debug('recordNameSet-->'+recordNameSet);
            if(objectapiname == 'Lead__c') objectapiname = 'Lead';
            if(objectapiname == 'Opportunity__c') objectapiname = 'Opportunity';
            String query = 'Select Id, Name From '+objectApiName+'  Where Name IN:recordNameSet';
            List<sObject> recordList = Database.query(query) ;
            if(recordList.size()>0){
                for(sObject obj : recordList){                      
                    recordNameIdMap.put((String)obj.get('Name'),(String)obj.get('Id')) ;
                }
            }
        }
         
        if(folderNameSet.size()>0){
            List<Folder__c> folderList = [Select Id, Name From Folder__c Where Name IN:folderNameSet] ;
            if(folderList.size()>0){
                for(Folder__c fold : folderList){
                    folderNameIdMap.put(fold.Name,fold.Id) ;
                }
            }
        }
        if(objectapiname == 'Lead') objectapiname = 'Lead__c';
        if(objectapiname == 'Opportunity') objectapiname = 'Opportunity__c';
        for(FileWrapper fw : awsFileList){
             
            FileWrapper convertedData = (FileWrapper)JSON.deserialize(JSON.serialize(fw),FileWrapper.Class);
 
            Amazon_S3_Files__c attachment = new Amazon_S3_Files__c();
             
            attachment.Aws_S3_File_Id__c = convertedData.getAwss3fileid();
            attachment.File_Path__c = convertedData.getHref();
            attachment.File_Name__c =  convertedData.getLabel();  
            
            String fileKey = convertedData.getFkey();
            fileKey = fileKey.replaceAll(' ','+'); 
            attachment.AWS_File_Key__c = fileKey ;
            attachment.ETag__c = convertedData.getEtag();
            attachment.Size_In_Bytes__c = Decimal.valueOf(convertedData.getSize());			
            attachment.Folder_Name__c = convertedData.getFoldername(); 
            attachment.Folder__c = folderNameIdMap.containsKey(convertedData.getFoldername())?
                							 folderNameIdMap.get(convertedData.getFoldername()):''	;
            
            
            String recordNameValue = recordNameIdMap.containsKey(convertedData.getRecordname())?
                							 recordNameIdMap.get(convertedData.getRecordname()):''	;
            
            
            attachment.put(objectapiname,recordNameValue);
            /*if(objectapiname=='Loan_Origination__c'){
                attachment.Loan_Origination__c = recordNameIdMap.containsKey(convertedData.getRecordname())?
                							 recordNameIdMap.get(convertedData.getRecordname()):''	;
            }else if(objectapiname=='Loan_Application__c'){ 
            	attachment.Loan_Application__c = recordNameIdMap.containsKey(convertedData.getRecordname())?
                							 recordNameIdMap.get(convertedData.getRecordname()):''	;
            }*/
            if(objectapiname=='Lead__c'){
                attachment.Lead__c = recordNameIdMap.containsKey(convertedData.getRecordname())?
                recordNameIdMap.get(convertedData.getRecordname()):'';
            }else if(objectapiname=='Opportunity__c'){
                attachment.Opportunity__c = recordNameIdMap.containsKey(convertedData.getRecordname())?
                recordNameIdMap.get(convertedData.getRecordname()):'';
            }
            String mapKey = attachment.Lead__c+'/'+convertedData.getFoldername()+'/'+convertedData.getLabel();
            s3FileMap.put(fileKey,attachment) ;
            
        }
        
        if(s3FileMap.size()>0){
            // List<Amazon_S3_Files__c> s3List = new List<Amazon_S3_Files__c>();
            
            List<String> recordNameTypes = recordNameIdMap.values() ;
            String query = 'Select Id, Name,AWS_File_Key__c From Amazon_S3_Files__c Where '+objectApiName+' IN:recordNameTypes';
            List<Amazon_S3_Files__c> s3List = Database.query(query) ;
            
        //     /*if(objectapiname=='Loan_Origination__c'){
        //     	 s3List = [SELECT id, File_Name__c, Folder_Name__c, AWS_File_Key__c, File_Type__c,Loan_Origination__c 
        //                                    FROM Amazon_S3_Files__c 
        //                                    WHERE Loan_Origination__c IN:recordNameIdMap.values()];  
        //     }else if(objectapiname=='Loan_Application__c'){ 
        //     	s3List = [SELECT id, File_Name__c, Folder_Name__c, AWS_File_Key__c, File_Type__c,Loan_Origination__c 
        //                                    FROM Amazon_S3_Files__c 
        //                                    WHERE Loan_Application__c IN:recordNameIdMap.values()];
        //     }*/

                if(objectapiname=='Lead__c'){
                	 s3List = [SELECT id, File_Name__c, Folder_Name__c, AWS_File_Key__c, File_Type__c,Lead__c 
                                               FROM Amazon_S3_Files__c 
                                               WHERE Lead__c IN:recordNameIdMap.values()];  
                }else if(objectapiname=='Opportunity__c'){
                    s3List = [SELECT id, File_Name__c, Folder_Name__c, AWS_File_Key__c, File_Type__c,Opportunity__c 
                                              FROM Amazon_S3_Files__c 
                                              WHERE Opportunity__c IN:recordNameIdMap.values()];  
               }

        //     System.debug('s3List-->'+s3List);
            if(s3List.size()>0){
                for(Amazon_S3_Files__c s3file :s3List ){                      
                    if(s3FileMap.containsKey(s3file.AWS_File_Key__c) ){                         
                        //s3FileMap.remove(s3file.AWS_File_Key__c);
                        s3FileMap.get(s3file.AWS_File_Key__c).Id=s3file.Id;
                    }                       
                }                
            }
        } 
        
        if(s3FileMap.size()>0){             
        	upsert s3FileMap.values();          
        }   
        
    }
    
        
    // Wrapper class for update files and folder
    public class FileWrapper {
         
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Boolean expanded {get; set;}
        @AuraEnabled
        public String etag {get; set;}
        @AuraEnabled
        public String href {get; set;}
        @AuraEnabled
        public String size {get; set;}
        @AuraEnabled
        public String awss3fileid {get; set;}
        @AuraEnabled
        public String recordname {get; set;}
        @AuraEnabled
        public String foldername {get; set;}
        @AuraEnabled
        public String objectname {get; set;}
        
        @AuraEnabled
        public String objectapiname {get; set;}
        
        @AuraEnabled
        public String fkey {get; set;}

		@AuraEnabled
        public String recordId {get; set;}

        
        String getLabel(){ return label; }
        String getName(){ return label; }
        Boolean getExpanded(){ return expanded; }
        String getEtag(){ return etag; }
        String getHref(){ return href; }
        String getSize(){ return size; }
        String getRecordname(){ return recordname; }
        String getFoldername(){ return foldername; }
        String getObjectname(){ return objectname; }
        String getAwss3fileid(){ return awss3fileid; }
        String getFkey(){ return fkey; }
        String getRecordId(){ return recordId; }
        String getObjectApiname(){ return objectapiname; }
        
        
    }
    
    
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){

                //if (!sObj.contains('__')) to exclude managed package objects

                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                //System.debug('Prefix is ' + prefix);
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    //System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
 
    
    
}