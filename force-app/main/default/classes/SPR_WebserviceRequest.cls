public class SPR_WebserviceRequest {

    public class CreateContact{
        public String cognito_key;
        public String first_name;
        public String last_name;
        public String email;
        public String phone;
        public String birthdate;
        public String citizenship;
        public String marital_status;
        public String intention_to_use_fund;
        public String reffered_by;
        public String lead_uuid; 
        public String fund_required_timeline;
        public STring how_will_you_use_investment;
        public String sfid;
        
    }
    
    public class CreateContactResponse {
        public String sfid;
        public String home_owner_adviser_sfid;
        public Map<String,String> home_owner_adviser_object;
         
    }
    
    public class CreateApplication{
        public String sfid;
        public String user_sfid;
        public String street;
        public String city;
        public String state;
        public String zipcode;
        public String home_estimated_price;
        public String splitero_offer_price;
        public String fund_required_timeline;
        public String lead_uuid; 
        public String loan_amount;
        public String loan_number;
        public String interest_rate;
        
        public String legal_first_name;
        public String legal_middle_name;
        public String legal_last_name;
        public String email;
        public String phone_number;
        public String birthday;
        
        public String cityzenship_status;
        public String marriatal_status;
        public String vesting_type;
        public String property_title_hold;
        
        public String co_owners_legal_first_name;
        public String co_owners_legal_middle_name ;
        public String co_owners_legal_last_name ;
        public String co_owners_email ;
        
        public String co_owners_2_legal_first_name;
        public String co_owners_2_legal_middle_name ;
        public String co_owners_2_legal_last_name ;
        public String co_owners_2_email ;
        
        public String co_owners_3_legal_first_name;
        public String co_owners_3_legal_middle_name ;
        public String co_owners_3_legal_last_name ;
        public String co_owners_3_email ;
        
        public String co_owners_4_legal_first_name;
        public String co_owners_4_legal_middle_name ;
        public String co_owners_4_legal_last_name ;
        public String co_owners_4_email ;
                
        public String number_of_co_owners ;
        
        public String beneficiary_of_the_trust ;
        public String signing_authority_for_llc ;
        
        public String primary_use_of_property ;
        public String primary_residence_street ;
        public String primary_residence_city ;
        public String primary_residence_state ;
        public String primary_residence_zipcode ;
        
        public String intended_to_rent_in_12_month ;
        public String have_primary_mortgage ;
        public String principal_balance_on_primary_mortgage ;
        public String primary_mortgage_terms_been_modified ;
        public String primary_mortgage_in_forbearance ;
        
        public String have_second_mortgage ;
        public String principal_balance_of_second_mortgage ;
        public String second_mortgage_terms_been_modified ;
        public String second_mortgage_in_forbearance ;
        
        public String have_home_equity_loan ;
        public String heloc_within_draw_period ;
        public String heloc_max_draw_amount ;
        public String heloc_current_balance ;
        public String hero_or_pace_loan ;
        public String solar_or_energy_efficiency_loan ;
        public String property_part_of_hoa_or_condo ;
        public String delinquencies_on_your_property_taxes ;
         
        public String property_used_for_commercial_agricultural ;
        public String commercial_agricultural_use_detail ;
         
        public String home_actively_listed_for_sale ;
        public String current_list_or_contract_price ;
        public String current_list_price_contract_price_detail;
        public String hazardous_materials_on_the_property ;
        public String hazardous_materials_detail ;
        public String any_structural_modifications_without_permits ;
        public String structural_modifications_detail ;
        public String ongoing_or_pending_lawsuits_against_property ;
        public String ongoing_or_pending_lawsuits_detail ;
        public String property_include_accessory_dwelling_unit ;
        public String property_currently_under_renovation ;
        public String under_renovation_detail ;
        public String any_major_systems_need_repair ;
        public String major_repair_detail ;
        public String amount_needed_from_splitero ;
        public String intention_to_use_fund ;
        public String intention_to_use_fund_multi;
       
        public String explain_fund_usage ;
        public String pleaded_financial_crimes ;
        public String pleaded_financial_crimes_detail ;
        public String any_bankruptcy_filed ;
        public String any_bankruptcy_filed_detail;
        public String directly_indirectly_obligated_loan_foreclosure;
        public String planning_on_new_loans_secured_by_proper;
        public String plan_new_loans_secured_by_property_expl;
        public String delinquency_in_your_hoa_dues;
        public String full_address;
        public String directly_indirectly_obligated_loan_foreclosure_detail;
        public String plan_on_incurring_new_debts_on_property;
        public String incurring_new_debts_detail;
        public String consent_credit_report;
        public String consent_disclosure_of_accounts;
        public String consent_share_my_information_with_third_parties;
        public String consent_for_electronic_signature_and_communication;
        public String consent_acknowledge_splitero_discolosure_policies;
        public String electronic_signature_full_name;
        public String social_security_number;
        public String delinquencies_detail;
        public String application_completion_date;
        public String application_consent_given_date;
		public String application_documents_submitted_date;
         
        public String electronic_signature_date_time;
        public String status;
		public String application_completed;
        public String solar_or_energy_efficiency_loan_detail;
        public String application_started;
        public String application_question_completed;
        public String solar_or_energy_efficiency_loan_yn;
        
        public String step_1_completion_time;
        public String is_step_1_completed;
        public String step_2_completion_time;
        public String is_step_2_completed;
        public String step_3_completion_time;
        public String is_step_3_completed;
        public String step_4_completion_time;
        public String is_step_4_completed;
        public String step_5_completion_time;
        public String is_step_5_completed;
        public String step_6_completion_time;
        public String is_step_6_completed;
        public String step_7_completion_time;
        public String is_step_7_completed;
        public String last_logged_in_at; 
        
        public String home_owner_adviser_sfid;
        public String is_active;
        
        public List<Co_owners> co_owners;
         
         
    }
    
    public class UpdateApplication{
        public String sfid;
        public CreateApplication update_field_json; 
        
    }
    
    public class CreateFileApplication{
        public String aws_file_key;
        public String aws_file_full_path;
        public String document_key;
        public String loan_sfid;
        public String file_name;
        public String folder_name;
        public String file_type;
         
        public String sfid; 
         
    }
    
    public class Co_owners {
		public Integer id;
		public String first_name;
		public String middle_name;
		public String last_name;
		public String email;
	}
    
    public static Boolean setCoOwners(SPR_WebserviceRequest.CreateApplication jsonFile,Application__c app ){
        
        Boolean response=True;
        List<SPR_WebserviceRequest.Co_owners> co_ownerList = jsonFile.co_owners;
        //Application__c app = new Application__c();
        
        System.debug('co_ownerList-->'+co_ownerList);
        app.Co_Owners_Legal_First_name__c='';
        app.Co_Owners_Legal_Middle_name__c='';
        app.Co_Owners_Legal_Last_name__c='';
        app.Co_Owners_Email_Address__c='';
        
        app.Co_Owner_2_Legal_First_name__c= '';
        app.Co_Owner_2_Legal_Middle_name__c= '';
        app.Co_Owner_2_Legal_Last_name__c= '';
        app.Co_Owner_2_Email_Address__c='';
        
        app.Co_Owner_3_Legal_First_name__c='';
        app.Co_Owner_3_Legal_Middle_name__c= '';
        app.Co_Owner_3_Legal_Last_name__c= '';
        app.Co_Owner_3_Email_Address__c='';
        
        app.Co_Owner_4_Legal_First_name__c='';
        app.Co_Owner_4_Legal_Middle_name__c='';
        app.Co_Owner_4_Legal_Last_name__c='';
        app.Co_Owner_4_Email_Address__c='';         
        
        if(co_ownerList.size()>0){
            Map<Integer,SPR_WebserviceRequest.Co_owners> coOwnerMap = new Map<Integer,SPR_WebserviceRequest.Co_owners>();
            Integer count=0;
            for(SPR_WebserviceRequest.Co_owners ocowner: co_ownerList){
                coOwnerMap.put(count,ocowner);
                count++;
            }
            
            app.Co_Owners_Legal_First_name__c=coOwnerMap.containsKey(0)?coOwnerMap.get(0).first_name:'' ;
            app.Co_Owners_Legal_Middle_name__c=coOwnerMap.containsKey(0)?coOwnerMap.get(0).middle_name:'' ;
            app.Co_Owners_Legal_Last_name__c=coOwnerMap.containsKey(0)?coOwnerMap.get(0).last_name:'' ;
            app.Co_Owners_Email_Address__c=coOwnerMap.containsKey(0)?coOwnerMap.get(0).email:'' ;
            
            app.Co_Owner_2_Legal_First_name__c=coOwnerMap.containsKey(1)?coOwnerMap.get(1).first_name:'' ;
            app.Co_Owner_2_Legal_Middle_name__c=coOwnerMap.containsKey(1)?coOwnerMap.get(1).middle_name:'' ;
            app.Co_Owner_2_Legal_Last_name__c=coOwnerMap.containsKey(1)?coOwnerMap.get(1).last_name:'' ;
            app.Co_Owner_2_Email_Address__c=coOwnerMap.containsKey(1)?coOwnerMap.get(1).email:'' ;
             
            app.Co_Owner_3_Legal_First_name__c=coOwnerMap.containsKey(2)?coOwnerMap.get(2).first_name:'' ;
            app.Co_Owner_3_Legal_Middle_name__c=coOwnerMap.containsKey(2)?coOwnerMap.get(2).middle_name:'' ;
            app.Co_Owner_3_Legal_Last_name__c=coOwnerMap.containsKey(2)?coOwnerMap.get(2).last_name:'' ;
            app.Co_Owner_3_Email_Address__c=coOwnerMap.containsKey(2)?coOwnerMap.get(2).email:'' ;
            
            app.Co_Owner_4_Legal_First_name__c=coOwnerMap.containsKey(3)?coOwnerMap.get(3).first_name:'' ;
            app.Co_Owner_4_Legal_Middle_name__c=coOwnerMap.containsKey(3)?coOwnerMap.get(3).middle_name:'' ;
            app.Co_Owner_4_Legal_Last_name__c=coOwnerMap.containsKey(3)?coOwnerMap.get(3).last_name:'' ;
            app.Co_Owner_4_Email_Address__c=coOwnerMap.containsKey(3)?coOwnerMap.get(3).email:'' ;
            
            if( (coOwnerMap.containsKey(0) && ( coOwnerMap.get(0).first_name.length()<1 || coOwnerMap.get(0).last_name.length()<1) ) ||	(coOwnerMap.containsKey(1) && ( coOwnerMap.get(1).first_name.length()<1 || coOwnerMap.get(1).last_name.length()<1) ) || (coOwnerMap.containsKey(2) && ( coOwnerMap.get(2).first_name.length()<1 || coOwnerMap.get(2).last_name.length()<1) ) || (coOwnerMap.containsKey(3) && ( coOwnerMap.get(3).first_name.length()<1 || coOwnerMap.get(3).last_name.length()<1) )){
                response=false;
            }
            
        }
        
        return response;
    }
    
    public class DocumentRequest{
        public String lead_uuid;
        public String recordType;
        public String status;
    }
    
    public class DocumentResponse{
        public String lead_uuid;
        public String OppurtunityId;
        public String LeadId;
        Public List<Documents> Documents;
        Public Boolean success;
        Public String message;
    }
    
    public class Documents{
        public String id;
        public String document_type_title;
        public Boolean is_reqired;
        public String document_key;
        public String s3_folder_key;
        public String aws_file_key;
        public String aws_file_path;
    }
    
}