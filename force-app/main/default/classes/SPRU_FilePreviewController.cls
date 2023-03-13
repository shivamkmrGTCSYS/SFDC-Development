/*****************************************************************
 * Class Name: FilePreviewController
 * Created Date: 03-Nov-2020
 * Description: FilePreview page Controller to show preview of aws files
 *******************************************************************/
public class SPRU_FilePreviewController
{
    
    public static AWS_Setting__c AWS_Setting = AWS_Setting__c.getOrgDefaults();
    
    public String generatedFileUrl
    {
        get;
        set;
    }
    public String fileUrl
    {
        get;
        set;
    }
    public transient String fileData
    {
        get;
        set;
    }
    public transient String fileType
    {
        get;
        set;
    }

    public SPRU_FilePreviewController()
    {
        this.fileType = 'application/pdf';
        this.fileUrl = ApexPages.currentPage().getParameters().get('fileUrl');
        if (String.isNotBlank(fileData))
        {
            //this.generatedFileUrl = 'data:' + fileType + ';base64,' + fileData;//'https://docs.google.com/viewer?embedded=true&url='+this.fileUrl;            
        }
    }

    
    
    @AuraEnabled
    public static Map < String, String > generateAwsFileURL(String s3fileId)
    {
        System.debug('s3fileId-->' + s3fileId);
        //s3fileId = s3fileId.replaceAll(' ','+'); 
        System.debug('s3fileId-->' + s3fileId);
        String fileUrl = '';
        String Folder_Name = '';
        String Automation_API_Name = Label.defaultAutomationName;
        // String Object_Name = 'Loan_Origination__c';
        List < Amazon_S3_Files__c > s3 = [SELECT id, File_Name__c, File_Path__c, AWS_File_Key__c, File_Type__c, Folder_Name__c FROM Amazon_S3_Files__c WHERE AWS_File_Key__c =: s3fileId];
        System.debug('s3-->' + s3);

        String officeappsURL = '';
        String fileType = '';
        Map < String, String > response = new Map < String, String > ();

        if (s3[0].File_Name__c.Contains('.'))
        {
            fileType = s3[0].File_Name__c.substringAfter('.');
        }

        if (fileType == 'docx' || fileType == 'xlsx' || fileType == 'xls' || fileType == 'doc' || fileType == 'csv')
        {
            officeappsURL = 'https://view.officeapps.live.com/op/embed.aspx?src=';
        }

        if (s3.size() > 0)
        {
            List<Amazon_S3_File_Note__c> noteList = [Select Id,Note__c,CreatedDate,CreatedBy.Name From Amazon_S3_File_Note__c Where Amazon_S3_File__c=:s3[0].Id];
            //System.debug('noteList-->' + noteList);
            fileUrl = officeappsURL + getSignedURL(EncodingUtil.urlDecode(s3[0].AWS_File_Key__c, 'UTF-8'));

            // List < Document_Configuration__mdt > dcmList = [SELECT Automation_API_Name__c, Folder_Name__c FROM Document_Configuration__mdt
            //     WHERE Folder_Name__c =: s3[0].Folder_Name__c
            // ];

            // if (dcmList.size() > 0)
            // {
            //     Automation_API_Name = dcmList[0].Automation_API_Name__c;
            // }

            response.put('fileUrl', fileUrl);
            response.put('Folder_Name', s3[0].Folder_Name__c);
            // response.put('Loan_Origination_Id', s3[0].Loan_Origination__c == null ? s3[0].Loan_Application__c : null);
            response.put('Amazon_S3_Files_Id', s3[0].Id);
            response.put('Automation_API_Name', Automation_API_Name);
            // response.put('Object_Name', Object_Name);
            response.put('notes',JSON.serialize(noteList) );
        }
        System.debug('response-->' + response);
        return response;
    }
    
    
    public static string getSignedURL(String file) 
    {
        String filename = EncodingUtil.urlEncode(file, 'UTF-8');
 
         
        String AccessKey = AWS_Setting.aws_key__c  ; //AWS key
        String SecretKey =AWS_Setting.aws_secret__c  ; //AWS Secret key
        String BucketName = AWS_Setting.bucket_name__c  ; //AWS bucket name
        String host = AWS_Setting.host__c  ;
        
        
        Datetime now = DateTime.now();
        Datetime expireson = now.AddSeconds(360); // Lifespan of the link
        Long Lexpires = expireson.getTime()/1000;
        
        String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+BucketName+'/'+filename;//.replaceAll(' ','+');
        System.debug('redirectToS3Key stringstosign: ' + stringtosign);
        
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(SecretKey));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(SecretKey)); 
        String signed= EncodingUtil.base64Encode(mac);     
        String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        String url = 'https://'+BucketName+'.s3.amazonaws.com/'+filename+'?AWSAccessKeyId='+AccessKey+
                     '&Expires='+Lexpires+'&Signature='+EncodingUtil.urlEncode(signed,'UTF-8');
                
        return url;
    }
    
    @AuraEnabled
    public static List<Amazon_S3_Files__c> getListOfApplicationFileId(Id opportunityWorksheetId,String folderId){
        List<Amazon_S3_Files__c> response = new List<Amazon_S3_Files__c>();
        System.debug('opportunityWorksheetId-->'+opportunityWorksheetId);
        System.debug('folderId-->'+folderId);
        String objectName = opportunityWorksheetId.getSObjectType().getDescribe().getName();
		System.debug('objectName-->'+objectName);
        if(objectName=='Credit_Report__c'){
            Credit_Report__c cr = [Select Id, Opportunity_Worksheet__c From Credit_Report__c Where Id=:opportunityWorksheetId Limit 1];
            opportunityWorksheetId = cr.Opportunity_Worksheet__c;
            folderId=Label.SPR_Credit_Report_Folder_Id;
        }
        if(opportunityWorksheetId!=null && folderId !=null){
            
            Opportunity_Worksheet__c ow = [Select Id, Opportunity__c From Opportunity_Worksheet__c Where Id=:opportunityWorksheetId Limit 1];
            System.debug('Opportunity__c-->'+ow.Opportunity__c);
            response = [SELECT Id, File_Name__c, File_Path__c,AWS_File_Key__c,Opportunity_Worksheet__c,Folder__c
                FROM Amazon_S3_Files__c
                WHERE Opportunity__c =:ow.Opportunity__c and Folder__c=:folderId];
        }
        return response;
        
    }
    
    @AuraEnabled
    public static List<Amazon_S3_Files__c> displayUploadedFiles(Id parentId){
         return [SELECT Id, File_Name__c, File_Path__c,AWS_File_Key__c FROM Amazon_S3_Files__c
                WHERE Id =:parentId];        
    }
    
    @AuraEnabled
    public static List<Amazon_S3_Files__c> getFileExplorer(Id recordId,String folderName){
        List<Amazon_S3_Files__c> response = new List<Amazon_S3_Files__c>();
        System.debug('recordId-->'+recordId);
        System.debug('folderName-->'+folderName);
         
        String objectName = recordId.getSObjectType().getDescribe().getName();
		System.debug('objectName-->'+objectName);
        String query = 'Select Id, Opportunity_Worksheet__c From '+objectName+'  Where Id=\''+String.escapeSingleQuotes(recordId)+'\' LIMIT 1'; 
        
        sObject dbResult = database.query(query);
        System.debug('dbResult-->'+dbResult);
        System.debug('Opportunity_Worksheet__c-->'+dbResult.get('Opportunity_Worksheet__c'));
        
        String opportunityWorksheetId=String.valueOf(dbResult.get('Opportunity_Worksheet__c'));
        String folderObjectName='Opportunity';
        Folder__c folder = [Select Id From Folder__c Where Name=:folderName AND Object_Name__c=:folderObjectName Limit 1];
        String folderId;
        if(folder!=null){
            folderId=folder.Id;
        }
         
        if(opportunityWorksheetId!=null && folderId !=null){
            
            Opportunity_Worksheet__c ow = [Select Id, Opportunity__c From Opportunity_Worksheet__c Where Id=:opportunityWorksheetId Limit 1];
            System.debug('Opportunity__c-->'+ow.Opportunity__c);
            response = [SELECT Id, File_Name__c, File_Path__c,AWS_File_Key__c,Opportunity_Worksheet__c,Folder__c
                FROM Amazon_S3_Files__c
                WHERE Opportunity__c =:ow.Opportunity__c and Folder__c=:folderId];
        }
        return response;
        
    }

    @AuraEnabled
    public static List<Amazon_S3_Files__c> getListOfFiles(Id recordId ){
        List<Amazon_S3_Files__c> response = new List<Amazon_S3_Files__c>();
        System.debug('opportunityWorksheetId-->'+recordId);
        
        String objectName = recordId.getSObjectType().getDescribe().getName();
		 
        if(recordId!=null  ){
            
            Opportunity_Worksheet__c ow = [Select Id, Opportunity__c From Opportunity_Worksheet__c Where Id=:recordId Limit 1];
            System.debug('Opportunity__c-->'+ow.Opportunity__c);
            response = [SELECT Id, File_Name__c, File_Path__c,AWS_File_Key__c,Opportunity_Worksheet__c,Folder__c
                FROM Amazon_S3_Files__c
                WHERE Opportunity__c =:ow.Opportunity__c ];
        }
        return response;
        
    }
    
    
}