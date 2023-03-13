@RestResource(urlMapping='/sf/documents/*')
global with sharing class SPR_DocumentList {
  
    @HttpPost
    global static void postRequestHandler(){
        RestResponse res = RestContext.response;
        
        String jsonReferer =  RestContext.request.headers.get('Referer');         
        System.debug('jsonReferer-->'+jsonReferer);
        
        SPR_WebserviceRequest.DocumentResponse docResponse = new  SPR_WebserviceRequest.DocumentResponse();
        
        if(jsonReferer!=Label.SPR_API_Referer){
            docResponse.success=False; 
            docResponse.message= 'Invalid Referer';
            res.responseBody = Blob.valueOf(JSON.serialize(docResponse));
            res.statusCode = 406;
            return;
        }
        
        String jsonPayload =  RestContext.request.requestBody.toString();
        System.debug('jsonPayload-->'+jsonPayload);
        
		SPR_WebserviceRequest.DocumentRequest jsonFile = (SPR_WebserviceRequest.DocumentRequest)JSON.deserialize(jsonPayload, SPR_WebserviceRequest.DocumentRequest.class);
        System.debug('jsonFile-->'+jsonFile); 
        System.debug('jsonFile-->'+jsonFile.lead_uuid); 
        List<Lead> LeadList =[Select Id,Splitero_File_Number__c,Property__c,Application__c , ConvertedOpportunityId From Lead Where Web_UUID__c=:jsonFile.lead_uuid Limit 1] ; 
        if(leadList.size()>0){
          	String leadId=leadList[0].Id;
          	String  OpportunityId =leadList[0].ConvertedOpportunityId;
            if(OpportunityId != Null){
                List<SPR_WebserviceRequest.Documents> docList = new  List<SPR_WebserviceRequest.Documents>();
                String recordTypeName = jsonFile.recordType ;
                String status = jsonFile.status ;
            	List<Document__c> documentList;
                
                if(recordTypeName!=null && status!=null ){
                    documentList = [Select Id , Name , Required__c ,Document_Key__c,
                                                  RecordType.Name, Status__c,Amazon_S3_File__r.AWS_File_Key__c,
                                    				Amazon_S3_File__c,Amazon_S3_File__r.File_Path__c
                                                  From Document__c 
                                                  Where Opportunity__c=:OpportunityId AND  
                                    				Status__c=:status AND
                                    				RecordType.Name=:recordTypeName
                                                 ];
                }else{
                    documentList = [Select Id , Name , Required__c ,Document_Key__c,
                                                  RecordType.Name, Status__c,Amazon_S3_File__r.AWS_File_Key__c,
                                    				Amazon_S3_File__c,Amazon_S3_File__r.File_Path__c
                                                  From Document__c 
                                                  Where Opportunity__c=:OpportunityId AND 
                                                 ((Document_Type__c = 'Homeowner Docs' AND Status__c IN (NULL,'Awaiting Submission') AND Required__c=True)  
                                                  OR (Document_Type__c = 'Third Party Reports' AND Status__c = 'Awaiting Submission'  AND Required__c=True) )
                                                 ];
                }
                system.debug('documentList'+documentList);
                for(Document__c dcList :documentList){
                    
                    SPR_WebserviceRequest.Documents doc = New SPR_WebserviceRequest.Documents();
                    doc.id = dcList.id;
                    doc.document_type_title = dcList.Name;
                    doc.is_reqired = dcList.Required__c;
                    doc.document_key = dclist.Document_Key__c;
                    doc.s3_folder_key = dcList.Name;
                    
                    if(dcList.Amazon_S3_File__c!=null){
                    	doc.aws_file_key = dcList.Amazon_S3_File__r.AWS_File_Key__c; 
                        String path = dcList.Amazon_S3_File__r.File_Path__c;
                        path=path.replace('s3-us-east-1','s3.us-east-1');
                        doc.aws_file_path=path;
                        
                    }
                    docList.add(doc);
                     
                }
				                
                docResponse.lead_uuid=jsonFile.lead_uuid;docResponse.success=True;
                
                docResponse.OppurtunityId=OpportunityId;
                docResponse.LeadId=leadId;
                docResponse.Documents =docList; 
            	docResponse.message= 'Success';
            	res.statusCode = 200;  
            }else{
                docResponse.success=False;
                docResponse.message= 'OpportunityId is Not Exit for Lead UUID';
                 res.statusCode = 403;
            }
          	

        }else{
			docResponse.success=False;
            docResponse.message= 'Invalid Lead UUID';
            res.statusCode = 403;
        }
                    
        res.responseBody = Blob.valueOf(JSON.serialize(docResponse));
        
        
        
    }
    
    
}