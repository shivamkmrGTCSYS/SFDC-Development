public class SPR_CreateOppConsumerCalculator {
	
    @AuraEnabled
    public static String createConsumerCalculator(String recordId){
		System.debug('recordId-->'+recordId);

        Valuation__c verValuation = getValuationRecord(recordId,'Veros');
        Valuation__c ccValuation = getValuationRecord(recordId,'Clear Capital');
        Valuation__c radianValuation = getValuationRecord(recordId,'Radian');
        
        Opportunity opp = [Select Id,Property_Type__c,FICO__c,Occupancy_Status__c,
                            Appraisal_Cost__c,Title_Cleared__c,Senior_Lien_Type__c,Initial_Appraised_Value__c,Est_Home_Value_Zillow__c,Est_Home_Value__c,
                           Foreclosure_Seasoning__c,Services_Homeowner_Paid__c,Taxes_Government_Fees_HO_Paid__c,
                           Bankruptcy_Time_Since__c,AVM_Final_Confidence_Score__c,
                           Investment_Position__c,Lot_Size__c,Investment_amount_Calculator__c,Occupancy_Status_Credit_report__c,
                           Total_Liens_Paid_Through_Closing__c,Total_Collections_to_be_Paid_Off_calc__c,Total_Senior_Liens__c,
                           Title_Clean__c, Instant_Title_Received__c,Hybrid_Appraisal_Required__c
                           From Opportunity Where Id=:recordId] ;
        
        Consumer_Calculator__c cc = new Consumer_Calculator__c();
        cc.Opportunity__c=recordId;
        
        
            
        cc.Property_Type__c=opp.Property_Type__c;
        cc.AVM_Confidence__c=opp.AVM_Final_Confidence_Score__c;         
        cc.FICO__c = opp.FICO__c;
        cc.Occupancy_Status__c = opp.Occupancy_Status_Credit_report__c;
        
        if(opp.Initial_Appraised_Value__c!=null && opp.Initial_Appraised_Value__c > 0){
            cc.Property_Value__c = opp.Initial_Appraised_Value__c;
        }else{
            if(opp.Est_Home_Value_Zillow__c != null && (opp.Est_Home_Value_Zillow__c*1.1)<=opp.Est_Home_Value__c){
                cc.Property_Value__c = opp.Est_Home_Value_Zillow__c*1.1;
            }else{
                cc.Property_Value__c = opp.Est_Home_Value__c;
            }
        }
        
        //FC (Time Since)    
        if(opp.Foreclosure_Seasoning__c =='Seasoned')
        	cc.FC_Time_Since__c = true;
        else
            cc.FC_Time_Since__c = false; 
        
        cc.Foreclosure_Seasoning__c = opp.Foreclosure_Seasoning__c;
                
        cc.Bankruptcy_Time_Since__c = opp.Bankruptcy_Time_Since__c;
        
        if(opp.Bankruptcy_Time_Since__c=='Seasoned')
        	cc.BK_Time_Since__c = true;
        else
            cc.BK_Time_Since__c = false;
        
        if(opp.Hybrid_Appraisal_Required__c == 'Yes' )
        	cc.AAR_Required__c=True;
        else
            cc.AAR_Required__c = False;
        
        cc.Lien_Position__c = opp.Investment_Position__c;
        if(opp.Instant_Title_Received__c=='Yes'){
            cc.Title_Clean__c = True;
        }else{
            cc.Title_Clean__c = false;
        }
        
        cc.Estimated_fees_Maximum__c=1500;
        cc.Lot_Size__c = opp.Lot_Size__c!=null?Decimal.valueOf(opp.Lot_Size__c):0;
        cc.Senior_Lien_Type__c = opp.Senior_Lien_Type__c;
        cc.Senior_Mortgage__c = opp.Total_Senior_Liens__c;
         
        cc.Payoffs_Required__c = opp.Total_Liens_Paid_Through_Closing__c+opp.Total_Collections_to_be_Paid_Off_calc__c;
        cc.HO_Requested__c = opp.Investment_amount_Calculator__c;
        cc.Estimated_fees_HO_Requested__c = opp.Services_Homeowner_Paid__c+opp.Taxes_Government_Fees_HO_Paid__c;
        //cc.Estimated_fees_Maximum__c = opp.;
        //cc.Estimate__c = opp.;

        cc.Radian_Value__c = radianValuation.Estimated_Value__c;
        cc.Veros_Value__c = verValuation.Estimated_Value__c;
        cc.Clear_Capital_Value__c = ccValuation.Estimated_Value__c;

        cc.Radian_Score__c = radianValuation.Confidence_Score__c;
        cc.Veros_Score__c = verValuation.Confidence_Score__c;
        cc.Clear_Capital_Score__c = ccValuation.Confidence_Score__c;
        
        insert cc;
        
        return Label.Consumer_Calculator_Record;
    }

    public static Valuation__c getValuationRecord(String opptyId ,String source){
        Valuation__c v = new Valuation__c(Estimated_Value__c = 0,Confidence_Score__c = 0);
        List<Valuation__c>  vList =[SELECT Estimated_Value__c,Confidence_Score__c,AVM_Source__c FROM Valuation__c WHERE Opportunity__c=:opptyId AND Recordtype.Name=: source];

        return ( vList.size() > 0 ? vList[0] : v );
    }
    
}