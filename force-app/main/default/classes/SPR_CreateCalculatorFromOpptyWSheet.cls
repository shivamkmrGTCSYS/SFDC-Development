public with sharing class SPR_CreateCalculatorFromOpptyWSheet {

    @AuraEnabled
    public static String createConsumerCalculator(String recordId) {
		System.debug('recordId-->'+recordId);

        try
        {

            Valuation__c verValuation = getValuationRecord(recordId,'Veros');
            Valuation__c ccValuation = getValuationRecord(recordId,'Clear Capital');
            Valuation__c radianValuation = getValuationRecord(recordId,'Radian');

            
            Opportunity_Worksheet__c opp = [Select Id, Senior_Mortgage_Amount__c, Credit_Score__c, Lot_Size_acres__c,Bankruptcy_Seasoning__c, Bankruptcy__c, Foreclosure__c, AVM_Acceptable_Calculated__c, Splitero_Property_Type__c,FICO__c,
                            Senior_Lien_Type__c,Initial_Appraised_Value__c,Estimated_Value_First_American__c,Estimated_Value_Homeowner__c,
                            Foreclosure_Seasoning__c,Services_Homeowner_Paid__c,Taxes_Government_Fees_HO_Paid__c,
                            Bankruptcy_Time_Since__c,AVM_Final_Confidence_Score__c, Payoffs_Required__c, 
                            Investment_Position__c,Lot_Size__c,Investment_amount_Calculator__c, Occupancy_Status_Credit_Report__c,
                            Total_Liens_Paid_Through_Closing__c,Total_Collections_to_be_Paid_Off_calc__c,Total_Senior_Liens__c,
                            Title_Clean__c, Instant_Title_Received__c,Hybrid_Appraisal_Required__c, Opportunity__c, Prime_Rate__c,Version__c
                            From Opportunity_Worksheet__c Where Id=:recordId] ;
            
            Consumer_Calculator__c cc = new Consumer_Calculator__c();
            cc.Opportunity__c=opp.Opportunity__c;
            cc.Prime_Rate__c = opp.Prime_Rate__c;
            cc.Property_Type__c=opp.Splitero_Property_Type__c;

            if(opp.AVM_Acceptable_Calculated__c == 'Yes')
            {
                cc.AVM_Confidence__c = opp.AVM_Final_Confidence_Score__c;
            }
            else 
            {
                cc.AVM_Confidence__c = 90;
            }       
            cc.FICO__c = opp.Credit_Score__c;
            cc.Occupancy_Status__c = opp.Occupancy_Status_Credit_Report__c == 'Owner Occupied' ? 'OO' : 'NOO';
            
            if(opp.Initial_Appraised_Value__c!=null && opp.Initial_Appraised_Value__c > 0)
            {
                cc.Property_Value__c = opp.Initial_Appraised_Value__c;
            }
            else
            {
                if(opp.Estimated_Value_First_American__c != null && (opp.Estimated_Value_First_American__c*1.1)<=opp.Estimated_Value_Homeowner__c)
                {
                    cc.Property_Value__c = opp.Estimated_Value_First_American__c*1.1;
                }
                else
                {
                    cc.Property_Value__c = opp.Estimated_Value_Homeowner__c;
                }
            }

            if(cc.Property_Value__c == null)
            {
                cc.Property_Value__c = 0;
            }
            
            
            cc.FC_Time_Since__c = opp.Foreclosure__c;
            cc.Foreclosure_Seasoning__c = opp.Foreclosure_Seasoning__c;
                    
            cc.BK_Time_Since__c = opp.Bankruptcy__c;
            cc.Bankruptcy_Time_Since__c = opp.Bankruptcy_Seasoning__c;
            
            if(opp.Hybrid_Appraisal_Required__c == 'Yes' )
                cc.AAR_Required__c=True;
            else
                cc.AAR_Required__c = False;
            
            cc.Lien_Position__c = opp.Investment_Position__c;

            /*
            if(opp.Instant_Title_Received__c=='Yes'){
                cc.Title_Clean__c = True;
            }else{
                cc.Title_Clean__c = false;
            }
            */

            if(opp.Title_Clean__c=='Yes'){
                cc.Title_Clean__c = True;
            }else{
                cc.Title_Clean__c = false;
            }
            
            cc.Estimated_fees_Maximum__c=1500;
            cc.Lot_Size__c = opp.Lot_Size_acres__c != null ? Decimal.valueOf(opp.Lot_Size_acres__c) : null;
            cc.Senior_Lien_Type__c = opp.Senior_Lien_Type__c;
            cc.Senior_Mortgage__c = opp.Senior_Mortgage_Amount__c;
            
            cc.Payoffs_Required__c = opp.Payoffs_Required__c;
            cc.HO_Requested__c = opp.Investment_amount_Calculator__c;
            cc.Estimated_fees_HO_Requested__c = opp.Services_Homeowner_Paid__c+opp.Taxes_Government_Fees_HO_Paid__c;
            //cc.Estimated_fees_Maximum__c = opp.;
            //cc.Estimate__c = opp.;

            if(cc.Estimated_fees_HO_Requested__c == null || cc.Estimated_fees_HO_Requested__c < 1)
            {
                cc.Estimated_fees_HO_Requested__c = 1500;
            }

            cc.Radian_Value__c = radianValuation.Estimated_Value__c;
            cc.Veros_Value__c = verValuation.Estimated_Value__c;
            cc.Clear_Capital_Value__c = ccValuation.Estimated_Value__c;

            cc.Radian_Score__c = radianValuation.Confidence_Score__c;
            cc.Veros_Score__c = verValuation.Confidence_Score__c;
            cc.Clear_Capital_Score__c = ccValuation.Confidence_Score__c;
            cc.Opportunity_Worksheet__c = opp.Id;
            cc.Version__c=opp.Version__c;
            
            insert cc;
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return ex.getMessage()+' '+ex.getStackTraceString();
        }
        
        return Label.Consumer_Calculator_Record;
    }

    public static Valuation__c getValuationRecord(String opptyId ,String source){
        Valuation__c v = new Valuation__c(Estimated_Value__c = 0,Confidence_Score__c = 0);
        List<Valuation__c>  vList =[SELECT Estimated_Value__c,Confidence_Score__c,AVM_Source__c FROM Valuation__c WHERE Opportunity_Worksheet__c=:opptyId AND Recordtype.Name=: source];

        return ( vList.size() > 0 ? vList[0] : v );
    }
}