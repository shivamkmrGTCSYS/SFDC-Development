@IsTest
public class SUN_AWSFolderViewControllerTest {

    
    @TestSetup
    static void makeData(){        
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        insert ld;
        
        Amazon_S3_Files__c attachment = new Amazon_S3_Files__c();             
        attachment.Aws_S3_File_Id__c =  'Test Aws_S3_File_Id__c';
        attachment.File_Path__c = 'Test File_Path__c';
        attachment.File_Name__c =  'Test File_Name__c'; 
        
        attachment.AWS_File_Key__c = 'Test AWS_File_Key__c';  
        attachment.ETag__c = 'Test ETag__c'; 
        attachment.Size_In_Bytes__c =  12345;			
        attachment.Folder_Name__c = 'Test Folder_Name__c';        
         
        insert attachment;	 
        
        Folder_Configuration__c folConfig = new Folder_Configuration__c();
        folConfig.Object_Name__c = 'Amazon_S3_Files__c';
        insert folConfig;
        
        Folder__c folder = new Folder__c(Name='Test folder name',Folder_Configuration__c=folConfig.Id );
        insert folder;
        
        AWS_Setting__c awssetting = new AWS_Setting__c();
        awssetting.aws_key__c ='aws key' ;
        awssetting.aws_secret__c ='aws secret' ;
        awssetting.bucket_name__c ='bucket name' ;
        awssetting.host__c ='aws host' ; 
        insert awssetting ;
        
        
    }
    
    public static testmethod void testGetAWSConfiguration() {
        List<Lead> s3file = [Select Id From Lead] ;
        System.assert(s3file.size()>0);
        
        AWS_Setting__c AWS_Setting = AWS_Setting__c.getOrgDefaults();
        
        Test.startTest(); 
			
         	Map<String, String> response = SUN_AWSFolderViewController.getAWSConfiguration(s3file[0].Id,'Lead');
			        
        Test.stopTest() ;
        
        // Asserts
        System.assertEquals(AWS_Setting.bucket_name__c, response.get('bucket'));
        System.assertEquals(AWS_Setting.host__c, response.get('host'));
        System.assertEquals(AWS_Setting.aws_key__c, response.get('key'));
        System.assertEquals(AWS_Setting.region__c, response.get('region'));
        System.assertEquals(AWS_Setting.aws_secret__c, response.get('secret'));        
        System.assertEquals('Lead', response.get('objectlabel'));       
    }
    
    public static testmethod void testGetAWSConfigurationDetails() {
        List<Amazon_S3_Files__c> s3file = [Select Id From Amazon_S3_Files__c] ;
        System.assert(s3file.size()>0);
        
        AWS_Setting__c AWS_Setting = AWS_Setting__c.getOrgDefaults();
        
        Test.startTest(); 
			
         	Map<String, String> response = SUN_AWSFolderViewController.getAWSConfigurationDetails( 'Amazon_S3_Files__c');
			        
        Test.stopTest() ;
                
        // Asserts
        System.assertEquals(AWS_Setting.bucket_name__c, response.get('bucket'));
        System.assertEquals(AWS_Setting.host__c, response.get('host'));
        System.assertEquals(AWS_Setting.aws_key__c, response.get('key'));
        System.assertEquals(AWS_Setting.region__c, response.get('region'));
        System.assertEquals(AWS_Setting.aws_secret__c, response.get('secret'));        
        System.assertEquals('Amazon S3 File', response.get('objectlabel')); 
        
    }
    
    public static testmethod void testUpdateAwsFile() {
        List<Amazon_S3_Files__c> s3file = [Select Id From Amazon_S3_Files__c] ;
        System.assert(s3file.size()>0);
        
        
        List<Lead> leadList = [Select Id,Name From Lead] ;
        System.assert(leadList.size()>0);
        
        List<Folder__c> folderList = [Select Id,Name From Folder__c] ;
        System.assert(folderList.size()>0);
        
        SUN_AWSFolderViewController.FileWrapper fw = new SUN_AWSFolderViewController.FileWrapper();
        fw.awss3fileid = 'Test awss3fileid';
        fw.etag = 'Test etag';
        fw.expanded = true;
        fw.fkey = 'Test fkey';
        fw.foldername ='Test folder name';
        fw.href = 'Test href';
        fw.label =leadList[0].Name;
        fw.name = leadList[0].Name;
        fw.objectname = 'Test objectname';
        fw.recordname = leadList[0].Name;
        fw.size = '12345';
        fw.recordId = leadList[0].Id;
        fw.objectapiname =  'Lead__c';
        fw.expanded =  True;
        fw.label =  'Test label';
        
        Test.startTest(); 			
        SUN_AWSFolderViewController.updateAwsFile(new List<SUN_AWSFolderViewController.FileWrapper>{fw});			        
        Test.stopTest() ;
         
        s3file = [Select Id,Aws_S3_File_Id__c,File_Path__c,File_Name__c,AWS_File_Key__c,
                  ETag__c,Size_In_Bytes__c,Folder_Name__c 
                  From Amazon_S3_Files__c 
                  Where ETag__c='Test etag'] ;
        system.debug(s3file.size());
        // Asserts
        System.assert(s3file.size()>0);
        System.assertEquals('Test awss3fileid', s3file[0].Aws_S3_File_Id__c);
        System.assertEquals('Test href', s3file[0].File_Path__c);
        System.assertEquals('Test label', s3file[0].File_Name__c);
        System.assertEquals('Test+fkey', s3file[0].AWS_File_Key__c);
        System.assertEquals('Test etag', s3file[0].ETag__c);
        System.assertEquals(12345, s3file[0].Size_In_Bytes__c);
        System.assertEquals('Test folder name', s3file[0].Folder_Name__c); 
         
    }
    
    public static testmethod void testInsertAttachmentRecord(){
        
        List<Lead> leadList = [Select Id,Name From Lead] ;
        System.assert(leadList.size()>0);
        
        List<Folder__c> folderList = [Select Id From Folder__c];
        System.assert(folderList.size()>0);
        
        Boolean response = SUN_UploadFileToAwsS3Controller.insertAttachmentRecord (
            leadList[0].Id,'Lead', 'Test File Name', 'String fileType','Test AWS_File_Key', 
            'String etag', 100,folderList[0].Id);  
        
        List<Amazon_S3_Files__c> s3fileList = [Select Id,File_Name__c From Amazon_S3_Files__c Where File_Name__c='Test File Name' ] ;
         
        System.assert(s3fileList.size()>0);
    }
    
    public static testmethod void testGetUploadConfiguration() {
        List<Amazon_S3_Files__c> s3file = [Select Id From Amazon_S3_Files__c] ;
        System.assert(s3file.size()>0);
        List<Lead> leadList = [Select Id,Name From Lead] ;
        System.assert(leadList.size()>0);
        
        AWS_Setting__c AWS_Setting = AWS_Setting__c.getOrgDefaults();
        
        Test.startTest(); 
			
         	Map<String, String> response = SUN_UploadFileToAwsS3Controller.getUploadConfiguration( 
                leadList[0].Id,'Lead', 'String fileName', 'String folderName', 'String fileType');
			        
        Test.stopTest() ;
                
        // Asserts
        System.assertEquals(AWS_Setting.bucket_name__c, response.get('bucket'));
        System.assertEquals(AWS_Setting.host__c, response.get('host'));
        System.assertEquals(AWS_Setting.aws_key__c, response.get('key'));
        System.assertEquals(AWS_Setting.region__c, response.get('region'));
        System.assertEquals(AWS_Setting.aws_secret__c, response.get('secret'));        
         
        
    }

    public static testmethod void testDisplayUploadedFiles() {
         
        List<Lead> leadList = [Select Id,Name From Lead] ;
        System.assert(leadList.size()>0);
        
        Test.startTest(); 			
         	List<Amazon_S3_Files__c> result = SUN_UploadFileToAwsS3Controller.displayUploadedFiles(leadList[0].Id);			        
        Test.stopTest() ;
        
		System.assertEquals(0,result.size());  
    }
    
    public static testmethod void testGetAllFolderName() {
         
        List<Lead> leadList = [Select Id,Name From Lead] ;
        System.assert(leadList.size()>0);
        List<Folder__c> folderList = [Select Id,Object_Name__c From Folder__c];
        System.assert(folderList.size()>0);
        
        Test.startTest(); 			
         	List<Folder__c> result = SUN_UploadFileToAwsS3Controller.getAllFolderName(leadList[0].Id,folderList[0].Object_Name__c);			        
        Test.stopTest() ;
 
		System.assert(result.size()>0);    	            
        
    }
    
}