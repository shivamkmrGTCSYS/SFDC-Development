public class CreditReportTriggerHelper {
    
    public static void updateCreditScore(List<Credit_Report__c> crList, Map<Id,Credit_Report__c> crOldMap){
        for(Credit_Report__c cc: crList){
            
            if(Trigger.isInsert || ( Trigger.isUpdate && (cc.Equifax_Score__c !=crOldMap.get(cc.Id).Equifax_Score__c || cc.Experian_Score__c !=crOldMap.get(cc.Id).Experian_Score__c || cc.Transunion_Score__c !=crOldMap.get(cc.Id).Transunion_Score__c) )){
                if(cc.Equifax_Score__c!=null && cc.Experian_Score__c !=null && cc.Transunion_Score__c!=null){
                    cc.Credit_Score__c= getMeadian(cc.Equifax_Score__c,cc.Experian_Score__c,cc.Transunion_Score__c);
                } else if(cc.Equifax_Score__c!=null && cc.Experian_Score__c !=null){
                    cc.Credit_Score__c= getAverage(cc.Equifax_Score__c,cc.Experian_Score__c);
                } else if(cc.Equifax_Score__c!=null && cc.Transunion_Score__c !=null){
                    cc.Credit_Score__c= getAverage(cc.Equifax_Score__c,cc.Transunion_Score__c);
                } else if(cc.Experian_Score__c!=null && cc.Transunion_Score__c !=null){
                    cc.Credit_Score__c= getAverage(cc.Experian_Score__c,cc.Transunion_Score__c);
                }else if(cc.Equifax_Score__c!=null ){
                    cc.Credit_Score__c=cc.Equifax_Score__c;
                }else if(cc.Experian_Score__c!=null ){
                    cc.Credit_Score__c=cc.Experian_Score__c;
                }else if(cc.Transunion_Score__c!=null ){
                    cc.Credit_Score__c=cc.Transunion_Score__c;
                }else{
                    cc.Credit_Score__c=null;
                }
            }            
        }
    }
    
    public static decimal getMeadian(Decimal a, Decimal b, Decimal c){
        List<Decimal> decimalList = new List<Decimal>{a,b,c};
            
        for(Integer i = 0 ; i < decimalList.size() ; i ++) {
            for(Integer j = i+1 ; j <= decimalList.size() -1 ; j ++ ){
                Decimal x = 0 ;
                if(decimalList[i] >  decimalList[j]){
                    x = decimalList[i]  ;
                    decimalList[i] = decimalList[j]  ;
                    decimalList[j]  = x; 
            	}
        	}
        }
        return decimalList[1];
    }
    public static decimal getAverage(Decimal a, Decimal b){        
        return (a+b)/2;
    }
    
}