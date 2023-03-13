@RestResource(urlMapping='/web/file/record/*')
global with sharing class SPR_WebsiteFileInboundService {
     
    @HttpPost
    global static void postRequestHandler() 
    {
        System.debug('Inbound Request from File Loan API');
        RestResponse res = RestContext.response;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 406;
            return;
        }
        
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
         
        SPR_WebserviceRequest.CreateFileApplication jsonFile = (SPR_WebserviceRequest.CreateFileApplication)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.CreateFileApplication.class);
        System.debug('jsonFile-->'+jsonFile);
        
        String aws_file_key = jsonFile.aws_file_key ;
        String aws_file_full_path = jsonFile.aws_file_full_path ;
        String document_key = jsonFile.document_key ;
        String loan_sfid = jsonFile.loan_sfid ;
         
        List<String> filePathList = aws_file_full_path.split('/');
        String fileName='';
        if(filePathList.size()>0){
            Integer pathLen = filePathList.size()-1;
            fileName = filePathList[pathLen];
        }
        
        Amazon_S3_Files__c a3files = new Amazon_S3_Files__c();
        a3files.AWS_File_Key__c=aws_file_key;
        a3files.File_Path__c=aws_file_full_path;
        a3files.Document_Key__c=document_key;
        a3files.File_Name__c=fileName ;
        a3files.File_Type__c=jsonFile.file_type ;
        a3files.Folder_Name__c=jsonFile.folder_name ;
        a3files.Source__c='Website';
        
        a3files.Application__c=loan_sfid;
        if(loan_sfid!='' && loan_sfid!=null){
            List<Application__c> appList = [Select Id, Lead__c, Opportunity__c From Application__c Where Id=:loan_sfid] ;
            if(appList.size()>0){
                a3files.Lead__c=appList[0].Lead__c;
                a3files.Opportunity__c=appList[0].Opportunity__c;
            }
        }
        if(a3files.Folder_Name__c!=''){
               
            if(a3files.Lead__c!=null){
                Folder_Configuration__c fc = [Select Id From Folder_Configuration__c Where Object_Name__c='Lead' Limit 1];
            	List<Folder__c> folderList = [Select Id From Folder__c Where Folder_Configuration__c=:fc.Id AND Name=:a3files.Folder_Name__c] ;
         		if(folderList.size()>0)
                	a3files.Folder__c=folderList[0].Id;
            }else if(a3files.Opportunity__c!=null){
                Folder_Configuration__c fc = [Select Id From Folder_Configuration__c Where Object_Name__c='Opportunity' Limit 1];
            	List<Folder__c> folderList = [Select Id From Folder__c Where Folder_Configuration__c=:fc.Id AND Name=:a3files.Folder_Name__c] ;
         		if(folderList.size()>0)
                	a3files.Folder__c=folderList[0].Id;
            }
        }
        
        
        Map<String,String> response = new Map<String, String>();
        try{
            insert a3files;
            response.put('sfid',a3files.Id);
        }catch(Exception e){
            System.debug('Error while creating aws file record');
            response.put('sfid','');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(response));  
        res.statusCode = 200;
    }
    
    @HttpPut
    global static void putRequestHandler() 
    {
        System.debug('Inbound Request from File Loan API');
        RestResponse res = RestContext.response;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 406;
            return;
        }
        
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
         
        SPR_WebserviceRequest.CreateFileApplication jsonFile = (SPR_WebserviceRequest.CreateFileApplication)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.CreateFileApplication.class);
        System.debug('jsonFile-->'+jsonFile);
        
        String aws_file_key = jsonFile.aws_file_key ;
        String aws_file_full_path = jsonFile.aws_file_full_path ;
        String document_key = jsonFile.document_key ;
        String loan_sfid = jsonFile.loan_sfid ;
        String sfid = jsonFile.sfid ;
         
        Amazon_S3_Files__c a3files = new Amazon_S3_Files__c();
        
        if(loan_sfid!='' && loan_sfid!=null){
            List<Application__c> appList = [Select Id, Lead__c, Opportunity__c From Application__c Where Id=:loan_sfid] ;
            if(appList.size()>0){
                a3files.Lead__c=appList[0].Lead__c;
                a3files.Opportunity__c=appList[0].Opportunity__c;
            }
        }
        
        if(a3files.Folder_Name__c!=''){ 
               
            if(a3files.Lead__c!=null){
                Folder_Configuration__c fc = [Select Id From Folder_Configuration__c Where Object_Name__c='Lead' Limit 1];
            	List<Folder__c> folderList = [Select Id From Folder__c Where Folder_Configuration__c=:fc.Id AND Name=:a3files.Folder_Name__c] ;
         		if(folderList.size()>0)
                	a3files.Folder__c=folderList[0].Id;
            }else if(a3files.Opportunity__c!=null){
                Folder_Configuration__c fc = [Select Id From Folder_Configuration__c Where Object_Name__c='Opportunity' Limit 1];
            	List<Folder__c> folderList = [Select Id From Folder__c Where Folder_Configuration__c=:fc.Id AND Name=:a3files.Folder_Name__c] ;
         		if(folderList.size()>0)
                	a3files.Folder__c=folderList[0].Id;
            }
        }
        
        a3files.Id=sfid;
        a3files.AWS_File_Key__c=aws_file_key;
        a3files.File_Path__c=aws_file_full_path;
        a3files.Document_Key__c=document_key;
        a3files.Application__c=loan_sfid;
        List<String> filePathList = aws_file_full_path.split('/');
        
        String fileName='';
        if(filePathList.size()>0){
            Integer pathLen = filePathList.size()-1;
            fileName = filePathList[pathLen];
        }
        
        a3files.File_Name__c=fileName ;
        
        a3files.File_Type__c=jsonFile.file_type ;
        a3files.Folder_Name__c=jsonFile.folder_name ;
        Map<String,String> response = new Map<String, String>();
        try{
            update a3files;
            response.put('success','true');
        }catch(Exception e){
            System.debug('Error while creating aws file record');
            response.put('success','false');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(response));  
        res.statusCode = 200;
    }

    @HttpDelete
    global static void deleteRequestHandler() 
    {
        System.debug('Inbound Request from File Loan API');
        RestResponse res = RestContext.response;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 406;
            return;
        }
         
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
         
        SPR_WebserviceRequest.CreateFileApplication jsonFile = (SPR_WebserviceRequest.CreateFileApplication)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.CreateFileApplication.class);
        System.debug('jsonFile-->'+jsonFile);
        
        String sfid = jsonFile.sfid;
        
        Amazon_S3_Files__c a3files = new Amazon_S3_Files__c(); 
        a3files.Id=sfid;
        Map<String,String> response = new Map<String, String>();
        try{
            delete a3files;
            response.put('success','true');
        }catch(Exception e){
            System.debug('Error while updating aws file record');
            response.put('success','false');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(response));  
        res.statusCode = 200;
    }
}