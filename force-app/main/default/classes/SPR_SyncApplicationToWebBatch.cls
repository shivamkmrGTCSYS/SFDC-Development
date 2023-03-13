public class SPR_SyncApplicationToWebBatch implements Database.Batchable<sObject>, Database.AllowsCallouts , Schedulable {

    
    public Database.QueryLocator start(Database.BatchableContext bc){ 
        
        String query = 'SELECT Id,User_Sfid__c,Contact__c,Web_UUID__c, Street__c, City__c, State__c, Zipcode__c, Home_Estimated_Price__c,' ; 
            query += ' Splitero_Offer_Price__c, Fund_Required_Timeline__c, Loan_Amount__c, Interest_Rate__c, Legal_First_Name__c,' ; 
            query += ' Legal_Middle_Name__c, Legal_Last_Name__c, Email__c, Phone_Number__c, Birthdate__c, Citizenship_Status__c, ' ;
            query += ' Marital_Status__c, Vesting_Type__c, Number_of_Co_Owners_excluding_yourself__c, Co_Owners_Legal_First_name__c, ' ;
            query += ' Co_Owners_Legal_Middle_name__c, Co_Owners_Legal_Last_name__c, Co_Owners_Email_Address__c, Co_Owner_2_Legal_First_name__c,' ;
            query += ' Co_Owner_2_Legal_Middle_name__c, Co_Owner_2_Legal_Last_name__c, Co_Owner_2_Email_Address__c, Co_Owner_3_Legal_First_name__c, ' ;
            query += ' Co_Owner_3_Legal_Middle_name__c, Co_Owner_3_Legal_Last_name__c, Co_Owner_3_Email_Address__c, Co_Owner_4_Legal_First_name__c,' ;
            query += ' Co_Owner_4_Legal_Middle_name__c, Co_Owner_4_Legal_Last_name__c, Co_Owner_4_Email_Address__c, is_Beneficiary_of_Trust__c, ' ;
            query += ' Signing_authority_for_LLC__c, Primary_Use_of_Property__c, Primary_Street__c, Primary_City__c, Primary_State_Province__c,' ;
            query += ' Primary_Zip_Postal_Code__c, Intend_to_rent_in_next_12_months__c, X1st_Mortgage_Exists__c, X1st_Mortgage_Balance__c, ' ;
            query += ' x1st_Loan_Mod__c, X1st_Forbearance__c, X2nd_Mortgage_Exists__c, X2nd_Mortgage_Balance__c, X2nd_Loan_Mod__c,' ;
            query += ' X2nd_Forbearance__c, Home_Equity_Loan_or_HELOC__c, Is_HELOC_in_Draw_Period__c, HELOC_Max_Draw_Amount__c, HELOC_Balance__c,' ;
            query += ' HERO_or_PACE_loan__c, Solar_or_Energy_Efficiency_Loan_Detail__c, Solar_or_Energy_Efficient_Loan__c, HOA__c, Property_Taxes__c,' ;
            query += ' Property_used_for_Commercial_or_Agricult__c, Property_Commercial_or_Ag_Explaination__c, Property_listed_or_under_contract__c,' ;
            query += ' Current_List_Price_or_Contract_Price__c, current_list_price_contract_price_detail__c, Hazardous_Substances__c, Hazardous_Substances_Explanation__c, ' ;
            query += ' Unpermitted_WorkCode_Violations_Non_Co__c, unperm_work_code_viol_NC_Explaination__c, Ongoing_or_Pending_Lawsuits_or_actions__c, ' ;
            query += ' Ongoing_Pending_Lawsuits_or_actions_Expl__c, ADUsGranny_Flats_Inlaw_units__c, Current_or_Soon_to_Commence_Remodels__c, Current_or_Soon_to_commence_Remodels_Exp__c, Major_System_Faliors__c, ' ;
            query += ' Major_System_Failures_Explanation__c, Desired_Investment__c, How_will_you_use_these_Funds_single__c, How_Will_you_use_these_Fundsnotes__c, Financial_Crimes__c, Financial_Crime_Explanation__c, ' ;
            query += ' Bankruptcy_last_4_years__c, Bankruptcy_last_4_years_Explanation__c, Foreclosure_last_7_years__c, Planning_On_New_Loans_Secured_by_Proper__c, Plan_new_loans_secured_by_property_Expl__c, Do_you_have_any_delinquency_in_your_HOA__c,' ;
            query += ' Property_Address__c, Directly_Indirectly_Obligated_Loan_Forec__c, Plan_On_Incurring_New_Debts_On_Property__c, Incurring_New_Debts_Detail__c, I_hereby_authorize_Splitero_to_obtain_my__c, Consent_Disclosure_Of_Accounts__c, ' ;
            query += ' consent_share_my_information_with_third__c, consent_for_electronic_signature_and_com__c, Consent_Acknowledge_Splitero_Discolosure__c, Electronic_Signature__c, Social_Security_Number__c, Please_Explain__c, Application_Completion_Date__c,' ;
            query += ' Application_Consent_Given_Date__c, Application_Documents_Submitted_Date__c, Electronic_Signature_Date_Time__c, Status__c, Application_Completed__c, Application_Started__c, Application_Question_Completed__c, Step_1_Completion_Time__c, Step_2_Completion_Time__c,' ;
            query += ' Step_3_Completion_Time__c, Step_4_Completion_Time__c, Step_5_Completion_Time__c, Step_6_Completion_Time__c, Step_7_Completion_Time__c, Step_1_Completion_Status__c, Step_2_Completion_Status__c, Step_3_Completion_Status__c, Step_4_Completion_Status__c, Step_5_Completion_Status__c,' ; 
            query += ' Step_6_Completion_Status__c, Step_7_Completion_Status__c, Application_Completion_Step__c, Last_Login_at__c, Lead__r.Home_Owner_Advisor__c,Loan_Number__c,How_will_you_use_these_Funds__c ' ; 
            query += ' FROM Application__c Where Sync_to_Web__c=false   '  ;
         
        System.debug('query-->'+query);
        
        return Database.getQueryLocator(query);
            
    }
    
    public void execute(Database.BatchableContext bc, List<Application__c> scope){
        System.debug('scope-->'+scope ) ;
          
        SPR_SyncApplicationToWebUtility.updateApplication(scope[0]);
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    
    public void execute(SchedulableContext SC){
          Database.executeBatch(new SPR_SyncApplicationToWebBatch(),1);
    }
    
    
}