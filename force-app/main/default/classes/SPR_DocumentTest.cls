@isTest
public class SPR_DocumentTest {

    @isTest
    public static void docUpdate(){
        
        SyncApplication__c sa = new SyncApplication__c();
        sa.Access_Key__c = 'AccessKey'; 
        sa.Access_Token_End_Point__c = 'https://test.token.com/api/';
        sa.Web_End_Point_Document__c = 'https://test.token.com/api/';
        sa.Web_End_Point__c = 'https://test.com/api/';
        insert sa;
        
        
        opportunity opp = new opportunity();
        opp.Name = 'test1';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
         
        insert opp;
        
        Application__c app = new Application__c( );
        app.Opportunity__c=opp.Id;
        insert app;
        Id externalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Homeowner').getRecordTypeId();
        Document__c doc = new Document__c();
        doc.Name ='Clear Capital AVM';
        doc.Opportunity__c = opp.Id;
        doc.RecordTypeId=externalRecordTypeId;
        insert doc; 
        
        Test.startTest();
        	doc.Status__c='Rejected';
        	update doc ;
        Test.stopTest();
    }
    
}