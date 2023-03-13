public class SPR_OpportunityTriggerHelper {

    public static void updateCloseDate(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        for(Opportunity opp : oppList){
            if(oldMap==null || (oldMap!=null && opp.StageName!=oldMap.get(opp.Id).StageName)){ 
                if(opp.StageName=='Pre-Approving'){
                    opp.CloseDate=Date.today().addDays(28);
                }
                if(opp.StageName=='Intent to Proceed'){
                    opp.CloseDate=Date.today().addDays(25);
                }
                if(opp.StageName=='Processing'){
                    opp.CloseDate=Date.today().addDays(21);
                }
                if(opp.StageName=='Underwriting'){
                    opp.CloseDate=Date.today().addDays(12);
                }
                if(opp.StageName=='Closing'){
                    opp.CloseDate=Date.today().addDays(8);
                }
            }
        }
    }
    
    public static void setFeeValues(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        for(Opportunity opp : oppList){
            if(oldMap==null){
                opp.Acquisition_Fee__c=2.5;
                opp.Annual_Servicing_Fee__c=1;
                opp.Booked_Profit_Share__c=1;
            }else{
                if(opp.Backend_partner_selected__c==True){
                    System.debug('opp.Create_Capitol_Markets__c-->'+opp.Create_Capitol_Markets__c);
                    if(opp.Create_Capitol_Markets__c=='Redwood Trust'){
                        opp.Acquisition_Fee__c=2.75;
                        opp.Annual_Servicing_Fee__c=1.125;
                        opp.Booked_Profit_Share__c=1;
                    }
                    if(opp.Create_Capitol_Markets__c=='Kingsbridge'){
                        opp.Acquisition_Fee__c=2.75;
                    }
                }
            }
        }
    }


    public static void calculateForeclosueAndBanruptcy(List<Opportunity> oppList, Map<Id,Opportunity> oldMap)
    {
        for(Opportunity oppRec : oppList)
        {
            calculateForeClosure(oppRec);
            calculateForeBankRuptcy(oppRec);
        }
    }
    

    private static void calculateForeClosure(Opportunity opportunityRecord) 
    {
        // --------------------------------------- FORECLOSURE START -------------------------------------
        Decimal calculatedDays1 =  opportunityRecord.Completion_Date_1__c == null ? 0 :
        (opportunityRecord.Completion_Date_1__c).daysBetween(System.today())/365.00;
        Decimal calculatedDays2 = opportunityRecord.Completion_Date_2__c == null ? 0 : 
        (opportunityRecord.Completion_Date_2__c).daysBetween(System.today())/365.00;
        Decimal calculatedDays3 = opportunityRecord.Completion_Date_3__c == null ? 0 : 
        (opportunityRecord.Completion_Date_3__c).daysBetween(System.today())/365.00;
        
        Integer numberOfForeclosureOrDeed = 0;
        numberOfForeclosureOrDeed += opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1__c != null ? 1 : 0;
        numberOfForeclosureOrDeed += opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2__c != null ? 1 : 0;
        numberOfForeclosureOrDeed += opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3__c != null ? 1 : 0;
        
        String finalForeclosureVal1 =  String.isBlank(opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1__c) ? '' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1__c == 'Foreclosure' && calculatedDays1 >= 7 ? 'Seasoned' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1__c == 'Foreclosure' && opportunityRecord.Extenuating_Circumstances_1__c == true && calculatedDays1 >= 3 ? 'Seasoned':
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1__c == 'Deed-In-Lieu' && calculatedDays1 >= 4 ? 'Seasoned' : 'Ineligible';
        
        String finalForeclosureVal2 =  String.isBlank(opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2__c) ? '' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2__c == 'Foreclosure' && calculatedDays2 >= 7 ? 'Seasoned' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2__c == 'Foreclosure' && opportunityRecord.Extenuating_Circumstances_2__c == true && calculatedDays2 >= 3 ? 'Seasoned':
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2__c == 'Deed-In-Lieu' && calculatedDays2 >= 4 ? 'Seasoned' : 'Ineligible';
        
        String finalForeclosureVal3 =  String.isBlank(opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3__c) ? '' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3__c == 'Foreclosure' && calculatedDays3 >= 7 ? 'Seasoned' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3__c == 'Foreclosure' && opportunityRecord.Extenuating_Circumstances_3__c == true && calculatedDays3 >= 3 ? 'Seasoned':
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3__c == 'Deed-In-Lieu' && calculatedDays3 >= 4 ? 'Seasoned' : 'Ineligible';
        
        opportunityRecord.Foreclosure_Seasoning__c = numberOfForeclosureOrDeed == 0 ? '' : 
        numberOfForeclosureOrDeed > 0 && 
            (finalForeclosureVal1 == 'Seasoned' || String.isBlank(finalForeclosureVal1)) &&
            (finalForeclosureVal2 == 'Seasoned' || String.isBlank(finalForeclosureVal2)) &&
            (finalForeclosureVal3 == 'Seasoned' || String.isBlank(finalForeclosureVal3)) ? 'Seasoned' : 'Ineligible';
        // --------------------------------------- FORECLOSURE END -------------------------------------
    }

    private static void calculateForeBankRuptcy(Opportunity opportunityRecord) 
    {
        // --------------------------------------- BANKRUPTCY START -------------------------------------
        Decimal calculatedDaysBankruptcy1 =  opportunityRecord.Discharge_Date_Bankruptcy_1__c == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_1__c).daysBetween(System.today())/365.00;
        opportunityRecord.Discharge_Seasoning_1__c = calculatedDaysBankruptcy1;

        System.debug('opportunityRecord.Discharge_Date_Bankruptcy_1__c '+opportunityRecord.Discharge_Date_Bankruptcy_1__c);
        //System.debug('(opportunityRecord.Discharge_Date_Bankruptcy_1__c).daysBetween(System.today()) '+(opportunityRecord.Discharge_Date_Bankruptcy_1__c).daysBetween(System.today()));
        Decimal calculatedDaysDismissalBankruptcy1 =  opportunityRecord.Dismissal_Date_Bankruptcy_1__c == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_1__c).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy2 =  opportunityRecord.Discharge_Date_Bankruptcy_2__c == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_2__c).daysBetween(System.today())/365.00;
        opportunityRecord.Discharge_Seasoning_2__c = calculatedDaysBankruptcy2;

        Decimal calculatedDaysDismissalBankruptcy2 =  opportunityRecord.Dismissal_Date_Bankruptcy_2__c == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_2__c).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy3 =  opportunityRecord.Discharge_Date_Bankruptcy_3__c == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_3__c).daysBetween(System.today())/365.00;
        //opportunityRecord.Discharge_Seasoning_3__c = calculatedDaysBankruptcy3;

        Decimal calculatedDaysDismissalBankruptcy3 =  opportunityRecord.Dismissal_Date_Bankruptcy_3__c == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_3__c).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy4 =  opportunityRecord.Discharge_Date_Bankruptcy_4__c == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_4__c).daysBetween(System.today())/365.00;
        //opportunityRecord.Discharge_Seasoning_4__c = calculatedDaysBankruptcy4;

        Decimal calculatedDaysDismissalBankruptcy4 = opportunityRecord.Dismissal_Date_Bankruptcy_4__c == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_4__c).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy5 =  opportunityRecord.Discharge_Date_Bankruptcy_5__c == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_5__c).daysBetween(System.today())/365.00;
        //opportunityRecord.Discharge_Seasoning_5__c = calculatedDaysBankruptcy5;

        Decimal calculatedDaysDismissalBankruptcy5 =  opportunityRecord.Dismissal_Date_Bankruptcy_5__c == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_5__c).daysBetween(System.today())/365.00;

    
        List<Boolean> extenuatingValues = new  List<Boolean>{opportunityRecord.Extenuating_Circumstances_Bankruptcy_1__c,
            opportunityRecord.Extenuating_Circumstances_Bankruptcy_2__c,
            opportunityRecord.Extenuating_Circumstances_Bankruptcy_3__c,
            opportunityRecord.Extenuating_Circumstances_Bankruptcy_4__c,
            opportunityRecord.Extenuating_Circumstances_Bankruptcy_5__c };
                
        List<Decimal> DischargeListRaw = new List<Decimal>{calculatedDaysBankruptcy1,
            calculatedDaysBankruptcy2,
            calculatedDaysBankruptcy3,
            calculatedDaysBankruptcy4,
            calculatedDaysBankruptcy5};

        List<Decimal> DischargeList = new List<Decimal>();
        if(calculatedDaysBankruptcy1 != null && calculatedDaysBankruptcy1 != 0){
            DischargeList.add(calculatedDaysBankruptcy1);
        } 
        if(calculatedDaysBankruptcy2 != null && calculatedDaysBankruptcy2 != 0){
            DischargeList.add(calculatedDaysBankruptcy2);
        } 
        if(calculatedDaysBankruptcy3 != null && calculatedDaysBankruptcy3 != 0){
            DischargeList.add(calculatedDaysBankruptcy3);
        } 
        if(calculatedDaysBankruptcy4 != null && calculatedDaysBankruptcy4 != 0){
            DischargeList.add(calculatedDaysBankruptcy4);
        } 
        if(calculatedDaysBankruptcy5 != null && calculatedDaysBankruptcy5 != 0){
            DischargeList.add(calculatedDaysBankruptcy5);
        } 
                        
        List<Decimal> DismissalListRaw = new List<Decimal>{calculatedDaysDismissalBankruptcy1,
                            calculatedDaysDismissalBankruptcy2,
                            calculatedDaysDismissalBankruptcy3,
                            calculatedDaysDismissalBankruptcy4,
                            calculatedDaysDismissalBankruptcy5 };
        

        List<Decimal> DismissalList = new List<Decimal>();
        if(calculatedDaysDismissalBankruptcy1 != null && calculatedDaysDismissalBankruptcy1 != 0){
            DismissalList.add(calculatedDaysDismissalBankruptcy1);
        }
        if(calculatedDaysDismissalBankruptcy2 != null && calculatedDaysDismissalBankruptcy2 != 0){
            DismissalList.add(calculatedDaysDismissalBankruptcy2);
        }
        if(calculatedDaysDismissalBankruptcy3 != null && calculatedDaysDismissalBankruptcy3 != 0){
            DismissalList.add(calculatedDaysDismissalBankruptcy3);
        }
        if(calculatedDaysDismissalBankruptcy4 != null && calculatedDaysDismissalBankruptcy4 != 0){
            DismissalList.add(calculatedDaysDismissalBankruptcy4);
        }
        if(calculatedDaysDismissalBankruptcy5 != null && calculatedDaysDismissalBankruptcy5 != 0){
            DismissalList.add(calculatedDaysDismissalBankruptcy5);
        }
        
        DischargeList.sort();
        List<Decimal> sortedDismissalList = DismissalList;
        sortedDismissalList.sort();
        Decimal minDismissalVal = sortedDismissalList.size() > 0 ? sortedDismissalList[0] : null;
        Decimal minVal = DischargeList.size() > 0 ? DischargeList[0] : null;


        Decimal minOfDischargeAndDismissalAll = 0;
        if(minDismissalVal == null) {
            minOfDischargeAndDismissalAll = minVal;
        } else if(minVal == null) {
            minOfDischargeAndDismissalAll = minDismissalVal;
        } else {
            minOfDischargeAndDismissalAll = math.min(minDismissalVal, minVal);
        }
        
        Integer numberOfBankruptcies = 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_1__c != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_2__c != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_3__c != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_4__c != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_5__c != null ? 1 : 0;
        system.debug('min@@@@@@@@22 '+math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1));

        String finalBankruptcyVal = '';
        
        /*String finalBankruptcyVal = String.isBlank(opportunityRecord.Type_Required_Bankruptcy_1__c) ? '' :
        opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 7' && math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) >= 4 ? 'Seasoned' : 
        opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 7' && opportunityRecord.Extenuating_Circumstances_Bankruptcy_1__c == true && math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) >= 2 ? 'Seasoned' :
        (opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 13' && calculatedDaysBankruptcy1 >= 2) || 
            (opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 13' && calculatedDaysDismissalBankruptcy1 >= 4) ? 'Seasoned' : 
        opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 13' && opportunityRecord.Extenuating_Circumstances_Bankruptcy_1__c == true &&
            calculatedDaysDismissalBankruptcy1 >= 2 ? 'Seasoned' : (numberOfBankruptcies == 1 ? 'Seasoned' : 'Ineligible');
        */

        
        System.debug('math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) -- ' +math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1));
        
        Decimal minOfDischargeDismissal = 0;
        if(calculatedDaysBankruptcy1 == 0) {
            minOfDischargeDismissal = calculatedDaysDismissalBankruptcy1;
        } else if(calculatedDaysDismissalBankruptcy1 == 0) {
            minOfDischargeDismissal = calculatedDaysBankruptcy1;
        } else {
            minOfDischargeDismissal = math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1);
        }

        if(String.isBlank(opportunityRecord.Type_Required_Bankruptcy_1__c)) {
            finalBankruptcyVal = '';
            System.debug('Condition 1');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 7' && minOfDischargeDismissal >= 4) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 2');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 7' && opportunityRecord.Extenuating_Circumstances_Bankruptcy_1__c == true && minOfDischargeDismissal >= 2) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 3');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 13' && calculatedDaysBankruptcy1 >= 2) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 4');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 13' && calculatedDaysDismissalBankruptcy1 >= 4) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 5');
        } else if( opportunityRecord.Type_Required_Bankruptcy_1__c == 'Chapter 13' && opportunityRecord.Extenuating_Circumstances_Bankruptcy_1__c == true && calculatedDaysDismissalBankruptcy1 >= 2) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 6');
        } else {
            finalBankruptcyVal = 'Ineligible';
            System.debug('Condition 7');
        }
        
        /*
        opportunityRecord.Bankruptcy_Time_Since__c = numberOfBankruptcies == 0 ? '' :
        numberOfBankruptcies == 1 ? finalBankruptcyVal : minVal == null || (numberOfBankruptcies > 1 && minVal >= 5) ? 'Seasoned' : 
        numberOfBankruptcies > 1 && (minVal == null || minVal >= 3) && (minDismissalVal != null && extenuatingValues[DismissalList.indexOf(minDismissalVal)] == true) ? 'Seasoned' : 'Ineligible';
        */

        
        System.debug(' Multiple BK: minVal '+minVal);
        System.debug(' Multiple BK: DischargeList '+DischargeList);
        System.debug(' Multiple BK: minOfDischargeDismissal '+minOfDischargeDismissal);
        System.debug(' Multiple BK: DismissalList '+DismissalList);
        System.debug(' Multiple BK: DismissalList '+DismissalListRaw);
        System.debug(' Multiple BK: minOfDischargeAndDismissalAll '+minOfDischargeAndDismissalAll);
        System.debug(' Multiple BK: numberOfBankruptcies '+numberOfBankruptcies);
        //System.debug(' Multiple BK: DismissalListRaw.indexOf(minDismissalVal) '+DismissalListRaw.indexOf(minDismissalVal));
        System.debug(' Multiple BK: minDismissalVal '+minDismissalVal);
        //System.debug(' Multiple BK: extenuatingValues[DismissalList.indexOf(minDismissalVal)] '+extenuatingValues[DismissalList.indexOf(minDismissalVal)]);
        opportunityRecord.Bankruptcy_Time_Since__c = '';
        

        
        if(numberOfBankruptcies == 1) {
            opportunityRecord.Bankruptcy_Time_Since__c = finalBankruptcyVal;
        } else if(numberOfBankruptcies > 1 && minOfDischargeAndDismissalAll >= 5) {
            opportunityRecord.Bankruptcy_Time_Since__c = 'Seasoned';
            System.debug('Condition 8');
        } else if(numberOfBankruptcies > 1 && minOfDischargeAndDismissalAll >= 3 && minDismissalVal != null && extenuatingValues[DismissalListRaw.indexOf(minDismissalVal)] == true) {
            opportunityRecord.Bankruptcy_Time_Since__c = 'Seasoned';
            System.debug('Condition 9');
        } else if(numberOfBankruptcies == 2 && 
                 ((minOfDischargeAndDismissalAll >= 3 && DischargeListRaw.indexOf(minOfDischargeAndDismissalAll) != -1 && extenuatingValues[DischargeListRaw.indexOf(minOfDischargeAndDismissalAll)] == true) || (minDismissalVal != null && minDismissalVal >= 3 && extenuatingValues[DismissalListRaw.indexOf(minDismissalVal)] == true)) && 
                 extenuatingValues.contains(true)) {
            opportunityRecord.Bankruptcy_Time_Since__c = 'Seasoned';
            System.debug('Condition 9');
        } else if(DismissalList.size() > 0 || DischargeList.size() > 0){
            opportunityRecord.Bankruptcy_Time_Since__c = 'Ineligible';
            System.debug('Condition 10 - DismissalList.size() > 0 || DischargeList.size() > 0');
        } else {
            opportunityRecord.Bankruptcy_Time_Since__c = null;
            System.debug('Condition 11 - end');
        }
        // --------------------------------------- BANKRUPTCY END -------------------------------------
    }
    
    public static void createActionPlan(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        
        Map<String,String> stagePlan = getStagePlan();
        List<ActionPlan> aptList = new List<ActionPlan>();
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>();
        
        for(Opportunity opp : oppList){
            oppMap.put(opp.Id,opp);
            System.debug('opp-->'+opp);
            if(opp.StageName!=null && stagePlan.containsKey(opp.StageName)){
                ActionPlan ap = new ActionPlan();
                ap.Name=opp.StageName;
                ap.ActionPlanTemplateVersionId = stagePlan.get(opp.StageName);
                ap.TargetId=opp.Id;
                ap.StartDate=Date.today();
                ap.ActionPlanType='Industries';
                aptList.add(ap);
            }
        }
        System.debug('aptList-->'+aptList);
        if(aptList.size()>0){
            insert aptList;
            System.debug('aptList-->'+aptList);
            updateTask(aptList, oppMap );
        }
         
    }
	

    
    public static void updateActionPlan(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        
        Map<String,Opportunity> oppToUpdateMap = new Map<String,Opportunity>();
        Set<String> oppIds = new Set<String>();
        List<Opportunity> oppToUpdateList = new List<Opportunity>();
        for(Opportunity opp : oppList){
            System.debug('opp-->'+opp);
            if(opp.StageName!=null && opp.StageName != oldMap.get(opp.Id).StageName ){
                oppToUpdateMap.put(opp.Id,opp);
                oppIds.add(opp.Id);
            }
        }
         
        if(oppIds.size()>0){
            List<ActionPlan> actionPlanList = getExistingActionPlan(oppIds);
            for(Opportunity opp : oppToUpdateMap.values()){
                if(!checkExistingActionPlan( opp, actionPlanList)){
                    oppToUpdateList.add(opp);
                }
            }
        }
        
        if(oppToUpdateList.size()>0){
            createActionPlan(oppToUpdateList,new Map<Id,Opportunity>());
        }
        
    }
    
    public static Boolean checkExistingActionPlan(Opportunity opp,List<ActionPlan> actionPlanList){
        Boolean response = false ;
        for(ActionPlan ap: actionPlanList){
            if(ap.Name==opp.StageName && ap.TargetId==opp.Id){
                response = true;
                break;
            }
        }
        return response;
    }
    
    public static List<ActionPlan> getExistingActionPlan(Set<String> oppIds){
        List<ActionPlan> actionPlanList = [Select Id, Name,ActionPlanTemplateVersionId,TargetId 
                                           From ActionPlan Where TargetId IN:oppIds] ;
        return actionPlanList;
    }
    
    
    public static Map<String,String> getStagePlan(){
        Map<String,String> response = new Map<String, String>();
        Map<String,String> actionPlanVersionMap = new Map<String, String>();
        List<String> actionPlanList = new List<String>();
        
        
        Map<String, Opportunity_Action_Plan_Mapping__mdt> mcs = Opportunity_Action_Plan_Mapping__mdt.getAll();
        
        for(Opportunity_Action_Plan_Mapping__mdt oapm : mcs.values() ){
            actionPlanList.add(oapm.Action_Plan_Template__c);
        }
		System.debug('actionPlanList-->'+actionPlanList);
        
		List<ActionPlanTemplateVersion> aptvList =[Select Id,ActionPlanTemplateId  From ActionPlanTemplateVersion 
                                             Where ActionPlanTemplateId IN :actionPlanList AND Status='Final'];
        System.debug('aptvList-->'+aptvList);
        
        for(ActionPlanTemplateVersion aptv:  aptvList){
            actionPlanVersionMap.put(aptv.ActionPlanTemplateId,aptv.Id);
        }    
        System.debug('actionPlanVersionMap-->'+actionPlanVersionMap);  
        
        for(Opportunity_Action_Plan_Mapping__mdt oapm : mcs.values() ){
            if(actionPlanVersionMap.containsKey(oapm.Action_Plan_Template__c)){
                response.put(oapm.Opportunity_Stage__c,actionPlanVersionMap.get(oapm.Action_Plan_Template__c));
            }            
        }
        System.debug('response-->'+response); 
        
        return response;
        
    }
    
    
    public static void createDocument(List<Opportunity> oppList){
        
        Map<String, Document_Checklist_to_Stage__mdt> DctoStageMap = Document_Checklist_to_Stage__mdt.getAll();
        List<Document__c> DocumentList = New List<Document__c>();
        Map<String,String> rtMap = new Map<String,String>();
        //Id internalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        //Id externalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
        List<RecordType> rtList = [Select Id, DeveloperName From RecordType Where sObjectType='Document__c'];
        for(RecordType rt: rtList){
            rtMap.put(rt.DeveloperName,rt.Id);
        }
         
        for(Opportunity opp :oppList ){
            if(opp.StageName=='Pre-Approving'){
            	for(Document_Checklist_to_Stage__mdt DcMap :DctoStageMap.values()){
                	Document__c Doc = New Document__c();
                    //Doc.RecordTypeId = dcMap.Make_Visible_in_Portal__c == true ? externalRecordTypeId : internalRecordTypeId;
                    if(DcMap.Record_Type__c!=null && rtMap.containsKey(DcMap.Record_Type__c)) 
                    {
                        Doc.RecordTypeId = rtMap.get(DcMap.Record_Type__c);
                    }
                    Doc.Name = DcMap.Document_Checklist_Name__c;
                    Doc.Required__c = DcMap.Required__c;
                    Doc.Opportunity__c = opp.id;
                    Doc.Document_Key__c = DcMap.DeveloperName;
                    Doc.Document_Type__c=DcMap.Document_Type__c;
                    Doc.SF_Folder_Name__c=DcMap.SF_Folder_Name__c;
                    DocumentList.add(Doc);
                }
            }
        }        
        
        if(DocumentList.size()>0){
          insert DocumentList;
          SPR_DocumentUtility.upsertDocument(oppList, DocumentList) ;
        }
    }
    
    public static void updateDocument(List<Opportunity> oppList ){         
        SPR_DocumentUtility.updateDocument(oppList  ) ;
    }
    
    
    public static void updateTask(List<ActionPlan> aptList, Map<String,Opportunity> oppMap ){ 
        System.debug('aptList-->'+aptList);
        List<ActionPlanItem> actionPlanItemList =[SELECT Id, Name, ActionPlanId,ActionPlan.Name,
                                                  ActionPlan.Target.Id ,ActionPlan.TargetId,  
                                                  ItemId, ItemState, ActionPlanTemplateItemId 
                                                  FROM ActionPlanItem WHERE ActionPlanId IN: aptList];
        System.debug('actionPlanItemList-->'+actionPlanItemList);
        //System.debug('actionPlanItemList-->'+actionPlanItemList[0].ActionPlan.Target);
        List<Task> taskList = new List<Task>();
        if(actionPlanItemList.size()>0){
            for(ActionPlanItem apt: actionPlanItemList){
                if(apt.ActionPlan.Name=='Pre-Approving' || apt.ActionPlan.Name=='Processing'){
                    if(oppMap.containsKey(apt.ActionPlan.TargetId) && oppMap.get(apt.ActionPlan.TargetId).Processor__c!=null){
                        Task t = new Task();
                        t.Id=apt.ItemId;
                        t.OwnerId=oppMap.get(apt.ActionPlan.TargetId).Processor__c;
                        taskList.add(t); 
                    }
                } 
                if(apt.ActionPlan.Name=='Intent to Proceed' || apt.ActionPlan.Name=='Final Intent to Proceed'){
                    if(oppMap.containsKey(apt.ActionPlan.TargetId) && oppMap.get(apt.ActionPlan.TargetId).Homeowner_Advisor__c!=null){
                        Task t = new Task();
                        t.Id=apt.ItemId;
                        t.OwnerId=oppMap.get(apt.ActionPlan.TargetId).Homeowner_Advisor__c;
                        taskList.add(t); 
                    }
                } 
                if(apt.ActionPlan.Name=='Underwriting'){
                    if(oppMap.containsKey(apt.ActionPlan.TargetId) && oppMap.get(apt.ActionPlan.TargetId).Underwriter__c!=null){
                        Task t = new Task();
                        t.Id=apt.ItemId;
                        t.OwnerId=oppMap.get(apt.ActionPlan.TargetId).Underwriter__c;
                        taskList.add(t); 
                    }
                }
                if(apt.ActionPlan.Name=='Underwriting QA'){
                    if(oppMap.containsKey(apt.ActionPlan.TargetId) && oppMap.get(apt.ActionPlan.TargetId).Underwriting_QA__c!=null){
                        Task t = new Task();
                        t.Id=apt.ItemId;
                        t.OwnerId=oppMap.get(apt.ActionPlan.TargetId).Underwriting_QA__c;
                        taskList.add(t);
                    }
                }
            }                
        }
        if(taskList.size()>0){
            update taskList;
        }
    }
    
    public static void updateActionPlanTask(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>();
         
        for(Opportunity opp: oppList){
            if(opp.Processor__c!=oldMap.get(opp.Id).Processor__c || 
               opp.Homeowner_Advisor__c!=oldMap.get(opp.Id).Homeowner_Advisor__c || 
               opp.Underwriter__c!=oldMap.get(opp.Id).Underwriter__c || 
               opp.Underwriting_QA__c!=oldMap.get(opp.Id).Underwriting_QA__c
              ){
                oppMap.put(opp.Id,opp);
            }
        }
        
        List<ActionPlan> aptList = [Select Id From ActionPlan Where TargetId IN:oppMap.keySet() ];
        updateTask(aptList, oppMap );
        
    }
    
    /*public static void updateTaskProcessor(List<Opportunity> oppList, Map<Id,Opportunity> oldMap ){ 
        Map<String ,String>OppIdProcessorMap = new Map<String , String>(); 
        Set<String> oppIdSet = new Set<String>();
        for(Opportunity opp : oppList){
            if(opp.Processor__c != oldMap.get(opp.Id).Processor__c){
            	oppIdSet.add(opp.Id);
                OppIdProcessorMap.put(opp.Id , opp.Processor__c);
            }    
        }
        
        List<Task> taskList =[ Select Id ,WhatId From Task Where WhatId IN:oppIdSet];
        for(Task tsk : taskList){
            tsk.OwnerId = OppIdProcessorMap.get(tsk.WhatId);              
        }
        
        if(taskList.size()>0){
            update taskList;
        }
    }*/
    
    public static void updateStageToPortal(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        Set<String> oppIds = new Set<String>(); 
        for(Opportunity opp: oppList){
            if(opp.StageName!=oldMap.get(opp.Id).StageName){
                oppIds.add(opp.Id);
            }
        }
        if(oppIds.size()>0){
            SPR_SyncApplicationToWebUtility.sendOpportunityStageToWeb(oppIds);            
        }
    }
     
    
    
}