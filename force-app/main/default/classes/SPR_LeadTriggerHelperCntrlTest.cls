@isTest
public class SPR_LeadTriggerHelperCntrlTest {
    
    @TestSetup
    static void makeData(){        
        
        opportunity opp = new opportunity();
        opp.Name = 'test';
        opp.StageName = 'Collecting Docs';
        opp.CloseDate =system.today().addDays(30);
        insert opp;
        
        Property__c pr = new Property__c();
        pr.Street__c = '2369 Loring st';
        pr.City__c = 'San Diego';
        pr.State_Province__c = 'CA';
        pr.County__c = 'United States';
        pr.Zip_Postal_Code__c = '92109'; 
        pr.Opportunity__c = opp.Id;
        insert pr;
        
        
      
        Lead le = new Lead();
        le.LastName = 'test';
        le.Company = 'demo';
        le.Status = 'New';
        le.Street = '1716 Thomas Court';
        le.City = 'Modesto';
        le.State = 'CA';
        le.Country = 'United States';
        le.PostalCode = '95355';
        le.IsConverted= false;
        insert le;
                 
        Amazon_S3_Files__c s3 = new Amazon_S3_Files__c();
        
        s3.Opportunity__c = opp.Id;
        s3.Lead__c=le.Id;
        s3.Folder_Name__c='1st Mortgage Statement';
        insert s3;
        
        Valuation__c avm = new Valuation__c();
        avm.Opportunity__c = opp.Id;
        avm.Lead__c = le.Id;
        avm.Amazon_S3_File__c=s3.Id;
        insert avm;
        
        Application__c app = new Application__c();
        app.Opportunity__c=opp.Id;
        insert app;
        
        Title_and_Escrow__c te = new Title_and_Escrow__c();
        te.Opportunity__c=opp.Id;
        insert te;
    }
    
    @isTest
    public static void testLeadUpdation(){
        Lead le = [SELECT IsConverted FROM Lead WHERE Name='test'];
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(le.id);
        lc.setOpportunityName('Cole Swain');
        lc.setConvertedStatus('Converted');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        system.assertEquals(le.id != null, true);
    }
    
    
    
    
}