public class ConsumerCalculatorTriggerHandler {
    
    private static Map<String, Map<String, Decimal>> fieldToMinMaxValues = new  Map<String, Map<String, Decimal>>();
    private static Map<String, Map<String, Decimal>> fieldToMinMaxCheckValues = new  Map<String, Map<String, Decimal>>();
    private static List<Consumer_Price_Config__c> categoryRecords;
    private static Map<String, Object> promoValues = new  Map<String, Object>();
    
    static{
        fieldToMinMaxValues.put('Multiple',new Map<String, Decimal>{} ); 
        fieldToMinMaxValues.put('Starting Point',new Map<String, Decimal>{} );
        fieldToMinMaxValues.put('Cap',new Map<String, Decimal>{} );
        fieldToMinMaxValues.put('Origination Fee',new Map<String, Decimal>{} );
        fieldToMinMaxValues.put('OLTV',new Map<String, Decimal>{} );
        fieldToMinMaxValues.get('Multiple').put('Min', 2.5);
        fieldToMinMaxValues.get('Multiple').put('Max', 3.5);
        fieldToMinMaxValues.get('Starting Point').put('Min', 80.0);
        fieldToMinMaxValues.get('Starting Point').put('Max', 83.0);
        fieldToMinMaxValues.get('Cap').put('Min', 13.99);
        fieldToMinMaxValues.get('Cap').put('Max', 17.99);
        fieldToMinMaxValues.get('Origination Fee').put('Min', 1.99);
        fieldToMinMaxValues.get('Origination Fee').put('Max',1.99);
        fieldToMinMaxValues.get('OLTV').put('Min', 55); 
        fieldToMinMaxValues.get('OLTV').put('Max', 80);

        fieldToMinMaxCheckValues.put('Multiple',new Map<String, Decimal>{} ); 
        fieldToMinMaxCheckValues.put('Starting Point',new Map<String, Decimal>{} );
        fieldToMinMaxCheckValues.put('Cap',new Map<String, Decimal>{} );
        fieldToMinMaxCheckValues.put('Origination Fee',new Map<String, Decimal>{} );
        fieldToMinMaxCheckValues.put('OLTV',new Map<String, Decimal>{} );
        fieldToMinMaxCheckValues.get('Multiple').put('Min', 2.5);
        fieldToMinMaxCheckValues.get('Multiple').put('Max', 3.5);
        fieldToMinMaxCheckValues.get('Starting Point').put('Min', 80.0);
        fieldToMinMaxCheckValues.get('Starting Point').put('Max', 83.0);
        fieldToMinMaxCheckValues.get('Cap').put('Min', 13.99);
        fieldToMinMaxCheckValues.get('Cap').put('Max', 17.99);
        fieldToMinMaxCheckValues.get('Origination Fee').put('Min', 1.99);
        fieldToMinMaxCheckValues.get('Origination Fee').put('Max', 2.99);
        fieldToMinMaxCheckValues.get('OLTV').put('Min', 55); 
        fieldToMinMaxCheckValues.get('OLTV').put('Max', 80);
        
        promoValues.put('FICO', 680);
        promoValues.put('Occupancy Status', 'OO');
        promoValues.put('Property Value', 3000000);
        promoValues.put('AVM Confidence', 90);
        promoValues.put('FC', FALSE);
        promoValues.put('BK', FALSE);
        promoValues.put('Lien Position1', '1');
        promoValues.put('Lien Position', '2');
        promoValues.put('Property Type', 'SFR');
        promoValues.put('Title Clean', TRUE);
        promoValues.put('Senior Lien Type', 'Typical');
        promoValues.put('OLTV', 70.00);
        promoValues.put('Check Size', 250000);
        
        categoryRecords = [SELECT Id, Category__c, Multiple__c, Starting_Point__c, Cap__c, 
                           Origination_Fee__c, Max_OLTV__c,Start_Range__c, End_Range__c, Variable__c,
                           Currency__c // v7
                           FROM Consumer_Price_Config__c
                          ];
        
    }
    
    public static void beforeUpdate(List<Consumer_Calculator__c> newRecords, Map<Id,Consumer_Calculator__c> oldMap){
        Map<String, List<Consumer_Price_Config__c>> config = associateCalculatorVersion(newRecords,oldMap);
        for(Consumer_Calculator__c cc: newRecords){
            if(cc.Migration_Override__c != true) {
                if((cc.Lot_Size__c != oldMap.get(cc.id).Lot_Size__c) ||
                ( cc.Property_Value__c != oldMap.get(cc.id).Property_Value__c)||
                /* (cc.AVM_Confidence__c != oldMap.get(cc.id).AVM_Confidence__c) ||*/
                (cc.FICO__c != oldMap.get(cc.id).FICO__c) ||
                ( cc.Occupancy_Status__c != oldMap.get(cc.id).Occupancy_Status__c) ||
                (cc.Property_Type__c != oldMap.get(cc.id).Property_Type__c) ||
                (cc.Title_Clean__c != oldMap.get(cc.id).Title_Clean__c) ||
                ( cc.Senior_Lien_Type__c != oldMap.get(cc.id).Senior_Lien_Type__c) ||
                (cc.Lien_Position__c != oldMap.get(cc.id).Lien_Position__c) ||
                ( cc.FC_Time_Since__c != oldMap.get(cc.id).FC_Time_Since__c) ||
                (cc.BK_Time_Since__c != oldMap.get(cc.id).BK_Time_Since__c) ||
                (cc.AAR_Required__c != oldMap.get(cc.id).AAR_Required__c) ||
                (cc.Payoffs_Required__c != oldMap.get(cc.id).Payoffs_Required__c) ||
                (cc.Radian_Score__c != oldMap.get(cc.id).Radian_Score__c) ||
                (cc.Radian_Value__c != oldMap.get(cc.id).Radian_Value__c) ||
                (cc.Veros_Score__c != oldMap.get(cc.id).Veros_Score__c) ||
                (cc.Veros_Value__c != oldMap.get(cc.id).Veros_Value__c) ||
                (cc.Clear_Capital_Score__c != oldMap.get(cc.id).Clear_Capital_Score__c) ||
                (cc.Clear_Capital_Value__c != oldMap.get(cc.id).Clear_Capital_Value__c) ||
                cc.Opportunity__c != null || true ){
                    handleBeforeInsertUpdate(cc,config.get(cc.Version__c));
                }
            }
        }
    }
    
    public static void beforeInsert(List<Consumer_Calculator__c> newRecords){
        Map<String, List<Consumer_Price_Config__c>> config = associateCalculatorVersion(newRecords,null);
        for(Consumer_Calculator__c cc: newRecords){
            if(cc.Migration_Override__c != true) {
                handleBeforeInsertUpdate(cc,config.get(cc.Version__c));
            }
        }
        
    }
    
    public static void handleBeforeInsertUpdate(Consumer_Calculator__c cc, List<Consumer_Price_Config__c> priceConfig){
        
        if(cc != null){
            if(priceConfig != null)
            {
                categoryRecords = priceConfig;
                System.debug(' Category Record: '+categoryRecords);
            }
            Decimal homeOwnerFixConstant = cc.Property_Value__c; // D8  v6.1 Appraised Value
            
            if(homeOwnerFixConstant != null && (homeOwnerFixConstant < 150000 || homeOwnerFixConstant > 5000000))
            {
                homeOwnerFixConstant = 0;
            }
            
            Map<String, Map<String, Decimal>> categoryToFieldValue = new  Map<String, Map<String, Decimal>>();
            //Decimal propertyValue = cc.Property_Value__c!=null ? cc.Property_Value__c/1000000 : 0;//math.round(cc.Property_Value__c/1000000);
            //system.debug('propertyValue '+propertyValue);
            system.debug('categoryRecords size '+categoryRecords.size());
            Map<String, Consumer_Price_Config__c> valToData = new  Map<String, Consumer_Price_Config__c>();
            
            // -------------- new changes ---------------
            Decimal radian_Confidence = cc.radian_Score__c > 90 ? cc.radian_Value__c : 0 ;
            Decimal veros_Confidence = cc.veros_Score__c > 90 ? cc.veros_Value__c : 0 ;
            Decimal clearCapital_Confidence = cc.clear_Capital_Score__c > 90 ? cc.Clear_Capital_Value__c : 0 ;
            
            Integer med_count = 0;
            med_count = radian_Confidence != 0 ? med_count + 1 : med_count;
            med_count = veros_Confidence != 0 ? med_count + 1 : med_count;
            med_count = clearCapital_Confidence != 0 ? med_count + 1 : med_count;
            system.debug('med_count '+med_count);
            Decimal confidence_Median = med_count != 0 ? (radian_Confidence + veros_Confidence + clearCapital_Confidence)/med_count : 0;
            
            Decimal radian_Variance = confidence_Median != 0 ? ((confidence_Median - radian_Confidence)/confidence_Median) < 0.1 ? radian_Confidence : 0 : 0;
            Decimal veros_Variance = confidence_Median != 0 ? ((confidence_Median - veros_Confidence)/confidence_Median) < 0.1 ? veros_Confidence : 0 : 0;
            Decimal clearCapital_Variance = confidence_Median != 0 ? ((confidence_Median - clearCapital_Confidence)/confidence_Median) < 0.1 ? 
                clearCapital_Confidence : 0 : 0;
            
            Decimal radian_Score = radian_Variance > 0 ? cc.radian_Score__c : 0;
            Decimal veros_Score = veros_Variance > 0 ? cc.veros_Score__c : 0;
            Decimal clearCapital_Score = clearCapital_Variance > 0 ? cc.clear_Capital_Score__c : 0;
            Decimal totalAVM = (cc.radian_Score__c != null ? cc.radian_Score__c : 0) +
                (cc.veros_Score__c != null ? cc.veros_Score__c : 0) +
                (cc.radian_Score__c != null ? cc.radian_Score__c : 0) ;
            
            String final_Variance = med_count >= 2 ? String.valueOf(((radian_Variance + veros_Variance + clearCapital_Variance)/med_count).round(System.RoundingMode.HALF_UP))
                : 'Order AAR';
            Decimal scoreValue = final_Variance.isNumeric() ? (radian_Score + veros_Score + clearCapital_Score)/med_count : 0;
            String final_Score = final_Variance.isNumeric() ? String.valueOf(((radian_Score + veros_Score + clearCapital_Score)/med_count).round(System.RoundingMode.HALF_UP))
                : 'N/A';
            if(final_Variance.isNumeric()){
                cc.AVM_Final_Value__c = Decimal.valueOf(final_Variance);
                cc.AVM_Final_Result__c = '';
            }else if(totalAVM != 0 && !final_Variance.isNumeric()){
                cc.AVM_Final_Result__c = final_Variance;
                cc.AVM_Final_Value__c = null;
            }
            
            system.debug('final_Variance '+final_Variance);
            system.debug('final_Score '+scoreValue);
            
            /* Before 6.1 Decimal inter_propertyValue =  final_Variance.isNumeric() ? Decimal.valueOf(final_Variance) 
            : cc.Property_Value__c != null ? cc.Property_Value__c : 0 ; */
            
            Decimal inter_propertyValue = homeOwnerFixConstant == null ? 0 : homeOwnerFixConstant; // v 6.1
            
            System.debug(' inter_propertyValue final_Variance '+final_Variance);
            System.debug(' inter_propertyValue cc.Property_Value__c '+cc.Property_Value__c);
            System.debug(' inter_propertyValue '+inter_propertyValue);
            
            /* Before 6.2 Decimal inter_propertyScore =  cc.AAR_Required__c ? 90 :
            final_Score.isNumeric() ? scoreValue : 90 ;
            */
            
            // V6.3
            Decimal inter_propertyScore =  cc.AAR_Required__c ? 90 : cc.AVM_Confidence__c != null ? cc.AVM_Confidence__c : 90;
            cc.AVM_Confidence__c = inter_propertyScore;
            
            system.debug('inter_propertyValue '+inter_propertyValue);
            system.debug('inter_propertyScore '+inter_propertyScore);
            
            Decimal lotSize_Integer = (cc.Lot_Size__c != null ? cc.Lot_Size__c : 0)*43560;
            Decimal fico = cc.FICO__c != null ? cc.FICO__c : 0;
            // -------------- new changes end ---------------
            
            for( Consumer_Price_Config__c cp: categoryRecords){
                Boolean valueExist = false;
                System.debug(' IP '+cp.Category__c);
                if(cp.Category__c != 'Intermediate Pricing Max HO' && cp.Category__c != 'Intermediate Pricing Min HO' && cp.Category__c != 'Intermediate Pricing Min MX' && cp.Category__c != 'Intermediate Pricing Max MX') {
                    System.debug(' IP IN '+cp.Category__c);
                    if(cp.Start_Range__c != null){
                        if((inter_propertyValue != null && inter_propertyValue > cp.Start_Range__c && 
                            (cp.End_Range__c == null || (cp.End_Range__c != null && inter_propertyValue <= cp.End_Range__c)) && 
                            cp.Category__c== 'Property Value (M)') ||
                        (fico != null && fico >= cp.Start_Range__c &&  
                            (cp.End_Range__c == null || (cp.End_Range__c != null && fico < cp.End_Range__c))
                            &&  cp.Category__c == 'FICO'  && cp.Currency__c == null) ||
                        (fico != null && fico >= cp.Start_Range__c &&  
                            (cp.End_Range__c == null || (cp.End_Range__c != null && fico < cp.End_Range__c))
                            &&  cp.Category__c == 'FICO/Lien Position' && cp.Currency__c != null && cp.Variable__c == cc.Lien_Position__c) ||
                        (inter_propertyScore != null && inter_propertyScore >= cp.Start_Range__c && 
                            (cp.End_Range__c == null || (cp.End_Range__c != null && inter_propertyScore < cp.End_Range__c)) && 
                            cp.Category__c=='AVM Conf.')){
                                System.debug('---> '+cp.Category__c);
                                valueExist = true;
                            }
                        
                    }else if(cp.Variable__c != null && cp.Category__c != 'FICO/Lien Position'){
                        system.debug('finally--- '+cp.Category__c+' lein '+String.valueOf(cc.Lien_Position__c));
                        if((cc.Occupancy_Status__c != null && cp.Category__c == 'Occupancy' && cp.Variable__c.toLowerCase() == cc.Occupancy_Status__c.toLowerCase()) ||
                        (cc.Property_Type__c != null && cp.Category__c == 'Property Type' &&  cp.Variable__c.toLowerCase() == cc.Property_Type__c.toLowerCase()) ||
                        (cc.Title_Clean__c != null && cp.Category__c == 'Title' && Boolean.valueof(cp.Variable__c) == cc.Title_Clean__c) ||
                        (cc.Senior_Lien_Type__c != null && cp.Category__c == 'Senior Lein' && cp.Variable__c.toLowerCase() == cc.Senior_Lien_Type__c.toLowerCase()) ||
                        (cc.Lien_Position__c != null && cp.Category__c == 'Lein Position' && cp.Variable__c == cc.Lien_Position__c) ||
                        (cc.FC_Time_Since__c != null && cp.Category__c == 'FC' &&  Boolean.valueof(cp.Variable__c) == cc.FC_Time_Since__c) || 
                        (cc.BK_Time_Since__c != null && cp.Category__c == 'BK' && Boolean.valueof(cp.Variable__c) == cc.BK_Time_Since__c)){
                            valueExist = true;
                        }
                    }
                    
                    if(valueExist || cp.Category__c=='OLTV' || cp.Category__c=='Check Size (K)'){
                        if( cp.Category__c=='AVM Conf.') system.debug('cp.Cap__c '+cp.Cap__c);
                        Map<String, Decimal> fieldToValue = new Map<String, Decimal>();
                        fieldToValue.put('Multiple',cp.Multiple__c);
                        fieldToValue.put('Starting Point',cp.Starting_Point__c);
                        fieldToValue.put('Cap',cp.Cap__c);
                        fieldToValue.put('Origination Fee',cp.Origination_Fee__c);
                        fieldToValue.put('OLTV',cp.Max_OLTV__c);
                        fieldToValue.put('FICO/Lien Position',cp.Currency__c);
                        
                        system.debug(' ##= fieldToValue '+fieldToValue);
                        if(cp.Category__c=='OLTV'){
                            categoryToFieldValue.put(cp.Category__c+'_'+cp.Start_Range__c+'-'+cp.End_Range__c, fieldToValue);
                            
                        }else if(cp.Category__c=='Check Size (K)'){
                            categoryToFieldValue.put(cp.Category__c+'_'+Integer.valueOf(cp.Start_Range__c), fieldToValue);
                            
                        }else{
                            
                            system.debug(' fieldToValue '+fieldToValue+' cp.Category__c '+cp.Category__c);
                            categoryToFieldValue.put(cp.Category__c, fieldToValue);
                        }
                    }
                } else if(cp.Category__c == 'Intermediate Pricing Max HO') {
                    System.debug(' IP '+'Intermediate Pricing Max HO');
                    fieldToMinMaxValues.get('Multiple').put('Max', cp.Multiple__c);
                    fieldToMinMaxValues.get('Starting Point').put('Max', cp.Starting_Point__c);
                    fieldToMinMaxValues.get('Cap').put('Max', cp.Cap__c);
                    fieldToMinMaxValues.get('Origination Fee').put('Max', cp.Origination_Fee__c);
                    fieldToMinMaxValues.get('OLTV').put('Max', cp.Max_OLTV__c);
                } else if(cp.Category__c == 'Intermediate Pricing Min HO') {
                    System.debug(' IP '+'Intermediate Pricing Min HO');
                    fieldToMinMaxValues.get('Multiple').put('Min',  cp.Multiple__c);
                    fieldToMinMaxValues.get('Starting Point').put('Min', cp.Starting_Point__c);
                    fieldToMinMaxValues.get('Cap').put('Min',  cp.Cap__c);
                    fieldToMinMaxValues.get('Origination Fee').put('Min', cp.Origination_Fee__c);
                    fieldToMinMaxValues.get('OLTV').put('Min', cp.Max_OLTV__c); 
                } else if(cp.Category__c == 'Intermediate Pricing Max MX') {
                    System.debug(' IP '+'Intermediate Pricing Max MX');
                    fieldToMinMaxCheckValues.get('Multiple').put('Max', cp.Multiple__c);
                    fieldToMinMaxCheckValues.get('Starting Point').put('Max', cp.Starting_Point__c);
                    fieldToMinMaxCheckValues.get('Cap').put('Max', cp.Cap__c);
                    fieldToMinMaxCheckValues.get('Origination Fee').put('Max', cp.Origination_Fee__c);
                    fieldToMinMaxCheckValues.get('OLTV').put('Max', cp.Max_OLTV__c);
                } else if(cp.Category__c == 'Intermediate Pricing Min MX') {
                    System.debug(' IP '+'Intermediate Pricing Min MX');
                    fieldToMinMaxCheckValues.get('Multiple').put('Min',  cp.Multiple__c);
                    fieldToMinMaxCheckValues.get('Starting Point').put('Min', cp.Starting_Point__c);
                    fieldToMinMaxCheckValues.get('Cap').put('Min',  cp.Cap__c);
                    fieldToMinMaxCheckValues.get('Origination Fee').put('Min', cp.Origination_Fee__c);
                    fieldToMinMaxCheckValues.get('OLTV').put('Min', cp.Max_OLTV__c); 
                }
            }
            
            Decimal finalPricing_Multiple_HORequested = 0;
            Decimal finalPricing_StartingPoint_HORequested = 0;
            Decimal finalPricing_Cap_HORequested = 0;
            Decimal finalPricing_OriginationFee_HORequested = 0;
            Decimal finalPricing_OLTV_HORequested = 0;
            
            Decimal finalPricing_Multiple_Maximum = 0;
            Decimal finalPricing_StartingPoint_Maximum = 0;
            Decimal finalPricing_Cap_Maximum = 0;
            Decimal finalPricing_OriginationFee_Maximum = 0;
            Decimal finalPricing_OLTV_Maximum = 0;
            Decimal min_OLTV=0;
            Integer count = 0;
            
            cc.FICO_Lien_Position_Max_Check_Size__c = null;
            cc.FICO_Lien_Position_HO_Requested__c = null;
            Map<String, Map<String, Decimal>> OLTVToFieldValue = new  Map<String, Map<String, Decimal>>();
            
            for(String category: categoryToFieldValue.keySet()){
                
                system.debug('##=  categoryToFieldValue.get(category) '+categoryToFieldValue.get(category));
                system.debug('##=  FICO_Lien_Position_Max_Check_Size__c '+cc.FICO_Lien_Position_Max_Check_Size__c);
                system.debug('##=  FICO_Lien_Position_HO_Requested__c '+cc.FICO_Lien_Position_HO_Requested__c);
                if(category.startsWith('OLTV')){
                    OLTVToFieldValue.put(category.split('_')[1], categoryToFieldValue.get(category));
                    
                } else if(category == 'FICO/Lien Position') {
                    cc.FICO_Lien_Position_Max_Check_Size__c = categoryToFieldValue.get(category).get('FICO/Lien Position');
                    cc.FICO_Lien_Position_HO_Requested__c = categoryToFieldValue.get(category).get('FICO/Lien Position');
                    system.debug('##=  FICO_Lien_Position_Max_Check_Size__c IN '+cc.FICO_Lien_Position_Max_Check_Size__c);
                    system.debug('##=  FICO_Lien_Position_HO_Requested__c IN '+cc.FICO_Lien_Position_HO_Requested__c);
                } else if(!category.startsWith('Check Size (K)')){
                    count += categoryToFieldValue.get(category).size() - 1;
                    system.debug('inside count @@ '+category+' ## '+count);
                    finalPricing_Multiple_HORequested += categoryToFieldValue.get(category).get('Multiple');
                    finalPricing_StartingPoint_HORequested += categoryToFieldValue.get(category).get('Starting Point');
                    finalPricing_Cap_HORequested += categoryToFieldValue.get(category).get('Cap');
                    finalPricing_OriginationFee_HORequested += categoryToFieldValue.get(category).get('Origination Fee');
                    //finalPricing_OLTV_HORequested += categoryToFieldValue.get(category).get('Origination Fee');
                    system.debug('##=  finalPricing_OriginationFee_HORequested 0 '+finalPricing_OriginationFee_HORequested);
                    system.debug('##=  finalPricing_StartingPoint_HORequested 0 '+finalPricing_StartingPoint_HORequested);
                    
                    finalPricing_Multiple_Maximum += categoryToFieldValue.get(category).get('Multiple');
                    finalPricing_StartingPoint_Maximum += categoryToFieldValue.get(category).get('Starting Point');
                    finalPricing_Cap_Maximum += categoryToFieldValue.get(category).get('Cap');
                    finalPricing_OriginationFee_Maximum += categoryToFieldValue.get(category).get('Origination Fee');
                    //finalPricing_OLTV_Maximum += categoryToFieldValue.get(category).get('Origination Fee');
                    
                    if(min_OLTV == null){
                        min_OLTV = categoryToFieldValue.get(category).get('OLTV');
                    }else{
                        system.debug('@@@@@@min_OLTV '+min_OLTV);
                        system.debug('@@@@@@min_OLTV new## '+categoryToFieldValue.get(category).get('OLTV'));
                        min_OLTV = min_OLTV < categoryToFieldValue.get(category).get('OLTV') ? min_OLTV : categoryToFieldValue.get(category).get('OLTV');
                    }
                }
            }
            
            //count +=10; 
            count += lotSize_Integer < 120 || lotSize_Integer > 217800 ? 0 : 5;
            system.debug('count@## '+count);
            system.debug('min_OLTV '+min_OLTV);
            system.debug('vallll@@@@@@@ '+fieldToMinMaxValues.get('OLTV').get('Max'));
            Decimal intermediatePricing_Multiple = math.max(math.min(finalPricing_Multiple_HORequested, fieldToMinMaxValues.get('Multiple').get('Max')), fieldToMinMaxValues.get('Multiple').get('Min'));
            Decimal intermediatePricing_OLTV = math.max(math.min((min_OLTV + fieldToMinMaxValues.get('OLTV').get('Max')), fieldToMinMaxValues.get('OLTV').get('Max')), fieldToMinMaxValues.get('OLTV').get('Min'));
            // Decimal property_Value = cc.Property_Value__c != null ? cc.Property_Value__c : 0;
            Decimal senior_Mortgage = cc.Senior_Mortgage__c != null ? cc.Senior_Mortgage__c : 0;
            Decimal hoRequested = cc.HO_Requested__c != null ? cc.HO_Requested__c : 0;
            
            system.debug('##= senior_Mortgage '+senior_Mortgage);
            system.debug('##= intermediatePricing_OLTV '+intermediatePricing_OLTV);
            system.debug('##= min_OLTV '+min_OLTV);
            system.debug('##= intermediatePricing_Multiple '+intermediatePricing_Multiple);
            system.debug('##= fieldToMinMaxValues '+fieldToMinMaxValues);
            system.debug('##= fieldToMinMaxValues '+homeOwnerFixConstant);
            
            
            Decimal min_Equity = (homeOwnerFixConstant - senior_Mortgage - 25000); // v6.1 replaced inter_propertyValue with homeOwnerFixConstant
            Decimal maximum_Upside = homeOwnerFixConstant != 0 ? (0.7/(intermediatePricing_Multiple))*homeOwnerFixConstant : 0;// round of till 3 
            system.debug('@@@maximum_Upside '+maximum_Upside);
            // maximum_Upside = maximum_Upside.setScale(-3, roundingMode.DOWN); in version 6.1 this round down is not needed.
            Decimal OLTV = ((intermediatePricing_OLTV/100)*homeOwnerFixConstant) - senior_Mortgage; // v6.1 replaced with homeOwnerFixConstant
            Decimal[] myList_HORequested = new List<Decimal> {min_Equity, maximum_Upside, OLTV, 350000};
                if(hoRequested != null && hoRequested > 0) {
                    myList_HORequested.add(hoRequested);
                }
            // v7.0
            if(cc.FICO_Lien_Position_HO_Requested__c != null) {
                myList_HORequested.add(cc.FICO_Lien_Position_HO_Requested__c);
            }
            myList_HORequested.sort();
            Decimal checkSize_HORequested = myList_HORequested[0] < 20000 ? 0 : myList_HORequested[0];
            system.debug('##= checkSize_HORequested '+checkSize_HORequested);
            Decimal[] myList = new List<Decimal> {min_Equity, maximum_Upside, OLTV, 500000};
                
                // v7.0
                if(cc.FICO_Lien_Position_Max_Check_Size__c != null) {
                    myList.add(cc.FICO_Lien_Position_Max_Check_Size__c);
                }
            myList.sort();
            
            Decimal minimumOfCheckSizeMax = myList[0] > hoRequested && hoRequested > 0 ? hoRequested : myList[0]; // v7
            
            Decimal checkSize_Maximum = minimumOfCheckSizeMax < 20000 ? 0 : myList[0]; // v6.2 v7
            
            //Decimal checkSize_Maximum = myList_HORequested[0] < 20000 ? 0 : myList_HORequested[0]; // v6.3
            system.debug('##= checkSize_Maximum '+checkSize_Maximum);
            Decimal OLTV_HORequested = inter_propertyValue != 0 ? (senior_Mortgage + checkSize_HORequested)/inter_propertyValue : 0;
            Decimal OLTV_Maximum = inter_propertyValue != 0 ? (senior_Mortgage + checkSize_Maximum)/inter_propertyValue : 0;
            cc.Maximum_Upside__c = maximum_Upside;
            cc.Min_Equity__c = min_Equity;
            cc.OLTV__c = OLTV;
            
            System.debug(' --> Maximum_Upside__c '+cc.Maximum_Upside__c);
            System.debug(' --> Min_Equity__c '+cc.Min_Equity__c);
            System.debug(' --> OLTV__c '+cc.OLTV__c);
            
            cc.Check_Size__c = checkSize_HORequested;//use this in promo
            system.debug('finalPricing_Multiple_HORequested '+finalPricing_Multiple_HORequested);
            if(OLTV_HORequested <= (fieldToMinMaxValues.get('OLTV').get('Max')/100) ){
                for(String key: OLTVToFieldValue.keySet()){
                    if(OLTV_HORequested <= (fieldToMinMaxValues.get('OLTV').get('Max')/100) && 
                       OLTV_HORequested*100 > Decimal.valueOf(key.split('-')[0]) &&
                       OLTV_HORequested*100 <= Decimal.valueOf(key.split('-')[1])){
                           system.debug('key@@ '+key);
                           system.debug('key---val@@ '+OLTVToFieldValue.get(key));
                           finalPricing_Multiple_HORequested += OLTVToFieldValue.get(key).get('Multiple');
                           finalPricing_StartingPoint_HORequested += OLTVToFieldValue.get(key).get('Starting Point');
                           system.debug('##=  finalPricing_StartingPoint_HORequested 1 '+finalPricing_StartingPoint_HORequested);
                           finalPricing_Cap_HORequested += OLTVToFieldValue.get(key).get('Cap');
                           finalPricing_OriginationFee_HORequested += OLTVToFieldValue.get(key).get('Origination Fee');
                           finalPricing_OLTV_HORequested +=  OLTVToFieldValue.get(key).get('OLTV');
                           break;
                       }
                    
                }
            }
            system.debug('finalPricing_Multiple_HORequested1111 '+finalPricing_Multiple_HORequested);
            system.debug('##=  finalPricing_OriginationFee_HORequested '+finalPricing_OriginationFee_HORequested);
            if(OLTV_Maximum <= (fieldToMinMaxCheckValues.get('OLTV').get('Max')/100)){
                for(String key: OLTVToFieldValue.keySet()){
                    
                    if(OLTV_Maximum <= (fieldToMinMaxCheckValues.get('OLTV').get('Max')/100) && 
                       OLTV_Maximum*100 > Decimal.valueOf(key.split('-')[0]) &&
                       OLTV_Maximum*100 <= Decimal.valueOf(key.split('-')[1])){
                           system.debug('key@@ '+key);
                           system.debug('key---val@@ '+OLTVToFieldValue.get(key));
                           finalPricing_Multiple_Maximum += OLTVToFieldValue.get(key).get('Multiple');
                           finalPricing_StartingPoint_Maximum += OLTVToFieldValue.get(key).get('Starting Point');
                           finalPricing_Cap_Maximum += OLTVToFieldValue.get(key).get('Cap');
                           finalPricing_OriginationFee_Maximum += OLTVToFieldValue.get(key).get('Origination Fee');
                           finalPricing_OLTV_Maximum +=  OLTVToFieldValue.get(key).get('OLTV');
                           break;
                       }
                }
            }
            Decimal val_CheckSize = 350*1000;
            finalPricing_Multiple_Maximum +=  checkSize_Maximum <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Multiple') : categoryToFieldValue.get('Check Size (K)_350').get('Multiple');
            finalPricing_StartingPoint_Maximum += checkSize_Maximum <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Starting Point') : categoryToFieldValue.get('Check Size (K)_350').get('Starting Point');
            finalPricing_Cap_Maximum += checkSize_Maximum <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Cap') : categoryToFieldValue.get('Check Size (K)_350').get('Cap');
            finalPricing_OriginationFee_Maximum +=checkSize_Maximum <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Origination Fee') : categoryToFieldValue.get('Check Size (K)_350').get('Origination Fee');
            finalPricing_OLTV_Maximum += checkSize_Maximum <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('OLTV') : categoryToFieldValue.get('Check Size (K)_350').get('OLTV');
            
            finalPricing_Multiple_HORequested +=  checkSize_HORequested <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Multiple') : categoryToFieldValue.get('Check Size (K)_350').get('Multiple');
            finalPricing_StartingPoint_HORequested += checkSize_HORequested <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Starting Point') : categoryToFieldValue.get('Check Size (K)_350').get('Starting Point');
            finalPricing_Cap_HORequested += checkSize_HORequested <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Cap') : categoryToFieldValue.get('Check Size (K)_350').get('Cap');
            finalPricing_OriginationFee_HORequested +=checkSize_HORequested <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('Origination Fee') : categoryToFieldValue.get('Check Size (K)_350').get('Origination Fee');
            finalPricing_OLTV_HORequested += checkSize_HORequested <= val_CheckSize ? categoryToFieldValue.get('Check Size (K)_0').get('OLTV') : categoryToFieldValue.get('Check Size (K)_350').get('OLTV');
            system.debug('finalPricing_Multiple_HORequested2222 '+finalPricing_Multiple_HORequested);
            
            system.debug('##=  finalPricing_OriginationFee_HORequested 2 '+finalPricing_OriginationFee_HORequested);
            system.debug('##=  finalPricing_StartingPoint_HORequested 2 '+finalPricing_StartingPoint_HORequested);
            //Decimal finalPricing_MaxCheck = count< 55 ? 0: check_Size_Maximum;
            finalPricing_Multiple_HORequested = math.max(math.min(finalPricing_Multiple_HORequested, fieldToMinMaxValues.get('Multiple').get('Max')), fieldToMinMaxValues.get('Multiple').get('Min'));
            finalPricing_StartingPoint_HORequested = math.max(math.min(finalPricing_StartingPoint_HORequested, fieldToMinMaxValues.get('Starting Point').get('Max')), fieldToMinMaxValues.get('Starting Point').get('Min'));
            finalPricing_Cap_HORequested = math.max(math.min(finalPricing_Cap_HORequested, fieldToMinMaxValues.get('Cap').get('Max')), fieldToMinMaxValues.get('Cap').get('Min'));
            finalPricing_OriginationFee_HORequested = math.max(math.min(finalPricing_OriginationFee_HORequested, fieldToMinMaxValues.get('Origination Fee').get('Max')), fieldToMinMaxValues.get('Origination Fee').get('Min'));
            finalPricing_OLTV_HORequested = math.max(math.min(finalPricing_OLTV_HORequested, fieldToMinMaxValues.get('OLTV').get('Max')), fieldToMinMaxValues.get('OLTV').get('Min'));
            
            system.debug('##=  finalPricing_OriginationFee_HORequested 3 '+finalPricing_OriginationFee_HORequested); 
            system.debug('##=  finalPricing_StartingPoint_HORequested 3 '+finalPricing_StartingPoint_HORequested);
            finalPricing_Multiple_Maximum = math.max(math.min(finalPricing_Multiple_Maximum, fieldToMinMaxCheckValues.get('Multiple').get('Max')), fieldToMinMaxCheckValues.get('Multiple').get('Min'));
            finalPricing_StartingPoint_Maximum = math.max(math.min(finalPricing_StartingPoint_Maximum, fieldToMinMaxCheckValues.get('Starting Point').get('Max')), fieldToMinMaxCheckValues.get('Starting Point').get('Min'));
            finalPricing_Cap_Maximum = math.max(math.min(finalPricing_Cap_Maximum, fieldToMinMaxCheckValues.get('Cap').get('Max')), fieldToMinMaxCheckValues.get('Cap').get('Min'));
            finalPricing_OriginationFee_Maximum = math.max(math.min(finalPricing_OriginationFee_Maximum, fieldToMinMaxCheckValues.get('Origination Fee').get('Max')), fieldToMinMaxCheckValues.get('Origination Fee').get('Min'));
            finalPricing_OLTV_Maximum = math.max(math.min(finalPricing_OLTV_Maximum, fieldToMinMaxCheckValues.get('OLTV').get('Max')), fieldToMinMaxCheckValues.get('OLTV').get('Min'));
            system.debug('@###finalPricing_Multiple_Maximum '+finalPricing_Multiple_Maximum);
            /* cc.Final_Pricing_Max_Check__c  = finalPricing_MaxCheck;
            cc.Final_Pricing_Multiple__c = finalPricing_Multiple;
            cc.Final_Pricing_Starting_Point__c = finalPricing_StartingPoint;
            cc.Final_Pricing_Cap__c = finalPricing_Cap; 
            cc.Final_Pricing_Orign_Fee__c = finalPricing_OriginationFee;
            cc.Final_Pricing_OLTV__c = property_Value != 0 ? ((finalPricing_MaxCheck + senior_Mortgage)/property_Value)*100 > 100 ? 0: ((finalPricing_MaxCheck + senior_Mortgage)/property_Value)*100 : 0; 
            cc.Final_Remark__c = cc.Final_Pricing_OLTV__c == 0 || check_Size_Maximum == 0 || min_Equity == 0 || finalPricing_MaxCheck == 0 ? 'INELIGIBLE':'';
            */
            
            // ---------- new changes -----------------
            Decimal investmentHoRequested = 0;
            Decimal investmentMaximum = 0;
            if(count< 55 || checkSize_HORequested <= 0){
                cc.Investment_Ho_Requested__c = null;
                cc.Investment_Maximum__c = null;
                cc.Investment_Result_HO_Requested__c = 'INELIGIBLE';
                cc.Investment_Result_Maximum__c = 'INELIGIBLE';
                System.debug(' HO Request '+checkSize_HORequested + ' '+count);
                
            }else{
                cc.Investment_Ho_Requested__c = checkSize_HORequested;
                cc.Investment_Maximum__c = checkSize_Maximum;
                cc.Investment_Result_HO_Requested__c = '';
                cc.Investment_Result_Maximum__c = '';
                investmentHoRequested = checkSize_HORequested;
                investmentMaximum = checkSize_Maximum;
                System.debug(' HO Request ELSE '+checkSize_HORequested + ' '+count);
            }
            //cc.Investment_Ho_Requested__c = count< 55 ? 0: checkSize_HORequested ;
            //cc.Investment_Maximum__c =  count< 55 ? 0: checkSize_Maximum ;
            cc.OLTV_HO_Requested__c = inter_propertyValue != 0 
                ? ((investmentHoRequested + senior_Mortgage)/inter_propertyValue)*100
                : 0;
            cc.OLTV_Maximum__c = inter_propertyValue != 0 
                ? ((investmentMaximum + senior_Mortgage)/inter_propertyValue)*100
                : 0;
            cc.Multiple_HO_Requested__c = finalPricing_Multiple_HORequested;
            cc.Multiple_Maximum__c = finalPricing_Multiple_Maximum;
            cc.Investment_Thickness_HO_Requested__c =  inter_propertyValue != 0 
                ? (investmentHoRequested/inter_propertyValue)*100
                : 0;
            cc.Investment_Thickness_Maximum__c = inter_propertyValue != 0 
                ? (investmentMaximum/inter_propertyValue)*100
                : 0;
            cc.Split_Percentage_HO_Requested__c = cc.Investment_Thickness_HO_Requested__c*cc.Multiple_HO_Requested__c;
            cc.Split_Percentage_Maximum__c = cc.Investment_Thickness_Maximum__c*cc.Multiple_Maximum__c;
            cc.Starting_Point_HO_Requested__c = finalPricing_StartingPoint_HORequested;
            cc.Starting_Point_Maximum__c = finalPricing_StartingPoint_Maximum;
            cc.Starting_Point_HO_Requested1__c = (finalPricing_StartingPoint_HORequested*inter_propertyValue)/100;
            cc.Starting_Point_Maximum1__c = (finalPricing_StartingPoint_Maximum*inter_propertyValue)/100;
            cc.Safety_Cap_HO_Requested__c = finalPricing_Cap_HORequested;
            cc.Safety_Cap_Maximum__c = finalPricing_Cap_Maximum;
            
            cc.Origination_Fee_HO_Requested__c = finalPricing_OriginationFee_HORequested;
            cc.Origination_Fee_Maximum__c = finalPricing_OriginationFee_Maximum;
            
            System.debug('##= cc.Origination_Fee_HO_Requested__c' + cc.Origination_Fee_HO_Requested__c);
            System.debug('##= cc.Origination_Fee_Maximum__c' + cc.Origination_Fee_Maximum__c);
            system.debug('##=  finalPricing_StartingPoint_HORequested 4 '+finalPricing_StartingPoint_HORequested);
            
            cc.Origination_Fee_HO_Requested1__c = (finalPricing_OriginationFee_HORequested * investmentHoRequested)/100 > 1500 ?
                (finalPricing_OriginationFee_HORequested* investmentHoRequested)/100 : 1500 ;
            cc.Origination_Fee_Maximum1__c = (finalPricing_OriginationFee_Maximum * investmentMaximum)/100 > 1500 ?
                (finalPricing_OriginationFee_Maximum* investmentMaximum)/100 : 1500 ;
            
            cc.Origination_Fee_Min_HO_Requested__c =  cc.Origination_Fee_HO_Requested1__c == 1500 && investmentHoRequested != 0
                ? (cc.Origination_Fee_HO_Requested1__c/investmentHoRequested)*100 
                : null;
            cc.Origination_Fee_Min_Maximum__c = cc.Origination_Fee_Maximum1__c == 1500 && investmentMaximum != 0
                ? (cc.Origination_Fee_Maximum1__c/investmentMaximum)*100 
                : null;
            
            cc.Origination_Fee_MinResult_HO_Requested__c = cc.Origination_Fee_HO_Requested1__c == 1500 ?
                '' : 'N/A';
            cc.Origination_Fee_MinResult_Maximum__c = cc.Origination_Fee_Maximum1__c == 1500 ?
                '' : 'N/A';
            //--------promo --------------
            String isPromoEligible = 'No';
            
            System.debug('cc.FICO__c-->'+cc.FICO__c);
            System.debug('promoValues.get(FICO)-->'+promoValues.get('FICO'));
            System.debug('cc.Occupancy_Status__c-->'+cc.Occupancy_Status__c);
            System.debug('promoValues.get(Occupancy Status)-->'+promoValues.get('Occupancy Status'));
            System.debug('inter_propertyValue-->'+inter_propertyValue);
            System.debug('promoValues.get(Property Value)--'+promoValues.get('Property Value'));
            System.debug('inter_propertyScore-->'+inter_propertyScore);
            System.debug('promoValues.get(AVM Confidence)-->'+promoValues.get('AVM Confidence'));
            System.debug('cc.FC_Time_Since__c-->'+cc.FC_Time_Since__c);
            System.debug('promoValues.get(FC)-->'+promoValues.get('FC'));
            System.debug('cc.BK_Time_Since__c-->'+cc.BK_Time_Since__c);
            System.debug('promoValues.get(BK)-->'+promoValues.get('BK'));
            System.debug('cc.Lien_Position__c-->'+cc.Lien_Position__c);
            System.debug('promoValues.get(Lien Position)-->'+promoValues.get('Lien Position'));
            System.debug('cc.Property_Type__c-->'+cc.Property_Type__c);
            System.debug('promoValues.get(Property Type)-->'+promoValues.get('Property Type'));
            System.debug('cc.Title_Clean__c-->'+cc.Title_Clean__c);
            System.debug('promoValues.get(Title Clean)-->'+promoValues.get('Title Clean'));
            System.debug('cc.Senior_Lien_Type__c-->'+cc.Senior_Lien_Type__c);
            System.debug('promoValues.get(Senior Lien Type)-->'+promoValues.get('Senior Lien Type'));
            System.debug('checkSize_Maximum-->'+checkSize_Maximum);
            System.debug('promoValues.get(Check Size)-->'+promoValues.get('Check Size'));
            System.debug('cc.OLTV_HO_Requested__c-->'+cc.OLTV_HO_Requested__c);
            System.debug('promoValues.get(OLTV)-->'+promoValues.get('OLTV'));
            
            if(cc.FICO__c != null && cc.FICO__c >= (Decimal)promoValues.get('FICO') &&
               cc.Occupancy_Status__c!=null && cc.Occupancy_Status__c == (String)promoValues.get('Occupancy Status') &&
               inter_propertyValue <=  (Decimal)promoValues.get('Property Value') &&
               inter_propertyScore >= (Decimal)promoValues.get('AVM Confidence') &&
               cc.FC_Time_Since__c == (Boolean)promoValues.get('FC') &&
               cc.BK_Time_Since__c == (Boolean)promoValues.get('BK') &&
               (cc.Lien_Position__c == (String)promoValues.get('Lien Position') || cc.Lien_Position__c == (String)promoValues.get('Lien Position1') ) &&
               cc.Property_Type__c == (String)promoValues.get('Property Type') &&
               cc.Title_Clean__c == (Boolean)promoValues.get('Title Clean') &&
               cc.Senior_Lien_Type__c == (String)promoValues.get('Senior Lien Type') &&
               checkSize_Maximum <= (Decimal)promoValues.get('Check Size') && 
               cc.OLTV_Maximum__c <= (Decimal)promoValues.get('OLTV')){
                   system.debug('aaaaa----------------');
                   isPromoEligible = 'Yes';
                   cc.Promo_Eligible_Maximum__c = true;
                   
               }else{
                   cc.Promo_Eligible_Maximum__c = false;
               }
            
            if(cc.FICO__c != null && cc.FICO__c >= (Decimal)promoValues.get('FICO') &&
               cc.Occupancy_Status__c!=null && cc.Occupancy_Status__c == (String)promoValues.get('Occupancy Status') &&
               inter_propertyValue <=  (Decimal)promoValues.get('Property Value') &&
               inter_propertyScore >= (Decimal)promoValues.get('AVM Confidence') &&
               cc.FC_Time_Since__c == (Boolean)promoValues.get('FC') &&
               cc.BK_Time_Since__c == (Boolean)promoValues.get('BK') &&
               (cc.Lien_Position__c == (String)promoValues.get('Lien Position') || cc.Lien_Position__c == (String)promoValues.get('Lien Position1') ) &&
               cc.Property_Type__c == (String)promoValues.get('Property Type') &&
               cc.Title_Clean__c == (Boolean)promoValues.get('Title Clean') &&
               cc.Senior_Lien_Type__c == (String)promoValues.get('Senior Lien Type') &&
               checkSize_HORequested <= (Decimal)promoValues.get('Check Size') && 
               cc.OLTV_HO_Requested__c <= (Decimal)promoValues.get('OLTV')){
                   system.debug('aaaaa----------------');
                   cc.Promo_Eligible_HO_Requested__c = true;
                   
               }else{
                   cc.Promo_Eligible_HO_Requested__c = false;
               }
            
            cc.Promo_Eligible__c = isPromoEligible;
            //cc.Promo_Eligible_HO_Requested__c = isPromoEligible == 'Yes' ? true : false;
            //cc.Promo_Eligible_Maximum__c = isPromoEligible == 'Yes' ? true : false;
            cc.Investment_Max_HO_Requested__c = investmentHoRequested == investmentMaximum ? true : false;
            cc.Investment_Max_Maximum__c = investmentMaximum == investmentMaximum ?  true : false;
            cc.Net_to_HO_HO_Requested__c = investmentHoRequested - cc.Origination_Fee_HO_Requested1__c - (cc.Estimated_fees_HO_Requested__c != null ? cc.Estimated_fees_HO_Requested__c : 0);
            cc.Net_to_HO_Maximum__c = investmentMaximum - cc.Origination_Fee_Maximum1__c - (cc.Estimated_fees_Maximum__c != null ? cc.Estimated_fees_Maximum__c : 0);
            system.debug('Investment_Maximum__c '+investmentMaximum);
            system.debug('Origination_Fee_Maximum1__c '+cc.Origination_Fee_Maximum1__c);
            
            cc.upsell__c = cc.Net_to_HO_Maximum__c - cc.Net_to_HO_HO_Requested__c;
            cc.Net_after_Payoffs_HO_Requested__c = ((cc.Net_to_HO_HO_Requested__c != null ? cc.Net_to_HO_HO_Requested__c : 0) - (cc.Payoffs_Required__c != null ? cc.Payoffs_Required__c : 0)) < 0 ?
                null : (cc.Net_to_HO_HO_Requested__c != null ? cc.Net_to_HO_HO_Requested__c : 0) - (cc.Payoffs_Required__c !=null ? cc.Payoffs_Required__c : 0) ;
            cc.Net_after_Payoffs_Maximum__c = ((cc.Net_to_HO_Maximum__c != null ? cc.Net_to_HO_Maximum__c : 0) - (cc.Payoffs_Required__c != null ? cc.Payoffs_Required__c : 0)) < 0 ?
                null :((cc.Net_to_HO_Maximum__c != null ? cc.Net_to_HO_Maximum__c : 0) - (cc.Payoffs_Required__c != null ? cc.Payoffs_Required__c : 0)) ;
                    cc.Net_after_Payoffs_Result_HO_Requested__c = ((cc.Net_to_HO_HO_Requested__c != null ? cc.Net_to_HO_HO_Requested__c : 0) - (cc.Payoffs_Required__c != null ? cc.Payoffs_Required__c : 0)) < 0 ?
                    'INELIGIBLE' : '';
            cc.Net_after_Payoffs_Result_Maximum__c = ((cc.Net_to_HO_Maximum__c != null ? cc.Net_to_HO_Maximum__c : 0) - (cc.Payoffs_Required__c != null ? cc.Payoffs_Required__c : 0)) < 0 ?
                'INELIGIBLE' : '';
            
        }
    }
    
    public static void validateOpportunity(List<Consumer_Calculator__c> newRecordList, Map<Id,Consumer_Calculator__c> oldMap){
        List<String> oppoIds = new List<String>();
        for(Consumer_Calculator__c cc : newRecordList){
            if( cc.Committed_Calculator__c=='Yes' && cc.Opportunity__c!=null && (Trigger.isInsert || (Trigger.isUpdate && (cc.Committed_Calculator__c != oldMap.get(cc.Id).Committed_Calculator__c || cc.Opportunity__c != oldMap.get(cc.Id).Opportunity__c ) )) ){
            	oppoIds.add(cc.Opportunity__c);
        	}
        }
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        if(oppoIds.size()>0){
            oppMap=new Map<Id,Opportunity>([Select Id,(Select Id From Consumer_Calculators__r Where Committed_Calculator__c='Yes' ) From Opportunity Where Id IN:oppoIds]);
        } 
        for(Consumer_Calculator__c cc : newRecordList){
            if( cc.Committed_Calculator__c=='Yes' && cc.Opportunity__c!=null && oppMap.containsKey(cc.Opportunity__c)){
            	Opportunity opp = oppMap.get(cc.Opportunity__c); 
                if(opp.Consumer_Calculators__r != null && opp.Consumer_Calculators__r.size()>0){
                    cc.addError('Opportunity and Opportunity Worksheet can not have more then one records of Committed Calculator to be Yes');
                }
        	}
        }    
    }
    
    public static void updateOpportunity(List<Consumer_Calculator__c> newRecordList, Map<Id,Consumer_Calculator__c> oldMap){
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        for(Consumer_Calculator__c cc: newRecordList){             
            if(cc.Committed_Calculator__c=='Yes' && cc.Opportunity__c!=null){                
                Opportunity opp = new Opportunity(Id=cc.Opportunity__c,Committed_Calculator__c=cc.Id); 
                opp.Investment_Amount__c = cc.Investment_HO_Requested__c;
                opp.Multiple_manual__c = cc.Multiple_HO_Requested__c;
                opp.Spliteros_Split__c = cc.Split_Percentage_HO_Requested__c;
                opp.Starting_Point_percent__c = cc.Starting_Point_HO_Requested__c;
                opp.Safety_Cap__c = cc.Safety_Cap_HO_Requested__c;
                opp.Origination_Fee__c  = cc.Origination_Fee_HO_Requested__c;
                opp.Quick_Split_Eligable__c = cc.Promo_Eligible_HO_Requested__c == true ? 'Yes' : 'No';
                opp.Quick_Split_Window__c = 18;
                opp.Quick_Split_Safety_Cap__c = 9.99;
                opp.Max_Investment_Amount__c = cc.Investment_Maximum__c;
                opp.Opportunity_Worksheet__c = cc.Opportunity_Worksheet__c;

                opp.FICO__c = cc.FICO__c;
                opp.Occupancy_Status_Credit_report__c=cc.Occupancy_Status__c;
                opp.Investment_Position__c=cc.Lien_Position__c;
                opp.Senior_Lien_Type__c=cc.Senior_Lien_Type__c;
                
                oppToUpdate.add(opp);
            }else if(cc.Opportunity__c!=null && cc.Committed_Calculator__c=='No' && oldMap!=null && cc.Committed_Calculator__c!= oldMap.get(cc.Id).Committed_Calculator__c){
                Opportunity opp = new Opportunity(Id=cc.Opportunity__c,Committed_Calculator__c=null);                
                oppToUpdate.add(opp);
            }
        } 
        if(oppToUpdate.size()>0){
            SPR_TriggerUtility.ByPassAllTrigger=True;
            update oppToUpdate;
            SPR_TriggerUtility.ByPassAllTrigger=False;
        }  
    }

    public static void validateOpportunityWorksheet(List<Consumer_Calculator__c> newRecordList, Map<Id,Consumer_Calculator__c> oldMap){
        List<String> oppoIds = new List<String>();
        for(Consumer_Calculator__c cc : newRecordList){
            if( cc.Committed_Calculator__c=='Yes' && cc.Opportunity_Worksheet__c!=null && (Trigger.isInsert || (Trigger.isUpdate && (cc.Committed_Calculator__c != oldMap.get(cc.Id).Committed_Calculator__c || cc.Opportunity_Worksheet__c != oldMap.get(cc.Id).Opportunity_Worksheet__c ) )) ){
            	oppoIds.add(cc.Opportunity_Worksheet__c);
        	}
        }
        Map<Id,Opportunity_Worksheet__c> oppMap = new Map<Id,Opportunity_Worksheet__c>();
        if(oppoIds.size()>0){
            oppMap=new Map<Id,Opportunity_Worksheet__c>([Select Id,(Select Id From Consumer_Calculators__r Where Committed_Calculator__c='Yes' ) From Opportunity_Worksheet__c Where Id IN:oppoIds]);
        } 
        for(Consumer_Calculator__c cc : newRecordList){
            if( cc.Committed_Calculator__c=='Yes' && cc.Opportunity_Worksheet__c!=null && oppMap.containsKey(cc.Opportunity_Worksheet__c)){
            	Opportunity_Worksheet__c opp = oppMap.get(cc.Opportunity_Worksheet__c); 
                if(opp.Consumer_Calculators__r != null && opp.Consumer_Calculators__r.size()>0){
                    cc.addError('Opportunity and Opportunity Worksheet can not have more then one records of Committed Calculator to be Yes');
                }
        	}
        }    
    }

    public static void updateOpportunityWorksheet(List<Consumer_Calculator__c> newRecordList, Map<Id,Consumer_Calculator__c> oldMap){
        
        List<Opportunity_Worksheet__c> oppToUpdate = new List<Opportunity_Worksheet__c>();
        for(Consumer_Calculator__c cc: newRecordList){             
            if(cc.Committed_Calculator__c=='Yes' && cc.Opportunity_Worksheet__c!=null){                
                Opportunity_Worksheet__c opp = new Opportunity_Worksheet__c(Id=cc.Opportunity_Worksheet__c,Committed_Calculator__c=cc.Id);                
                opp.Investment_Amount__c = cc.Investment_HO_Requested__c;
                oppToUpdate.add(opp);
            }else if(cc.Opportunity_Worksheet__c!=null && cc.Committed_Calculator__c=='No' && oldMap!=null && cc.Committed_Calculator__c!= oldMap.get(cc.Id).Committed_Calculator__c){
                Opportunity_Worksheet__c opp = new Opportunity_Worksheet__c(Id=cc.Opportunity_Worksheet__c,Committed_Calculator__c=null);                
                oppToUpdate.add(opp);
            }
        } 
        if(oppToUpdate.size()>0){
            SPR_TriggerUtility.ByPassAllTrigger=True;
            update oppToUpdate;
            SPR_TriggerUtility.ByPassAllTrigger=False;
        }  
    }
    
    public static Map<String, List<Consumer_Price_Config__c>> associateCalculatorVersion(List<Consumer_Calculator__c> newRecordList, Map<Id,Consumer_Calculator__c> oldMap)
    {
        Set<String> versionList = new Set<String>();
        for(Consumer_Calculator__c cc: newRecordList)
        {
            versionList.add(cc.Version__c);
        }

        Map<String, List<Consumer_Price_Config__c>> versionConfigMapping = new Map<String, List<Consumer_Price_Config__c>>();
        Map<String, Id> versionControlMap = new Map<String, Id>();
        for(Consumer_Price_Config__c pcConfig : [SELECT Id, Category__c, Multiple__c, Starting_Point__c, Cap__c, 
                                                    Origination_Fee__c, Max_OLTV__c,Start_Range__c, End_Range__c, Variable__c,
                                                    Currency__c,  Calculator_Version__c, Calculator_Version__r.Version__c
                                                    FROM Consumer_Price_Config__c
                                                    WHERE Calculator_Version__r.Version__c IN:versionList
                                                ])
        {
            if(versionConfigMapping.containsKey(pcConfig.Calculator_Version__r.Version__c))
            {
                versionConfigMapping.get(pcConfig.Calculator_Version__r.Version__c).add(pcConfig);
                continue;
            }
            versionConfigMapping.put(pcConfig.Calculator_Version__r.Version__c, new List<Consumer_Price_Config__c>{pcConfig});
            versionControlMap.put(pcConfig.Calculator_Version__r.Version__c, pcConfig.Calculator_Version__c);
        }

        for(Consumer_Calculator__c cc: newRecordList)
        {
            if(versionControlMap.containsKey(cc.Version__c))
            {
                cc.Calculator_Version__c = versionControlMap.get(cc.Version__c);
            }
        }

        return versionConfigMapping;
    }
}