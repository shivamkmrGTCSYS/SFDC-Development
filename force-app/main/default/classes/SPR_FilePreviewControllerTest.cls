@IsTest
public class SPR_FilePreviewControllerTest {
    
    @TestSetup
    static void makeData(){
        
        Lead ld = new Lead();
        ld.LastName = 'Test';
        ld.Company = 'Test Company';
        insert ld;    
        
        Amazon_S3_Files__c attachment = new Amazon_S3_Files__c();             
        attachment.Aws_S3_File_Id__c =  'Test Aws_S3_File_Id__c';
        attachment.File_Path__c = 'Test File_Path__c';
        attachment.File_Name__c =  'Test File_Name__c.csv';         
        attachment.AWS_File_Key__c = 'Test+AWS_File_Key__c';  
        attachment.ETag__c = 'Test ETag__c'; 
        attachment.Size_In_Bytes__c =  12345;			
        attachment.Folder_Name__c = 'Photos';
        attachment.Lead__c = ld.Id;
        insert attachment;	
        
        AWS_Setting__c awssetting = new AWS_Setting__c();
        awssetting.aws_key__c ='aws key' ;
        awssetting.aws_secret__c ='aws secret' ;
        awssetting.bucket_name__c ='bucket name' ;
        awssetting.host__c ='aws host' ; 
        insert awssetting ;
        
        Folder_Configuration__c folConfig = new Folder_Configuration__c();
        folConfig.Object_Name__c = 'Loan_Origination__c';
        insert folConfig;
            
        Folder__c fol = new Folder__c();
        fol.Name = 'Photos';
        fol.Folder_Configuration__c = folConfig.id;
        insert fol;
        
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
        
        SPR_FilePreviewController sfpc = new SPR_FilePreviewController();
         
        System.debug('sfpc-->'+sfpc); 
        System.assertEquals('application/pdf', sfpc.fileType);
        System.assertEquals('Test File URL', sfpc.fileUrl);
        
        Map<String,String> generateAwsFileURL = SPR_FilePreviewController.generateAwsFileURL(s3fileList[0].AWS_File_Key__c);
        
        Test.stopTest(); 
        
        
        // Asserts
        System.assertEquals('Photos', generateAwsFileURL.get('Folder_Name'));
        System.assertEquals(Label.defaultAutomationName, generateAwsFileURL.get('Automation_API_Name'));         
        
         
        
    }
    
    
    
}