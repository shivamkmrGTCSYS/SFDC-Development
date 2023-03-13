@isTest
public class SPR_FinalAvmOpptyWorksheetTest {

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
        insert s3;
        
        Opportunity_Worksheet__c oppwk2 = new Opportunity_Worksheet__c(Opportunity__c = opp.Id );
        insert oppwk2;
        
        Id verosId = Schema.SObjectType.Valuation__c
                                .getRecordTypeInfosByName()
                                .get('Veros')
                                .getRecordTypeId();
        Id clearCapitalId = Schema.SObjectType.Valuation__c
                                .getRecordTypeInfosByName()
                                .get('Clear Capital')
                                .getRecordTypeId();
    	Id caId = Schema.SObjectType.Valuation__c
                                .getRecordTypeInfosByName()
                                .get('Collateral Analytics')
                                .getRecordTypeId();
        
        Valuation__c avm = new Valuation__c();
        avm.Opportunity__c = opp.Id;
        avm.Lead__c = le.Id;
        avm.Amazon_S3_File__c=s3.Id;
        avm.Estimated_Value__c=10000;
        avm.Confidence_Score__c=95;
        avm.Opportunity_Worksheet__c=oppwk2.Id;
        avm.RecordTypeId=verosId;
        insert avm;
        
        Valuation__c avm1 = new Valuation__c();
        avm1.Opportunity__c = opp.Id;
        avm1.Lead__c = le.Id;
        avm1.Amazon_S3_File__c=s3.Id;
        avm1.Estimated_Value__c=10000;
        avm1.Confidence_Score__c=95;
        avm1.Opportunity_Worksheet__c=oppwk2.Id;
        avm1.RecordTypeId=clearCapitalId;
        insert avm1;
        
        Valuation__c avm2 = new Valuation__c();
        avm2.Opportunity__c = opp.Id;
        avm2.Lead__c = le.Id;
        avm2.Amazon_S3_File__c=s3.Id;
        avm2.Estimated_Value__c=10000;
        avm2.Confidence_Score__c=95;
        avm2.Opportunity_Worksheet__c=oppwk2.Id;
        avm2.RecordTypeId=caId;
        insert avm2;
        
    }
    
    @isTest
    public static void calculateOnOpportunityWorksheetTest(){
        Opportunity_Worksheet__c ow = [Select Id From Opportunity_Worksheet__c LIMIT 1];
        
        Test.startTest();
        	SPR_FinalAvmOpptyWorksheet.calculateOnOpportunityWorksheet(ow.Id);
        Test.stopTest();
    }
     
}