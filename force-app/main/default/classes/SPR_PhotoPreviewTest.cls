@IsTest
public class SPR_PhotoPreviewTest {

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
        folConfig.Object_Name__c = 'Lead__c';
        insert folConfig;
            
        Folder__c fol = new Folder__c();
        fol.Name = 'Photos';
        fol.Folder_Configuration__c = folConfig.id;
        insert fol;
        
    }
    
    
    public static testmethod void testGenerateAwsPhotosURL() {
        
        List<Amazon_S3_Files__c> s3fileList = [Select Id,File_Name__c,File_Path__c, AWS_File_Key__c,Aws_S3_File_Id__c From Amazon_S3_Files__c] ;
        System.assert(s3fileList.size()>0);
        List<Lead> leadList = [Select Id,Name From Lead] ;
        System.assert(leadList.size()>0);
        
        Test.startTest();
        	List<Map<String, String>> response = SPR_PhotoPreview.generateAwsPhotosURL(leadList[0].Id);
        Test.stopTest();
        
        System.assert(response.size()>0);
        Map<String, String> firstResponse = response[0] ;
        System.assertEquals('Photos', firstResponse.get('Folder_Name'));
        System.debug('response'+response);
            
    }
    
    
}