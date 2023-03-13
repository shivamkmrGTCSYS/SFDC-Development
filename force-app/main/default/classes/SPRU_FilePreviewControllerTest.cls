@IsTest
public class SPRU_FilePreviewControllerTest {
    
    @TestSetup
    static void makeData(){
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        insert ld;    
        
        Folder_Configuration__c folConfig = new Folder_Configuration__c();
        folConfig.Object_Name__c = 'Opportunity';
        insert folConfig;
            
        Folder__c fol = new Folder__c();
        fol.Name = 'Photos';
        fol.Folder_Configuration__c = folConfig.id;
        insert fol;
        
        Application__c app = new Application__c(Lead__c=ld.Id, Investment_Amount__c=123.45);
        insert app;
        
        Amazon_S3_Files__c attachment = new Amazon_S3_Files__c();             
        attachment.Aws_S3_File_Id__c =  'Test Aws_S3_File_Id__c';
        attachment.File_Path__c = 'Test File_Path__c';
        attachment.File_Name__c =  'Test File_Name__c.csv';         
        attachment.AWS_File_Key__c = 'Test+AWS_File_Key__c';  
        attachment.ETag__c = 'Test ETag__c'; 
        attachment.Size_In_Bytes__c =  12345;			
        attachment.Folder_Name__c = 'Photos';
        attachment.Lead__c = ld.Id;
        attachment.Application__c=app.Id;
        attachment.Folder__c=fol.Id;
        insert attachment;	
        
        AWS_Setting__c awssetting = new AWS_Setting__c();
        awssetting.aws_key__c ='aws key' ;
        awssetting.aws_secret__c ='aws secret' ;
        awssetting.bucket_name__c ='bucket name' ;
        awssetting.host__c ='aws host' ; 
        insert awssetting ;
        
        
        
    }
    
    public static testmethod void testGenerateFileURL() {
        
        List<Amazon_S3_Files__c> s3fileList = [Select Id,File_Name__c,File_Path__c, AWS_File_Key__c,Aws_S3_File_Id__c From Amazon_S3_Files__c] ;
        System.assert(s3fileList.size()>0);
        List<Lead> leadList = [Select Id,Name From Lead] ;
        System.assert(leadList.size()>0);
        
        Test.startTest();
        
        // set the page reference
        PageReference pageRef = Page.SUN_FilePreview;        
        test.setCurrentPage(pageRef);
        
        //Add fileUrl param to page URL 
        ApexPages.currentPage().getParameters().put('fileUrl', 'Test File URL');
        
        //Add fileUrl param to page URL 
        ApexPages.currentPage().getParameters().put('Id', s3fileList[0].AWS_File_Key__c);
        
        SPRU_FilePreviewController sfpc = new SPRU_FilePreviewController();
        
        System.debug('sfpc-->'+sfpc);
        System.assertEquals('application/pdf', sfpc.fileType);
        System.assertEquals('Test File URL', sfpc.fileUrl);
        
        Map<String,String> generateAwsFileURL = SPRU_FilePreviewController.generateAwsFileURL(s3fileList[0].AWS_File_Key__c);
        
        Test.stopTest(); 
        
        
        // Asserts
        System.assertEquals('Photos', generateAwsFileURL.get('Folder_Name'));
        System.assertEquals(Label.defaultAutomationName, generateAwsFileURL.get('Automation_API_Name'));         
        
         
        
    }
    
    @isTest
    public static void getListOfApplicationFileIdTest(){
        List<Application__c> appList = [Select Id From Application__c];
        System.assert(appList.size()>0);
        
        List<Folder__c> folderList = [Select Id From Folder__c];
        System.assert(folderList.size()>0);
        
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109'; 
        insert pr;
        
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        opp.Property__c = pr.id;
        insert opp;
        
        Opportunity_Worksheet__c ow = new Opportunity_Worksheet__c();
        ow.Opportunity__c=opp.Id;
        insert ow;
        
        Test.startTest();
        	SPRU_FilePreviewController.getListOfApplicationFileId(ow.Id,folderList[0].Id);
        Test.stopTest();
        
    }
    
    @isTest
    public static void displayUploadedFilesTest(){
        List<Amazon_S3_Files__c> s3List = [Select Id From Amazon_S3_Files__c];
        System.assert(s3List.size()>0);
        Test.startTest();
        	SPRU_FilePreviewController.displayUploadedFiles(s3List[0].Id );
        Test.stopTest();
        
    }
    
    @isTest
    public static void getFileExplorerTest(){
        List<Application__c> appList = [Select Id From Application__c];
        System.assert(appList.size()>0);
        
        List<Folder__c> folderList = [Select Id From Folder__c];
        System.assert(folderList.size()>0);
        
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109'; 
        insert pr;
        
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        opp.Property__c = pr.id;
        insert opp;
        
        Opportunity_Worksheet__c ow = new Opportunity_Worksheet__c();
        ow.Opportunity__c=opp.Id;
        insert ow;
        
        Credit_Report__c cr = new Credit_Report__c();
        //cr.Name='Credit Report';
        cr.Opportunity_Worksheet__c=ow.Id;
        insert cr;
        
        Test.startTest();
        	SPRU_FilePreviewController.getFileExplorer(cr.Id,'Photos');
        Test.stopTest();
        
    }
    
}