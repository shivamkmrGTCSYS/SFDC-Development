public class SPR_DataTreeAVM_API_util {
    @AuraEnabled
    public static String doCallout(String recordId)
    {
        String message = '';
        String address = '';
        String propertyId = '';
        if(recordId.startsWith('006'))
        {
            List<Opportunity> opportunityList = new List<Opportunity>();
            opportunityList = [SELECT ID, Property__c, Property__r.Property_Address__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
            if(opportunityList.size() > 0)
            {
                if(opportunityList[0].Property__c != NULL)
                    address = opportunityList[0].Property__r.Property_Address__c;
                else
                    message ='No Property record is associated with Opportunity'; 
            }                   
        }
        else 
        {
            Lead leadDetails = [SELECT ID, Street, City, State, Country, PostalCode, Property__c FROM Lead WHERE Id = :recordId LIMIT 1];
            
            String street = String.isNotBlank(leadDetails.Street) ? leadDetails.Street : '';
            String city = String.isNotBlank(leadDetails.City) ? leadDetails.City : '';
            String state = String.isNotBlank(leadDetails.State) ? leadDetails.State : '';
            String country = String.isNotBlank(leadDetails.Country) ? leadDetails.Country : '';
            String postalCode = String.isNotBlank(leadDetails.PostalCode) ? leadDetails.PostalCode : '';            
            address = street+' '+city+' '+state+' '+country+' '+postalCode;
            
            system.debug('d1===>'+ leadDetails.Property__c);
            propertyId = leadDetails.Property__c;

        }
        if(String.isNotBlank(address))
        {
            DTAPI__c dtApiAuthDetail = [Select User_Name__c, Password__c, Endpoint__c From DTAPI__c LIMIT 1];
            String endPoint = dtApiAuthDetail.Endpoint__c;
            
            //Get Token
            String requestBody = '{"Username":"' + dtApiAuthDetail.User_Name__c + '","Password":"' + dtApiAuthDetail.Password__c + '"}';
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint+'Login/Authenticate'); 
            req.setHeader('Content-Type','application/json');
            req.setMethod('POST');
            req.setBody(requestBody);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('body===>'+res.getBody());
            
            //Get Details
            String accessToken = res.getBody();
            String requestBodyPayload = JSON.serialize(prepareRequest(address));
            System.debug('requestBodyPayload===>'+requestBodyPayload);
            
            HttpRequest httpReq = new HttpRequest();
            httpReq.setHeader('Authorization',accessToken.replaceAll('"', ''));
            httpReq.setHeader('Content-Type','application/json');
            httpReq.setEndpoint(endPoint+'Report/GetReport');        
            httpReq.setMethod('POST');
            httpReq.setBody(requestBodyPayload);
            
            Http httpCall = new Http();
            HTTPResponse httpRes = httpCall.send(httpReq); 
            System.debug('httpResbody===>'+httpRes.getBody());
            
            if(httpRes.getStatusCode() == 200)
            {
                message = createRecord(httpRes.getBody(), recordId, propertyId);
                system.debug('message==>'+message);
            }
            else
            {
                message = 'Record Creation Failed';
            } 
        }
        else if(String.isBlank(message))
        {
            message = 'Address Is Not Present In Record ';
        }        
        return message;
    }
	public static Map<String, Object> prepareRequest(String address)
    {
        Map<String, Object> payloadMap = new Map<String, Object>();
        
        String randomNumber = String.valueof(Integer.valueof(Math.random() * 10000))+''+String.valueof(System.now().getTime());
                
        List<String> productNames = new List<String>{'DataTreeAVM'};
        payloadMap.put('ProductNames',productNames);
        payloadMap.put('SearchType','FullAddress');
        
        /*Map<String, String> addressDetails = new Map<String, String>();
        addressDetails.put('StreetName','Thornlake');
        addressDetails.put('StreetNumber','19617');
        addressDetails.put('StateFips','6');
        addressDetails.put('CountyFips','6037');
        addressDetails.put('City','Cerritos');
        addressDetails.put('ZipCode','90703');*/        
        
        payloadMap.put('FullAddress',address);        
        payloadMap.put('ReferenceId',randomNumber);
        
        return payloadMap;
    }
    public static String createRecord(String response, String recordId, String propertyId)
    {
        Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(response);        
        List<Valuation__c> avmList = new List<Valuation__c>();
        String extPropertyId = '';
        String message = '';
        
        for (Object obj : (List<Object>) responsePayloadMAP.get('Reports'))
        {
            Map<String, Object> innerData = (Map<String, Object>) obj;
            Map<String, Object> dataMap = (Map<String, Object>) innerData.get('Data');        
       		
            if(String.isBlank(extPropertyId))
            {
               	Map<String, Object> subjectPropertyMap = (Map<String,Object>) dataMap.get('SubjectProperty');
                
                if(subjectPropertyMap.containsKey('PropertyId'))   
                    extPropertyId = String.ValueOf(subjectPropertyMap.get('PropertyId')); 
            }          
            
            Map<String, Object> valuationSummaryMap = (Map<String,Object>) dataMap.get('ValuationSummary');
            system.debug('reportList===>'+valuationSummaryMap);
            
            Decimal eValue = Decimal.valueOf(String.valueOf(valuationSummaryMap.get('EstimatedValue')));
            Decimal eValueHigh = Decimal.valueOf(String.valueOf(valuationSummaryMap.get('EstimatedValueHigh')));
            Decimal eValueLow = Decimal.valueOf(String.valueOf(valuationSummaryMap.get('EstimatedValueLow')));
            Decimal cScore = Decimal.valueOf(String.valueOf(valuationSummaryMap.get('ConfidenceScore')));
            Decimal sDeviation = Decimal.valueOf(String.valueOf(valuationSummaryMap.get('StandardDeviation')));
            
            //Create AVM record
            Valuation__c avm = new Valuation__c();
            
            avm.Estimated_Value__c = eValue;
            avm.Estimated_Value_High__c = eValueHigh;
            avm.Estimated_Value_Low__c = eValueLow;
            avm.Confidence_Score__c = cScore;
            avm.Standard_Deviation__c = sDeviation;

            if(recordId.startsWith('006'))
                avm.Opportunity__c = recordId;
            else
            {
                avm.Lead__c = recordId;
                avm.Property__c =  propertyId;              
            }               

            avm.AVM_Source__c = 'First AM';            
            avmList.add(avm);             
        }

        //Insert AVM Record
        if(avmList.size() > 0)
        {
            try {
                insert avmList;
                message = 'Success';
            } catch (Exception ex) {
                system.debug('error==>'+ex.getMessage());
                message = 'Record Creation Failed';
            }            
        }

        //Update Property Record
        List<Property__c> propertyList = new List<Property__c>();
        for(Property__c property : [SELECT Id, DTAPI_Property_ID__c FROM Property__c WHERE (Lead__c = :recordId OR Opportunity__c = :recordId)])
        {
            if(String.isBlank(property.DTAPI_Property_ID__c))
            {
                property.DTAPI_Property_ID__c = extPropertyId;
            	propertyList.add(property);
            }
        }
        if(propertyList.size() > 0)
        	update(propertyList);

        return message;
    }    
}