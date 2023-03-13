@isTest
public class SPR_WebsiteLoanInboundServiceTest {

    @isTest
    public static void testPostMethod406(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        
        String requestData='{"user_sfid":"'+con.Id+'",  "state":"AK",  "zipcode":"Yes",  "home_estimated_price":"1234",  "splitero_offer_price":"3234",  "fund_required_timeline":"30-90 Days",  "loan_amount":"1111",  "interest_rate":"22",  "lead_uuid":"HTI8G83WKG",  "legal_first_name":"Yes",  "legal_middle_name":"Yes",  "legal_last_name":"Yes",  "email":"Yes@Yes.com",  "phone_number":"1234567890",  "birthday":"02/07/1983",  "cityzenship_status":"Visa Holder",  "marriatal_status":"Married",  "property_title_hold":"Individual",  "number_of_co_owners":"3",  "co_owners_legal_first_name":"Yes",  "co_owners_legal_middle_name":"Yes",  "co_owners_legal_last_name":"Yes",  "co_owners_email":"Yes@abab.com",  "co_owners_2_legal_first_name":"Yes",  "co_owners_2_legal_middle_name":"Yes",  "co_owners_2_legal_last_name":"Yes",  "co_owners_2_email":"Yesasas@asas.com",  "co_owners_3_legal_first_name":"Yes",  "co_owners_3_legal_middle_name":"Yes",  "co_owners_3_legal_last_name":"Yes",  "co_owners_3_email":"Yesweweew@asas.com",  "co_owners_4_legal_first_name":"Yes",  "co_owners_4_legal_middle_name":"Yes",  "co_owners_4_legal_last_name":"Yes",  "co_owners_4_email":"Yessfdgsdfg@asasa.com",  "beneficiary_of_the_trust":"Yes",  "signing_authority_for_llc":"Yes",  "primary_use_of_property":"Second Home",  "primary_residence_street":"Yes",  "primary_residence_city":"Yes",  "primary_residence_state":"AK",  "primary_residence_zipcode":"Yes",  "intended_to_rent_in_12_month":"Yes",  "have_primary_mortgage":"Yes",  "principal_balance_on_primary_mortgage":"12333",  "primary_mortgage_terms_been_modified":"Yes",  "primary_mortgage_in_forbearance":"Yes",  "have_second_mortgage":"Yes",  "principal_balance_of_second_mortgage":"3344",  "second_mortgage_terms_been_modified":"Yes",  "second_mortgage_in_forbearance":"Yes",  "have_home_equity_loan":"Yes",  "heloc_within_draw_period":"Yes",  "heloc_max_draw_amount":"455",  "heloc_current_balance":"4335",  "hero_or_pace_loan":"Yes",  "solar_or_energy_efficiency_loan":"Yes",  "property_part_of_hoa_or_condo":"Yes",  "delinquencies_on_your_property_taxes":"Current",  "property_used_for_commercial_agricultural":"Yes",  "commercial_agricultural_use_detail":"Yes",  "home_actively_listed_for_sale":"Yes",  "current_list_or_contract_price":"234343",  "hazardous_materials_on_the_property":"Yes",  "hazardous_materials_detail":"Yes",  "any_structural_modifications_without_permits":"Yes",  "structural_modifications_detail":"Yes",  "ongoing_or_pending_lawsuits_against_property":"Yes",  "ongoing_or_pending_lawsuits_detail":"Yes",  "property_include_accessory_dwelling_unit":"Yes",  "property_currently_under_renovation":"Yes",  "under_renovation_detail":"Yes",  "any_major_systems_need_repair":"Yes",  "major_repair_detail":"Yes",  "amount_needed_from_splitero":"56565",  "intention_to_use_fund":"Small Business",  "explain_fund_usage":"Yes",  "pleaded_financial_crimes":"Yes",  "pleaded_financial_crimes_detail":"Yes",  "any_bankruptcy_filed":"Yes",  "any_bankruptcy_filed_detail":"Yes",  "directly_indirectly_obligated_loan_foreclosure":"Yes",  "planning_on_new_loans_secured_by_proper":"Yes",  "plan_new_loans_secured_by_property_expl":"Yes"  } ';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/loan/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLoanInboundService.postRequestHandler();
        
        Test.stopTest();
        
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testPostMethod(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        
        Portal_User__c portalUser = new Portal_User__c();
        //portalUser.Application__c='';
        portalUser.Cognito_Key__c='connitokey';
        portalUser.Email__c='test@test.com';
        portalUser.First_Name__c='testf';
        portalUser.Last_Name__c='testl';
        portalUser.Lead__c=l.Id;
        portalUser.Phone_Number__c='1234456778';
        //portalUser.Last_Logged_In__c='';
        insert portalUser ; 
        
        String requestData='{"user_sfid":"'+portalUser.Id+'",  "state":"AK",  "zipcode":"Yes",  "home_estimated_price":"1234",  "splitero_offer_price":"3234",  "fund_required_timeline":"30-90 Days",  "loan_amount":"1111",  "interest_rate":"22",  "lead_uuid":"HTI8G83WKG",  "legal_first_name":"Yes",  "legal_middle_name":"Yes",  "legal_last_name":"Yes",  "email":"Yes@Yes.com",  "phone_number":"1234567890",  "birthday":"02/07/1983",  "cityzenship_status":"Visa Holder",  "marriatal_status":"Married",  "property_title_hold":"Individual",  "number_of_co_owners":"3",  "co_owners_legal_first_name":"Yes",  "co_owners_legal_middle_name":"Yes",  "co_owners_legal_last_name":"Yes",  "co_owners_email":"Yes@abab.com",  "co_owners_2_legal_first_name":"Yes",  "co_owners_2_legal_middle_name":"Yes",  "co_owners_2_legal_last_name":"Yes",  "co_owners_2_email":"Yesasas@asas.com",  "co_owners_3_legal_first_name":"Yes",  "co_owners_3_legal_middle_name":"Yes",  "co_owners_3_legal_last_name":"Yes",  "co_owners_3_email":"Yesweweew@asas.com",  "co_owners_4_legal_first_name":"Yes",  "co_owners_4_legal_middle_name":"Yes",  "co_owners_4_legal_last_name":"Yes",  "co_owners_4_email":"Yessfdgsdfg@asasa.com",  "beneficiary_of_the_trust":"Yes",  "signing_authority_for_llc":"Yes",  "primary_use_of_property":"Second Home",  "primary_residence_street":"Yes",  "primary_residence_city":"Yes",  "primary_residence_state":"AK",  "primary_residence_zipcode":"Yes",  "intended_to_rent_in_12_month":"Yes",  "have_primary_mortgage":"Yes",  "principal_balance_on_primary_mortgage":"12333",  "primary_mortgage_terms_been_modified":"Yes",  "primary_mortgage_in_forbearance":"Yes",  "have_second_mortgage":"Yes",  "principal_balance_of_second_mortgage":"3344",  "second_mortgage_terms_been_modified":"Yes",  "second_mortgage_in_forbearance":"Yes",  "have_home_equity_loan":"Yes",  "heloc_within_draw_period":"Yes",  "heloc_max_draw_amount":"455",  "heloc_current_balance":"4335",  "hero_or_pace_loan":"Yes",  "solar_or_energy_efficiency_loan":"Yes",  "property_part_of_hoa_or_condo":"Yes",  "delinquencies_on_your_property_taxes":"Current",  "property_used_for_commercial_agricultural":"Yes",  "commercial_agricultural_use_detail":"Yes",  "home_actively_listed_for_sale":"Yes",  "current_list_or_contract_price":"234343",  "hazardous_materials_on_the_property":"Yes",  "hazardous_materials_detail":"Yes",  "any_structural_modifications_without_permits":"Yes",  "structural_modifications_detail":"Yes",  "ongoing_or_pending_lawsuits_against_property":"Yes",  "ongoing_or_pending_lawsuits_detail":"Yes",  "property_include_accessory_dwelling_unit":"Yes",  "property_currently_under_renovation":"Yes",  "under_renovation_detail":"Yes",  "any_major_systems_need_repair":"Yes",  "major_repair_detail":"Yes",  "amount_needed_from_splitero":"56565",  "intention_to_use_fund":"Small Business",  "explain_fund_usage":"Yes",  "pleaded_financial_crimes":"Yes",  "pleaded_financial_crimes_detail":"Yes",  "any_bankruptcy_filed":"Yes",  "any_bankruptcy_filed_detail":"Yes",  "directly_indirectly_obligated_loan_foreclosure":"Yes",  "planning_on_new_loans_secured_by_proper":"Yes",  "plan_new_loans_secured_by_property_expl":"Yes"  } ';
    	RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/loan/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(requestData);
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLoanInboundService.postRequestHandler();
        
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode);
    
    }

    @isTest
    public static void testPutMethod406(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        
        Application__c app=new Application__c(State__c='AK');
        insert app;
                 
        SPR_WebserviceRequest.UpdateApplication updateApplication = new SPR_WebserviceRequest.UpdateApplication();
            
        updateApplication.sfid=app.Id;
        SPR_WebserviceRequest.CreateApplication createApp=new SPR_WebserviceRequest.CreateApplication();
        createApp.lead_uuid='HTI8G83WKG';
        SPR_WebserviceRequest.Co_owners coowner = new SPR_WebserviceRequest.Co_owners();
        coowner.email='test@email.com';
        coowner.first_name='first name';
        coowner.last_name='last name';
        coowner.middle_name='middle name';
        coowner.id=1;
        createApp.co_owners=new List<SPR_WebserviceRequest.Co_owners>{coowner};
        updateApplication.update_field_json=createApp;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/loan/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(JSON.serialize(updateApplication));
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLoanInboundService.putRequestHandler();
        
        Test.stopTest();
        
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testPutMethod(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        
        Application__c app=new Application__c(State__c='AK');
        insert app;
                 
        SPR_WebserviceRequest.UpdateApplication updateApplication = new SPR_WebserviceRequest.UpdateApplication();
            
        updateApplication.sfid=app.Id;
        SPR_WebserviceRequest.CreateApplication createApp=new SPR_WebserviceRequest.CreateApplication();
        createApp.lead_uuid='HTI8G83WKG';
        SPR_WebserviceRequest.Co_owners coowner = new SPR_WebserviceRequest.Co_owners();
        coowner.email='test@email.com';
        coowner.first_name='first name';
        coowner.last_name='last name';
        coowner.middle_name='middle name';
        coowner.id=1;
        createApp.co_owners=new List<SPR_WebserviceRequest.Co_owners>{coowner};
        updateApplication.update_field_json=createApp;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/loan/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='POST';
        request.requestBody=Blob.valueOf(JSON.serialize(updateApplication));
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLoanInboundService.putRequestHandler();
        
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode);
    
    }
    
    
    @isTest
    public static void testGetMethod406(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        
        Application__c app=new Application__c(State__c='AK',Contact__c=con.Id);
        insert app;
          
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/loan/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='GET';
        request.addParameter('sfid', app.Id); 
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLoanInboundService.getRequestHandler();
        
        Test.stopTest();
        
        System.assertEquals(406, res.statusCode);
    
    }
    
    @isTest
    public static void testGetMethod(){
        
        Contact con = new Contact();
        con.LastName = 'test';
        insert con;
        
        Lead l = new Lead(Web_UUID__c='HTI8G83WKG');
        l.LastName='test';
        l.Company='test';
        insert l;
        
        Application__c app=new Application__c(State__c='AK',Contact__c=con.Id);
        insert app;
          
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl+='services/apexrest/web/loan/record/*';
        request.requestURI=baseUrl;
        request.httpMethod='GET';
        request.addParameter('sfid', app.Id); 
        request.addHeader('Referer', Label.SPR_API_Referer);
        
        RestContext.request=request;
        RestContext.response=res;
        Test.startTest();
        
        	SPR_WebsiteLoanInboundService.getRequestHandler();
        
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode);
    
    }
    
}