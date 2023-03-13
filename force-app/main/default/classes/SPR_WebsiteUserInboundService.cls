@RestResource(urlMapping='/web/user/webuser/*')
global with sharing class SPR_WebsiteUserInboundService {
    @HttpPost
    global static void postRequestHandler() 
    {
    
        System.debug('Inbound Request from SPR User API');
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
         
        SPR_WebserviceRequest.CreateContact jsonFile = (SPR_WebserviceRequest.CreateContact)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.CreateContact.class);
        System.debug('jsonFile-->'+jsonFile);
        
        String cognito_key = jsonFile.cognito_key ;
        String first_name = jsonFile.first_name ;
        String last_name = jsonFile.last_name ;
        String email = jsonFile.email ;
        String phone = jsonFile.phone ;
        String birthdate = jsonFile.birthdate ;
        String citizenship = jsonFile.citizenship ;
        String marital_status = jsonFile.marital_status ;
        String intention_to_use_fund = jsonFile.intention_to_use_fund ;
        String fund_required_timeline = jsonFile.fund_required_timeline ;
        String reffered_by = jsonFile.reffered_by ;
        String lead_uuid = jsonFile.lead_uuid ; 
        
        String leadId='';
        String ownerid='';
        Boolean error=false;
        String errorMeaagse='';
        List<Lead> leadList = new List<Lead>();
        if(lead_uuid!=null){
            leadList = [Select Id,OwnerId From Lead Where Web_UUID__c=:lead_uuid Limit 1] ; 
            if(leadList.size()>0){
                leadId=leadList[0].Id;
                ownerid=leadList[0].OwnerId;
            }else{
                error=true;
                errorMeaagse=' Invalid UUID' ;
            }
        }else{
            error=true;
            errorMeaagse=' Invalid UUID' ;
        }
        
        Account acc = new Account();
        acc.Name = first_name+' '+last_name;
        //insert acc;
        
        Contact con = new Contact();
        con.Cognito_Key__c =cognito_key;
        con.FirstName=first_name;
        con.LastName=last_name;
        con.Email=email;
        con.Phone=phone;
        con.Birthdate=date.parse(birthdate);        
        con.Citizenship__c=citizenship;
        con.Marital_Status__c=marital_status;
        con.Intention_To_Use_Fund__c=intention_to_use_fund;
        con.Fund_Required_Timeline__c=fund_required_timeline;
        con.Reffered_By__c=reffered_by;
        con.AccountId=acc.Id; 
        
        
        if(error==true){
            Map<String,String> response = new Map<String,String>(); 
            response.put('error',errorMeaagse); 
            
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            res.statusCode = 400;
        }else{
            
            con.Home_Owner_Adviser_Sfid__c=ownerid;
            //insert con ;
            Portal_User__c portalUser = new Portal_User__c();
            //portalUser.Application__c='';
            portalUser.Cognito_Key__c=cognito_key;
            portalUser.Email__c=email;
            portalUser.First_Name__c=first_name;
            portalUser.Last_Name__c=last_name;
            portalUser.Lead__c=leadList[0].Id;
            portalUser.Phone_Number__c=phone;
            //portalUser.Last_Logged_In__c='';
            insert portalUser ;    
            
            SPR_WebserviceRequest.CreateContactResponse ccr = new SPR_WebserviceRequest.CreateContactResponse();
            ccr.sfid=portalUser.Id;
            ccr.home_owner_adviser_sfid=ownerid;
                     
            User u = [Select Id, FirstName, LastName, email,phone,Photo_URL__c,Calendly_Call_Iitem__c From User Where Id=:ccr.home_owner_adviser_sfid Limit 1] ;
            Map<String,String> home_owner_adviser_object = new Map<String,String>();          
            home_owner_adviser_object.put('sfid',u.Id);
            home_owner_adviser_object.put('first_name',u.FirstName);
            home_owner_adviser_object.put('last_name',u.LastName);
            home_owner_adviser_object.put('email',u.email);
            home_owner_adviser_object.put('phone',u.phone);
            home_owner_adviser_object.put('photo-url',u.Photo_URL__c);
            home_owner_adviser_object.put('calendly-call-item',u.Calendly_Call_Iitem__c);        
            
            ccr.home_owner_adviser_object=home_owner_adviser_object;
                
            res.responseBody = Blob.valueOf(JSON.serialize(ccr));
             
            res.statusCode = 200;
             
        }
        
        
    }

    @HttpPut
    global static void putRequestHandler() 
    {
        
        System.debug('Inbound Request from SPR User API');
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
         
        SPR_WebserviceRequest.CreateContact jsonFile = (SPR_WebserviceRequest.CreateContact)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.CreateContact.class);
        System.debug('jsonFile-->'+jsonFile);
                  
        String sfid = jsonFile.sfid ;
        String first_name = jsonFile.first_name ;
        String last_name = jsonFile.last_name ;         
        String phone = jsonFile.phone ;
        String birthdate = jsonFile.birthdate ;
        String citizenship = jsonFile.citizenship ;
        String marital_status = jsonFile.marital_status ;
        String how_will_you_use_investment = jsonFile.how_will_you_use_investment ;
        String fund_required_timeline = jsonFile.fund_required_timeline ;
        String reffered_by = jsonFile.reffered_by ;
          
          
        Contact con = new Contact();
        con.Id=sfid;
         
        con.FirstName=first_name;
        con.LastName=last_name;         
        con.Phone=phone;
        con.Birthdate=date.parse(birthdate);        
        con.Citizenship__c=citizenship;
        con.Marital_Status__c=marital_status;
        con.How_Will_You_Use_Investment__c=how_will_you_use_investment;
        con.Fund_Required_Timeline__c=fund_required_timeline;
        con.Reffered_By__c=reffered_by;
        Map<String,String> response = new Map<String,String>();  
        try{
            update con;
            response.put('success','true');
        }catch(Exception e){
            System.debug('Error while updating aws file record');
            response.put('success','false');
        }  
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
    @HttpGet
    global static void advisorRequestHandler() 
    {
    
        System.debug('Inbound Request from SPR User API');
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
        
        
        res.statusCode = 200;
        
        String sfid = RestContext.request.params.get('sfid'); 
        SYstem.debug('sfid-->'+sfid);
        User u = [Select Id, FirstName, LastName, email,phone,Photo_URL__c,Calendly_Call_Iitem__c From User Where Id=:sfid Limit 1] ;
        
        Map<String,String> response = new Map<String,String>(); 
         
        response.put('sfid',u.Id);
        response.put('first_name',u.FirstName);
        response.put('last_name',u.LastName);
        response.put('email',u.email);
        response.put('phone',u.phone);
        response.put('photo-url',u.Photo_URL__c);
        response.put('calendly-call-item',u.Calendly_Call_Iitem__c);
        
        
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
     
     
}