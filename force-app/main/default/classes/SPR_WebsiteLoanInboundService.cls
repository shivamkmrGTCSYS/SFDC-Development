@RestResource(urlMapping='/web/loan/record/*')
global with sharing class SPR_WebsiteLoanInboundService {
    
     

    @HttpPost
    global static void postRequestHandler() 
    {
        System.debug('Inbound Request from SPR Loan API');
        RestResponse res = RestContext.response;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 406;
            return;
        }
                
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
         
        SPR_WebserviceRequest.CreateApplication jsonFile = (SPR_WebserviceRequest.CreateApplication)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.CreateApplication.class);
        System.debug('jsonFile-->'+jsonFile);
         
        String Splitero_File_Number='';
        Boolean error=false;
        String errorMeaagse='';
        String leadId='';
        Application__c app = new Application__c();
        List<Lead> leadList = new List<Lead>();
        if(jsonFile.lead_uuid!=null){
            leadList = [Select Id,Splitero_File_Number__c,Property__c,Application__c From Lead Where Web_UUID__c=:jsonFile.lead_uuid Limit 1] ; 
            if(leadList.size()>0){
                leadId=leadList[0].Id; 
                app.Lead__c=leadList[0].Id;                 
                Splitero_File_Number=leadList[0].Splitero_File_Number__c;
                app.Property__c=leadList[0].Property__c;
            } else{
                error=true;
                errorMeaagse=' Invalid UUID' ;
            }           
        }        
        if(jsonFile.user_sfid!=null){
            List<Portal_User__c> portalUserList = [Select Id From Portal_User__c Where Id=:jsonFile.user_sfid Limit 1] ; 
            if(portalUserList.size()==0){ 
                error=true;
                errorMeaagse=' Invalid Portal User' ;
            }           
        } 
        
        //if(jsonFile.user_sfid!=null) app.User_Sfid__c=jsonFile.user_sfid;
        //if(jsonFile.user_sfid!=null) app.Contact__c=jsonFile.user_sfid;
        if(jsonFile.user_sfid!=null) app.Portal_User__c=jsonFile.user_sfid;
        //if(jsonFile.street!=null) app.Street__c=jsonFile.street;
        //if(jsonFile.city!=null) app.City__c=jsonFile.city;
        if(jsonFile.state!=null) app.State__c=jsonFile.state;
        if(jsonFile.zipcode!=null) app.Zipcode__c=jsonFile.zipcode;
        if(jsonFile.home_estimated_price!=null) app.Home_Estimated_Price__c=Decimal.valueOf(jsonFile.home_estimated_price);
        if(jsonFile.splitero_offer_price!=null) app.Splitero_Offer_Price__c=Decimal.valueOf(jsonFile.splitero_offer_price);
        if(jsonFile.fund_required_timeline!=null) app.Fund_Required_Timeline__c=jsonFile.fund_required_timeline;
        if(jsonFile.loan_amount!=null) app.Loan_Amount__c=Decimal.valueOf(jsonFile.loan_amount);
        if(jsonFile.interest_rate!=null) app.Interest_Rate__c=Decimal.valueOf(jsonFile.interest_rate);
        
        if(jsonFile.legal_first_name!=null) app.Legal_First_Name__c= jsonFile.legal_first_name;
        if(jsonFile.legal_middle_name!=null) app.Legal_Middle_Name__c= jsonFile.legal_middle_name;
        if(jsonFile.legal_last_name!=null) app.Legal_Last_Name__c= jsonFile.legal_last_name;
        if(jsonFile.email!=null) app.Email__c= jsonFile.email;
        if(jsonFile.phone_number!=null) app.Phone_Number__c= jsonFile.phone_number;
        if(jsonFile.birthday!=null) app.Birthdate__c= date.parse(jsonFile.birthday);
        
        if(jsonFile.cityzenship_status!=null) app.Citizenship_Status__c= jsonFile.cityzenship_status;
        if(jsonFile.marriatal_status!=null) app.Marital_Status__c= jsonFile.marriatal_status;
        if(jsonFile.property_title_hold!=null) app.Vesting_Type__c= jsonFile.property_title_hold;
        
        if(jsonFile.number_of_co_owners!=null) app.Number_of_Co_Owners_excluding_yourself__c= Integer.valueOf(jsonFile.number_of_co_owners);
        
        if(jsonFile.co_owners_legal_first_name!=null) app.Co_Owners_Legal_First_name__c= jsonFile.co_owners_legal_first_name;
        if(jsonFile.co_owners_legal_middle_name!=null) app.Co_Owners_Legal_Middle_name__c= jsonFile.co_owners_legal_middle_name;
        if(jsonFile.co_owners_legal_last_name!=null) app.Co_Owners_Legal_Last_name__c= jsonFile.co_owners_legal_last_name;
        if(jsonFile.co_owners_email!=null) app.Co_Owners_Email_Address__c= jsonFile.co_owners_email;
                       
        if(jsonFile.co_owners_2_legal_first_name!=null) app.Co_Owner_2_Legal_First_name__c= jsonFile.co_owners_2_legal_first_name;
        if(jsonFile.co_owners_2_legal_middle_name!=null) app.Co_Owner_2_Legal_Middle_name__c= jsonFile.co_owners_2_legal_middle_name;
        if(jsonFile.co_owners_2_legal_last_name!=null) app.Co_Owner_2_Legal_Last_name__c= jsonFile.co_owners_2_legal_last_name;
        if(jsonFile.co_owners_2_email!=null) app.Co_Owner_2_Email_Address__c= jsonFile.co_owners_2_email;
        
        if(jsonFile.co_owners_3_legal_first_name!=null) app.Co_Owner_3_Legal_First_name__c= jsonFile.co_owners_3_legal_first_name;
        if(jsonFile.co_owners_3_legal_middle_name!=null) app.Co_Owner_3_Legal_Middle_name__c= jsonFile.co_owners_3_legal_middle_name;
        if(jsonFile.co_owners_3_legal_last_name!=null) app.Co_Owner_3_Legal_Last_name__c= jsonFile.co_owners_3_legal_last_name;
        if(jsonFile.co_owners_3_email!=null) app.Co_Owner_3_Email_Address__c= jsonFile.co_owners_3_email;
        
        if(jsonFile.co_owners_4_legal_first_name!=null) app.Co_Owner_4_Legal_First_name__c= jsonFile.co_owners_4_legal_first_name;
        if(jsonFile.co_owners_4_legal_middle_name!=null) app.Co_Owner_4_Legal_Middle_name__c= jsonFile.co_owners_4_legal_middle_name;
        if(jsonFile.co_owners_4_legal_last_name!=null) app.Co_Owner_4_Legal_Last_name__c= jsonFile.co_owners_4_legal_last_name;
        if(jsonFile.co_owners_4_email!=null) app.Co_Owner_4_Email_Address__c= jsonFile.co_owners_4_email;
        
        if( (jsonFile.co_owners_legal_first_name!=null && jsonFile.co_owners_legal_first_name.length()<3) ||  (jsonFile.co_owners_legal_last_name!=null && jsonFile.co_owners_legal_last_name.length()<3) || (jsonFile.co_owners_2_legal_first_name!=null && jsonFile.co_owners_2_legal_first_name.length()<3) || (jsonFile.co_owners_2_legal_last_name!=null && jsonFile.co_owners_2_legal_last_name.length()<3) || (jsonFile.co_owners_3_legal_first_name!=null && jsonFile.co_owners_3_legal_first_name.length()<3) || (jsonFile.co_owners_3_legal_last_name!=null && jsonFile.co_owners_3_legal_last_name.length()<3) || (jsonFile.co_owners_4_legal_first_name!=null && jsonFile.co_owners_4_legal_first_name.length()<3) || (jsonFile.co_owners_4_legal_last_name!=null && jsonFile.co_owners_4_legal_last_name.length()<3)  ){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Co-owner First name OR Last Name must have at least 3 character'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 406;
            return;
        }
        
        if(jsonFile.beneficiary_of_the_trust!=null) app.is_Beneficiary_of_Trust__c= jsonFile.beneficiary_of_the_trust;
        if(jsonFile.signing_authority_for_llc!=null) app.Signing_authority_for_LLC__c= jsonFile.signing_authority_for_llc;
        
        if(jsonFile.primary_use_of_property!=null) app.Primary_Use_of_Property__c= jsonFile.primary_use_of_property;
        if(jsonFile.primary_residence_street!=null) app.Primary_Street__c= jsonFile.primary_residence_street;
        if(jsonFile.primary_residence_city!=null) app.Primary_City__c= jsonFile.primary_residence_city;
        if(jsonFile.primary_residence_state!=null) app.Primary_State_Province__c= jsonFile.primary_residence_state;
        if(jsonFile.primary_residence_zipcode!=null) app.Primary_Zip_Postal_Code__c= jsonFile.primary_residence_zipcode;
        
        
        if(jsonFile.intended_to_rent_in_12_month!=null) app.Intend_to_rent_in_next_12_months__c= jsonFile.intended_to_rent_in_12_month;
        if(jsonFile.have_primary_mortgage!=null) app.X1st_Mortgage_Exists__c= jsonFile.have_primary_mortgage;
        if(jsonFile.principal_balance_on_primary_mortgage!=null) app.X1st_Mortgage_Balance__c=Decimal.valueOf(jsonFile.principal_balance_on_primary_mortgage);
        if(jsonFile.primary_mortgage_terms_been_modified!=null) app.x1st_Loan_Mod__c= jsonFile.primary_mortgage_terms_been_modified;
        if(jsonFile.primary_mortgage_in_forbearance!=null) app.X1st_Forbearance__c= jsonFile.primary_mortgage_in_forbearance;
        
        if(jsonFile.have_second_mortgage!=null) app.X2nd_Mortgage_Exists__c= jsonFile.have_second_mortgage;
        if(jsonFile.principal_balance_of_second_mortgage!=null) app.X2nd_Mortgage_Balance__c=Decimal.valueOf(jsonFile.principal_balance_of_second_mortgage);
        if(jsonFile.second_mortgage_terms_been_modified!=null) app.X2nd_Loan_Mod__c= jsonFile.second_mortgage_terms_been_modified;
        if(jsonFile.second_mortgage_in_forbearance!=null) app.X2nd_Forbearance__c= jsonFile.second_mortgage_in_forbearance;
        
        
        if(jsonFile.have_home_equity_loan!=null) app.Home_Equity_Loan_or_HELOC__c= jsonFile.have_home_equity_loan;
        if(jsonFile.heloc_within_draw_period!=null) app.Is_HELOC_in_Draw_Period__c= jsonFile.heloc_within_draw_period;
        if(jsonFile.heloc_max_draw_amount!=null) app.HELOC_Max_Draw_Amount__c=Decimal.valueOf(jsonFile.heloc_max_draw_amount);
        if(jsonFile.heloc_current_balance!=null) app.HELOC_Balance__c=Decimal.valueOf(jsonFile.heloc_current_balance);
        if(jsonFile.hero_or_pace_loan!=null) app.HERO_or_PACE_loan__c= jsonFile.hero_or_pace_loan;
        if(jsonFile.solar_or_energy_efficiency_loan_yn!=null) app.Solar_or_Energy_Efficient_Loan__c = jsonFile.solar_or_energy_efficiency_loan_yn;
        
        
        if(jsonFile.property_part_of_hoa_or_condo!=null) app.HOA__c= jsonFile.property_part_of_hoa_or_condo;
        if(jsonFile.delinquencies_on_your_property_taxes!=null) app.Property_Taxes__c= jsonFile.delinquencies_on_your_property_taxes;
         
        if(jsonFile.property_used_for_commercial_agricultural!=null) app.Property_used_for_Commercial_or_Agricult__c= jsonFile.property_used_for_commercial_agricultural;
        if(jsonFile.commercial_agricultural_use_detail!=null) app.Property_Commercial_or_Ag_Explaination__c= jsonFile.commercial_agricultural_use_detail;
        if(jsonFile.home_actively_listed_for_sale!=null) app.Property_listed_or_under_contract__c= jsonFile.home_actively_listed_for_sale;
        if(jsonFile.current_list_or_contract_price!=null) app.Current_List_Price_or_Contract_Price__c=Decimal.valueOf(jsonFile.current_list_or_contract_price);
        if(jsonFile.current_list_price_contract_price_detail!=null) app.current_list_price_contract_price_detail__c=String.valueOf(jsonFile.current_list_price_contract_price_detail);
        if(jsonFile.hazardous_materials_on_the_property!=null) app.Hazardous_Substances__c= jsonFile.hazardous_materials_on_the_property;
         
        
        if(jsonFile.hazardous_materials_detail!=null) app.Hazardous_Substances_Explanation__c= jsonFile.hazardous_materials_detail;
        if(jsonFile.any_structural_modifications_without_permits!=null) app.Unpermitted_WorkCode_Violations_Non_Co__c= jsonFile.any_structural_modifications_without_permits;
        if(jsonFile.structural_modifications_detail!=null) app.unperm_work_code_viol_NC_Explaination__c= jsonFile.structural_modifications_detail;
        if(jsonFile.ongoing_or_pending_lawsuits_against_property!=null) app.Ongoing_or_Pending_Lawsuits_or_actions__c= jsonFile.ongoing_or_pending_lawsuits_against_property;
        if(jsonFile.ongoing_or_pending_lawsuits_detail!=null) app.Ongoing_Pending_Lawsuits_or_actions_Expl__c= jsonFile.ongoing_or_pending_lawsuits_detail;
        if(jsonFile.property_include_accessory_dwelling_unit!=null) app.ADUsGranny_Flats_Inlaw_units__c= jsonFile.property_include_accessory_dwelling_unit;
        if(jsonFile.property_currently_under_renovation!=null) app.Current_or_Soon_to_Commence_Remodels__c= jsonFile.property_currently_under_renovation;
        if(jsonFile.under_renovation_detail!=null) app.Current_or_Soon_to_commence_Remodels_Exp__c= jsonFile.under_renovation_detail;
        if(jsonFile.any_major_systems_need_repair!=null) app.Major_System_Faliors__c= jsonFile.any_major_systems_need_repair;
        if(jsonFile.major_repair_detail!=null) app.Major_System_Failures_Explanation__c= jsonFile.major_repair_detail;
        if(jsonFile.amount_needed_from_splitero!=null) app.Desired_Investment__c=Decimal.valueOf(jsonFile.amount_needed_from_splitero);
        if(jsonFile.intention_to_use_fund!=null) app.How_will_you_use_these_Funds_Single__c= jsonFile.intention_to_use_fund;
        if(jsonFile.intention_to_use_fund_multi!=null) app.How_will_you_use_these_Funds__c= jsonFile.intention_to_use_fund_multi;
        if(jsonFile.explain_fund_usage!=null) app.How_Will_you_use_these_Fundsnotes__c= jsonFile.explain_fund_usage;
        if(jsonFile.pleaded_financial_crimes!=null) app.Financial_Crimes__c= jsonFile.pleaded_financial_crimes;
        if(jsonFile.pleaded_financial_crimes_detail!=null) app.Financial_Crime_Explanation__c= jsonFile.pleaded_financial_crimes_detail;
        if(jsonFile.any_bankruptcy_filed!=null) app.Bankruptcy_last_4_years__c= jsonFile.any_bankruptcy_filed;
        
        
        if(jsonFile.any_bankruptcy_filed_detail!=null) app.Bankruptcy_last_4_years_Explanation__c= jsonFile.any_bankruptcy_filed_detail;
        if(jsonFile.directly_indirectly_obligated_loan_foreclosure!=null) app.Foreclosure_last_7_years__c= jsonFile.directly_indirectly_obligated_loan_foreclosure;
        if(jsonFile.planning_on_new_loans_secured_by_proper!=null) app.Planning_On_New_Loans_Secured_by_Proper__c= jsonFile.planning_on_new_loans_secured_by_proper;
        if(jsonFile.plan_new_loans_secured_by_property_expl!=null) app.Plan_new_loans_secured_by_property_Expl__c= jsonFile.plan_new_loans_secured_by_property_expl;
               
        if(jsonFile.delinquency_in_your_hoa_dues!=null) app.Do_you_have_any_delinquency_in_your_HOA__c= jsonFile.delinquency_in_your_hoa_dues;
        
        if(jsonFile.full_address!=null) app.Property_Address__c= jsonFile.full_address;
        if(jsonFile.directly_indirectly_obligated_loan_foreclosure_detail!=null) app.Directly_Indirectly_Obligated_Loan_Forec__c= jsonFile.directly_indirectly_obligated_loan_foreclosure_detail;
        if(jsonFile.plan_on_incurring_new_debts_on_property!=null) app.Plan_On_Incurring_New_Debts_On_Property__c= jsonFile.plan_on_incurring_new_debts_on_property;
        if(jsonFile.incurring_new_debts_detail!=null) app.Incurring_New_Debts_Detail__c= jsonFile.incurring_new_debts_detail;
        if(jsonFile.consent_credit_report!=null) app.I_hereby_authorize_Splitero_to_obtain_my__c= jsonFile.consent_credit_report;
        if(jsonFile.consent_disclosure_of_accounts!=null) app.Consent_Disclosure_Of_Accounts__c= jsonFile.consent_disclosure_of_accounts;
        if(jsonFile.consent_share_my_information_with_third_parties!=null) app.consent_share_my_information_with_third__c= jsonFile.consent_share_my_information_with_third_parties;
        
        if(jsonFile.consent_for_electronic_signature_and_communication!=null) app.consent_for_electronic_signature_and_com__c= jsonFile.consent_for_electronic_signature_and_communication;
        if(jsonFile.consent_acknowledge_splitero_discolosure_policies!=null) app.Consent_Acknowledge_Splitero_Discolosure__c= jsonFile.consent_acknowledge_splitero_discolosure_policies;
        if(jsonFile.electronic_signature_full_name!=null) app.Electronic_Signature__c= jsonFile.electronic_signature_full_name;
        if(jsonFile.social_security_number!=null) app.Social_Security_Number__c= jsonFile.social_security_number;
        
        if(jsonFile.delinquencies_detail!=null) app.Please_Explain__c= jsonFile.delinquencies_detail;
          
        if(jsonFile.application_completion_date!=null) app.Application_Completion_Date__c= datetime.parse(jsonFile.application_completion_date);
        if(jsonFile.application_consent_given_date!=null) app.Application_Consent_Given_Date__c= datetime.parse(jsonFile.application_consent_given_date);
        if(jsonFile.application_documents_submitted_date!=null) app.Application_Documents_Submitted_Date__c= datetime.parse(jsonFile.application_documents_submitted_date);
         
        if(jsonFile.electronic_signature_date_time!=null) app.Electronic_Signature_Date_Time__c= datetime.parse(jsonFile.electronic_signature_date_time);
        if(jsonFile.application_completed!=null) app.Application_Completed__c= Boolean.valueOf(jsonFile.application_completed);
         
        if(jsonFile.application_started!=null) app.Application_Started__c= Boolean.valueOf(jsonFile.application_started);
        if(jsonFile.application_question_completed!=null) app.Application_Question_Completed__c= Boolean.valueOf(jsonFile.application_question_completed);
        
        if(jsonFile.step_1_completion_time!=null) app.Step_1_Completion_Time__c= datetime.parse(jsonFile.step_1_completion_time);
        if(jsonFile.step_2_completion_time!=null) app.Step_2_Completion_Time__c= datetime.parse(jsonFile.step_2_completion_time);
        if(jsonFile.step_3_completion_time!=null) app.Step_3_Completion_Time__c= datetime.parse(jsonFile.step_3_completion_time);
        if(jsonFile.step_4_completion_time!=null) app.Step_4_Completion_Time__c= datetime.parse(jsonFile.step_4_completion_time);
        if(jsonFile.step_5_completion_time!=null) app.Step_5_Completion_Time__c= datetime.parse(jsonFile.step_5_completion_time);
        if(jsonFile.step_6_completion_time!=null) app.Step_6_Completion_Time__c= datetime.parse(jsonFile.step_6_completion_time);
        if(jsonFile.step_7_completion_time!=null) app.Step_7_Completion_Time__c= datetime.parse(jsonFile.step_7_completion_time);
        
        if(jsonFile.is_step_1_completed!=null) app.Step_1_Completion_Status__c= String.valueOf(jsonFile.is_step_1_completed);        
        if(jsonFile.is_step_2_completed!=null) app.Step_2_Completion_Status__c= String.valueOf(jsonFile.is_step_2_completed);        
        if(jsonFile.is_step_3_completed!=null) app.Step_3_Completion_Status__c= String.valueOf(jsonFile.is_step_3_completed);        
        if(jsonFile.is_step_4_completed!=null) app.Step_4_Completion_Status__c= String.valueOf(jsonFile.is_step_4_completed);        
        if(jsonFile.is_step_5_completed!=null) app.Step_5_Completion_Status__c= String.valueOf(jsonFile.is_step_5_completed);        
        if(jsonFile.is_step_6_completed!=null) app.Step_6_Completion_Status__c= String.valueOf(jsonFile.is_step_6_completed);        
        if(jsonFile.is_step_7_completed!=null) app.Step_7_Completion_Status__c= String.valueOf(jsonFile.is_step_7_completed);
        
        if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes' && jsonFile.is_step_5_completed=='Yes' && jsonFile.is_step_6_completed=='Yes' && jsonFile.is_step_7_completed=='Yes'){
            app.Application_Completion_Step__c='Step 7';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes' && jsonFile.is_step_5_completed=='Yes' && jsonFile.is_step_6_completed=='Yes'){
            app.Application_Completion_Step__c='Step 6';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes' && jsonFile.is_step_5_completed=='Yes'){
            app.Application_Completion_Step__c='Step 5';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes'){
            app.Application_Completion_Step__c='Step 4';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes'){
            app.Application_Completion_Step__c='Step 3';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes'){
            app.Application_Completion_Step__c='Step 2';
        } else if(jsonFile.is_step_1_completed=='Yes'){    
            app.Application_Completion_Step__c='Step 1';
        }
        
        if(jsonFile.last_logged_in_at!=null) app.Last_Login_at__c= datetime.parse(jsonFile.last_logged_in_at);
        
        if(jsonFile.status!=null) app.Status__c= jsonFile.status;
        
        if(error==true){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error',errorMeaagse); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 400;
        }else{
            
            insert app;
            
            if(jsonFile.lead_uuid!=null && leadId!=''){
                Lead led = new Lead();
                led.Id=leadId;
                led.Portal_Lead__c=true;
                if(leadList.size()>0 && leadList[0].Application__c==null){
                    led.Application__c=app.Id;
                }
                SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=true;
                update led ;
                SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=false;
            }
            Map<String,String> response = new Map<String,String>(); 
            response.put('sfid',app.Id);
            response.put('success','true');
            response.put('message','Application created successfully');
            response.put('loan-number',Splitero_File_Number);
            response.put('loan-amount',jsonFile.loan_amount);
            response.put('interest-rate',jsonFile.interest_rate);
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 200;
        }
        
    }
    
    @HttpPut
    global static void putRequestHandler() 
    {
        System.debug('Inbound Request from SPR Loan API');
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 406;
            return;
        }
        
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
         
        SPR_WebserviceRequest.UpdateApplication updateApplication = (SPR_WebserviceRequest.UpdateApplication)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.UpdateApplication.class);
        
        SPR_WebserviceRequest.CreateApplication jsonFile= updateApplication.update_field_json;
        System.debug('jsonFile-->'+jsonFile);
        String sfid = updateApplication.sfid ;
                

        Application__c app = new Application__c();
        
        app.Id=sfid;
        if(sfid!=null){
            app = [Select Id, Status__c From Application__c Where Id=:sfid];
        }
        String leadId='';
        List<Lead> leadList = new List<Lead>();
        if(jsonFile.lead_uuid!=null){
            leadList = [Select Id,Splitero_File_Number__c,Property__c,Application__c From Lead Where Web_UUID__c=:jsonFile.lead_uuid Limit 1] ; 
            if(leadList.size()>0){
                app.Lead__c=leadList[0].Id;  
                leadId= leadList[0].Id;              
            }            
        }  
         
        if(jsonFile.user_sfid!=null){
            List<Portal_User__c> portalUserList = [Select Id From Portal_User__c Where Id=:jsonFile.user_sfid Limit 1] ; 
            if(portalUserList.size()==0){ 
                Map<String,String> response2 = new Map<String,String>(); 
                response2.put('error','Invalid Port User'); 
                
                res.responseBody = Blob.valueOf(JSON.serialize(response2));
                res.statusCode = 400;
                return;
            }           
        } 
        
        //if(jsonFile.user_sfid!=null) app.User_Sfid__c=jsonFile.user_sfid;
        //if(jsonFile.user_sfid!=null) app.Contact__c=jsonFile.user_sfid;
        if(jsonFile.user_sfid!=null) app.Portal_User__c=jsonFile.user_sfid;
        
        //if(jsonFile.street!=null) app.Street__c=jsonFile.street;
        //if(jsonFile.city!=null) app.City__c=jsonFile.city;
        if(jsonFile.state!=null) app.State__c=jsonFile.state;
        if(jsonFile.zipcode!=null) app.Zipcode__c=jsonFile.zipcode;
        if(jsonFile.home_estimated_price!=null) app.Home_Estimated_Price__c=Decimal.valueOf(jsonFile.home_estimated_price);
        if(jsonFile.splitero_offer_price!=null) app.Splitero_Offer_Price__c=Decimal.valueOf(jsonFile.splitero_offer_price);
        if(jsonFile.fund_required_timeline!=null) app.Fund_Required_Timeline__c=jsonFile.fund_required_timeline;
        if(jsonFile.loan_amount!=null) app.Loan_Amount__c=Decimal.valueOf(jsonFile.loan_amount);
        if(jsonFile.interest_rate!=null) app.Interest_Rate__c=Decimal.valueOf(jsonFile.interest_rate);
        
        if(jsonFile.legal_first_name!=null) app.Legal_First_Name__c= jsonFile.legal_first_name;
        if(jsonFile.legal_middle_name!=null) app.Legal_Middle_Name__c= jsonFile.legal_middle_name;
        if(jsonFile.legal_last_name!=null) app.Legal_Last_Name__c= jsonFile.legal_last_name;
        if(jsonFile.email!=null) app.Email__c= jsonFile.email;
        if(jsonFile.phone_number!=null) app.Phone_Number__c= jsonFile.phone_number;
        if(jsonFile.birthday!=null) app.Birthdate__c= date.parse(jsonFile.birthday);
        
        if(jsonFile.cityzenship_status!=null) app.Citizenship_Status__c= jsonFile.cityzenship_status;
        if(jsonFile.marriatal_status!=null) app.Marital_Status__c= jsonFile.marriatal_status;
        if(jsonFile.property_title_hold!=null) app.Vesting_Type__c= jsonFile.property_title_hold;
        
        if(jsonFile.number_of_co_owners!=null) app.Number_of_Co_Owners_excluding_yourself__c= Integer.valueOf(jsonFile.number_of_co_owners);
        
        Boolean coowner = SPR_WebserviceRequest.setCoOwners(jsonFile,app);
        if(coowner==false){
            Map<String,String> response1 = new Map<String,String>(); 
            response1.put('error','Co-owner First name OR Last Name must have at least 3 character'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response1));
            res.statusCode = 406;
            return;
        }
        System.debug('app-->'+app);
        /*if(jsonFile.co_owners_legal_first_name!=null) app.Co_Owners_Legal_First_name__c= jsonFile.co_owners_legal_first_name;
        if(jsonFile.co_owners_legal_middle_name!=null) app.Co_Owners_Legal_Middle_name__c= jsonFile.co_owners_legal_middle_name;
        if(jsonFile.co_owners_legal_last_name!=null) app.Co_Owners_Legal_Last_name__c= jsonFile.co_owners_legal_last_name;
        if(jsonFile.co_owners_email!=null) app.Co_Owners_Email_Address__c= jsonFile.co_owners_email;
        
        if(jsonFile.co_owners_2_legal_first_name!=null) app.Co_Owner_2_Legal_First_name__c= jsonFile.co_owners_2_legal_first_name;
        if(jsonFile.co_owners_2_legal_middle_name!=null) app.Co_Owner_2_Legal_Middle_name__c= jsonFile.co_owners_2_legal_middle_name;
        if(jsonFile.co_owners_2_legal_last_name!=null) app.Co_Owner_2_Legal_Last_name__c= jsonFile.co_owners_2_legal_last_name;
        if(jsonFile.co_owners_2_email!=null) app.Co_Owner_2_Email_Address__c= jsonFile.co_owners_2_email;
        
        if(jsonFile.co_owners_3_legal_first_name!=null) app.Co_Owner_3_Legal_First_name__c= jsonFile.co_owners_3_legal_first_name;
        if(jsonFile.co_owners_3_legal_middle_name!=null) app.Co_Owner_3_Legal_Middle_name__c= jsonFile.co_owners_3_legal_middle_name;
        if(jsonFile.co_owners_3_legal_last_name!=null) app.Co_Owner_3_Legal_Last_name__c= jsonFile.co_owners_3_legal_last_name;
        if(jsonFile.co_owners_3_email!=null) app.Co_Owner_3_Email_Address__c= jsonFile.co_owners_3_email;
        
        if(jsonFile.co_owners_4_legal_first_name!=null) app.Co_Owner_4_Legal_First_name__c= jsonFile.co_owners_4_legal_first_name;
        if(jsonFile.co_owners_4_legal_middle_name!=null) app.Co_Owner_4_Legal_Middle_name__c= jsonFile.co_owners_4_legal_middle_name;
        if(jsonFile.co_owners_4_legal_last_name!=null) app.Co_Owner_4_Legal_Last_name__c= jsonFile.co_owners_4_legal_last_name;
        if(jsonFile.co_owners_4_email!=null) app.Co_Owner_4_Email_Address__c= jsonFile.co_owners_4_email;
        */
        
        
        if(jsonFile.beneficiary_of_the_trust!=null) app.is_Beneficiary_of_Trust__c= jsonFile.beneficiary_of_the_trust;
        if(jsonFile.signing_authority_for_llc!=null) app.Signing_authority_for_LLC__c= jsonFile.signing_authority_for_llc;
        
        if(jsonFile.primary_use_of_property!=null) app.Primary_Use_of_Property__c= jsonFile.primary_use_of_property;
        if(jsonFile.primary_residence_street!=null) app.Primary_Street__c= jsonFile.primary_residence_street;
        if(jsonFile.primary_residence_city!=null) app.Primary_City__c= jsonFile.primary_residence_city;
        if(jsonFile.primary_residence_state!=null) app.Primary_State_Province__c= jsonFile.primary_residence_state;
        if(jsonFile.primary_residence_zipcode!=null) app.Primary_Zip_Postal_Code__c= jsonFile.primary_residence_zipcode;
        
        
        if(jsonFile.intended_to_rent_in_12_month!=null) app.Intend_to_rent_in_next_12_months__c= jsonFile.intended_to_rent_in_12_month;
        if(jsonFile.have_primary_mortgage!=null) app.X1st_Mortgage_Exists__c= jsonFile.have_primary_mortgage;
        if(jsonFile.principal_balance_on_primary_mortgage!=null) app.X1st_Mortgage_Balance__c=Decimal.valueOf(jsonFile.principal_balance_on_primary_mortgage);
        if(jsonFile.primary_mortgage_terms_been_modified!=null) app.x1st_Loan_Mod__c= jsonFile.primary_mortgage_terms_been_modified;
        if(jsonFile.primary_mortgage_in_forbearance!=null) app.X1st_Forbearance__c= jsonFile.primary_mortgage_in_forbearance;
        
        if(jsonFile.have_second_mortgage!=null) app.X2nd_Mortgage_Exists__c= jsonFile.have_second_mortgage;
        if(jsonFile.principal_balance_of_second_mortgage!=null) app.X2nd_Mortgage_Balance__c=Decimal.valueOf(jsonFile.principal_balance_of_second_mortgage);
        if(jsonFile.second_mortgage_terms_been_modified!=null) app.X2nd_Loan_Mod__c= jsonFile.second_mortgage_terms_been_modified;
        if(jsonFile.second_mortgage_in_forbearance!=null) app.X2nd_Forbearance__c= jsonFile.second_mortgage_in_forbearance;
        
        
        if(jsonFile.have_home_equity_loan!=null) app.Home_Equity_Loan_or_HELOC__c= jsonFile.have_home_equity_loan;
        if(jsonFile.heloc_within_draw_period!=null) app.Is_HELOC_in_Draw_Period__c= jsonFile.heloc_within_draw_period;
        if(jsonFile.heloc_max_draw_amount!=null) app.HELOC_Max_Draw_Amount__c=Decimal.valueOf(jsonFile.heloc_max_draw_amount);
        if(jsonFile.heloc_current_balance!=null) app.HELOC_Balance__c=Decimal.valueOf(jsonFile.heloc_current_balance);
        if(jsonFile.hero_or_pace_loan!=null) app.HERO_or_PACE_loan__c= jsonFile.hero_or_pace_loan;
        if(jsonFile.solar_or_energy_efficiency_loan_detail!=null) app.Solar_or_Energy_Efficiency_Loan_Detail__c= jsonFile.solar_or_energy_efficiency_loan_detail;
        if(jsonFile.solar_or_energy_efficiency_loan_yn!=null) app.Solar_or_Energy_Efficient_Loan__c = jsonFile.solar_or_energy_efficiency_loan_yn;
        
        if(jsonFile.property_part_of_hoa_or_condo!=null) app.HOA__c= jsonFile.property_part_of_hoa_or_condo;
        if(jsonFile.delinquencies_on_your_property_taxes!=null) app.Property_Taxes__c= jsonFile.delinquencies_on_your_property_taxes;
         
        if(jsonFile.property_used_for_commercial_agricultural!=null) app.Property_used_for_Commercial_or_Agricult__c= jsonFile.property_used_for_commercial_agricultural;
        if(jsonFile.commercial_agricultural_use_detail!=null) app.Property_Commercial_or_Ag_Explaination__c= jsonFile.commercial_agricultural_use_detail;
        if(jsonFile.home_actively_listed_for_sale!=null) app.Property_listed_or_under_contract__c= jsonFile.home_actively_listed_for_sale;
        if(jsonFile.current_list_or_contract_price!=null) app.Current_List_Price_or_Contract_Price__c=Decimal.valueOf(jsonFile.current_list_or_contract_price);
        if(jsonFile.current_list_price_contract_price_detail!=null) app.current_list_price_contract_price_detail__c=String.valueOf(jsonFile.current_list_price_contract_price_detail);
        if(jsonFile.hazardous_materials_on_the_property!=null) app.Hazardous_Substances__c= jsonFile.hazardous_materials_on_the_property;
         
        
        if(jsonFile.hazardous_materials_detail!=null) app.Hazardous_Substances_Explanation__c= jsonFile.hazardous_materials_detail;
        if(jsonFile.any_structural_modifications_without_permits!=null) app.Unpermitted_WorkCode_Violations_Non_Co__c= jsonFile.any_structural_modifications_without_permits;
        if(jsonFile.structural_modifications_detail!=null) app.unperm_work_code_viol_NC_Explaination__c= jsonFile.structural_modifications_detail;
        if(jsonFile.ongoing_or_pending_lawsuits_against_property!=null) app.Ongoing_or_Pending_Lawsuits_or_actions__c= jsonFile.ongoing_or_pending_lawsuits_against_property;
        if(jsonFile.ongoing_or_pending_lawsuits_detail!=null) app.Ongoing_Pending_Lawsuits_or_actions_Expl__c= jsonFile.ongoing_or_pending_lawsuits_detail;
        if(jsonFile.property_include_accessory_dwelling_unit!=null) app.ADUsGranny_Flats_Inlaw_units__c= jsonFile.property_include_accessory_dwelling_unit;
        if(jsonFile.property_currently_under_renovation!=null) app.Current_or_Soon_to_Commence_Remodels__c= jsonFile.property_currently_under_renovation;
        if(jsonFile.under_renovation_detail!=null) app.Current_or_Soon_to_commence_Remodels_Exp__c= jsonFile.under_renovation_detail;
        if(jsonFile.any_major_systems_need_repair!=null) app.Major_System_Faliors__c= jsonFile.any_major_systems_need_repair;
        if(jsonFile.major_repair_detail!=null) app.Major_System_Failures_Explanation__c= jsonFile.major_repair_detail;
        if(jsonFile.amount_needed_from_splitero!=null) app.Desired_Investment__c=Decimal.valueOf(jsonFile.amount_needed_from_splitero);
        if(jsonFile.intention_to_use_fund!=null) app.How_will_you_use_these_Funds_Single__c = jsonFile.intention_to_use_fund;
        if(jsonFile.intention_to_use_fund_multi!=null) app.How_will_you_use_these_Funds__c = jsonFile.intention_to_use_fund_multi;
        if(jsonFile.explain_fund_usage!=null) app.How_Will_you_use_these_Fundsnotes__c= jsonFile.explain_fund_usage;
        if(jsonFile.pleaded_financial_crimes!=null) app.Financial_Crimes__c= jsonFile.pleaded_financial_crimes;
        if(jsonFile.pleaded_financial_crimes_detail!=null) app.Financial_Crime_Explanation__c= jsonFile.pleaded_financial_crimes_detail;
        if(jsonFile.any_bankruptcy_filed!=null) app.Bankruptcy_last_4_years__c= jsonFile.any_bankruptcy_filed;
        
        
        if(jsonFile.any_bankruptcy_filed_detail!=null) app.Bankruptcy_last_4_years_Explanation__c= jsonFile.any_bankruptcy_filed_detail;
        if(jsonFile.directly_indirectly_obligated_loan_foreclosure!=null) app.Foreclosure_last_7_years__c= jsonFile.directly_indirectly_obligated_loan_foreclosure;
        if(jsonFile.planning_on_new_loans_secured_by_proper!=null) app.Planning_On_New_Loans_Secured_by_Proper__c= jsonFile.planning_on_new_loans_secured_by_proper;
        if(jsonFile.plan_new_loans_secured_by_property_expl!=null) app.Plan_new_loans_secured_by_property_Expl__c= jsonFile.plan_new_loans_secured_by_property_expl;
               
        if(jsonFile.delinquency_in_your_hoa_dues!=null) app.Do_you_have_any_delinquency_in_your_HOA__c= jsonFile.delinquency_in_your_hoa_dues;
        
        if(jsonFile.full_address!=null) app.Property_Address__c= jsonFile.full_address;
        if(jsonFile.directly_indirectly_obligated_loan_foreclosure_detail!=null) app.Directly_Indirectly_Obligated_Loan_Forec__c= jsonFile.directly_indirectly_obligated_loan_foreclosure_detail;
        if(jsonFile.plan_on_incurring_new_debts_on_property!=null) app.Plan_On_Incurring_New_Debts_On_Property__c= jsonFile.plan_on_incurring_new_debts_on_property;
        if(jsonFile.incurring_new_debts_detail!=null) app.Incurring_New_Debts_Detail__c= jsonFile.incurring_new_debts_detail;
        if(jsonFile.consent_credit_report!=null) app.I_hereby_authorize_Splitero_to_obtain_my__c= jsonFile.consent_credit_report;
        if(jsonFile.consent_disclosure_of_accounts!=null) app.Consent_Disclosure_Of_Accounts__c= jsonFile.consent_disclosure_of_accounts;
        if(jsonFile.consent_share_my_information_with_third_parties!=null) app.consent_share_my_information_with_third__c= jsonFile.consent_share_my_information_with_third_parties;
        
        if(jsonFile.consent_for_electronic_signature_and_communication!=null) app.consent_for_electronic_signature_and_com__c= jsonFile.consent_for_electronic_signature_and_communication;
        if(jsonFile.consent_acknowledge_splitero_discolosure_policies!=null) app.Consent_Acknowledge_Splitero_Discolosure__c= jsonFile.consent_acknowledge_splitero_discolosure_policies;
        if(jsonFile.electronic_signature_full_name!=null) app.Electronic_Signature__c= jsonFile.electronic_signature_full_name;
        if(jsonFile.social_security_number!=null) app.Social_Security_Number__c= jsonFile.social_security_number;
         
        if(jsonFile.delinquencies_detail!=null) app.Please_Explain__c= jsonFile.delinquencies_detail;
        
        if(jsonFile.application_completion_date!=null) app.Application_Completion_Date__c= datetime.parse(jsonFile.application_completion_date);
        if(jsonFile.application_consent_given_date!=null) app.Application_Consent_Given_Date__c= datetime.parse(jsonFile.application_consent_given_date);
        if(jsonFile.application_documents_submitted_date!=null) app.Application_Documents_Submitted_Date__c= datetime.parse(jsonFile.application_documents_submitted_date);
        
         
        if(jsonFile.electronic_signature_date_time!=null) app.Electronic_Signature_Date_Time__c= datetime.parse(jsonFile.electronic_signature_date_time);
       
        if(app.Status__c!='Inquiring'){
            if(jsonFile.status!=null) app.Status__c= jsonFile.status;
        }
        
        if(jsonFile.application_completed!=null) app.Application_Completed__c= Boolean.valueOf(jsonFile.application_completed);
                
        if(jsonFile.application_started!=null) app.Application_Started__c= Boolean.valueOf(jsonFile.application_started);
        if(jsonFile.application_question_completed!=null) app.Application_Question_Completed__c= Boolean.valueOf(jsonFile.application_question_completed);
        
        if(jsonFile.step_1_completion_time!=null) app.Step_1_Completion_Time__c= datetime.parse(jsonFile.step_1_completion_time);
        if(jsonFile.step_2_completion_time!=null) app.Step_2_Completion_Time__c= datetime.parse(jsonFile.step_2_completion_time);
        if(jsonFile.step_3_completion_time!=null) app.Step_3_Completion_Time__c= datetime.parse(jsonFile.step_3_completion_time);
        if(jsonFile.step_4_completion_time!=null) app.Step_4_Completion_Time__c= datetime.parse(jsonFile.step_4_completion_time);
        if(jsonFile.step_5_completion_time!=null) app.Step_5_Completion_Time__c= datetime.parse(jsonFile.step_5_completion_time);
        if(jsonFile.step_6_completion_time!=null) app.Step_6_Completion_Time__c= datetime.parse(jsonFile.step_6_completion_time);
        if(jsonFile.step_7_completion_time!=null) app.Step_7_Completion_Time__c= datetime.parse(jsonFile.step_7_completion_time);
        
        if(jsonFile.is_step_1_completed!=null) app.Step_1_Completion_Status__c= String.valueOf(jsonFile.is_step_1_completed);        
        if(jsonFile.is_step_2_completed!=null) app.Step_2_Completion_Status__c= String.valueOf(jsonFile.is_step_2_completed);        
        if(jsonFile.is_step_3_completed!=null) app.Step_3_Completion_Status__c= String.valueOf(jsonFile.is_step_3_completed);        
        if(jsonFile.is_step_4_completed!=null) app.Step_4_Completion_Status__c= String.valueOf(jsonFile.is_step_4_completed);        
        if(jsonFile.is_step_5_completed!=null) app.Step_5_Completion_Status__c= String.valueOf(jsonFile.is_step_5_completed);        
        if(jsonFile.is_step_6_completed!=null) app.Step_6_Completion_Status__c= String.valueOf(jsonFile.is_step_6_completed);        
        if(jsonFile.is_step_7_completed!=null) app.Step_7_Completion_Status__c= String.valueOf(jsonFile.is_step_7_completed);
        
        if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes' && jsonFile.is_step_5_completed=='Yes' && jsonFile.is_step_6_completed=='Yes' && jsonFile.is_step_7_completed=='Yes'){
            app.Application_Completion_Step__c='Step 7';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes' && jsonFile.is_step_5_completed=='Yes' && jsonFile.is_step_6_completed=='Yes'){
            app.Application_Completion_Step__c='Step 6';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes' && jsonFile.is_step_5_completed=='Yes'){
            app.Application_Completion_Step__c='Step 5';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes' && jsonFile.is_step_4_completed=='Yes'){
            app.Application_Completion_Step__c='Step 4';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes' && jsonFile.is_step_3_completed=='Yes'){
            app.Application_Completion_Step__c='Step 3';
        } else if(jsonFile.is_step_1_completed=='Yes' && jsonFile.is_step_2_completed=='Yes'){
            app.Application_Completion_Step__c='Step 2';
        } else if(jsonFile.is_step_1_completed=='Yes'){    
            app.Application_Completion_Step__c='Step 1';
        }
        
        if(jsonFile.last_logged_in_at!=null) app.Last_Login_at__c= datetime.parse(jsonFile.last_logged_in_at);
        
        Map<String,String> response = new Map<String,String>(); 
        Application__c existingApp = [Select Id, Application_Completed__c From Application__c Where Id=:sfid] ;
        if(existingApp.Application_Completed__c==True){
            response.put('success','false');
            response.put('error','Application is read-only  ');
        }else{
            try{
                update app;
                if(jsonFile.lead_uuid!=null && leadId!=''){
                    Lead led = new Lead();
                    led.Id=leadId;
                    led.Portal_Lead__c=true;
                    if(leadList.size()>0 && leadList[0].Application__c==null){
                        led.Application__c=app.Id;
                    }
                    SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=true;
                    update led ;
                    SPR_LeadTriggerHelperCntrl.ByPassAllTrigger=false;
                }
                
                response.put('success','true');
                 
            	response.put('message','Application updated successfully');
            }catch(Exception e){
                response.put('success','false');
                response.put('error',e.getMessage());
            }
        }       
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
    
    
    @HttpGet
    global static void getRequestHandler() 
    {
        System.debug('Inbound Request from SPR User API');
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        if(jsonReferer!=Label.SPR_API_Referer){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error','Invalid Referer'); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 406;
            return;
        }
        
        String sfid = RestContext.request.params.get('sfid'); 
        SYstem.debug('sfid-->'+sfid);
        
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
            query += ' Current_List_Price_or_Contract_Price__c,current_list_price_contract_price_detail__c, Hazardous_Substances__c, Hazardous_Substances_Explanation__c, ' ;
            query += ' Unpermitted_WorkCode_Violations_Non_Co__c, unperm_work_code_viol_NC_Explaination__c, Ongoing_or_Pending_Lawsuits_or_actions__c, ' ;
            query += ' Ongoing_Pending_Lawsuits_or_actions_Expl__c, ADUsGranny_Flats_Inlaw_units__c, Current_or_Soon_to_Commence_Remodels__c, Current_or_Soon_to_commence_Remodels_Exp__c, Major_System_Faliors__c, ' ;
            query += ' Major_System_Failures_Explanation__c, Desired_Investment__c, How_will_you_use_these_Funds_single__c, How_Will_you_use_these_Fundsnotes__c, Financial_Crimes__c, Financial_Crime_Explanation__c, ' ;
            query += ' Bankruptcy_last_4_years__c, Bankruptcy_last_4_years_Explanation__c, Foreclosure_last_7_years__c, Planning_On_New_Loans_Secured_by_Proper__c, Plan_new_loans_secured_by_property_Expl__c, Do_you_have_any_delinquency_in_your_HOA__c,' ;
            query += ' Property_Address__c, Directly_Indirectly_Obligated_Loan_Forec__c, Plan_On_Incurring_New_Debts_On_Property__c, Incurring_New_Debts_Detail__c, I_hereby_authorize_Splitero_to_obtain_my__c, Consent_Disclosure_Of_Accounts__c, ' ;
            query += ' consent_share_my_information_with_third__c, consent_for_electronic_signature_and_com__c, Consent_Acknowledge_Splitero_Discolosure__c, Electronic_Signature__c, Social_Security_Number__c, Please_Explain__c, Application_Completion_Date__c,' ;
            query += ' Application_Consent_Given_Date__c, Application_Documents_Submitted_Date__c, Electronic_Signature_Date_Time__c, Status__c, Application_Completed__c, Application_Started__c, Application_Question_Completed__c, Step_1_Completion_Time__c, Step_2_Completion_Time__c,' ;
            query += ' Step_3_Completion_Time__c, Step_4_Completion_Time__c, Step_5_Completion_Time__c, Step_6_Completion_Time__c, Step_7_Completion_Time__c, Step_1_Completion_Status__c, Step_2_Completion_Status__c, Step_3_Completion_Status__c, Step_4_Completion_Status__c, Step_5_Completion_Status__c,' ; 
            query += ' Step_6_Completion_Status__c, Step_7_Completion_Status__c, Application_Completion_Step__c, Last_Login_at__c ' ; 
            query += ' ,Loan_Number__c, How_will_you_use_these_Funds__c, Lead__r.Home_Owner_Advisor__c ';
            query += ' From Application__c Where Id=:sfid and Contact__c!=null '  ;
        
        Application__c app = Database.query(query) ;
        SYstem.debug('app-->'+app);
 
        SPR_WebserviceRequest.CreateApplication response = SPR_SyncApplicationToWebUtility.CreateApplication(app);
         
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
         
}