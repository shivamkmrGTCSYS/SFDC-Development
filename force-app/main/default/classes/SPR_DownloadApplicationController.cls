public class SPR_DownloadApplicationController {

    public List<sObject> getIDs;
     
    public String downloadUrl{get;set;} 
    public Boolean urlFound{get;set;} 
    
    public SPR_DownloadApplicationController(ApexPages.StandardSetController controller){
        System.debug('Get Selected');
        urlFound=true;
        getIDs = controller.getSelected();         
        List<Id> applicationIds = new List<Id>();
        for(sObject app : getIDs){               
            applicationIds.add(app.Id);
        }
        if(applicationIds.size()>0){
            downloadUrl = downloadAllApplicationURL( applicationIds);
        }else{
            urlFound=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select atleast one record'));
   			//return null;
        }
        //appIds = appIds.removeEnd(','); 
    } 
    
    public static String downloadAllApplicationURL(List<Id> applicationIds){
        
        String response='';
        String recordId = applicationIds[0] ;
        String objectname=getObjectNameByRecordId(recordId); 
        
         
        Download_Application__c downloadApplicationAPI = [SELECT Id, API_Url__c, X_API_Key__c  FROM Download_Application__c LIMIT 1];
         
        String endPoint = downloadApplicationAPI.API_Url__c ;
        
        List<Sobject> sobjectRecordList = Database.query('SELECT id, Name,Splitero_File_Number__c FROM '+objectname+' WHERE Id IN:applicationIds ');
        String appNames = '';
        String fileName='';
        if(sobjectRecordList.size()>0){
            for(Sobject sobjectRecord : sobjectRecordList){
                
                appNames+='{"fileNumber": "'+String.valueOf(sobjectRecord.get('Splitero_File_Number__c'))+'","address": "'+String.valueOf(sobjectRecord.get('Name'))+'"},';
                 
                if(fileName==''){
                    fileName=String.valueOf(sobjectRecord.get('Splitero_File_Number__c'));
                }
            }
        }
        appNames = appNames.removeEnd(',');
        System.debug('appNames-->'+appNames);
		String requestBody='{"loanNumber": ['+appNames+'], "fileName": "'+fileName+'.zip"}' ;
        System.debug('requestBody-->'+requestBody);
        HttpRequest req = new HttpRequest();
                
        req.setHeader('x-api-key',downloadApplicationAPI.X_API_Key__c);
        req.setHeader('Content-Type','application/json');
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setBody(requestBody);

        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        system.debug('reponse===>'+res.getBody());
        
        if(res.getStatusCode() == 200)
        {
            Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            response=String.valueOf(responsePayloadMAP.get('signed_url')); 
        }
                 
        return response;
    }
    
    
    @AuraEnabled
    public static String downloadApplicationURL(String recordId)
    {
         
        System.debug('recordId-->'+recordId);
        
        String response=downloadAllApplicationURL(new List<Id>{recordId});
        /*
        Download_Application__c downloadApplicationAPI = [SELECT Id, API_Url__c, X_API_Key__c  FROM Download_Application__c LIMIT 1];
         
        String endPoint = downloadApplicationAPI.API_Url__c ;
               
        String objectname=getObjectNameByRecordId(recordId); 
        
        Sobject sobjectRecord = Database.query('SELECT id, Name FROM '+objectname+' WHERE id=:recordId LIMIT 1');
        
		String requestBody='{"loanNumber": ["'+sobjectRecord.get('Name')+'"], "fileName": "'+sobjectRecord.get('Name')+'.zip"}' ;       
        HttpRequest req = new HttpRequest();
                
        req.setHeader('x-api-key',downloadApplicationAPI.X_API_Key__c);
        req.setHeader('Content-Type','application/json');
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(requestBody);

        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        system.debug('reponse===>'+res.getBody());
        
        if(res.getStatusCode() == 200)
        {
            Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            response=String.valueOf(responsePayloadMAP.get('signed_url')); 
        }
        else
        {
            response = '';
        }
        */
        return response; 
    }
    
    public Static String getObjectNameByRecordId(String recordId){
         
        String objectApiName='';
        String keyCode  = recordId.subString(0,3);
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for(Schema.SObjectType objectInstance : gd.values())
        {
            if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
            { 
                System.debug('Id is related to object: '+ objectInstance.getDescribe().getName());
                objectApiName=String.valueOf(objectInstance.getDescribe().getName());
                break;            	
            }
        }
        return objectApiName;
        
    }
    
}