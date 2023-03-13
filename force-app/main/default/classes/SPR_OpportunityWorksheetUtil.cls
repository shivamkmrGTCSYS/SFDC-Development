public class SPR_OpportunityWorksheetUtil {

    static Id ptcRecordTypeId = Schema.SObjectType.Payoffs__c
                                .getRecordTypeInfosByName()
                                .get('Paid Through Closing')
                                .getRecordTypeId();
    static Id collectionsRecordTypeId = Schema.SObjectType.Payoffs__c
                                .getRecordTypeInfosByName()
                                .get('Collection')
                                .getRecordTypeId();

    public static List<Opportunity_Worksheet__c> calculateSeniorLienType(List<Opportunity_Worksheet__c> owList)
    {
        for(Opportunity_Worksheet__c owsh : owList)
        {
            System.debug('owsh-->'+owsh);
            System.debug('owsh-->'+(owsh.Investment_Position__c == '1'));

            if(owsh.Investment_Position__c == '1' || owsh.Investment_Position__c == '2' || owsh.Investment_Position__c == '3')
            {
                System.debug('owsh--> IN '+owsh);
                owsh.Senior_Lien_Type__c = 'ATypical';

                Boolean evaluateMortgage = true;
                if(owsh.Recorded_Instruments__r!= null && owsh.Recorded_Instruments__r.size() > 0)
                {
                    for(Recorded_Instruments__c recinstrument : owsh.Recorded_Instruments__r)
                    {
                        System.debug('String.isNotBlank(recinstrument.Oddities__c) '+String.isNotBlank(recinstrument.Oddities__c));
                        System.debug('recinstrument.Oddities__c '+recinstrument.Oddities__c);
                        if(String.isBlank(recinstrument.Oddities__c) || (String.isNotBlank(recinstrument.Oddities__c) && !recinstrument.Oddities__c.containsIgnoreCase('Private')))
                        {
                            owsh.Senior_Lien_Type__c = 'Typical';
                        }
                        else
                        {
                            evaluateMortgage = false;
                            owsh.Senior_Lien_Type__c = 'ATypical';
                            break;
                        }
                    }
                }
                else
                {
                    owsh.Senior_Lien_Type__c = 'Typical';
                }

                if(evaluateMortgage)
                {
                    if(owsh.Mortgage_Statements__r != null && owsh.Mortgage_Statements__r.size() > 0)
                    {
                        for(Mortgage_Statement__c mtgs : owsh.Mortgage_Statements__r)
                        {
                            System.debug('mtgs-->'+mtgs);
                            if(String.isBlank(mtgs.Mortgage_Payoff_Required_or_Requested__c) || mtgs.Mortgage_Payoff_Required_or_Requested__c == 'No')
                            {
                                owsh.Senior_Lien_Type__c = 'ATypical';
                                system.debug('owsh-->'+owsh);
                                System.debug('owsh.Prime_Rate__c-->'+owsh.Prime_Rate__c);
                                //System.debug('2nd (owsh.Prime_Rate__c + 4.00) '+(owsh.Prime_Rate__c + 4.00));
                                //System.debug('2nd mtgs.Interest_Rate__c '+mtgs.Interest_Rate__c);
                                if(mtgs.Is_Private_Mortgage__c != 'Yes' && mtgs.Interest_Rate__c != null && owsh.Prime_Rate__c != null && ((owsh.Prime_Rate__c + 4.00) >= mtgs.Interest_Rate__c) )
                                {
                                    owsh.Senior_Lien_Type__c = 'Typical';
                                }
                                else
                                {
                                    break;
                                }
                            }
                            else
                            {
                                owsh.Senior_Lien_Type__c = 'Typical';
                            }
                        }
                    }
                    else
                    {
                        owsh.Senior_Lien_Type__c = 'Typical';
                    }
                }
            }
            /*
            else if(owsh.Investment_Position__c == '3')
            {
                owsh.Senior_Lien_Type__c = 'ATypical';
                if(owsh.Mortgage_Statements__r != null && owsh.Mortgage_Statements__r.size() > 0)
                {
                    Integer occurrence = 0;
                    for(Mortgage_Statement__c mtgs : owsh.Mortgage_Statements__r)
                    {
                        if(mtgs.Mortgage_Payoff_Required_or_Requested__c == 'No')
                        {
                            System.debug('3rd (owsh.Prime_Rate__c + 4.00) '+(owsh.Prime_Rate__c + 4.00));
                            if(mtgs.Interest_Rate__c != null && owsh.Prime_Rate__c != null && ((owsh.Prime_Rate__c + 4.00) >= mtgs.Interest_Rate__c) )
                            {
                                if(mtgs.Is_Private_Mortgage__c != 'Yes')
                                {
                                    occurrence++;
                                }
                                else
                                {
                                    for(Recorded_Instruments__c recinstrument : owsh.Recorded_Instruments__r)
                                    {
                                        if(recinstrument.Oddities__c != 'Private')
                                        {
                                            occurrence++;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if(occurrence >= 2)
                    {
                        owsh.Senior_Lien_Type__c = 'Typical';
                        break;
                    }
                }
                else
                {
                    owsh.Senior_Lien_Type__c = 'Typical';
                }
            }*/
        }
  
        return owList;
    }
    
    public static List<Opportunity_Worksheet__c> updateSeniorLinesAndTitleCleanOnOW(List<Opportunity_Worksheet__c> owList){
         
        Map<Id,List<Title_Report__c>> titleRportMap = new Map<Id,List<Title_Report__c>>();
        for(Title_Report__c tr : [SELECT id, Senior_Liens__c, Opportunity_Worksheet__c, (Select Id, Type__c From Exception__r), (SELECT Type__c FROM Releases__r) FROM Title_Report__c WHERE Opportunity_Worksheet__c IN: owList])
        {
            if(titleRportMap.containsKey(tr.Opportunity_Worksheet__c))
            {
                titleRportMap.get(tr.Opportunity_Worksheet__c).add(tr);
            }
            else
            {
                titleRportMap.put(tr.Opportunity_Worksheet__c, new List<Title_Report__c>{tr});
            }
        }
        if(owList.size()>0)
        {
            for(Opportunity_Worksheet__c ow : owList)
            { 
                Decimal senioLines = 0;
                String titleClean='Yes';

                if(titleClean == 'Yes')
                {
                    if(titleRportMap.containsKey(ow.Id))
                    {
                        System.debug(' titleRportMap '+ow.Id);
                        List<Title_Report__c> trList = titleRportMap.get(ow.Id);
                        for(Title_Report__c treport : trList)
                        {
                            System.debug(' treport 1 '+treport);
                            senioLines = senioLines + treport.Senior_Liens__c;
                            if(treport.Releases__r != null && treport.Releases__r.size() > 0)
                            {
                                for(Release__c rel : treport.Releases__r)
                                {
                                    System.debug(' treport 1.2 '+rel);
                                    if(rel.Type__c != 'Mortgage' && rel.Type__c != 'Solar' && rel.Type__c != 'Easement' && rel.Type__c != 'HERO/PACE')
                                    {
                                        System.debug(' treport 1.2 in '+rel);
                                        titleClean = 'No';
                                        break;
                                    }
                                }
                            }

                            /*
                            if(treport.Exception__r != null && treport.Exception__r.size() > 0)
                            {
                                System.debug(' treport Exception__r 1.3 '+treport.Exception__r);
                                for(Exception__c excep : ow.Exception__r)
                                {
                                    System.debug(' treport excep 1.4 '+excep);
                                    if(titleClean=='Yes' && excep.Type__c!='Mortgage' && excep.Type__c!='' && excep.Type__c!= 'Hero/Pace')
                                    {
                                        System.debug(' treport excep 1.4 in '+excep);
                                        titleClean='No';
                                        break;
                                    }
                                }
                            }
                            */
                        }
                    }
                }

                /*
                if(titleClean == 'Yes')
                {
                    System.debug(' treport Exception__r 3 ');
                    if(ow.Mortgage_Statements__r != null && ow.Mortgage_Statements__r.size() > 0)
                    {
                        System.debug(' ow.Mortgage_Statements__r 3 '+ ow.Mortgage_Statements__r);
                        for(Mortgage_Statement__c mtgs : ow.Mortgage_Statements__r)
                        {
                            System.debug(' ow.Mortgage_Statements__r 3.1 '+ mtgs);
                            if(mtgs.Has_Default_Foreclosure_Notice__c == 'Yes')
                            {
                                System.debug(' ow.Mortgage_Statements__r 3.1 in '+ mtgs);
                                titleClean = 'No';
                                break;
                            }
                        }
                    }
                }
                */

                if(titleClean == 'Yes')
                {
                    if(ow.Title_Reports__r != null && ow.Title_Reports__r.size() > 0)
                    {
                        for(Title_Report__c treport : ow.Title_Reports__r)
                        {
                            if(treport.Final_Vesting_is_Trust_LLC__c == 'Yes')
                            {
                                titleClean = 'No';
                                break;
                            }
                        }
                    }
                }

                ow.Senior_Liens__c=senioLines;
                ow.Title_Clean__c=titleClean;   
                if(senioLines==0){
                    ow.Investment_Position__c = '1';
                }else if(senioLines==1){
                    ow.Investment_Position__c = '2';
                }else if(senioLines==2){
                    ow.Investment_Position__c = '3';
                } else {
                    ow.Investment_Position__c = null;
                }

                System.debug(' Result : ow.Senior_Liens__c '+ow.Senior_Liens__c);
                System.debug(' Result : ow.Title_Clean__c '+ow.Title_Clean__c);
                System.debug(' Result : ow.Investment_Position__c '+ow.Investment_Position__c);
            }             
        }  
        return owList; 
        
    }
    
    public static List<Opportunity_Worksheet__c> updateSeniorMortgageAmountOnOW(List<Opportunity_Worksheet__c> owList){
          
        if(owList.size()>0){
            for(Opportunity_Worksheet__c ow : owList){ 
                Decimal totalSeniorMortgageAmount =0;
                for(Mortgage_Statement__c mortgage : ow.Mortgage_Statements__r){
                    if(mortgage.Principal_Balance_or_maximum_if_HELOC__c != null && (mortgage.Mortgage_Payoff_Required_or_Requested__c=='No' || String.isBlank(mortgage.Mortgage_Payoff_Required_or_Requested__c))){
                        totalSeniorMortgageAmount+=(mortgage.Principal_Balance_or_maximum_if_HELOC__c+(mortgage.Deferred_Amount__c != null ? mortgage.Deferred_Amount__c : 0.0));
                    }                     
                }
                ow.Senior_Mortgage_Amount__c=totalSeniorMortgageAmount;                
            }            
        }         
        return owList;
        
    }
    
    public static void updateOpportunityWorksheet(List<Opportunity_Worksheet__c> owList){
          
        List<Opportunity_Worksheet__c> owUpdateList = new List<Opportunity_Worksheet__c>();
        if(owList.size()>0){
            
            for(Opportunity_Worksheet__c ow : owList){
                Date ptcGoodTroughDate;
                Boolean ptcGoodTroughDateNA=False;
                Date collectionGoodThroughDate;
                Boolean collectionGoodThroughDateNA=False;
                Date payoffsGoodThrough;
                Boolean payoffsGoodThroughNA=False;
                Decimal totalPayoffs=0;
                Decimal ptcTotal=0;
                Decimal collectionsTotal=0;
                System.debug('ow.Payoffs__r-->'+ow.Payoffs__r);
                for(Payoffs__c payoff : ow.Payoffs__r){                     
                    if(payoff.RecordTypeId==ptcRecordTypeId && payoff.Balance__c!=null){
                        ptcTotal+=payoff.Balance__c;
                    }
                    if(payoff.RecordTypeId==collectionsRecordTypeId  && payoff.Balance__c!=null){
                        collectionsTotal+=payoff.Balance__c;
                    }
                    if(payoff.RecordTypeId==ptcRecordTypeId && payoff.Good_Through_Date__c!=null && ptcGoodTroughDate ==null){
                        ptcGoodTroughDate = payoff.Good_Through_Date__c;
                    }
                    if(payoff.RecordTypeId==ptcRecordTypeId && payoff.Good_Through_Date__c!=null && payoff.Good_Through_Date__c < ptcGoodTroughDate){
                        ptcGoodTroughDate = payoff.Good_Through_Date__c;
                    }
                    if(payoff.RecordTypeId==collectionsRecordTypeId && payoff.Good_Through_Date__c!=null && collectionGoodThroughDate ==null){
                        collectionGoodThroughDate = payoff.Good_Through_Date__c;
                    }
                    if(payoff.RecordTypeId==collectionsRecordTypeId && payoff.Good_Through_Date__c!=null && payoff.Good_Through_Date__c < collectionGoodThroughDate){
                        collectionGoodThroughDate = payoff.Good_Through_Date__c;
                    }
                }

                /*
                for(Paid_Through_Closing__c ptc : ow.Paid_Through_Closings__r){
                    if(ptc.Good_Through_Date__c!=null && ptcGoodTroughDate ==null){
                        ptcGoodTroughDate = ptc.Good_Through_Date__c;
                    }
                    if(ptc.Good_Through_Date__c!=null && ptc.Good_Through_Date__c < ptcGoodTroughDate){
                        ptcGoodTroughDate = ptc.Good_Through_Date__c;
                    }
                     
                }
                */

                if(ptcGoodTroughDate==null){
                    ptcGoodTroughDateNA=True;
                }

                /*
                for(Collection__c collection : ow.Collections__r){
                    if(collection.Good_Through_Date__c!=null && collectionGoodThroughDate ==null){
                        collectionGoodThroughDate = collection.Good_Through_Date__c;
                    }
                    if(collection.Good_Through_Date__c!=null && collection.Good_Through_Date__c < collectionGoodThroughDate){
                        collectionGoodThroughDate = collection.Good_Through_Date__c;
                    }
                }
                */
                if(collectionGoodThroughDate==null){
                    collectionGoodThroughDateNA=True;
                }
                 
                if(ptcGoodTroughDate!=null && collectionGoodThroughDate!=null){
                    payoffsGoodThrough =ptcGoodTroughDate>collectionGoodThroughDate?collectionGoodThroughDate:ptcGoodTroughDate;
                }
                if(payoffsGoodThrough==null){
                    payoffsGoodThroughNA=True;
                }
                
                totalPayoffs=ptcTotal+collectionsTotal;
                
                Opportunity_Worksheet__c owUpdate = new Opportunity_Worksheet__c();
                owUpdate.Id=ow.Id;
                owUpdate.PTC_Good_Through_Date__c=ptcGoodTroughDate;
                owUpdate.PTC_Good_Through_Date_N_A__c=ptcGoodTroughDateNA;
                owUpdate.Collections_Good_Through_Date__c=collectionGoodThroughDate;
                owUpdate.Collections_Good_Through_Date_N_A__c=collectionGoodThroughDateNA;
                owUpdate.Payoffs_Good_Through__c=payoffsGoodThrough;
                owUpdate.Payoffs_Good_Through_N_A__c=payoffsGoodThroughNA;
                owUpdate.Payoffs_Required__c=totalPayoffs;   
                owUpdate.PTC_Total__c=ptcTotal;
                owUpdate.Collections_Total__c=collectionsTotal;
                owUpdateList.add(owUpdate);
            }
            SPR_TriggerUtility.ByPassAllTrigger=True;
            update owUpdateList ;
            SPR_TriggerUtility.ByPassAllTrigger=False;
        }      
        
    }
    @AuraEnabled
    public static String setOpportunityWorksheetData(String recordId){
        System.debug('recordId-->'+recordId);
        Set<String> oppWSIds = new Set<String>{recordId};
        List<Opportunity_Worksheet__c> owList = [Select Id,PTC_Total__c,Collections_Total__c,
                                                   (Select Id, Type__c From Exception__r),
                                                    (Select Id,Good_Through_Date__c From Collections__r),
                                                   (Select Id,Good_Through_Date__c,Balance__c,RecordTypeId From Payoffs__r),
                                                    (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r),
                                                    (Select Id, Deferred_Amount__c, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                                                        Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c
                                                        From Mortgage_Statements__r Where Mortgage_Payoff_Required_or_Requested__c='No')  
                                                     From Opportunity_Worksheet__c Where Id IN:oppWSIds];
        SPR_OpportunityWorksheetUtil.updateOpportunityWorksheet(owList);
        SPR_OpportunityWorksheetUtil.updateSeniorLinesAndTitleCleanOnOW(owList); 
        return 'Success';
    }

    @AuraEnabled
    public static String setOpportunityWorksheetDQHistory(String recordId){
        System.debug('recordId-->'+recordId);
        Set<String> oppWSIds = new Set<String>{recordId};
        List<Opportunity_Worksheet__c> owList = [SELECT Id, (SELECT RecordTypeId, Opportunity_Worksheet__c, Type_Required_Bankruptcy__c, Discharge_Date_Bankruptcy__c, Dismissal_Date_Bankruptcy__c, Extenuating_Circumstances__c FROM DQ_History__r ORDER BY CreatedDate DESC ) FROM Opportunity_Worksheet__c WHERE Id =:recordId];
        
        try 
        {
            if(owList.size() > 0)
            {
                DQHistoryTriggerHandler.beforeInsert(owList[0].DQ_History__r);
            }
        } 
        catch (Exception ex)
        {
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return ex.getMessage()+' '+ex.getStackTraceString();
        }
        
        return 'Success';
    }

    @AuraEnabled
    public static String calculateHybridAppraisal(String recordId)
    {
        List<Opportunity_Worksheet__c> owList = getOppWorksheet(recordId);

        Set<Id> oppList = new Set<Id>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        for(Opportunity_Worksheet__c ow : owList)
        {
            System.debug(' HA ' +ow.Valuations__r);
            if(ow.Valuations__r != null && ow.Valuations__r.size() > 0)
            {
                Date effectiveDate = null;
                List<Decimal> estimatedValueList = new List<Decimal>();
                for(Valuation__c val : ow.Valuations__r)
                {

                    if(val.Effective_Date__c != null && effectiveDate == null)
                    {
                        effectiveDate = val.Effective_Date__c;
                    }

                    if(val.Effective_Date__c != null && val.Effective_Date__c > effectiveDate)
                    {
                        effectiveDate = val.Effective_Date__c;
                    }
                    
                    if(val.Estimated_Value__c != null)
                    {
                        estimatedValueList.add(val.Estimated_Value__c);
                    }
                }

                System.debug(' HA ' +effectiveDate);
                System.debug(' HA ' +average(estimatedValueList));

                ow.Final_Hybrid_Date__c = effectiveDate;
                ow.Final_Hybrid_Value__c = average(estimatedValueList);
                ow.Initial_Appraised_Value_Source__c = 'Hybrid Appraisal';

                if(ow.Opportunity__c !=null && !oppList.contains(ow.Opportunity__c))
                {
                    Opportunity oppty = new Opportunity(Id=ow.Opportunity__c);
                    oppty.Hybrid_Appraisal_Value__c = ow.Final_Hybrid_Value__c;
                    oppty.Initial_Appraised_Value_Source__c = 'Hybrid Appraisal';

                    oppList.add(ow.Opportunity__c);
                    oppListToUpdate.add(oppty);
                }
            }
        }

        try 
        {
            if(owList.size() > 0)
            {
                update owList;
                update oppListToUpdate;
            }
        } 
        catch (Exception ex)
        {
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return ex.getMessage()+' '+ex.getStackTraceString();
        }
        
        return 'Success'; 
    }

    public static Decimal average(List<Decimal> nums) {
        Decimal total = 0.0;
        for (Decimal n : nums) {
            total += n;
        }
        return total / nums.size();
    }
    
    @AuraEnabled
    public static String calculateExceptions(String recordId){
        System.debug('recordId-->'+recordId);
        List<Opportunity_Worksheet__c> owList = getOppWorksheet(recordId);
        
        try 
        {
            if(owList.size() > 0)
            {
                List<Opportunity_Worksheet__c> owListSLT = SPR_OpportunityWorksheetUtil.updateSeniorLinesAndTitleCleanOnOW(owList);
                List<Opportunity_Worksheet__c> owListSMA = SPR_OpportunityWorksheetUtil.updateSeniorMortgageAmountOnOW(owListSLT);
                List<Opportunity_Worksheet__c> owListSLTUpdate = SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owListSMA);
                
                SPR_TriggerUtility.ByPassAllTrigger=True;
                update owListSLTUpdate;
                SPR_TriggerUtility.ByPassAllTrigger=False;
                
                List<Opportunity> oppToUpdate = new List<Opportunity>();
                for(Opportunity_Worksheet__c owsh : owList){
                    if(owsh.Opportunity__c!=null){
                        system.debug('owsh.Opportunity__c'+owsh.Opportunity__c);
                        Mortgage_Statement__c firstMS;
                        Mortgage_Statement__c secondMS;
                        if(owsh.Mortgage_Statements__r != null && owsh.Mortgage_Statements__r.size() > 0){
                            for(Mortgage_Statement__c mtgs : owsh.Mortgage_Statements__r)
                        	{
                                if(firstMS==null){
                                    firstMS= mtgs;
                                    system.debug('firstMS'+firstMS);
                                }else if(secondMS==null){
                                    secondMS=mtgs;
                                }
                            }
                        }
                        System.debug('firstMS-->'+firstMS);
                        System.debug('secondMS-->'+secondMS);
                        Opportunity opp = new Opportunity();
                        if(firstMS!=null){
                            opp.X1st_Mortgage_Statement_Date__c = firstMS.Statement_Date__c;
                            system.debug('firstMS.Statement_Date__c'+firstMS.Statement_Date__c);
                            Decimal pb = 0;
                            if(firstMS.Principal_Balance_or_maximum_if_HELOC__c!=null) pb =firstMS.Principal_Balance_or_maximum_if_HELOC__c;
                            Decimal deff = 0;
                            if(firstMS.Deferred_Amount__c!=null) deff =firstMS.Deferred_Amount__c;
                             system.debug('opp.X1st_Mortgage_Statement_Principal_Balanc__c'+opp.X1st_Mortgage_Statement_Principal_Balanc__c);
                            opp.X1st_Mortgage_Statement_Principal_Balanc__c = pb+deff ;
                        }
                        if(secondMS!=null){
                            opp.X2nd_Mortgage_Statement_Date__c  = secondMS.Statement_Date__c;
                            Decimal pbs = 0;
                            if(secondMS.Principal_Balance_or_maximum_if_HELOC__c!=null) pbs =secondMS.Principal_Balance_or_maximum_if_HELOC__c;
                            Decimal deffs = 0;
                            if(secondMS.Deferred_Amount__c!=null) deffs =secondMS.Deferred_Amount__c;
                             system.debug('opp.X2nd_mortgage_statement_principal_balanc__c'+opp.X2nd_mortgage_statement_principal_balanc__c);
                            opp.X2nd_mortgage_statement_principal_balanc__c = pbs+deffs ;
                        }
                        
                        if(firstMS!=null){
                            opp.Id=owsh.Opportunity__c;
                            oppToUpdate.add(opp);
                        }
                    }
                }
                 system.debug('oppToUpdate'+oppToUpdate);
                if(oppToUpdate.size()>0){
                                   
                    SPR_TriggerUtility.ByPassAllTrigger=True;
                    update oppToUpdate;
                    SPR_TriggerUtility.ByPassAllTrigger=False;				
                }
            }
        } 
        catch (Exception ex)
        {
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return ex.getMessage()+' '+ex.getStackTraceString();
        }
        
        return 'Success';
    }

    private static List<Opportunity_Worksheet__c> getOppWorksheet(String recordId)
    {
        return [Select Id,Prime_Rate__c,Investment_Position__c, Senior_Lien_Type__c, Opportunity__c,
            (Select Id, Type__c From Exception__r),
            (Select Id, Deferred_Amount__c, Principal_Balance_or_maximum_if_HELOC__c, Has_Default_Foreclosure_Notice__c,
                Mortgage_Payoff_Required_or_Requested__c,Interest_Rate__c, Is_Private_Mortgage__c,Statement_Date__c
                From Mortgage_Statements__r Order By Current_Lien_Position__c ASC),
            (SELECT Estimated_Value__c, Effective_Date__c FROM Valuations__r WHERE RecordType.DeveloperName='Hybrid_Appraisal'),                                            
            (SELECT Id, Oddities__c FROM Recorded_Instruments__r),
            (SELECT Id, Final_Vesting_is_Trust_LLC__c, Senior_Liens__c  FROM Title_Reports__r)
        From Opportunity_Worksheet__c Where Id =:recordId];
    }
    /*
    @AuraEnabled
    public static String calculateMortgage(String recordId){
        System.debug('recordId-->'+recordId);
        Set<String> oppWSIds = new Set<String>{recordId};
        
        List<Opportunity_Worksheet__c> owList = [Select Id,
                                                (Select Id, Principal_Balance_or_maximum_if_HELOC__c,
                                                Mortgage_Payoff_Required_or_Requested__c From Mortgage_Statements__r) 
                                                From Opportunity_Worksheet__c Where Id IN:oppWSIds];
        
        
         
        try 
        {
            if(owList.size() > 0)
            {
                SPR_OpportunityWorksheetUtil.updateSeniorMortgageAmountOnOW(owList);
            }
        } 
        catch (Exception ex)
        {
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return ex.getMessage()+' '+ex.getStackTraceString();
        }
        
        return 'Success';
    }
    
    @AuraEnabled
    public static String calculateSLType(String recordId){
        System.debug('calculateSLType recordId-->'+recordId);
        Set<String> oppWSIds = new Set<String>{recordId};
        
        List<Opportunity_Worksheet__c> owList = [Select Id,Investment_Position__c, Prime_Rate__c, 
                                                (Select Id, Interest_Rate__c, Is_Private_Mortgage__c From Mortgage_Statements__r 
                                                 Where Mortgage_Payoff_Required_or_Requested__c='No' ),
                                                (SELECT Id, Oddities__c FROM Recorded_Instruments__r)
                                                From Opportunity_Worksheet__c Where Id IN:oppWSIds];
        
        
         
        try 
        {
            if(owList.size() > 0)
            {
                SPR_OpportunityWorksheetUtil.calculateSeniorLienType(owList);
            }
        } 
        catch (Exception ex)
        {
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return ex.getMessage()+' '+ex.getStackTraceString();
        }
        
        return 'Success';
    }
  */
}