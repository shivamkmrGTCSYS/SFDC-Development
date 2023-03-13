public class SPR_LeadTriggerHelperCntrl {
    public static boolean ByPassAllTrigger=false;
    public static void leadConversion( Map < Id, Lead > leadMap, Map < Id, Lead > leadOldMap )
    {
 
        Set <Id> setOpportunityIds = new Set <Id> ();
        Set <String> oppIds = new Set <String> ();
        
        Map <Id, List <Valuation__c>> avmMapWithOptyId = new Map <Id, List <Valuation__c>> ();
        Map <Id, List < Property__c>> propertyMapWithOptyId = new Map <Id, List < Property__c>> ();
        Map <Id, List <Application__c>> applicationMapWithOptyId = new Map <Id, List <Application__c>> ();
        Map <Id, List <Title_and_Escrow__c>> titleAndEscrowMapWithOptyId = new Map <Id, List <Title_and_Escrow__c>> ();
        Map <Id, List <Amazon_S3_Files__c>> s3FileWithOptyId = new Map <Id, List <Amazon_S3_Files__c>> ();
        
        Map <Id, Lead> oppLeadMap = new Map <Id, Lead> ();
        Map<String , String> developerNameToRecordTypeIdMap = new Map <String , String>();
        List<RecordType> oppRecordTypes = [Select Id, DeveloperName From RecordType Where sObjectType='Opportunity']; 
        
        for(RecordType oppRecord : oppRecordTypes ){
        	developerNameToRecordTypeIdMap.put(oppRecord.DeveloperName , oppRecord.Id );    
        } 
        List<Opportunity> oppUpdateRecordtypeList = new List<Opportunity>(); 
        
        List<Lead> leadList = [SELECT Id, IsConverted, convertedOpportunityId,ConvertedContactId, RecordType.DeveloperName, 
                                (SELECT Id, Opportunity__c FROM AVMs__r), 
                                (SELECT Id, Opportunity__c FROM Properties__r),
                                (SELECT Id, Legal_First_Name__c, Legal_Last_Name__c, Property_Address__c, Opportunity__c, Lead__r.Property__r.Property_Address__c FROM Applications__r),
                                (SELECT Id, Opportunity__c FROM Title_and_Escrow__r),
                                (SELECT Id, Opportunity__c,Folder_Name__c FROM Amazon_S3_Files__r)
                              FROM Lead 
                              WHERE Id IN :leadMap.keySet()];
       
        for(Lead objLead : leadList) 
        {
            if (objLead.IsConverted && objLead.IsConverted != leadOldMap.get( objLead.Id ).IsConverted)
            {
                Opportunity newOpp = new Opportunity();
                newOpp.Id=objLead.convertedOpportunityId;
                if(objLead.RecordType.DeveloperName=='Retail' && developerNameToRecordTypeIdMap.containsKey('Retail')){
                   newOpp.RecordTypeId= developerNameToRecordTypeIdMap.get('Retail');
                }
                if(objLead.RecordType.DeveloperName=='Wholesale'  && developerNameToRecordTypeIdMap.containsKey('Wholesale')){
                   newOpp.RecordTypeId= developerNameToRecordTypeIdMap.get('Wholesale');
                }
                oppUpdateRecordtypeList.add(newOpp);
                
                setOpportunityIds.add( objLead.convertedOpportunityId );
                oppIds.add(objLead.convertedOpportunityId);
                oppLeadMap.put(objLead.convertedOpportunityId,objLead);

                if(objLead.AVMs__r != null && objLead.AVMs__r.size() > 0)
                {
                    avmMapWithOptyId.put( objLead.convertedOpportunityId, objLead.AVMs__r );
                }

                if(objLead.Properties__r != null && objLead.Properties__r.size() > 0)  
                {  
                    propertyMapWithOptyId.put( objLead.convertedOpportunityId, objLead.Properties__r );
                }
                
                if(objLead.Applications__r != null && objLead.Applications__r.size() > 0)
                {  
                    applicationMapWithOptyId.put( objLead.convertedOpportunityId, objLead.Applications__r );
                }

                if(objLead.Title_and_Escrow__r != null && objLead.Title_and_Escrow__r.size() > 0) 
                {   
                    titleAndEscrowMapWithOptyId.put( objLead.convertedOpportunityId, objLead.Title_and_Escrow__r );
                }

                if(objLead.Amazon_S3_Files__r != null && objLead.Amazon_S3_Files__r.size() > 0) 
                {   
                    s3FileWithOptyId.put( objLead.convertedOpportunityId, objLead.Amazon_S3_Files__r );
                }
            }	
       
        }
        
        system.debug ( 'setOpportunityIds===>' + setOpportunityIds );
        system.debug ( 'propertyMapWithOptyId===>' + propertyMapWithOptyId );
        system.debug ( 'avmMapWithOptyId===>' + avmMapWithOptyId );
        system.debug ( 'applicationMapWithOptyId===>' + applicationMapWithOptyId );
        system.debug ( 'titleAndEscrowMapWithOptyId===>' + titleAndEscrowMapWithOptyId );
        system.debug ( 's3FileWithOptyId===>' + s3FileWithOptyId );
        
        
        
        List <Valuation__c> avmList = new List <Valuation__c> ();
        List <Property__c> propertyList = new List <Property__c> ();
        List <Application__c> applicationList = new List <Application__c> ();
        List <Title_and_Escrow__c> titleAndEscrowList = new List <Title_and_Escrow__c> ();
        List < Opportunity> opportunityList = new List <Opportunity> ();
        List < Amazon_S3_Files__c> s3FileList = new List <Amazon_S3_Files__c> ();
        
        if( avmMapWithOptyId.size() > 0 )
        {
            for ( Id optyId : avmMapWithOptyId.keySet() )
            {
                if( avmMapWithOptyId.containsKey( optyId ) )
                {
                    for (Valuation__c avm : avmMapWithOptyId.get( optyId ) )
                    {
                        avm.Opportunity__c = optyId;
                        avmList.add( avm );
                    }
                }			
            }
        }
        
        if( propertyMapWithOptyId.size() > 0 )
        {
            for ( Id optyId : propertyMapWithOptyId.keySet() )
            {			
                if( propertyMapWithOptyId.containsKey( optyId ) )
                {
                    for (Property__c property : propertyMapWithOptyId.get( optyId ) )
                    {
                        property.Opportunity__c = optyId;
                        propertyList.add( property );
                    }
                }
            }
        }

        if(applicationMapWithOptyId.size() > 0 )
        {
            for (Id optyId : applicationMapWithOptyId.keySet() )
            {			
                if(applicationMapWithOptyId.containsKey( optyId ) )
                {
                    for (Application__c application : applicationMapWithOptyId.get( optyId ) )
                    {
                        application.Opportunity__c = optyId;
                        applicationList.add( application );
                    }
                }
            }
        }

        if( titleAndEscrowMapWithOptyId.size() > 0 )
        {
            for ( Id optyId : titleAndEscrowMapWithOptyId.keySet() )
            {			
                if( titleAndEscrowMapWithOptyId.containsKey( optyId ) )
                {
                    for (Title_and_Escrow__c titleAndEscrow : titleAndEscrowMapWithOptyId.get( optyId ) )
                    {
                        titleAndEscrow.Opportunity__c = optyId;
                        titleAndEscrowList.add( titleAndEscrow );
                    }
                }
            }
        }

        if( s3FileWithOptyId.size() > 0 )
        {
            for ( Id optyId : s3FileWithOptyId.keySet() )
            {			
                if( s3FileWithOptyId.containsKey( optyId ) )
                {
                    for (Amazon_S3_Files__c s3File : s3FileWithOptyId.get( optyId ) )
                    {
                        s3File.Opportunity__c = optyId;
                        s3FileList.add( s3File );
                    }
                }
            }
        }
        
        if ( setOpportunityIds.size() > 0 ) 
        { 
            for(Opportunity opty : [SELECT Id, Property__c FROM Opportunity WHERE Id IN :setOpportunityIds])
            {
                Boolean markDirty = false;
                if(propertyMapWithOptyId.containsKey( opty.Id ))
                {
                    opty.Property__c = propertyMapWithOptyId.get( opty.Id )[0].Id;
                    markDirty = true;
                }
                
                if(applicationMapWithOptyId.containsKey( opty.Id ) )
                {
                    Application__c appRecord = applicationMapWithOptyId.get( opty.Id )[0];
                    opty.Investment_Amount_Requested__c = appRecord.Id;
                    opty.Name = (appRecord.Legal_First_Name__c+' '+appRecord.Legal_Last_Name__c+' - '+appRecord.Lead__r.Property__r.Property_Address__c).left(120);
                    markDirty = true;
                }

                if(oppLeadMap.containsKey(opty.Id)){
                    opty.Primary_Contact__c =oppLeadMap.get(opty.Id).ConvertedContactId ;
                    markDirty = true;
                }
                if(markDirty) {
                    opportunityList.add(opty);
                }
            }   
        }
        
        system.debug ( 'avmList===>' + avmList );
        system.debug ( 'propertyList===>' + propertyList );
        system.debug ( 'opportunityList===>' + opportunityList );
        system.debug ( 'applicationList===>' + applicationList );
        system.debug ( 'titleAndEscrowList===>' + titleAndEscrowList );
        system.debug ( 's3FileList===>' + s3FileList );
        
        if ( avmList.size() > 0)
        {
            update avmList;
        }
        
        if ( propertyList.size() > 0)
        {
            update propertyList;
        }  
        
        if ( applicationList.size() > 0)
        {
            update applicationList;             
            SPR_SyncApplicationToWebUtility.sendOpportunityStageToWeb(oppIds,'Pre-Approving');
        } 

        if ( titleAndEscrowList.size() > 0)
        {
            update titleAndEscrowList;
        }

        if ( s3FileList.size() > 0)
        {
            update s3FileList;
            updateDocumentStatus(s3FileList);
        }
        
        if ( opportunityList.size() > 0)
        {
            update opportunityList;
            SPR_TriggerUtility.ByPassAllTrigger=true;
            update oppUpdateRecordtypeList;
            SPR_TriggerUtility.ByPassAllTrigger=false;
        } 
    }    
    
    public static void createPropertyRecord ( List < Lead > leadList )
    {system.debug('createPropertyRecord===>'+leadList);
        Map< Integer, Property__c > propertMap = new Map< Integer, Property__c > ();
        Map< Integer, Lead > leadMap = new Map < Integer, Lead > ();

        Integer intKey = 0;
        
        for ( Lead lead : leadList )
        {
            intKey =+ 1;

            leadMap.put(intKey, lead);

            String street = String.isNotBlank( lead.Street ) ? lead.Street : '';
            String city = String.isNotBlank( lead.City ) ? lead.City : '';
            String state = String.isNotBlank( lead.State ) ? lead.State : '';
            String country = String.isNotBlank( lead.Country ) ? lead.Country : '';
            String county = String.isNotBlank( lead.County__c ) ? lead.County__c : '';
            String postalCode = String.isNotBlank( lead.PostalCode ) ? lead.PostalCode : '';  
                      
            String address = street + ' ' + city + ' ' + state + ' ' + country + ' ' + postalCode;  

            if( lead.Property__c == null && String.isNotBlank( address ) )
            {
                Property__c property = new  Property__c ();
                system.debug('leadName===>'+lead.Company);
                //property.Name = lead.LastName;
                //property.Lead__c = lead.Id;
                property.Property_Address__c = address;
                property.Street__c = street;
                property.City__c = city;
                property.State_Province__c = state;
                property.County__c = county;               
                property.Zip_Postal_Code__c = postalCode;
        
                propertMap.put( intKey, property );
            }                
        } 
        system.debug('propertMap===>'+propertMap);      
        
        if ( propertMap.size() > 0 )
        {
            insert propertMap.values ();            
            
            for ( Integer key : leadMap.keySet ( ) )
            {
                if ( propertMap.containsKey( key ) )
                {
                    Lead lead = leadMap.get( key );
                    lead.Property__c = propertMap.get( key ).Id;                   
                }  
            }            
        }
    }    


    public static void generateFileNumber(List < Lead > leadList)
    {
        Map<String, Lead> fileNumbersMap = new Map<String, Lead>();
        for(Lead leadRecord : leadList)
        {
            leadRecord.Splitero_File_Number__c = 'H'+SPR_CommonUtility.generateRandomString(8);
            if(fileNumbersMap.containsKey(leadRecord.Splitero_File_Number__c)) {
                leadRecord.Splitero_File_Number__c = 'H'+SPR_CommonUtility.generateRandomString(8);
            }
            fileNumbersMap.put(leadRecord.Splitero_File_Number__c,leadRecord);
            if(leadRecord.Web_UUID__c==null || leadRecord.Web_UUID__c==''){
                String uuid=SPR_CommonUtility.generateRandomString(8).toLowercase()+'-'+
                    SPR_CommonUtility.generateRandomString(4).toLowercase()+'-'+
                    SPR_CommonUtility.generateRandomString(4).toLowercase()+'-'+
                    SPR_CommonUtility.generateRandomString(4).toLowercase()+'-'+
                    SPR_CommonUtility.generateRandomString(8).toLowercase();
               leadRecord.Web_UUID__c=uuid; 
            }
        }
    }
    
    public static void updateDocumentStatus(List <Amazon_S3_Files__c> s3FileList){
        
        List<String> oppIds = new List<String>();
        for(Amazon_S3_Files__c s3: s3FileList){
            oppIds.add(s3.Opportunity__c);
        }
        System.debug('oppIds-->'+oppIds);
        if(oppIds.size()>0){
            List<Document__c> docListUpdate = new List<Document__c>();
            List<Document__c> docList = [Select Id, Name, SF_Folder_Name__c,Opportunity__c From Document__c Where Opportunity__c IN:oppIds];
            if(docList.size()>0){
                for(Document__c doc: docList){
					for(Amazon_S3_Files__c s3: s3FileList){
                        if(s3.Folder_Name__c==doc.SF_Folder_Name__c && s3.Opportunity__c==doc.Opportunity__c){
                            doc.Status__c='Uploaded';
                            doc.Amazon_S3_File__c=s3.Id;
                            docListUpdate.add(doc);
                        }
                    }
                }
            }
            System.debug('docListUpdate-->'+docListUpdate);
            if(docListUpdate.size()>0){
                SPR_TriggerUtility.ByPassAllTrigger=true;
                update docListUpdate ;
                SPR_TriggerUtility.ByPassAllTrigger=false;
            }
        }
        
    }
    
    public static void updatePlaceKey(List<Lead> leadList){
        Set<String> ledIdSet = new Set<String>();
        for(Lead led: leadList){
            System.debug('led.Address-->'+led.Address);
            System.debug('led.Place_Key__c-->'+led.Place_Key__c);
            if( led.Place_Key__c==null || led.Place_Key__c==''){
                ledIdSet.add(led.Id);
            }
        }
        System.debug('ledIdSet-->'+ledIdSet);
        if(ledIdSet.size()>0){
            updatePlaceKeyFuture(ledIdSet);
        }
    }
    
    @future(callout=true)
    public static void updatePlaceKeyFuture(Set<String> ledIdSet){
        List<Lead> leadList = [Select Id, Address From Lead Where Id IN:ledIdSet];
        List<Lead> ledListToUpdate = new List<Lead>();
        for(Lead led: leadList){
            Address addr = led.Address;
            if(addr==null) continue ;
            String street = addr.street;
            String city = addr.City;
            String region = addr.state;
            String postal = addr.postalcode;
            
            String requestBody  = '{"query": {'+
                '"street_address": "'+street+'",'+
                '"city": "'+city+'",'+
                '"region": "'+region+'", '+
                '"postal_code": "'+postal+'",'+
                '"iso_country_code": "US"'+
                '}';
            String requestBody2=requestBody+'}';
            requestBody+=',"options": {"strict_address_match":true}'+'}';
            String placekey='';
            Map<String, Object> response = getPlaceKey(requestBody);
            if(!response.containsKey('placekey')){
                response = getPlaceKey(requestBody2); 
            }
            if(response.containsKey('placekey')){
                placekey=String.valueOf(response.get('placekey'));
                led.Place_Key__c=placekey;
                ledListToUpdate.add(led);
            }
        }
        
        if(ledListToUpdate.size()>0){
            SPR_TriggerUtility.ByPassAllTrigger=true;
            update ledListToUpdate;
            SPR_TriggerUtility.ByPassAllTrigger=false;            
        }
        
    }
    
    public static Map<String, Object> getPlaceKey(String requestBody){
        String endPoint = Label.SPR_PlaceKeyEndPointUrl;    
        system.debug('requestBody===>'+requestBody);
        HttpRequest req = new HttpRequest(); 
        
        req.setHeader('Content-Type','application/json');
        req.setHeader('apikey',Label.SPR_PlaceKey);          
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(requestBody); 
        
        Http http = new Http();
        HTTPResponse res ;
        
        Map<String, Object> responsePayloadMAP = new Map<String, Object>();
        if(!Test.isRunningTest()){
            res= http.send(req);
         	responsePayloadMAP=(Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            system.debug('req body ===> '+ res.getBody());
        }        
        
        system.debug('responsePayloadMAP ===> '+ responsePayloadMAP);
        
        return responsePayloadMAP;
    }
     
    
}