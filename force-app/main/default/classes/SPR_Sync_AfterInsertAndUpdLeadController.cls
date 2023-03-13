public class SPR_Sync_AfterInsertAndUpdLeadController {
    
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
        
        system.debug('res.getBody || Token 1 ===> '+res.getBody());
        
        if(res.getStatusCode() == 200)
        {
            Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            accessToken=String.valueOf(responsePayloadMAP.get('access_token')); 
        }
        else
        {
            accessToken = '';
        }     
         System.debug('return ----> '+ accessToken);
        return accessToken;
        
    }
    
	
    @future(callout=true)
    Public static void syncLeadFromSF(set<String> setOfIds){
        System.debug('Set Of Ids =---------> '+setOfIds);
        List<Lead> listofLeads = [SELECT Id, FirstName, LastName, Email, Phone, Street, City, State, PostalCode, Web_UUID__c FROM Lead WHERE Id IN :setOfIds];
		String accessToken = accessToken();
         for (Lead lead : listofLeads) {
        // Retrieve the lead record
        
        // Create the JSON payload for the callout
        String payload = '{"firstName": "' + lead.FirstName + '", ' +
                         '"lastName": "' + lead.LastName + '", ' +
                         '"email": "' + lead.Email + '", ' +
                         '"phone": "' + lead.Phone + '", ' +
                         '"street": "' + lead.Street + '", ' +
                         '"city": "' + lead.City + '", ' +
                         '"state": "' + lead.State + '", ' +
                         '"zipCode": "' + lead.PostalCode + '", ' +
                         '"homeEstimatedPrice": ' + null + ', ' +
                         '"preQualificationValue": ' + null + ', ' +
                         '"fundRequiredTimeline": "' + null+ '", ' +
                         '"leadUuid": "' + lead.Web_UUID__c + '", ' +
                         '"getReportID": 12952917, ' +
                         '"exportReportID": 9727011}';
             
             SyncApplication__c syncApp = [SELECT Id, Access_Key__c, Access_Token_End_Point__c, Web_End_Point__c FROM SyncApplication__c LIMIT 1];
           String accessKey = syncApp.Access_Key__c;

        // Make the callout to the endpoint
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://ok0geojkfk.execute-api.us-east-1.amazonaws.com/dev/api/lead');
        request.setMethod('POST');
        request.setBody(payload);   
        request.setHeader('Content-Type','application/json');
      	//request.setHeader('Authorization', 'Bearer eyJraWQiOiJaMU51WTFyMG1Ba1wvZUNYOHZNR3JLV2RVclhNcFVvQ29VWkF5TjZNU3NKUT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1NTdlN2Q4aXY4Z2htNjF0bjhwOHVvdW9maCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoic3BsaXRlcm8tZXh0ZXJuYWwtYXBpLWlkZW50aWZpZXJcL3NwbGl0ZXJvLWV4dGVybmFsLWFwaS1pZGVudGlmaWVyLmFwaSIsImF1dGhfdGltZSI6MTY3ODM1NDY3MiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfbTM2TUoydFlMIiwiZXhwIjoxNjc4MzU4MjcyLCJpYXQiOjE2NzgzNTQ2NzIsInZlcnNpb24iOjIsImp0aSI6ImM4ODIx');
        request.setHeader('Authorization','Bearer '+accessToken);
        //System.debug('Access token ---->'+ accessKey);
        httpResponse resp = http.send(request);
        
        string response = resp.getbody();
        System.debug('response :: '+response);
        system.debug('Status======>' + resp.getStatusCode());
        
  }
    }
    
}