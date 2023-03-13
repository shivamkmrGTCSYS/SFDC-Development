public with sharing class SPR_CalculateFinalAVMPrice 
{
    @auraenabled
    public static String calculateOnOpportunity(String recordId) 
    {
        List<Valuation__c> avmRecordList = [SELECT id, Estimated_Value__c, Confidence_Score__c FROM Valuation__c WHERE Opportunity__c=:recordId AND Confidence_Score__c>=90 AND Estimated_Value__c > 0 ORDER BY Estimated_Value__c ASC]; 

        List<Decimal> avmValue = new List<Decimal>();
        List<Decimal> avmScore = new List<Decimal>();
        for(Valuation__c avmRecord : avmRecordList)
        {
            if(avmRecord.Estimated_Value__c!=null)
                avmValue.add(avmRecord.Estimated_Value__c);
            if(avmRecord.Confidence_Score__c!=null)
                avmScore.add(avmRecord.Confidence_Score__c);
        }

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
                 
        Opportunity oppRecord = new Opportunity(Id=recordId);
        oppRecord.Final_AVM_Price__c = finalAVMPrice;
        if(finalAVMPrice!=null && avmScore!=null){ 
            oppRecord.AVM_Final_Confidence_Score__c = calculateMedian(avmScore);
            oppRecord.AVM_Acceptable_Calculated__c = 'Yes';
            oppRecord.AVM_Final_Price_Status__c = null;
        } else {
            oppRecord.AVM_Acceptable_Calculated__c = 'No';
            oppRecord.AVM_Final_Confidence_Score__c=null;
            oppRecord.AVM_Final_Price_Status__c='Order AAR';
        }
        if(finalAVMValueList!=null && finalAVMValueList.size()<2 ){ 
            oppRecord.AVM_Final_Price_Status__c='Order AAR';
            oppRecord.AVM_Acceptable_Calculated__c = 'No';
            oppRecord.AVM_Final_Confidence_Score__c=null;
            oppRecord.Final_AVM_Price__c = null;
        }
        
            
        update oppRecord;
        
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