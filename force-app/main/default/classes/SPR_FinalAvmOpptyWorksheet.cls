public with sharing class SPR_FinalAvmOpptyWorksheet {
    
    static Id verosId = Schema.SObjectType.Valuation__c
                                .getRecordTypeInfosByName()
                                .get('Veros')
                                .getRecordTypeId();
    static Id clearCapitalId = Schema.SObjectType.Valuation__c
                                .getRecordTypeInfosByName()
                                .get('Clear Capital')
                                .getRecordTypeId();
    static Id caId = Schema.SObjectType.Valuation__c
                                .getRecordTypeInfosByName()
                                .get('Collateral Analytics')
                                .getRecordTypeId();
    
    @auraenabled
    public static String calculateOnOpportunityWorksheet(String recordId) 
    {
        List<Valuation__c> avmRecordList = [SELECT id, Estimated_Value__c, Confidence_Score__c, Opportunity__c,
                                            RecordTypeId
                                            FROM Valuation__c 
                                            WHERE Opportunity_Worksheet__c=:recordId AND 
                                            Confidence_Score__c>=90 AND Estimated_Value__c > 0 
                                            ORDER BY Estimated_Value__c ASC];
        
        List<Valuation__c> avmRecordOppList = [SELECT id, Estimated_Value__c, Confidence_Score__c, Opportunity__c,
                                            RecordTypeId
                                            FROM Valuation__c  
                                            WHERE Opportunity_Worksheet__c=:recordId   
                                            ORDER BY Estimated_Value__c ASC];
        
        Opportunity_Worksheet__c owSheet = [Select Id, Opportunity__c From Opportunity_Worksheet__c Where Id=:recordId Limit 1];
		String oppId = owSheet.Opportunity__c;
        Opportunity opporToUpdate = new Opportunity(
        	Id=oppId
        );
        List<Decimal> avmValue = new List<Decimal>();
        List<Decimal> avmScore = new List<Decimal>();
        for(Valuation__c avmRecord : avmRecordOppList)
        {
             
            if(avmRecord.RecordTypeId==verosId){
                opporToUpdate.AVM_3_Value__c=avmRecord.Estimated_Value__c;
                opporToUpdate.AVM3_Confi_Score__c=avmRecord.Confidence_Score__c;
            }
            if(avmRecord.RecordTypeId==clearCapitalId){
                opporToUpdate.AVM_2_Value__c=avmRecord.Estimated_Value__c;
                opporToUpdate.AVM2_Confi_Score__c=avmRecord.Confidence_Score__c;
            } 
            if(avmRecord.RecordTypeId==caId){
                opporToUpdate.CA_AVM_Value__c=avmRecord.Estimated_Value__c;
                opporToUpdate.CA_AVM_Confidence_Score__c=avmRecord.Confidence_Score__c;
            }
        }
        for(Valuation__c avmRecord : avmRecordList)
        {
            if(avmRecord.Estimated_Value__c!=null)
                avmValue.add(avmRecord.Estimated_Value__c);
            if(avmRecord.Confidence_Score__c!=null)
                avmScore.add(avmRecord.Confidence_Score__c);             
        }
		
        SPR_TriggerUtility.ByPassAllTrigger=True;
        	update opporToUpdate;
        SPR_TriggerUtility.ByPassAllTrigger=False;
        
        System.debug(' AVM Value '+avmValue);
        System.debug(' AVM Score '+avmScore);
        Decimal medianValue = calculateMedian(avmValue);

		System.debug(' AVM Median 1 '+avmValue);
        List<Decimal> finalAVMValueList = new List<Decimal>();
        for(Valuation__c avmRecord : avmRecordList)
        {
            //Decimal variance = (1-(medianValue/avmRecord.Estimated_Value__c))*100;
            Decimal variance = Math.abs((medianValue-avmRecord.Estimated_Value__c)/(medianValue))*100;
			System.debug(' Variance : '+variance);
            if(variance <= 10)
            {
                finalAVMValueList.add(avmRecord.Estimated_Value__c);
            }
        }

        System.debug(' AVM finalAVMValueList  '+finalAVMValueList);
        Decimal finalAVMPrice = calculateMedian(finalAVMValueList);
        System.debug(' AVM Median 2 '+finalAVMPrice);
                 
        Opportunity_Worksheet__c oppRecord = new Opportunity_Worksheet__c(Id=recordId);
        oppRecord.Final_AVM_Price__c = finalAVMPrice;
        oppRecord.Initial_Appraised_Value_Source__c = 'AVM';
        if(finalAVMPrice!=null && avmScore!=null){ 
            oppRecord.AVM_Final_Confidence_Score__c = calculateMedian(avmScore);
            oppRecord.AVM_Acceptable_Calculated__c = 'Yes';
            oppRecord.Confidence_Score__c = oppRecord.AVM_Final_Confidence_Score__c;
            oppRecord.AVM_Final_Price_Status__c = null;
        } else {
            oppRecord.AVM_Acceptable_Calculated__c = 'No';
            oppRecord.AVM_Final_Confidence_Score__c=null;
            oppRecord.Confidence_Score__c = null;
            oppRecord.AVM_Final_Price_Status__c='Order AAR';
        }
        if(finalAVMValueList!=null && finalAVMValueList.size()<2 ){ 
            oppRecord.AVM_Final_Price_Status__c='Order AAR';
            oppRecord.AVM_Acceptable_Calculated__c = 'No';
            oppRecord.AVM_Final_Confidence_Score__c=null;
            oppRecord.Confidence_Score__c = null;
            oppRecord.Final_AVM_Price__c = null;
        }

        update oppRecord;

        Opportunity_Worksheet__c oppw = [SELECT id, Opportunity__c, Initial_Appraised_Value__c, Estimated_Value_First_American__c, Estimated_Value_Homeowner__c FROM Opportunity_Worksheet__c WHERE Id=:recordId];
        if(oppw.Initial_Appraised_Value__c!=null && oppw.Initial_Appraised_Value__c > 0)
        {
            oppw.Appraised_Value__c = oppw.Initial_Appraised_Value__c;
        }
        else
        {
            if(oppw.Estimated_Value_First_American__c != null && (oppw.Estimated_Value_First_American__c*1.1)<=oppw.Estimated_Value_Homeowner__c)
            {
                oppw.Appraised_Value__c = oppw.Estimated_Value_First_American__c*1.1;
            }
            else
            {
                oppw.Appraised_Value__c = oppw.Estimated_Value_Homeowner__c;
            }
        }

        update oppw;

        if(oppw.Opportunity__c !=null)
        {
            Opportunity oppty = new Opportunity(Id=oppw.Opportunity__c);
            oppty.Final_AVM_Price__c = oppRecord.Final_AVM_Price__c;
            oppty.AVM_Final_Confidence_Score__c = oppRecord.AVM_Final_Confidence_Score__c;
            oppty.Initial_Appraised_Value_Source__c = 'AVM';

            update oppty;
        }
        
        return 'Success';
    }

    public static Decimal calculateMedian(List<Decimal> values)
    {
        System.debug(' Median Data '+values);

        if(values == null || values.size() == 0) {
            return null;
        }
        Decimal medianValue = 0.0;
        Integer avmCount = values.size();
        Integer index = avmCount-1;
        values.sort();
        if(Math.mod(avmCount, 2) == 0)
        {
            medianValue = (values[(index-1)/2] + values[(index/2)+1])/2;
        }
        else 
        {
            medianValue = values[(index+1)/2];
        }

        System.debug(' Median '+medianValue);
        return medianValue;
    }
}