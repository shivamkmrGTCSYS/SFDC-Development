/******************************************************************************
* Author: K SANSI
* Date: Feb 25, 2022
* Descpription: AWS Service for uploading file

*/
public class SPR_AWSService {
    
    public string awsKey {get;set;}
    public string awsSecret {get;set;}
    public string bucketName {get;set;}
    public string methodName {get;set;}
    public string hostName {get;set;}
    public string folderName {get;set;}
    
    public SPR_AWSService(string key, string secret, string bucket, string method, string host, string folder)
    {
        awsKey=key;
        awsSecret=secret;
        bucketName=bucket;
        methodName=method;
        hostName=host;
        folderName=folder;
    }
    
    public string ContentType(string fileType)
    {
        switch on fileType.toLowerCase()
        {
            when 'docx'
            {
                return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            when 'csv'
            {
                return 'application/vnd.ms-excel';
            }
            when 'wav'
            {
                return 'audio/wav';
            }
            when 'wmv'
            {
                return 'video/x-ms-wmv';
            }
            when 'mp3'
            {
                return 'audio/mpeg';
            }
            when 'mp4'
            {
                return 'video/mp4';
            }
            when 'png'
            {
                return 'image/png';
                
            }
            when 'pdf'
            {
                return 'application/pdf';
                
            }
            when else {
                return 'image/jpeg';
            }
        }
    }
    
    public string CreateAuthHeader(String contentType,
                                   String filename, String formattedDateString,string fileExtension){
                                       string auth;
                                       String stringToSign = this.methodName+'\n\n'+contentType+'\n'+formattedDateString+'\n/'+this.bucketName+'/'+filename + '.'+fileExtension.toLowerCase();
                                       System.debug('stringToSign-->'+stringToSign);
                                       Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(this.awsSecret));
                                       String sig = EncodingUtil.base64Encode(mac);
                                       auth = 'AWS' + ' ' + this.awsKey + ':' + sig;
                                       return auth;
                                   }
    
    
    public void UploadDocuments(string recordId)
    {
        if(string.isBlank(this.awsSecret) || string.isBlank(this.awsKey) || string.isBlank(this.bucketName) || string.isBlank(this.hostName))
        {
            //throw new BaseException('Set AWS credential');
        }
        List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:recordId];
        Set<Id> ids=new Set<Id>();
        for(ContentDocumentLink link:links)
        {
            ids.add(link.ContentDocumentId);
        }
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        
        for(ContentVersion attach:versions)
        {
            try
            {
                //File Content
                String attachmentBody = EncodingUtil.base64Encode(attach.VersionData);
                String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
                
                String filename = attach.Title;
                string contentType=ContentType(attach.FileExtension);
                system.debug('contentType:'+contentType);
                system.debug('folderName:'+this.folderName);   
                String hostName = this.hostName.replace('-us-east-1', '');
                string fileUrl='https://' + this.bucketName + '.' + hostName + '/'+this.folderName+'/' + filename.toLowerCase()+ '.'+attach.FileExtension.toLowerCase();
                HttpRequest req = new HttpRequest();
                req.setMethod(this.methodName);
                req.setEndpoint(fileUrl);
                req.setHeader('Host', this.bucketName + '.' + this.hostName);
                req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
                req.setHeader('Content-Encoding', 'UTF-8');
                req.setHeader('Content-type', contentType);
                req.setHeader('Connection', 'keep-alive');
                req.setHeader('Date', formattedDateString);
                req.setHeader('ACL', 'public-read');
                Blob pdfBlob = EncodingUtil.base64Decode(attachmentBody);
            	req.setBodyAsBlob(pdfBlob);
                String authorization = CreateAuthHeader(contentType, this.folderName+'/' + filename.toLowerCase(), formattedDateString,attach.FileExtension.toLowerCase());   
                req.setHeader('Authorization',authorization);
                
                Http http = new Http();
                HTTPResponse res = http.send(req);
                system.debug('res===>'+res.getBody());
                System.debug(res.getStatusCode());
                System.debug(res);
                if (res.getStatusCode() == 200 || res.getStatusCode()==201) 
                {
                    System.debug('status success...');
                    HttpRequest req1 = new HttpRequest();
                    req1.setMethod('GET');
                    req1.setEndpoint(fileUrl);
                    req1.setHeader('Host', this.bucketName + '.' + this.hostName);
                    req1.setHeader('Content-Encoding', 'UTF-8');
                    req1.setHeader('Content-Disposition', 'attachment; filename=' + fileName);
                    req1.setHeader('Connection', 'keep-alive');
                    req1.setHeader('Content-type', contentType);
                    req1.setHeader('Date', formattedDateString);
                    req1.setHeader('ACL', 'public-read');
                    
                    req1.setHeader('Authorization',authorization);
                    
                    Http http1 = new Http();
                    HTTPResponse res1 = http1.send(req1);
                    
                    System.debug(res1);
                    system.debug('res1===>'+res.getBody());
                    System.debug(res1.getStatusCode());
                    
                    
                    //Store Information in Object
                    //Will be used for retrieving files
                    /*FileStore__c fileStore=new FileStore__c();
                    fileStore.S3ServerUrl__c=fileUrl;
                    fileStore.Name=filename+'.'+  attach.FileExtension.toLowerCase();
                    fileStore.RecordId__c=recordId;
                    fileStore.FileExtension__c=attach.FileExtension.toLowerCase();
                    insert fileStore;*/
                }
            }
            catch(Exception ex)
            {
               //throw new BaseException(ex);
            }
        }
    }
    
    public static String getFolderName(String objectName){
        String response=objectName;
        
        return response;
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