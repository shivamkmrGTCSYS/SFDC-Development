public class Spr_runVerosOppWsCtrl {
 public static Id VerosRTId; public static Id RadianRTId; public static Id CCRTId;
    static {
         VerosRTId = Schema.SObjectType.Valuation__c.getRecordTypeInfosByDeveloperName().get('Veros').getRecordTypeId();
         RadianRTId = Schema.SObjectType.Valuation__c.getRecordTypeInfosByDeveloperName().get('Radian').getRecordTypeId();
         CCRTId = Schema.SObjectType.Valuation__c.getRecordTypeInfosByDeveloperName().get('Clear_Capital').getRecordTypeId();
    }
    
    @AuraEnabled
    public static String sendRequest(String recordId)
    { 
        String message = '';
        String street = '';
        String city = '';
        String state = '';
        String country = '';
        String postalCode = '';
        String APN = '';
        String propertyType = null;   
        
        String propertyId = '';
        String oppId = '';
        if(recordId.startsWith('a3d'))
        {
            Opportunity_Worksheet__c oppWorksheet  = [SELECT Id, Name, Opportunity__c FROM Opportunity_Worksheet__c WHERE Id =: recordId LIMIT 1];
            
            Opportunity oppor  = [SELECT ID, Property__c, Property__r.Street__c, Property__r.City__c, Property__r.State_Province__c, Property__r.County__c, 
                                  Property__r.Zip_Postal_Code__c,Property__r.APN__c, Property__r.Property_Type__c 
                                  FROM Opportunity 
                                  WHERE Id = :oppWorksheet.Opportunity__c LIMIT 1];
            oppId = oppor.Id;
            
            street = String.isNotBlank( oppor.Property__r.Street__c ) ? oppor.Property__r.Street__c : '';
            city = String.isNotBlank( oppor.Property__r.City__c ) ? oppor.Property__r.City__c : '';
            state = String.isNotBlank( oppor.Property__r.State_Province__c ) ? oppor.Property__r.State_Province__c : '';
            country = String.isNotBlank( oppor.Property__r.County__c ) ? oppor.Property__r.County__c : '';
            postalCode = String.isNotBlank( oppor.Property__r.Zip_Postal_Code__c ) ? oppor.Property__r.Zip_Postal_Code__c : '';
            APN = String.isNotBlank( oppor.Property__r.APN__c ) ? oppor.Property__r.APN__c : '';
            propertyType = String.isNotBlank( oppor.Property__r.Property_Type__c ) ? oppor.Property__r.Property_Type__c : null;
           /*street = '12 1/2 25th Pl';
            city = 'Venice';
            country = 'US';
            state = 'CA';
            postalCode = '90293';
           // APN ='Other';*/
          //  propertyType = null;  
            
            
            propertyId = oppor.Property__c; 
        }
        else
        {
            Lead lead = [SELECT Id, Street, City, State, Country, PostalCode, Property__c, Property__r.APN__c, Property__r.Property_Type__c FROM Lead WHERE Id = :recordId LIMIT 1];
            street = String.isNotBlank( lead.Street ) ? lead.Street : '';
            city = String.isNotBlank( lead.City ) ? lead.City : '';
            state = String.isNotBlank( lead.State ) ? lead.State : '';
            country = String.isNotBlank( lead.Country ) ? lead.Country : '';
            postalCode = String.isNotBlank( lead.PostalCode ) ? lead.PostalCode : '';
            APN = String.isNotBlank( lead.Property__r.APN__c ) ? lead.Property__r.APN__c : '';
            propertyType = String.isNotBlank( lead.Property__r.Property_Type__c ) ? lead.Property__r.Property_Type__c : null;
            propertyId = lead.Property__c;
        }
        
        //Creating Request Body
        Veros_API__c verosApiCred = [SELECT Id, User_Name__c, Password__c, SourceApplication__c, Endpoint__c FROM Veros_API__c LIMIT 1];
        
        if(verosApiCred != Null)
        { 
            Map<String, Object> payloadMap = new Map<String, Object>();
            
            Map<String, String> header = new Map<String, String>();
            
            header.put('UserId', verosApiCred.User_Name__c);
            header.put('Password', verosApiCred.Password__c);
            header.put('SourceApplication', verosApiCred.SourceApplication__c);
            
            payloadMap.put('Header', header);
            
            Map<String, String> propertyDetails = new Map<String, String>();
            
            propertyDetails.put('StreetAddress', street);
            propertyDetails.put('City', city);
            propertyDetails.put('State', state);
            propertyDetails.put('Zip', postalCode);
            //propertyDetails.put('APN', APN); 
            propertyDetails.put('PropertyType', propertyType);
            
            payloadMap.put('Property', propertyDetails);
            
            Map<String, String> order = new Map<String, String>();
            
            order.put('CustomerOrderReference', 'CustRef123');
            order.put('PreferenceTableName', 'VeroVALUE TEST');
            order.put('Price', null);
            order.put('Credit', null);
            
            payloadMap.put('Order', order);        
            
            //Get Details      
            
            String requestBodyPayload = JSON.serialize(payloadMap);
            system.debug('payloadMap====>'+payloadMap);
            
            HttpRequest httpReq = new HttpRequest();            
            httpReq.setHeader('Content-Type','application/json');
            httpReq.setEndpoint(verosApiCred.Endpoint__c); 
            //httpReq.setEndpoint('https://run.mocky.io/v3/f252bb7c-0384-48e1-b258-c1513cd99634'); 
            httpReq.setMethod('POST');
            httpReq.setBody(requestBodyPayload);
            
            Http httpCall = new Http();
            HTTPResponse httpRes = httpCall.send(httpReq); 
            System.debug('httpResbody===>'+httpRes.getBody());
            system.debug('httpRes.getStatusCode()==>'+httpRes.getStatusCode());
            if(httpRes.getStatusCode() == 200)
            {
                
                message = createRecord(httpRes.getBody(), oppId, propertyId, street,recordId);
                system.debug('message==>'+message);
            }
            else
            {
                message = 'Record Creation Failed';
            }
        }        
        
        return message;
    } 
    
    public static String createRecord(String response, String oppId, String propertyId, String street,String recordId)
    {
        Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(response);        
        List<Valuation__c> avmList = new List<Valuation__c>();
        String extPropertyId = '';
        String message = '';
        
        system.debug('responsePayloadMAP====>'+responsePayloadMAP);
        
        if(responsePayloadMAP.containsKey('ResponseStatus'))
        {
            Map<String, Object> responseStatus = (Map<String, Object>) responsePayloadMAP.get('ResponseStatus');
            
            system.debug('responseStatus====>'+responseStatus);
            
            if(String.valueOf(responseStatus.get('StatusCode')) == 'AVM1000')
            {                
                Map<String, Object> AVMReport = (Map<String, Object>) responsePayloadMAP.get('AVMReport');
                system.debug('AVMReport====>'+AVMReport);
                
                Map<String, Object> summary = (Map<String, Object>) AVMReport.get('SUMMARY');
                system.debug('summary====>'+summary);
                
                for(Object service : (List<Object>) summary.get('SERVICES'))
                {
                    Map<String, Object> serviceInnerData = (Map<String, Object>) service;
                    Map<String, Object> valuation = (Map<String, Object>) serviceInnerData.get('VALUATION');
                    Map<String, String> avmDetailsMap = new Map<String, String>();
                    for(Object value : (List<Object>) valuation.get('VALUES'))
                    {
                        Map<String, Object> valueInnerData = (Map<String, Object>) value;
                        avmDetailsMap.put(String.ValueOf(valueInnerData.get('KEYNAME')), String.ValueOf(valueInnerData.get('KEYVALUE')));
                    }
                    system.debug('avmDetailsMap===>'+avmDetailsMap);
                    
                    //Create AVM record
                    Valuation__c avm = new Valuation__c();
                    
                    if(avmDetailsMap.containsKey('AVM VALUE'))
                        avm.Estimated_Value__c = Decimal.ValueOf(avmDetailsMap.get('AVM VALUE'));
                    if(avmDetailsMap.containsKey('AVM HIGH VALUE'))
                        avm.Estimated_Value_High__c = Decimal.ValueOf(avmDetailsMap.get('AVM HIGH VALUE'));
                    if(avmDetailsMap.containsKey('AVM LOW VALUE'))
                        avm.Estimated_Value_Low__c = Decimal.ValueOf(avmDetailsMap.get('AVM LOW VALUE'));
                    if(avmDetailsMap.containsKey('AVM CONFIDENCE SCORE'))
                        avm.Confidence_Score__c = Decimal.ValueOf(avmDetailsMap.get('AVM CONFIDENCE SCORE'));
                    if(avmDetailsMap.containsKey('FSD'))
                        avm.Standard_Deviation__c = Decimal.ValueOf(avmDetailsMap.get('FSD'));
                    
                    if(Id.valueOf(recordId).getSObjectType().getDescribe().getName() == 'Opportunity_Worksheet__c')
                    {
                        avm.Opportunity__c = oppId;
                        avm.Opportunity_Worksheet__c = recordId;
                        avm.Property__c = propertyId;
                    }
                    else if(recordId.startsWith('006'))
                    {
                        avm.Opportunity__c = oppId;
                    }                    
                    else
                    { 
                        avm.Lead__c = recordId;
                        avm.Property__c =  propertyId;              
                    }               
                    
                    avm.AVM_Source__c = 'Veros';
                    avm.RecordTypeId = VerosRTId;
                    system.debug('avm===>'+avm);            
                    avmList.add(avm); 
                }
                
                //Insert AVM Record
                if(avmList.size() > 0)
                {
                    try {
                        insert avmList;
                        
                        Map<String, Object> result = (Map<String, Object>) AVMReport.get('RESULT');
                        system.debug('result===>'+result);    
                        Map<String, Object> document = (Map<String, Object>) result.get('DOCUMENT');
                        system.debug('document**===>'+document); 
                        
                        List<Attachment> attachment = new List<Attachment>();
                        for(Valuation__c avm : avmList)
                        {
                            Attachment attach = new Attachment();
                            attach.contentType = 'application/pdf'; 
                            attach.name = 'Veros AVM '+ street + '.pdf';
                            attach.parentId = avm.Id;
                            attach.body = EncodingUtil.base64Decode(String.ValueOf(document.get('DOCUMENT_CONTENT')));
                            attachment.add(attach);
                        }  
                        
                        if(attachment.size()>0)
                        {
                            insert attachment;
                        }
                        
                        message = 'Success';
                    } catch (Exception ex) {
                        system.debug('error==>'+ex.getMessage());
                        message = 'Record Creation Failed';
                    }                        
                }
            }
            else
            {
                message = String.valueOf(responseStatus.get('StatusMessage'));
            }
        }
        system.debug('Message===>'+message);    
        return message;
    }
}