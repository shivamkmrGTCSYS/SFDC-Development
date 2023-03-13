@isTest
public class SPR_UploadFileToAwsS3ControllerTest {
    
    @isTest
    public static  void testInsertAttachmentRecord() {
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='Test', LastName='Contact', AccountId=acc.Id);
        insert con;
        
        Folder_Configuration__c  CF = new Folder_Configuration__c();
        CF.Object_Name__c= 'Test Lead';
        CF.Description__c = 'test folder';
        insert CF;
        
        Folder__c folder = new Folder__c();
        folder.Name = 'test foldar';
        folder.Folder_Configuration__c=CF.Id;
        insert folder;
        
        String objectName = 'Contact';
        String fileName = 'test.txt';
        String fileType = 'text/plain';
        String fileKey = 'test_key';
        String etag = 'test_etag';
        Integer size = 100;
        String folderName = folder.Id;
        
        // call the method to be tested
        Boolean result = SPR_UploadFileToAwsS3Controller.insertAttachmentRecord(con.Id, objectName, fileName, fileType, fileKey, etag, size, folderName);
        
        // assert the result
        System.assertEquals(true, result);
        
        
        List<Amazon_S3_Files__c> s3List = [SELECT id, File_Name__c, File_Path__c, AWS_File_Key__c, File_Type__c, 
                                           Opportunity__r.Splitero_File_Number__c FROM Amazon_S3_Files__c 
                                           WHERE AWS_File_Key__c=:fileKey];
        System.assertEquals(1, s3List.size());
        System.assertEquals(fileName.right(79), s3List[0].File_Name__c);
    }
    
    @isTest
    public static  void testGetUploadConfiguration() {
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='Test', LastName='Contact', AccountId=acc.Id);
        insert con;
        
        AWS_Setting__c awssetting = new AWS_Setting__c();
        awssetting.aws_key__c ='aws key' ;
        awssetting.aws_secret__c ='aws secret' ;
        awssetting.bucket_name__c ='bucket name' ;
        awssetting.host__c ='aws host' ; 
        insert awssetting ;
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        insert ld;
        
        /*String objectName = 'Lead';
        String fileName = 'test.txt';
        String fileType = 'text/plain';
        String folderName = 'Test Folder';*/     
        
        Test.startTest();        
        Map<String, String> configuration = SPR_UploadFileToAwsS3Controller.getUploadConfiguration(ld.Id, 'Lead', 'test.txt', 'Test Folder', 'text/plain');
        sObject sobjectRecord = SPR_UploadFileToAwsS3Controller.getRecordDetail(ld.Id, 'Lead');
        List<Amazon_S3_Files__c> result = SPR_UploadFileToAwsS3Controller.displayUploadedFiles(ld.Id);	
        Test.stopTest() ;        
        System.assertEquals('aws host', configuration.get('host'));
        System.assertEquals('bucket name', configuration.get('bucket'));
        System.assertEquals('aws key', configuration.get('key'));
        System.assertEquals('aws secret', configuration.get('secret'));
        
    }
    
    @isTest
    public static  void testGetAllFolderName() {
        
        Folder_Configuration__c  CFtest1 = new Folder_Configuration__c();
        CFtest1.Object_Name__c= 'Test Lead';
        CFtest1.Description__c = 'test folder';
        insert CFtest1;
        
        Folder__c folder1 = new Folder__c();
        folder1.Name = 'test foldar2';
        folder1.Folder_Configuration__c=CFtest1.Id;
        
        insert folder1;
        
        Folder_Configuration__c  CFtest2 = new Folder_Configuration__c();
        CFtest2.Object_Name__c= 'Test Lead';
        CFtest2.Description__c = 'test folder';
        insert CFtest2;
        
        Folder__c folder2 = new Folder__c();
        folder2.Name = 'test foldar3';
        folder2.Folder_Configuration__c=CFtest2.Id;
        
        insert folder2;
        
        
        List<Folder__c> folders = SPR_UploadFileToAwsS3Controller.getAllFolderName(null, 'Contact');
        
        // assert the result
        /* System.assertEquals(2, folders.size());
           System.assertEquals('Test Folder 1', folders[0].Name); 
           System.assertEquals('Test Folder 2', folders[1].Name);*/
    }
    
}