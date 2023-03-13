public class SPR_SyncApplicationToWebUtility {
    
    public static String accessToken(){
        
        String accessToken = '' ;
           
        SyncApplication__c syncApp = [SELECT Id, Access_Key__c, Access_Token_End_Point__c, Web_End_Point__c 
                                      FROM SyncApplication__c LIMIT 1];
                
        String endPoint = syncApp.Access_Token_End_Point__c;
        system.debug('endPoint===>'+endPoint);
          
        String requestBody  = 'grant_type=client_credentials&scope=splitero-external-api-identifier%2Fsplitero-external-api-identifier.api';//JSON.serialize(body);
        system.debug('requestBody===>'+requestBody);
        HttpRequest req = new HttpRequest();                
        
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setHeader('Authorization','Basic '+syncApp.Access_Key__c);
        //req.setHeader('Accept','*/*');
        req.setHeader('Cookie','XSRF-TOKEN=7cbd913f-4b03-44ac-ae1e-c072e864ab0e');
               
        //req.setHeader('charset','UTF-8');
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(requestBody);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        system.debug('reponse 1===> '+res.getBody());
        
        if(res.getStatusCode() == 200)
        {
            Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            accessToken=String.valueOf(responsePayloadMAP.get('access_token')); 
        }
        else
        {
            accessToken = '';
        }        
        return accessToken;
        
    }
    
    
    public static ApplicationResponse updateApplication(Application__c app){
        
        //Map<String,String> response = new Map<String,String>();
        ApplicationResponse response = new ApplicationResponse();
        String accessToken = accessToken() ;
           
        SPR_WebserviceRequest.CreateApplication ca = CreateApplication(app);
        
        System.debug('ca-->'+JSON.serialize(ca));
        SyncApplication__c syncApp = [SELECT Id, Access_Key__c, Access_Token_End_Point__c, Web_End_Point__c FROM SyncApplication__c LIMIT 1];
                
        String endPoint = syncApp.Web_End_Point__c;
        system.debug('endPoint===>'+endPoint);
                       
        String requestBody  = '{"sfid":"'+app.Id+'","updateFieldJson":'+JSON.serialize(ca)+'}';
        system.debug('requestBody===>'+requestBody);
        HttpRequest req = new HttpRequest();
                        
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization','Bearer '+accessToken);          
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(requestBody);   
        
        system.debug('req body ===> '+ requestBody);

        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        system.debug('reponse 2===>'+res.getBody());
        
        if(res.getStatusCode() == 200)
        {
            //Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            response = (ApplicationResponse) System.JSON.deserialize(res.getBody(), ApplicationResponse.class);
             
            Boolean success = response.success;           
            //String message = String.valueOf(responsePayloadMAP.get('message'));
            
            //response.put('success',String.valueOf(responsePayloadMAP.success));
            //response.put('message',responsePayloadMAP.message);   
            
            if(success==True){
                SPR_TriggerUtility.ByPassAllTrigger=true;
                app.Sync_to_Web__c=true;
                update app;
                SPR_TriggerUtility.ByPassAllTrigger=false;
            }            
        }
        
        return response;
           
    }

    
    public static SPR_WebserviceRequest.CreateApplication CreateApplication(Application__c app){
        
        SPR_WebserviceRequest.CreateApplication ca = new SPR_WebserviceRequest.CreateApplication();
        
        ca.sfid=app.Id;
        ca.user_sfid = app.Contact__c; 
        ca.lead_uuid=app.Web_UUID__c;
        ca.street = String.isBlank(app.Street__c) ? '' : app.Street__c;
        ca.city = String.isBlank(app.City__c) ? '' : app.City__c;
        ca.state = String.isBlank(app.State__c) ? '' : app.State__c;
        ca.zipcode = String.isBlank(app.Zipcode__c) ? '' : app.Zipcode__c;
        ca.home_estimated_price = String.valueOf(app.Home_Estimated_Price__c);
        ca.splitero_offer_price = String.valueOf(app.Splitero_Offer_Price__c);
        ca.fund_required_timeline = app.Fund_Required_Timeline__c;
        ca.loan_amount = String.valueOf(app.Loan_Amount__c);
        ca.loan_number = app.Loan_Number__c;
        ca.interest_rate = String.valueOf(app.Interest_Rate__c);
        ca.legal_first_name = app.Legal_First_Name__c;
        ca.legal_last_name = app.Legal_Last_Name__c;
        ca.legal_middle_name = app.Legal_Middle_Name__c;
        ca.email = app.Email__c;
        ca.phone_number = app.Phone_Number__c; 
        ca.birthday = String.valueOf(app.Birthdate__c);
        ca.cityzenship_status = app.Citizenship_Status__c;
        ca.marriatal_status = app.Marital_Status__c;
        ca.property_title_hold = app.Vesting_Type__c;
        ca.number_of_co_owners = String.valueOf(Integer.valueOf(app.Number_of_Co_Owners_excluding_yourself__c));
        
        ca.beneficiary_of_the_trust = app.is_Beneficiary_of_Trust__c;
        ca.signing_authority_for_llc = app.Signing_authority_for_LLC__c;
        ca.primary_use_of_property = app.Primary_Use_of_Property__c;
        ca.primary_residence_street = app.Primary_Street__c;
        ca.primary_residence_city = app.Primary_City__c;
        ca.primary_residence_state = app.Primary_State_Province__c;
        ca.primary_residence_zipcode = app.Primary_Zip_Postal_Code__c;
        ca.intended_to_rent_in_12_month = app.Intend_to_rent_in_next_12_months__c;
        ca.have_primary_mortgage = app.X1st_Mortgage_Exists__c;
        ca.principal_balance_on_primary_mortgage = String.valueOf(app.X1st_Mortgage_Balance__c);
        ca.primary_mortgage_terms_been_modified = app.x1st_Loan_Mod__c;
        ca.primary_mortgage_in_forbearance = app.X1st_Forbearance__c;
        ca.have_second_mortgage = app.X2nd_Mortgage_Exists__c;
        ca.principal_balance_of_second_mortgage = String.valueOf(app.X2nd_Mortgage_Balance__c);
        ca.second_mortgage_terms_been_modified = app.X2nd_Loan_Mod__c;
        ca.second_mortgage_in_forbearance = app.X2nd_Forbearance__c;
        ca.have_home_equity_loan = app.Home_Equity_Loan_or_HELOC__c;
        ca.heloc_within_draw_period = app.Is_HELOC_in_Draw_Period__c;
        ca.heloc_max_draw_amount = String.valueOf(app.HELOC_Max_Draw_Amount__c);
        ca.heloc_current_balance = String.valueOf(app.HELOC_Balance__c);
        ca.hero_or_pace_loan = app.HERO_or_PACE_loan__c;
        ca.solar_or_energy_efficiency_loan_detail = app.Solar_or_Energy_Efficiency_Loan_Detail__c;
        ca.solar_or_energy_efficiency_loan_yn = app.Solar_or_Energy_Efficient_Loan__c;
        ca.property_part_of_hoa_or_condo = app.HOA__c;
        ca.delinquencies_on_your_property_taxes = app.Property_Taxes__c;
        ca.property_used_for_commercial_agricultural = app.Property_used_for_Commercial_or_Agricult__c;
        ca.commercial_agricultural_use_detail = app.Property_Commercial_or_Ag_Explaination__c;
        ca.home_actively_listed_for_sale = app.Property_listed_or_under_contract__c;
        ca.current_list_or_contract_price = String.valueOf(app.Current_List_Price_or_Contract_Price__c);
        ca.current_list_price_contract_price_detail=String.valueOf(app.current_list_price_contract_price_detail__c);
        ca.hazardous_materials_on_the_property = app.Hazardous_Substances__c;
        ca.hazardous_materials_detail = app.Hazardous_Substances_Explanation__c;
        ca.any_structural_modifications_without_permits = app.Unpermitted_WorkCode_Violations_Non_Co__c;
        ca.structural_modifications_detail = app.unperm_work_code_viol_NC_Explaination__c;
        ca.ongoing_or_pending_lawsuits_against_property = app.Ongoing_or_Pending_Lawsuits_or_actions__c;
        ca.ongoing_or_pending_lawsuits_detail = app.Ongoing_Pending_Lawsuits_or_actions_Expl__c;
        ca.property_include_accessory_dwelling_unit = app.ADUsGranny_Flats_Inlaw_units__c;
        ca.property_currently_under_renovation = app.Current_or_Soon_to_Commence_Remodels__c;
        ca.under_renovation_detail = app.Current_or_Soon_to_commence_Remodels_Exp__c;
        ca.any_major_systems_need_repair = app.Major_System_Faliors__c;
        ca.major_repair_detail = app.Major_System_Failures_Explanation__c;
        ca.amount_needed_from_splitero = String.valueOf(app.Desired_Investment__c);
        ca.intention_to_use_fund = app.How_will_you_use_these_Funds_Single__c;
        ca.intention_to_use_fund_multi = app.How_will_you_use_these_Funds__c;
        ca.explain_fund_usage = app.How_Will_you_use_these_Fundsnotes__c;
        ca.pleaded_financial_crimes = app.Financial_Crimes__c;
        ca.pleaded_financial_crimes_detail = app.Financial_Crime_Explanation__c;
        ca.any_bankruptcy_filed = app.Bankruptcy_last_4_years__c;
        ca.any_bankruptcy_filed_detail = app.Bankruptcy_last_4_years_Explanation__c;
        ca.directly_indirectly_obligated_loan_foreclosure = app.Foreclosure_last_7_years__c;
        ca.planning_on_new_loans_secured_by_proper = app.Planning_On_New_Loans_Secured_by_Proper__c;
        ca.plan_new_loans_secured_by_property_expl = app.Plan_new_loans_secured_by_property_Expl__c;
        ca.delinquency_in_your_hoa_dues = app.Do_you_have_any_delinquency_in_your_HOA__c;
        ca.full_address = app.Property_Address__c;
        ca.directly_indirectly_obligated_loan_foreclosure_detail = app.Directly_Indirectly_Obligated_Loan_Forec__c;
        ca.plan_on_incurring_new_debts_on_property = app.Plan_On_Incurring_New_Debts_On_Property__c;
        ca.incurring_new_debts_detail = app.Incurring_New_Debts_Detail__c;
        ca.consent_credit_report = app.I_hereby_authorize_Splitero_to_obtain_my__c;
        ca.consent_disclosure_of_accounts = app.Consent_Disclosure_Of_Accounts__c;
        ca.consent_share_my_information_with_third_parties = app.consent_share_my_information_with_third__c;
        ca.consent_for_electronic_signature_and_communication = app.consent_for_electronic_signature_and_com__c;
        ca.consent_acknowledge_splitero_discolosure_policies = app.Consent_Acknowledge_Splitero_Discolosure__c;
        ca.electronic_signature_full_name = app.Electronic_Signature__c;
        ca.social_security_number = app.Social_Security_Number__c;
        ca.delinquencies_detail = app.Please_Explain__c;
        ca.application_completion_date = String.valueOf(app.Application_Completion_Date__c);
        ca.application_consent_given_date = String.valueOf(app.Application_Consent_Given_Date__c);
        ca.application_documents_submitted_date = String.valueOf(app.Application_Documents_Submitted_Date__c);
        ca.electronic_signature_date_time = String.valueOf(app.Electronic_Signature_Date_Time__c);
        ca.status = app.Status__c;
        ca.application_completed = String.valueOf(app.Application_Completed__c);
        ca.application_started = String.valueOf(app.Application_Started__c);
        ca.application_question_completed = String.valueOf(app.Application_Question_Completed__c);
        ca.step_1_completion_time = String.valueOf(app.Step_1_Completion_Time__c);
        ca.step_2_completion_time = String.valueOf(app.Step_2_Completion_Time__c);
        ca.step_3_completion_time = String.valueOf(app.Step_3_Completion_Time__c);
        ca.step_4_completion_time = String.valueOf(app.Step_4_Completion_Time__c);
        ca.step_5_completion_time = String.valueOf(app.Step_5_Completion_Time__c);
        ca.step_6_completion_time = String.valueOf(app.Step_6_Completion_Time__c);
        ca.step_7_completion_time = String.valueOf(app.Step_7_Completion_Time__c);
        ca.is_step_1_completed = app.Step_1_Completion_Status__c;
        ca.is_step_2_completed = app.Step_2_Completion_Status__c;
        ca.is_step_3_completed = app.Step_3_Completion_Status__c;
        ca.is_step_4_completed = app.Step_4_Completion_Status__c;
        ca.is_step_5_completed = app.Step_5_Completion_Status__c;
        ca.is_step_6_completed = app.Step_6_Completion_Status__c;
        ca.is_step_7_completed = app.Step_7_Completion_Status__c;
        ca.last_logged_in_at = String.valueOf(app.Last_Login_at__c);
        ca.home_owner_adviser_sfid = app.Lead__r.Home_Owner_Advisor__c;
        ca.is_active = 'true';
         
        List<SPR_WebserviceRequest.Co_owners> coownerList = new List<SPR_WebserviceRequest.Co_owners>();
        SPR_WebserviceRequest.Co_owners coowner1 = new SPR_WebserviceRequest.Co_owners();
        coowner1.first_name=app.Co_Owners_Legal_First_name__c;
        coowner1.middle_name=app.Co_Owners_Legal_Middle_name__c;
        coowner1.last_name=app.Co_Owners_Legal_Last_name__c;
        coowner1.email=app.Co_Owners_Email_Address__c;
        coownerList.add(coowner1);
        
        SPR_WebserviceRequest.Co_owners coowner2 = new SPR_WebserviceRequest.Co_owners();
        coowner2.first_name=app.Co_Owner_2_Legal_First_name__c;
        coowner2.middle_name=app.Co_Owner_2_Legal_Middle_name__c;
        coowner2.last_name=app.Co_Owner_2_Legal_Last_name__c;
        coowner2.email=app.Co_Owner_2_Email_Address__c;
        coownerList.add(coowner2);
          
        SPR_WebserviceRequest.Co_owners coowner3 = new SPR_WebserviceRequest.Co_owners();
        coowner3.first_name=app.Co_Owner_3_Legal_First_name__c;
        coowner3.middle_name=app.Co_Owner_3_Legal_Middle_name__c;
        coowner3.last_name=app.Co_Owner_3_Legal_Last_name__c;
        coowner3.email=app.Co_Owner_3_Email_Address__c;
        coownerList.add(coowner3);
         
        SPR_WebserviceRequest.Co_owners coowner4 = new SPR_WebserviceRequest.Co_owners();
        coowner4.first_name=app.Co_Owner_4_Legal_First_name__c;
        coowner4.middle_name=app.Co_Owner_4_Legal_Middle_name__c;
        coowner4.last_name=app.Co_Owner_4_Legal_Last_name__c;
        coowner4.email=app.Co_Owner_4_Email_Address__c;
        coownerList.add(coowner4);
         
        ca.co_owners=coownerList;
        
        System.debug('ca-->'+ca);
        return ca;
        
        
    }
    
    @AuraEnabled
    public static ApplicationResponse SyncApplicationToWeb(String recordId){
        
        System.debug('recordId-->'+recordId);
        
        String query = 'SELECT Id,User_Sfid__c,Contact__c,Web_UUID__c, Street__c, City__c, State__c, Zipcode__c, Home_Estimated_Price__c,' ; 
            query += ' Splitero_Offer_Price__c, Fund_Required_Timeline__c, Loan_Amount__c, Loan_Number__c, Interest_Rate__c, Legal_First_Name__c,' ; 
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
            query += ' Current_List_Price_or_Contract_Price__c,current_list_price_contract_price_detail__c, Hazardous_Substances__c, Hazardous_Substances_Explanation__c, ' ;
            query += ' Unpermitted_WorkCode_Violations_Non_Co__c, unperm_work_code_viol_NC_Explaination__c, Ongoing_or_Pending_Lawsuits_or_actions__c, ' ;
            query += ' Ongoing_Pending_Lawsuits_or_actions_Expl__c, ADUsGranny_Flats_Inlaw_units__c, Current_or_Soon_to_Commence_Remodels__c, Current_or_Soon_to_commence_Remodels_Exp__c, Major_System_Faliors__c, ' ;
            query += ' Major_System_Failures_Explanation__c, Desired_Investment__c, How_will_you_use_these_Funds__c, How_Will_you_use_these_Fundsnotes__c, Financial_Crimes__c, Financial_Crime_Explanation__c, ' ;
            query += ' Bankruptcy_last_4_years__c, Bankruptcy_last_4_years_Explanation__c, Foreclosure_last_7_years__c, Planning_On_New_Loans_Secured_by_Proper__c, Plan_new_loans_secured_by_property_Expl__c, Do_you_have_any_delinquency_in_your_HOA__c,' ;
            query += ' Property_Address__c, Directly_Indirectly_Obligated_Loan_Forec__c, Plan_On_Incurring_New_Debts_On_Property__c, Incurring_New_Debts_Detail__c, I_hereby_authorize_Splitero_to_obtain_my__c, Consent_Disclosure_Of_Accounts__c, ' ;
            query += ' consent_share_my_information_with_third__c, consent_for_electronic_signature_and_com__c, Consent_Acknowledge_Splitero_Discolosure__c, Electronic_Signature__c, Social_Security_Number__c, Please_Explain__c, Application_Completion_Date__c,' ;
            query += ' Application_Consent_Given_Date__c, Application_Documents_Submitted_Date__c, Electronic_Signature_Date_Time__c, Status__c, Application_Completed__c, Application_Started__c, Application_Question_Completed__c, Step_1_Completion_Time__c, Step_2_Completion_Time__c,' ;
            query += ' Step_3_Completion_Time__c, Step_4_Completion_Time__c, Step_5_Completion_Time__c, Step_6_Completion_Time__c, Step_7_Completion_Time__c, Step_1_Completion_Status__c, Step_2_Completion_Status__c, Step_3_Completion_Status__c, Step_4_Completion_Status__c, Step_5_Completion_Status__c,' ; 
            query += ' Step_6_Completion_Status__c, Step_7_Completion_Status__c, Application_Completion_Step__c, Last_Login_at__c, Lead__r.Home_Owner_Advisor__c,How_will_you_use_these_Funds_Single__c  ' ; 
            query += ' From Application__c Where Id=:recordId '  ;
        
        Application__c app = Database.query(query) ;
        SYstem.debug('app-->'+app);
        ApplicationResponse response = updateApplication(app);
        
        populateSyncToWebMessage(app,response);
        
        return response;
        
    }
    
    public static void populateSyncToWebMessage(Application__c app,ApplicationResponse response){
       app.Portal_Sync_Message__c = JSON.serialize(response);
       update app;
    }
    
    public static void sendRejectedStatus(List<Document__c> docList, Map<Id,Document__c> oldMap){
         
        String docId = '';
        for(Document__c docs : docList){
            if(docs.Status__c!=oldMap.get(docs.Id).Status__c && docs.Status__c=='Rejected'){
                docId=docs.Id;
                break;
            }
        }
        if(docId !=''){
            sendRejectedStatusToWeb(docId);
        }
    }
    
    @future(callout=true)
    public static void sendRejectedStatusToWeb( String  docId){
        Document__c doc = [Select Id,Document_Key__c, Opportunity__c From Document__c Where Id=:docId Limit 1] ;
        Application__c app =[Select Id From Application__c Where Opportunity__c=:doc.Opportunity__c Limit 1 ] ;          
        String accessToken = 'ajasdjasjdlkasjdldj';
        if(!Test.isRunningTest()) accessToken=accessToken();
        
        SyncApplication__c syncApp = [SELECT Id, Access_Key__c, Access_Token_End_Point__c, Web_End_Point__c,
                                      Web_End_Point_Document__c
                                      FROM SyncApplication__c LIMIT 1];
                
        String endPoint = syncApp.Web_End_Point_Document__c;
         
        system.debug('endPoint===>'+endPoint);
        
        String requestBody  = '{"loanSfid":"'+app.Id+'","documentKey":"'+doc.Document_Key__c+'" }';
        system.debug('requestBody===>'+requestBody);
        HttpRequest req = new HttpRequest();                
         
        
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization','Bearer '+accessToken);          
        req.setEndpoint(endPoint);
        req.setMethod('DELETE');
        req.setBody(requestBody);   
        
        system.debug('req body ===> '+ requestBody);
        
        Http http = new Http();
        HTTPResponse res ;
            
        if(!Test.isRunningTest()) res= http.send(req);
         
        
    }
    
	public static void sendOpportunityStageToWeb(Set<String> oppIds){
        sendOpportunityStageToWeb(oppIds, '');
    }
	@future(callout=true)
    public static void sendOpportunityStageToWeb( Set<String> oppIds, String stageName){
         
        List<Opportunity> oppListToSend = [Select Id, StageName, Signing_Appt_Sch_Date__c,Wire_Ordered__c,CD_sent__c,
                                               ( Select Id From Applications__r)
                                              From Opportunity Where Id IN:oppIds] ;
        String accessToken = 'ajasdjasjdlkasjdldj';
        if(!Test.isRunningTest()) accessToken=accessToken();
        SyncApplication__c syncApp = [SELECT Id, Access_Key__c, Access_Token_End_Point__c, Web_End_Point__c,
                                      Web_End_Point_Opp_Stage_Update__c
                                      FROM SyncApplication__c LIMIT 1];
        for(Opportunity opp: oppListToSend){
            if(opp.Applications__r!=null && opp.Applications__r.size()>0){
                Application__c app =opp.Applications__r[0]; 
                
                String endPoint = syncApp.Web_End_Point_Opp_Stage_Update__c;
                 
                system.debug('endPoint===>'+endPoint);
                if(stageName==''){
                    stageName=opp.StageName;
                }
                String requestBody  = '{"sfid":"'+ app.Id+ '","status":"'+ stageName+'"';
                if(opp.CD_sent__c!=null)
                    requestBody+=',"cdSent":"'+ opp.CD_sent__c+'"';
                if(opp.Wire_Ordered__c!=null)
                    requestBody+=',"wireOrdered":"'+ opp.Wire_Ordered__c+'"';
                if(opp.Signing_Appt_Sch_Date__c!=null)
                    requestBody+=',"signingApptScheduledDate":"'+ opp.Signing_Appt_Sch_Date__c+'"';
                 
                requestBody+=',"isConverted":true'; 
                
                requestBody+='}';
                system.debug('requestBody===>'+requestBody);
                HttpRequest req = new HttpRequest(); 
                
                req.setHeader('Content-Type','application/json');
                req.setHeader('Authorization','Bearer '+accessToken);          
                req.setEndpoint(endPoint);
                req.setMethod('PUT');
                req.setBody(requestBody);   
                
                system.debug('req body ===> '+ requestBody);
                
                Http http = new Http();
                HTTPResponse res ;
                    
                if(!Test.isRunningTest()) res= http.send(req);
                
                system.debug('req body ===> '+ res.getBody());
        
        	}
        }
    }
        
}