@RestResource(urlMapping='/web/lead/record/*')
global class SPR_WebsiteLeadService {

    @HttpGet
    global static void leadExistRequestHandler() 
    {
        System.debug('Inbound Request from SPR Lead API');
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
                 
        String lead_uuid = RestContext.request.params.get('leadUUID'); 
         
        List<Lead> leadList = new List<Lead>();
         
        SPR_WebsiteLeadServiceJson2Apex.Data data = new SPR_WebsiteLeadServiceJson2Apex.Data();
        data.leadUUID=lead_uuid;
        SPR_WebsiteLeadServiceJson2Apex response = new SPR_WebsiteLeadServiceJson2Apex();
        response.data= data;   
        if(jsonReferer!=Label.SPR_API_Referer){
            response.success=false;
            response.message='Invalid Referer';
        }else if(lead_uuid!=null){
            leadList = [Select Id  From Lead Where Web_UUID__c=:lead_uuid Limit 1] ; 
            if(leadList.size()>0){
                response.success=true;
                response.message='Lead Exist'; 
            } else{
                response.success=false;
                response.message='Lead Not Exist'; 
            }           
        }               
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
    
    
    
}