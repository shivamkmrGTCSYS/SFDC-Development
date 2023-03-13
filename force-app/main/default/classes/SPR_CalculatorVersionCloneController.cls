public class SPR_CalculatorVersionCloneController {
 
     
    @AuraEnabled
    public static Calculator_Version__c getCalculatorVersionDetail(String recordId)
    {
        Calculator_Version__c cv =[Select Id, Name,Version__c From Calculator_Version__c Where Id=:recordId ];
        
        return cv ;
    }
    @AuraEnabled
    public static Calculator_Version__c cloneCalculatorVersion(String recordId,String recordName)
    {
        // Record being cloned
        Calculator_Version__c currentCalculatorVersion = [Select Id, Name, Version__c From Calculator_Version__c 
                                                          Where Id=:recordId ];

        // Custom clone logic
        Calculator_Version__c clonedCalculatorVersion = new Calculator_Version__c();
        clonedCalculatorVersion.Name = recordName;
        clonedCalculatorVersion.Version__c = currentCalculatorVersion.Version__c;
        insert clonedCalculatorVersion;

        System.debug('clonedCalculatorVersion-->'+clonedCalculatorVersion);
        createRelatedRecords( clonedCalculatorVersion, currentCalculatorVersion); 
        // Redirect to the new cloned record
        //return new PageReference('/'+clonedCalculatorVersion.Id);
        return clonedCalculatorVersion;
    }
    
    public static void createRelatedRecords(Calculator_Version__c calculatorVersion,Calculator_Version__c currentCalculatorVersion){
        
        System.debug('calculatorVersion-->'+calculatorVersion);
        System.debug('currentCalculatorVersion-->'+currentCalculatorVersion);
        
        List<Consumer_Price_Config__c> configList = [Select Id, Calculator_Version__c, Cap__c,Category__c,Name,Currency__c,End_Range__c,
                                                     Max_OLTV__c,Multiple__c,Origination_Fee__c,Start_Range__c,
                                                     Starting_Point__c,Variable__c
                                                     From Consumer_Price_Config__c 
                                                     Where Calculator_Version__c=:currentCalculatorVersion.Id];
        System.debug('configList-->'+configList);
        List<Consumer_Price_Config__c> newConfigList = new List<Consumer_Price_Config__c>();
        if(configList.size()>0){
            for(Consumer_Price_Config__c cpc: configList){
                Consumer_Price_Config__c newcpc = new Consumer_Price_Config__c();
                newcpc.Calculator_Version__c=calculatorVersion.Id;
                newcpc.Cap__c=cpc.Cap__c;
                newcpc.Category__c=cpc.Category__c;
                newcpc.Name=cpc.Name;
                newcpc.Currency__c=cpc.Currency__c;
                newcpc.End_Range__c=cpc.End_Range__c;
                newcpc.Max_OLTV__c=cpc.Max_OLTV__c;
                newcpc.Multiple__c=cpc.Multiple__c;
                newcpc.Origination_Fee__c=cpc.Origination_Fee__c;
                newcpc.Start_Range__c=cpc.Start_Range__c;
                newcpc.Starting_Point__c=cpc.Starting_Point__c;
                newcpc.Variable__c=cpc.Variable__c;
                newConfigList.add(newcpc);
            }
            
            System.debug('newConfigList-->'+newConfigList);
            
            insert newConfigList; 
        }
        
    }
    
}