public class SPR_OpportunityUtilityTriggerHandler {

    public static void updateTotalBookedRevenue(List<Opportunity> oppList){
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
        for(Opportunity opp : oppList){
            if(opp.Total_Booked_Revenue__c>0){
                opp.Amount=opp.Total_Booked_Revenue__c;
                oppToUpdate.add(opp);
            }
        }                 
    }
    
}