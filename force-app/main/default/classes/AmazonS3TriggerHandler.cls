public class AmazonS3TriggerHandler {
    
    public static void updateDocumentCheckList(List<Amazon_S3_Files__c> s3List, Map<Id,Amazon_S3_Files__c> oldS3Map){
        Map<String , Document_Checklist_to_Stage__mdt> DocumentMap = Document_Checklist_to_Stage__mdt.getAll();
        
        List<String> docNameList = new List<String>();
        Map<String,Document_Checklist_to_Stage__mdt> sfNameToDocNameMap = new Map<String,Document_Checklist_to_Stage__mdt>();
        for( Document_Checklist_to_Stage__mdt document : DocumentMap.values() ){
            docNameList.add(document.SF_Folder_Name__c);
            system.debug('document.Document_Checklist_Name__c-->'+document.SF_Folder_Name__c);
            sfNameToDocNameMap.put(document.SF_Folder_Name__c,document);
        }
        system.debug('sfNameToDocNameMap-->'+sfNameToDocNameMap);
        Set<String> oppIds = new Set<String>();
        Set<String> folderNames = new Set<String>();
        for(Amazon_S3_Files__c s3: s3List){
            system.debug('s3.Folder_Name__c-->'+s3.Folder_Name__c); 
            system.debug('s3.Opportunity__c-->'+s3.Opportunity__c);
            if(docNameList.contains(s3.Folder_Name__c) && s3.Opportunity__c!=null){
                oppIds.add(s3.Opportunity__c);
                folderNames.add(s3.Folder_Name__c);
            }
        }
        Set<String> s3IdSet = new Set<String>();
        
        if(oppIds.size()>0 && folderNames.size()>0 ){
            Map<String,List<Document__c>> existingDoc = getAllDocuments(oppIds,folderNames);
            system.debug('existingDoc-->'+existingDoc);
            List<Document__c> docsToUpsert = new List<Document__c>();
            //Id externalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
            //Id internalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
            for(Amazon_S3_Files__c s3: s3List){
            	if(docNameList.contains(s3.Folder_Name__c) && s3.Opportunity__c!=null){
                    if(existingDoc.containsKey(s3.Opportunity__c)){
                        List<Document__c> docList = existingDoc.get(s3.Opportunity__c);
                        Map<String,List<Document__c>> existingNameDocs = documentMap( docList);
                        System.debug('existingNameDocs-->'+existingNameDocs); 
                        if(existingNameDocs.containsKey(s3.Folder_Name__c)){
                            Document__c existDoc = existingNameDocs.get(s3.Folder_Name__c)[0];
                            existDoc.Amazon_S3_File__c=s3.Id;
                            existDoc.Status__c ='Uploaded';
                            /*if(s3.Source__c=='Website'){
                                existDoc.RecordTypeId=externalRecordTypeId;
                            }else{
                                existDoc.RecordTypeId=internalRecordTypeId;
                            }*/
                            docsToUpsert.add(existDoc);
                        }else{
                            // need to create new record
                            Document__c newDocs = createDocument(s3,sfNameToDocNameMap.get(s3.Folder_Name__c));                         
                        	docsToUpsert.add(newDocs);
                        }
                        
                    }else{
                        // need to create new record
                        Document__c newDocs = createDocument(s3,sfNameToDocNameMap.get(s3.Folder_Name__c));                         
                        docsToUpsert.add(newDocs);
                    }
                }else{
                    // do nothing, either opportunity not exist or folder name not required to create
                }
            }
            System.debug('docsToUpsert-->'+docsToUpsert);
            if(docsToUpsert.size()>0){
                upsert docsToUpsert;
                createTask( docsToUpsert);
            }
            
        }
  
    }
    public static  Map<String,List<Document__c>> documentMap(List<Document__c> docList){
        Map<String,List<Document__c>> existingNameDocs = new Map<String,List<Document__c>>();
        for(Document__c docs: docList){
            if(!existingNameDocs.containsKey(docs.Name)){
                existingNameDocs.put(docs.SF_Folder_Name__c,new List<Document__c>());
            }
            existingNameDocs.get(docs.SF_Folder_Name__c).add(docs);
        }
        return existingNameDocs;
    }
    public static Document__c createDocument(Amazon_S3_Files__c s3, Document_Checklist_to_Stage__mdt document){
        String Name = document.Document_Checklist_Name__c;
        //Id externalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
        //Id internalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByDeveloperName().get(document.Record_Type__c).getRecordTypeId();
        System.debug('recordTypeId-->'+recordTypeId);
        Document__c newDocs =new Document__c();
        newDocs.SF_Folder_Name__c=s3.Folder_Name__c;
        newDocs.Amazon_S3_File__c=s3.Id;
        newDocs.Opportunity__c=s3.Opportunity__c;
        newDocs.Document_Key__c=s3.Document_Key__c;
        newDocs.Status__c='Uploaded';
        newDocs.RecordTypeId=recordTypeId;
        /*if(s3.Source__c=='Website'){
            newDocs.RecordTypeId=externalRecordTypeId;
        }else{
            newDocs.RecordTypeId=internalRecordTypeId;
        }*/
        newDocs.Name=Name;
        
        return newDocs;
    }
    public static void createTask( List<Document__c> docsToUpsert){
        System.debug('createTask');
        List<Document__c> docList = [Select Id, Name, Opportunity__r.OwnerId,Opportunity__r.Processor__c,Amazon_S3_File__c From Document__c Where Id IN:docsToUpsert];
        List<Task> taskList = new List<Task>();
        for(Document__c doc : docList){
            Task  tsk = new Task();
            tsk.Subject = 'Review '+doc.Name;
            tsk.OwnerId = doc.Opportunity__r.OwnerId;
            if(doc.Opportunity__r.Processor__c!=null){
                //tsk.OwnerId = doc.Opportunity__r.Processor__c;
            }
            tsk.WhatId=doc.Opportunity__c;
            tsk.Description ='To be reviewed'; 
            tsk.Amazon_S3_File__c=doc.Amazon_S3_File__c;
            taskList.add(tsk);
        }
        if(taskList.size()>0){
            insert taskList;
        }
        
    }
    
    
    public static Map<String,List<Document__c>> getAllDocuments(Set<String> oppIds,Set<String> folderNames){
        System.debug('folderNames-->'+folderNames);
        System.debug('oppIds-->'+oppIds);
        Map<String,List<Document__c>> docsMap = new Map<String,List<Document__c>>();
        List<Document__c> docksList = [Select Id, Opportunity__c, Name,SF_Folder_Name__c From Document__c 
                                       Where Opportunity__c IN :oppIds AND 
                                       SF_Folder_Name__c IN :folderNames 
                                       AND Amazon_S3_File__c IN (null,'')
                                       AND Status__c NOT IN ('Rejected','Expired') ] ;
        System.debug('docksList-->'+docksList);
        for(Document__c docs: docksList){
            if(!docsMap.containsKey(docs.Opportunity__c)){
                docsMap.put(docs.Opportunity__c,new List<Document__c>());
            }
            docsMap.get(docs.Opportunity__c).add(docs);
        }
        return docsMap;
        
    }
    
}