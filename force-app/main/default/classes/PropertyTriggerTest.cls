@isTest
public class PropertyTriggerTest {
	
    @isTest
    public static void populateSpliteroPropertyTest(){
                 
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109'; 
        pr.Property_Type_Tax__c='Transient Lodging';
                  
        Test.startTest();
        	insert pr;
        	pr.Property_Type_Tax__c='Townhouse/Rowhouse';
        	update pr;
        Test.stopTest();        
        
    }
     
    @isTest
    public static void populateSpliteroPropertyTest1(){
                 
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109'; 
        pr.Property_Type_Tax__c='Triplex';
                  
        Test.startTest();
        	insert pr;
        	pr.Property_Type_Tax__c='SFR';
        	update pr;
        Test.stopTest();        
        
    }
    
    @isTest
    public static void DocumentUpdateTest(){
        
         
        Property__c pr= New Property__c();
        pr.Number_Of_Owner__c=1;
          
        insert pr ;
          
        Opportunity opp = New Opportunity();
         
        opp.Property__c = pr.Id;
        opp.Name ='test1';
        opp.StageName ='Pre-Approving';
        opp.CloseDate = Date.today();
          
        insert opp;
                 
        Document__c doc = New Document__c();
        doc.Opportunity__c =opp.id;
        doc.Name = 'test';
        doc.Required__c =true;
          
        insert doc;
        
        Test.startTest();
        	Property__c pr1 =[Select Id From Property__c Where Id=:pr.Id];
        	pr1.Flood_Zone__c='A';
        	update pr1;
        Test.stopTest();
        
        
    }
    
}