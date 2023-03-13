public class SPR_ClearCapitalAPIUtil {
    
    public static Id VerosRTId; public static Id RadianRTId; public static Id CCRTId;
    static {
        VerosRTId = Schema.SObjectType.Valuation__c.getRecordTypeInfosByDeveloperName().get('Veros').getRecordTypeId();
        RadianRTId = Schema.SObjectType.Valuation__c.getRecordTypeInfosByDeveloperName().get('Radian').getRecordTypeId();
        CCRTId = Schema.SObjectType.Valuation__c.getRecordTypeInfosByDeveloperName().get('Clear_Capital').getRecordTypeId();
    }
    
    @AuraEnabled  
    public static String getAVMRequest(String recordId){
        String street;
        String city;
        String state;
        String address;
        
        if(recordId.startsWith('006')){
            List<Property__c> property = new List<Property__c>();
            property = [SELECT ID, Property_Address__c, Street__c, City__c, State_Province__c
                        FROM Property__c 
                        WHERE Opportunity__c = :recordId LIMIT 1];
            
            if(property.size() > 0){
                
                street = property[0].Street__c != null && String.isNotBlank(property[0].Street__c) ? property[0].Street__c : '';
                city =  property[0].City__c != null && String.isNotBlank(property[0].City__c) ? property[0].City__c : '';
                state = property[0].State_Province__c != null && String.isNotBlank(property[0].State_Province__c) ? property[0].State_Province__c: '';
                address = Street+' '+city+' '+state;
            } else
                return 'error:No Property record is associated with Opportunity';    
            
        }else {
            Lead lead = [SELECT Id, address, Street, City, State, Country, PostalCode 
                         FROM Lead 
                         WHERE Id=:recordId LIMIT 1];
            street = lead.Street != null && String.isNotBlank(lead.Street) ? lead.street : '';
            city =  lead.City != null && String.isNotBlank(lead.City) ? lead.City : '';
            state = lead.State != null && String.isNotBlank(lead.State) ? lead.State: '';
            address = Street+' '+city+' '+state; 
        }
        
        if(String.isNotBlank(street) && String.isNotBlank(city) && String.isNotBlank(state)){
            //Creating Request Body
            Clear_Capital_API__c clearCapitalApiCred = [SELECT Id, Api_Key__c, Endpoint__c FROM Clear_Capital_API__c LIMIT 1];
            
            String params = 'address='+EncodingUtil.urlEncode(street,'UTF-8')+'&city='+EncodingUtil.urlEncode(city,'UTF-8')
                +'&state='+EncodingUtil.urlEncode(state,'UTF-8');
            String endpoint = clearCapitalApiCred.Endpoint__c+'/avm/avm?'+params+'&includeDetails=true&isCascade=false&saveResult=false&includePdf=true';
            system.debug('endpoint '+endpoint);
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-api-key', clearCapitalApiCred.Api_Key__c);
            HttpResponse res;
            
            try {
                res =  http.send(req);
                system.debug('res.getbody'+res.getBody());
                system.debug('res.getStatusCode() '+res.getStatusCode());
                if(res.getStatusCode() == 200){
                    Map<String, Object> response =  (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    SPR_ClearCapitalAPIUtil.getAVMDocRequest(response, recordId); 
                    return 'Success';
                    
                }else{
                    return 'error:StatusCode-'+res.getStatusCode()+' Message-'+res.getBody();
                    
                }
                
            }catch(System.CalloutException e) {
                System.debug('Callout error: '+ e); 
                return e.getMessage();
            }
            
        }else{
            if(String.isNotBlank(address))
                return 'error:Complete Address is not present in record';
            else
                return 'error:Address is not present in record';  
        }
    }
    
    public static void getAVMDocRequest(Map<String, Object> response, String recordId){
        
        //ed6a7831-e0ed-4e91-ab38-5928ef277c1b ed6a7831-e0ed-4e91-ab38-5928ef277c1b
        //{avmId=ed6a7831-e0ed-4e91-ab38-5928ef277c1b, avmPdfLink=https://api.clearcapital.com/avm/avm/ed6a7831-e0ed-4e91-ab38-5928ef277c1b/pdf, avmResult={avmEffectiveDate=2022-02-04, comparables=null, confidenceScore=H, confidenceScoreAlt=96.8, forecastStdDev=0.032, highValue=624266, lowValue=585750, marketValue=605008, providerKey=CC, providerModel=CLEARAVM, ...}, avmType=Value Only, endpoint=avm, property={apn=085003079000, censusBlockGroup=060990009123, customerProvidedAddress=1716 Thomas Cou
        
        String avmId = (String)response.get('avmId');
        system.debug('avmId '+avmId);
        system.debug('recordId '+recordId);
        
        if(avmId !=null){
            //Creating Request Body
            Clear_Capital_API__c clearCapitalApiCred = [SELECT Id, Api_Key__c, Endpoint__c FROM Clear_Capital_API__c LIMIT 1];
            
            String endpoint = clearCapitalApiCred.Endpoint__c+'/avm/avm/'+avmId+'/pdf';
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/pdf');
            // req.setHeader('cache-control', 'no-cache');
            req.setHeader('x-api-key', clearCapitalApiCred.Api_Key__c);
            HttpResponse res;
            req.setTimeout(120000);
            
            try {
                res =  http.send(req);
                
                system.debug('res.getStatusCode() '+res.getStatusCode());
                system.debug('filename '+res.getHeader('filename'));
                String AVM_recordId =  SPR_ClearCapitalAPIUtil.createAVMRecord(response, recordId);
                if(res.getStatusCode() == 200){
                    system.debug('res '+res.getBody());
                    
                    
                    ContentVersion cv = new ContentVersion();
                    cv.Title = 'ClearAVM-'+avmId; 
                    cv.PathOnClient = 'ClearAVM-'+avmId+'.pdf';
                    cv.VersionData = res.getBodyAsBlob(); 
                    insert cv;
                    
                    ContentVersion cvv = [SELECT Id, Title, ContentDocumentId 
                                          FROM ContentVersion 
                                          WHERE Id = :cv.Id LIMIT 1];
                    system.debug('cvv '+cvv.ContentDocumentId);
                    
                    ContentDocumentLink contentlink = new ContentDocumentLink();
                    contentlink.LinkedEntityId = AVM_recordId;
                    contentlink.ContentDocumentId = cvv.ContentDocumentId;
                    insert contentlink;
                    
                }
                
            }catch(System.CalloutException e) {
                System.debug('Callout error: '+ e); 
            }
            
        }else{
            SPR_ClearCapitalAPIUtil.createAVMRecord(response, recordId);
        }
    } 
    
    public static String createAVMRecord(Map<String, Object> response, String recordId)
    {
        String avmId = (String)response.get('avmId');
        Map<String, Object> avmResult =  (Map<String, Object>)response.get('avmResult');
        
        system.debug('response '+response);
        system.debug('avmId '+avmId);
        
        Valuation__c avm = new Valuation__c();
        avm.Estimated_Value_High__c = Decimal.valueOf((Integer)avmResult.get('highValue'));
        avm.Estimated_Value_Low__c = Decimal.valueOf((Integer)avmResult.get('lowValue'));
        avm.Confidence_Score__c = Decimal.valueOf((String)avmResult.get('confidenceScoreAlt'));//marketValue
        avm.Estimated_Value__c  = Decimal.valueOf((Integer)avmResult.get('marketValue'));
        avm.AVM_Source__c = 'Clear Capital';
        avm.AVM_Id__c = avmId;
        avm.RecordTypeId = CCRTId;
        if(recordId.startsWith('006'))
            avm.Opportunity__c = recordId;
        else
            avm.Lead__c = recordId;
        //avm.Standard_Deviation__c = sDeviation;
        // avm.Estimated_Value__c = eValue;
        
        insert avm;
        
        return avm.id;
    }
}