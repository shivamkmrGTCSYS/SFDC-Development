@isTest
public class SPRU_PropertyDuplicateViewControllerTest {

    @isTest
    public static void getDuplicatePropertyTest(){
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        
        Lead l1 = new Lead(Web_UUID__c='HTI8G83WKG');
        l1.LastName='test';
        l1.Company='test';
        insert l1;
        
        Test.startTest();
        	SPRU_PropertyDuplicateViewController.getDuplicateProperty(l.Id,'');
        Test.stopTest();
        
    }
    
}