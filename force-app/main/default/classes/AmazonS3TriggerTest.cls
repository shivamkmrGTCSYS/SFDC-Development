@isTest
public class AmazonS3TriggerTest {
    
    @isTest
    public static void docTest(){
        opportunity opp = new opportunity();
        opp.Name = 'test1';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        // opp.AccountId=acc.Id;
        insert opp;
        Id externalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Homeowner').getRecordTypeId();
        Document__c doc = new Document__c();
        doc.Name ='Clear Capital AVM';
        doc.Opportunity__c = opp.Id;
        doc.RecordTypeId=externalRecordTypeId;
        insert doc; 
        
        Amazon_S3_Files__c  s3  =new Amazon_S3_Files__c();
        s3.Folder_Name__c ='AVM Clear Capital';
        s3.Opportunity__c = opp.Id;
        s3.Source__c='Website';
        Test.startTest();
        	insert s3;
        Test.stopTest();
          
    }
    
    @isTest
    public static void docTestNew(){
        opportunity opp = new opportunity();
        opp.Name = 'test1';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        // opp.AccountId=acc.Id;
        insert opp;        
        
        Amazon_S3_Files__c  s3 =new Amazon_S3_Files__c();
        s3.Folder_Name__c ='Clear Capital AVM';
        s3.Opportunity__c = opp.Id; 
        s3.Source__c='Website';
        Test.startTest();
        	insert s3;
        Test.stopTest();
        
 
    }
    
	@isTest
    public static void docTestNew1(){
        opportunity opp = new opportunity();
        opp.Name = 'test1';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        // opp.AccountId=acc.Id;
        insert opp;        
        
        List<Document__c> docList = new List<Document__c>();
        Document__c doc = New Document__c();             
        doc.Name = 'documentname';
        doc.Required__c = true;
        doc.Opportunity__c =opp.Id;
        docList.add(doc);
        insert docList;
        
        Test.startTest();
        	AmazonS3TriggerHandler.documentMap(docList);
        Test.stopTest();
        
 
    }     
    
    
    
}