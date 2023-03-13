public with sharing class DQHistoryTriggerHandler 
{
    static Id bankruptcyRecordTypeId = Schema.SObjectType.DQ_History__c
                                .getRecordTypeInfosByName()
                                .get('Bankruptcy')
                                .getRecordTypeId();
    
    static Id foreclosureRecordTypeId = Schema.SObjectType.DQ_History__c
                                .getRecordTypeInfosByName()
                                .get('Foreclosure or Deed-In-Lieu')
                                .getRecordTypeId();

    public static void beforeInsert(List<DQ_History__c> newList)
    {
        calculateBankruptcyAndForeclosure(newList);
    }

    public static void afterInsert(List<DQ_History__c> newList)
    {
        //updateBankruptcyAndForeclosure(newList);
    }

    private static void calculateBankruptcyAndForeclosure(List<DQ_History__c> newList)
    {
        Set<Id> oppWkSheetBK = new Set<Id>();
        Set<Id> oppWkSheetFC = new Set<Id>();
        for(DQ_History__c dqh : newList)
        {
            if(dqh.RecordTypeId == bankruptcyRecordTypeId)
            {
                oppWkSheetBK.add(dqh.Opportunity_Worksheet__c);
            }
            else if(dqh.RecordTypeId == foreclosureRecordTypeId)
            {
                oppWkSheetFC.add(dqh.Opportunity_Worksheet__c);
            }
        }

        List<Opportunity_Worksheet__c> oppWrkSheetBKList = new List<Opportunity_Worksheet__c>();
        List<Opportunity_Worksheet__c> oppWrkSheetFCList = new List<Opportunity_Worksheet__c>();
        List<DQ_History__c> dqHistoryToUpdate = new List<DQ_History__c>();

        for(Opportunity_Worksheet__c opw : [SELECT Id, 
                                            (SELECT Type_Required_Bankruptcy__c, Discharge_Date_Bankruptcy__c, 
                                             Dismissal_Date_Bankruptcy__c, Extenuating_Circumstances__c 
                                             FROM DQ_History__r 
                                             WHERE RecordTypeId=:bankruptcyRecordTypeId ORDER BY CreatedDate DESC ) 
                                            FROM Opportunity_Worksheet__c Where Id IN: oppWkSheetBK])
        {
            if(opw.DQ_History__r != null && opw.DQ_History__r.size() > 0)
            {
                Bankruptcy bk = new Bankruptcy(opw.DQ_History__r);
                dqHistoryToUpdate.addAll(bk.dqhListToUpdate);

                opw.Bankruptcy_Seasoning__c = calculateBankruptcy(bk);
                opw.Bankruptcies__c = opw.DQ_History__r.size();

                oppWrkSheetBKList.add(opw);
            }
            else
            {
                opw.Bankruptcy_Seasoning__c = null;
                opw.Bankruptcies__c = 0;

                oppWrkSheetBKList.add(opw);
            }
        }

        update oppWrkSheetBKList;

        for(Opportunity_Worksheet__c opw : [SELECT Id, 
                                            (SELECT Completion_Date__c, Extenuating_Circumstances__c, Type_Foreclosure_Or_Deed_In_Lieu__c
                                             FROM DQ_History__r 
                                             WHERE RecordTypeId=:foreclosureRecordTypeId ORDER BY CreatedDate DESC ) 
                                            FROM Opportunity_Worksheet__c Where Id IN: oppWkSheetFC])
        {
            if(opw.DQ_History__r != null && opw.DQ_History__r.size() > 0)
            {
                Foreclosure fc = new Foreclosure(opw.DQ_History__r);
                dqHistoryToUpdate.addAll(fc.dqhListToUpdate);

                opw.Foreclosure_Seasoning__c = calculateForeclosure(fc);
                opw.Foreclosures_or_Deeds_In_Lieu__c = opw.DQ_History__r.size();

                oppWrkSheetFCList.add(opw);
            }
            else
            {
                opw.Foreclosure_Seasoning__c = null;
                opw.Foreclosures_or_Deeds_In_Lieu__c = 0;

                oppWrkSheetFCList.add(opw);
            }
        }
        update oppWrkSheetFCList;
        update dqHistoryToUpdate;
    }

    private static String calculateBankruptcy(Bankruptcy opportunityRecord)
    {
        // --------------------------------------- BANKRUPTCY START -------------------------------------
        Decimal calculatedDaysBankruptcy1 =  opportunityRecord.Discharge_Date_Bankruptcy_1 == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_1).daysBetween(System.today())/365.00;

        System.debug('opportunityRecord.Discharge_Date_Bankruptcy_1 '+opportunityRecord.Discharge_Date_Bankruptcy_1);
        
        Decimal calculatedDaysDismissalBankruptcy1 =  opportunityRecord.Dismissal_Date_Bankruptcy_1 == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_1).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy2 =  opportunityRecord.Discharge_Date_Bankruptcy_2 == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_2).daysBetween(System.today())/365.00;

        Decimal calculatedDaysDismissalBankruptcy2 =  opportunityRecord.Dismissal_Date_Bankruptcy_2 == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_2).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy3 =  opportunityRecord.Discharge_Date_Bankruptcy_3 == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_3).daysBetween(System.today())/365.00;

        Decimal calculatedDaysDismissalBankruptcy3 =  opportunityRecord.Dismissal_Date_Bankruptcy_3 == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_3).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy4 =  opportunityRecord.Discharge_Date_Bankruptcy_4 == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_4).daysBetween(System.today())/365.00;

        Decimal calculatedDaysDismissalBankruptcy4 = opportunityRecord.Dismissal_Date_Bankruptcy_4 == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_4).daysBetween(System.today())/365.00;
        
        Decimal calculatedDaysBankruptcy5 =  opportunityRecord.Discharge_Date_Bankruptcy_5 == null ? 0 :
        (opportunityRecord.Discharge_Date_Bankruptcy_5).daysBetween(System.today())/365.00;

        Decimal calculatedDaysDismissalBankruptcy5 =  opportunityRecord.Dismissal_Date_Bankruptcy_5 == null ? 0 :
        (opportunityRecord.Dismissal_Date_Bankruptcy_5).daysBetween(System.today())/365.00;

    
        List<Boolean> extenuatingValues = new  List<Boolean>{opportunityRecord.Extenuating_Circumstances_1,
            opportunityRecord.Extenuating_Circumstances_2,
            opportunityRecord.Extenuating_Circumstances_3,
            opportunityRecord.Extenuating_Circumstances_4,
            opportunityRecord.Extenuating_Circumstances_5 };
                
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
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_1 != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_2 != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_3 != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_4 != null ? 1 : 0;
        numberOfBankruptcies += opportunityRecord.Type_Required_Bankruptcy_5 != null ? 1 : 0;
        system.debug('min@@@@@@@@22 '+math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1));

        //String finalBankruptcyVal = '';
        
        String finalBankruptcyVal = String.isBlank(opportunityRecord.Type_Required_Bankruptcy_1) ? '' :        opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 7' && math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) >= 4 ? 'Seasoned' :         opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 7' && opportunityRecord.Extenuating_Circumstances_1 == true && math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) >= 2 ? 'Seasoned' :        (opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 13' && calculatedDaysBankruptcy1 >= 2) ||             (opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 13' && calculatedDaysDismissalBankruptcy1 >= 4) ? 'Seasoned' :        opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 13' && opportunityRecord.Extenuating_Circumstances_1 == true &&            calculatedDaysDismissalBankruptcy1 >= 2 ? 'Seasoned' : (numberOfBankruptcies == 1 ? 'Seasoned' : 'Ineligible');
        

       
        System.debug('math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) -- ' +math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1));
        
        Decimal minOfDischargeDismissal = 0;
        if(calculatedDaysBankruptcy1 == 0) {
            minOfDischargeDismissal = calculatedDaysDismissalBankruptcy1;
        } else if(calculatedDaysDismissalBankruptcy1 == 0) {
            minOfDischargeDismissal = calculatedDaysBankruptcy1;
        } else {
            minOfDischargeDismissal = math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1);
        }

        if(String.isBlank(opportunityRecord.Type_Required_Bankruptcy_1)) {
            finalBankruptcyVal = '';
            System.debug('Condition 1');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 7' && minOfDischargeDismissal >= 4) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 2');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 7' && opportunityRecord.Extenuating_Circumstances_1 == true && minOfDischargeDismissal >= 2) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 3');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 13' && calculatedDaysBankruptcy1 >= 2) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 4');
        } else if(opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 13' && calculatedDaysDismissalBankruptcy1 >= 4) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 5');
        } else if( opportunityRecord.Type_Required_Bankruptcy_1 == 'Chapter 13' && opportunityRecord.Extenuating_Circumstances_1 == true && calculatedDaysDismissalBankruptcy1 >= 2) {
            finalBankruptcyVal = 'Seasoned';
            System.debug('Condition 6');
        } else {
            finalBankruptcyVal = 'Ineligible';
            System.debug('Condition 7');
        }
        
        /*
        opportunityRecord.Bankruptcy_Time_Since = numberOfBankruptcies == 0 ? '' :
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
        

        String finalBankruptcy;
        
        if(numberOfBankruptcies == 1) {
            finalBankruptcy = finalBankruptcyVal;
        } else if(numberOfBankruptcies > 1 && minOfDischargeAndDismissalAll >= 5) {
            finalBankruptcy = 'Seasoned';
            System.debug('Condition 8');
        } else if(numberOfBankruptcies > 1 && minOfDischargeAndDismissalAll >= 3 && minDismissalVal != null && extenuatingValues[DismissalListRaw.indexOf(minDismissalVal)] == true) {
            finalBankruptcy = 'Seasoned';
            System.debug('Condition 9');
        } else if(numberOfBankruptcies == 2 && 
                 ((minOfDischargeAndDismissalAll >= 3 && DischargeListRaw.indexOf(minOfDischargeAndDismissalAll) != -1 && extenuatingValues[DischargeListRaw.indexOf(minOfDischargeAndDismissalAll)] == true) || (minDismissalVal != null && minDismissalVal >= 3 && extenuatingValues[DismissalListRaw.indexOf(minDismissalVal)] == true)) && 
                 extenuatingValues.contains(true)) {
            finalBankruptcy = 'Seasoned';
            System.debug('Condition 9');
        } else if(DismissalList.size() > 0 || DischargeList.size() > 0){
            finalBankruptcy = 'Ineligible';
            System.debug('Condition 10 - DismissalList.size() > 0 || DischargeList.size() > 0');
        } else {
            finalBankruptcy = null;
            System.debug('Condition 11 - end');
        }

        opportunityRecord.result = finalBankruptcy;

        return finalBankruptcy;
        // --------------------------------------- BANKRUPTCY END -------------------------------------
    }

    private static String calculateForeclosure(Foreclosure opportunityRecord)
    {
        // --------------------------------------- FORECLOSURE START -------------------------------------
        Decimal calculatedDays1 =  opportunityRecord.Completion_Date_1 == null ? 0 :
        (opportunityRecord.Completion_Date_1).daysBetween(System.today())/365.00;
        Decimal calculatedDays2 = opportunityRecord.Completion_Date_2 == null ? 0 :        (opportunityRecord.Completion_Date_2).daysBetween(System.today())/365.00;
        Decimal calculatedDays3 = opportunityRecord.Completion_Date_3 == null ? 0 :        (opportunityRecord.Completion_Date_3).daysBetween(System.today())/365.00;
        
        Integer numberOfForeclosureOrDeed = 0;
        numberOfForeclosureOrDeed += opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1 != null ? 1 : 0;
        numberOfForeclosureOrDeed += opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2 != null ? 1 : 0;
        numberOfForeclosureOrDeed += opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3 != null ? 1 : 0;
        
        String finalForeclosureVal1 =  String.isBlank(opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1) ? '' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1 == 'Foreclosure' && calculatedDays1 >= 7 ? 'Seasoned' :
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1 == 'Foreclosure' && opportunityRecord.Extenuating_Circumstances_1 == true && calculatedDays1 >= 3 ? 'Seasoned':
        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_1 == 'Deed-In-Lieu' && calculatedDays1 >= 4 ? 'Seasoned' : 'Ineligible';
        
        String finalForeclosureVal2 =  String.isBlank(opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2) ? '' :        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2 == 'Foreclosure' && calculatedDays2 >= 7 ? 'Seasoned' :        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2 == 'Foreclosure' && opportunityRecord.Extenuating_Circumstances_2 == true && calculatedDays2 >= 3 ? 'Seasoned':        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_2 == 'Deed-In-Lieu' && calculatedDays2 >= 4 ? 'Seasoned' : 'Ineligible';
        
        String finalForeclosureVal3 =  String.isBlank(opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3) ? '' :        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3 == 'Foreclosure' && calculatedDays3 >= 7 ? 'Seasoned' :        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3 == 'Foreclosure' && opportunityRecord.Extenuating_Circumstances_3 == true && calculatedDays3 >= 3 ? 'Seasoned':        opportunityRecord.Type_Foreclosure_Or_Deed_In_Lieu_3 == 'Deed-In-Lieu' && calculatedDays3 >= 4 ? 'Seasoned' : 'Ineligible';
        
        opportunityRecord.result = numberOfForeclosureOrDeed == 0 ? '' : 
        numberOfForeclosureOrDeed > 0 && 
            (finalForeclosureVal1 == 'Seasoned' || String.isBlank(finalForeclosureVal1)) &&            (finalForeclosureVal2 == 'Seasoned' || String.isBlank(finalForeclosureVal2)) &&            (finalForeclosureVal3 == 'Seasoned' || String.isBlank(finalForeclosureVal3)) ? 'Seasoned' : 'Ineligible';

        return opportunityRecord.result;
        // --------------------------------------- FORECLOSURE END -------------------------------------
    }

    /*
    private static void updateBankruptcyAndForeclosure(List<DQ_History__c> dqhList)
    {
        List<Opportunity_Worksheet__c> oppWsListToUpdate = new List<Opportunity_Worksheet__c>();
        for(DQ_History__c dqh : dqhList)
        {
            Opportunity_Worksheet__c oppWs = new Opportunity_Worksheet__c(Id=dqh.Opportunity_Worksheet__c);
            oppWs.Foreclosure_Seasoning__c = dqh.Foreclosure_Seasoning__c;
            oppWs.Bankruptcy_Time_Since__c = dqh.Bankruptcy_Seasoning__c;

            oppWsListToUpdate.add(oppWs);
        }

        update oppWsListToUpdate;
    }
    */

    public class Bankruptcy 
    {
        public Date Discharge_Date_Bankruptcy_1;
        public Date Discharge_Date_Bankruptcy_2;
        public Date Discharge_Date_Bankruptcy_3;
        public Date Discharge_Date_Bankruptcy_4;
        public Date Discharge_Date_Bankruptcy_5;

        public Date Dismissal_Date_Bankruptcy_1;
        public Date Dismissal_Date_Bankruptcy_2;
        public Date Dismissal_Date_Bankruptcy_3;
        public Date Dismissal_Date_Bankruptcy_4;
        public Date Dismissal_Date_Bankruptcy_5;

        public Boolean Extenuating_Circumstances_1;
        public Boolean Extenuating_Circumstances_2;
        public Boolean Extenuating_Circumstances_3;
        public Boolean Extenuating_Circumstances_4;
        public Boolean Extenuating_Circumstances_5;

        public String Type_Required_Bankruptcy_1;
        public String Type_Required_Bankruptcy_2;
        public String Type_Required_Bankruptcy_3;
        public String Type_Required_Bankruptcy_4;
        public String Type_Required_Bankruptcy_5;

        String result;

        public List<DQ_History__c> dqhListToUpdate = new List<DQ_History__c>();

        public Bankruptcy(List<DQ_History__c> dqhList)
        {
            add(dqhList);
        }

        private void add(List<DQ_History__c> dqhList)
        {
            if(dqhList.size() > 0)
            {
                Type_Required_Bankruptcy_1 = dqhList[0].Type_Required_Bankruptcy__c;
                Discharge_Date_Bankruptcy_1 = dqhList[0].Discharge_Date_Bankruptcy__c;
                Dismissal_Date_Bankruptcy_1 = dqhList[0].Dismissal_Date_Bankruptcy__c;
                Extenuating_Circumstances_1 = dqhList[0].Extenuating_Circumstances__c == 'Yes';

                dqhList[0].DQ_History_Result__c = calculateResult(Type_Required_Bankruptcy_1, Discharge_Date_Bankruptcy_1, Dismissal_Date_Bankruptcy_1, Extenuating_Circumstances_1);
                dqhListToUpdate.add(dqhList[0]);
            }
            if(dqhList.size() > 1)
            {
                Type_Required_Bankruptcy_2 = dqhList[1].Type_Required_Bankruptcy__c;
                Discharge_Date_Bankruptcy_2 = dqhList[1].Discharge_Date_Bankruptcy__c;
                Dismissal_Date_Bankruptcy_2 = dqhList[1].Dismissal_Date_Bankruptcy__c;
                Extenuating_Circumstances_2 = dqhList[1].Extenuating_Circumstances__c == 'Yes';

                dqhList[1].DQ_History_Result__c = calculateResult(Type_Required_Bankruptcy_2, Discharge_Date_Bankruptcy_2, Dismissal_Date_Bankruptcy_2, Extenuating_Circumstances_2);
                dqhListToUpdate.add(dqhList[1]);
            }
            if(dqhList.size() > 2)
            {
                Type_Required_Bankruptcy_3 = dqhList[2].Type_Required_Bankruptcy__c;
                Discharge_Date_Bankruptcy_3 = dqhList[2].Discharge_Date_Bankruptcy__c;
                Dismissal_Date_Bankruptcy_3 = dqhList[2].Dismissal_Date_Bankruptcy__c;
                Extenuating_Circumstances_3 = dqhList[2].Extenuating_Circumstances__c == 'Yes';

                dqhList[2].DQ_History_Result__c = calculateResult(Type_Required_Bankruptcy_3, Discharge_Date_Bankruptcy_3, Dismissal_Date_Bankruptcy_3, Extenuating_Circumstances_3);
                dqhListToUpdate.add(dqhList[2]);
            }
            if(dqhList.size() > 3)
            {
                Type_Required_Bankruptcy_4 = dqhList[3].Type_Required_Bankruptcy__c;
                Discharge_Date_Bankruptcy_4 = dqhList[3].Discharge_Date_Bankruptcy__c;
                Dismissal_Date_Bankruptcy_4 = dqhList[3].Dismissal_Date_Bankruptcy__c;
                Extenuating_Circumstances_4 = dqhList[3].Extenuating_Circumstances__c == 'Yes';

                dqhList[3].DQ_History_Result__c = calculateResult(Type_Required_Bankruptcy_4, Discharge_Date_Bankruptcy_4, Dismissal_Date_Bankruptcy_4, Extenuating_Circumstances_4);
                dqhListToUpdate.add(dqhList[3]);
            }
            if(dqhList.size() > 4)
            {
                Type_Required_Bankruptcy_5 = dqhList[4].Type_Required_Bankruptcy__c;
                Discharge_Date_Bankruptcy_5 = dqhList[4].Discharge_Date_Bankruptcy__c;
                Dismissal_Date_Bankruptcy_5 = dqhList[4].Dismissal_Date_Bankruptcy__c;
                Extenuating_Circumstances_5 = dqhList[4].Extenuating_Circumstances__c == 'Yes';

                dqhList[4].DQ_History_Result__c = calculateResult(Type_Required_Bankruptcy_5, Discharge_Date_Bankruptcy_5, Dismissal_Date_Bankruptcy_5, Extenuating_Circumstances_5);
                dqhListToUpdate.add(dqhList[4]);
            }
        }

        private String calculateResult(String bkType, Date dischargeDate, Date dissmisalDate, Boolean extc)
        {
            Decimal calculatedDaysBankruptcy1 = dischargeDate == null ? 0 :
                                                (dischargeDate).daysBetween(System.today())/365.00;

            Decimal calculatedDaysDismissalBankruptcy1 = dissmisalDate == null ? 0 :
                                                         (dissmisalDate).daysBetween(System.today())/365.00;

            if(calculatedDaysBankruptcy1 == 0) {
                calculatedDaysBankruptcy1 = calculatedDaysDismissalBankruptcy1;
            } else if(calculatedDaysDismissalBankruptcy1 == 0) {
                calculatedDaysDismissalBankruptcy1 = calculatedDaysBankruptcy1;
            }

            String finalBankruptcyVal = String.isBlank(bkType) ? '' :                    bkType == 'Chapter 7' && math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) >= 4 ? 'Seasoned' :                     bkType == 'Chapter 7' && extc == true && math.min(calculatedDaysBankruptcy1, calculatedDaysDismissalBankruptcy1) >= 2 ? 'Seasoned' :                        (bkType == 'Chapter 13' && calculatedDaysBankruptcy1 >= 2) ||                         (bkType == 'Chapter 13' && calculatedDaysDismissalBankruptcy1 >= 4) ? 'Seasoned' :                     bkType == 'Chapter 13' && extc == true &&                    calculatedDaysDismissalBankruptcy1 >= 2 ? 'Seasoned' : 'Ineligible';

            return finalBankruptcyVal;
        }
    }

    public class Foreclosure 
    {
        public Date Completion_Date_1;
        public Date Completion_Date_2;
        public Date Completion_Date_3;

        public Boolean Extenuating_Circumstances_1;
        public Boolean Extenuating_Circumstances_2;
        public Boolean Extenuating_Circumstances_3;

        public String Type_Foreclosure_Or_Deed_In_Lieu_1;
        public String Type_Foreclosure_Or_Deed_In_Lieu_2;
        public String Type_Foreclosure_Or_Deed_In_Lieu_3;

        public String result;

        public List<DQ_History__c> dqhListToUpdate = new List<DQ_History__c>();

        public Foreclosure(List<DQ_History__c> dqhList)
        {
            add(dqhList);
        }

        @testVisible
        private void add(List<DQ_History__c> dqhList)
        {
            if(dqhList.size() > 0)
            {
                Completion_Date_1 = dqhList[0].Completion_Date__c;
                Extenuating_Circumstances_1 = dqhList[0].Extenuating_Circumstances__c == 'Yes';
                Type_Foreclosure_Or_Deed_In_Lieu_1 = dqhList[0].Type_Foreclosure_Or_Deed_In_Lieu__c;

                dqhList[0].DQ_History_Result__c = calculateResult(Type_Foreclosure_Or_Deed_In_Lieu_1, Completion_Date_1, Extenuating_Circumstances_1);

                dqhListToUpdate.add(dqhList[0]);
            }
            if(dqhList.size() > 1)
            {
                Completion_Date_2 = dqhList[1].Completion_Date__c;
                Extenuating_Circumstances_2 = dqhList[1].Extenuating_Circumstances__c == 'Yes';
                Type_Foreclosure_Or_Deed_In_Lieu_2 = dqhList[1].Type_Foreclosure_Or_Deed_In_Lieu__c;

                dqhList[1].DQ_History_Result__c = calculateResult(Type_Foreclosure_Or_Deed_In_Lieu_2, Completion_Date_2, Extenuating_Circumstances_2);

                dqhListToUpdate.add(dqhList[1]);
            } 
            if(dqhList.size() > 2)
            {
                Completion_Date_3 = dqhList[2].Completion_Date__c;
                Extenuating_Circumstances_3 = dqhList[2].Extenuating_Circumstances__c == 'Yes';
                Type_Foreclosure_Or_Deed_In_Lieu_3 = dqhList[2].Type_Foreclosure_Or_Deed_In_Lieu__c;

                dqhList[2].DQ_History_Result__c = calculateResult(Type_Foreclosure_Or_Deed_In_Lieu_3, Completion_Date_3, Extenuating_Circumstances_3);

                dqhListToUpdate.add(dqhList[2]);
            }
        }

        private String calculateResult(String fcType, Date completionDate, boolean extc)
        {
            Decimal calculatedDays =  completionDate== null ? 0 :
                                        (completionDate).daysBetween(System.today())/365.00;

            String finalForeclosureVal =  String.isBlank(fcType) ? '' :
            fcType == 'Foreclosure' && calculatedDays >= 7 ? 'Seasoned' :
            fcType == 'Foreclosure' && extc == true && calculatedDays >= 3 ? 'Seasoned':
            fcType == 'Deed-In-Lieu' && calculatedDays >= 4 ? 'Seasoned' : 'Ineligible';

            return finalForeclosureVal;
        }
    }
    public static void insertDocument(List<DQ_History__c>newList){
        Set<string> OppWorkIds = New Set<String>();
        for(DQ_History__c dq :newList ){
            if(dq.Opportunity_Worksheet__c!=null && dq.Name != null && dq.Extenuating_Circumstances__c=='Yes'){
                OppWorkIds.add(dq.Opportunity_Worksheet__c);
            }   
        }
        if(OppWorkIds.size()>0){
        	List<Opportunity> oppList = [Select Id , Name From Opportunity 
                                     Where Opportunity_Worksheet__c IN: OppWorkIds ];
        
        	SPR_DocumentUtility.updateDocument(oppList ) ;   
        }
    }
    public static void updateDocument(List<DQ_History__c> newList ,Map<Id, DQ_History__c> OldMap){
        
        Set<string> OppWorkIds = New Set<String>();
        for(DQ_History__c dq :newList){
            if(dq.Opportunity_Worksheet__c!=null && dq.Extenuating_Circumstances__c != OldMap.get(dq.Id).Extenuating_Circumstances__c){
                OppWorkIds.add(dq.Opportunity_Worksheet__c);
                
            }    
        }
        if(OppWorkIds.size()>0){
        	List<Opportunity> oppList = [Select Id , Name From Opportunity Where
                                     Opportunity_Worksheet__c IN: OppWorkIds ];
        
        	SPR_DocumentUtility.updateDocument(oppList ) ; 
           
        }
    }
}