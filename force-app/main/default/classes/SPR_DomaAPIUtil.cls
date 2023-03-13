public class SPR_DomaAPIUtil {

    public static String accessToken(){
        
        String accessToken = '' ;
        SPR_Doma_API__c domaAPI = [SELECT Id, Client_Id__c, Client_Secret__c, Access_Token_API_Domain__c FROM SPR_Doma_API__c LIMIT 1];
          
        String endPoint = 'https://'+domaAPI.Access_Token_API_Domain__c+'/oauth/token/';
        system.debug('endPoint===>'+endPoint);
        Map<String, String> body = new Map<String, String>();       
            
        body.put('grant_type', 'client_credentials');
        body.put('client_id', domaAPI.Client_Id__c);
        body.put('client_secret', domaAPI.Client_Secret__c);
              
        
        String requestBody  = JSON.serialize(body);
        system.debug('requestBody===>'+requestBody);
        HttpRequest req = new HttpRequest();
                
        //req.setHeader('Content-Type','application/x-www-form-urlencoded');
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
            accessToken=String.valueOf(responsePayloadMAP.get('access_token')); 
        }
        else
        {
            accessToken = '';
        }
        
        return accessToken;
        
    }
    @AuraEnabled
    public static String submitOrder(String recordId){

        System.debug('recordId-->'+recordId);
        String message;   
        String accessToken = 'access token';
        //if(!Test.isRunningTest())        	 
        	accessToken=accessToken();
        
        system.debug('accessToken===>'+accessToken);
        
        //leadId = '00Q3C000004YSLxUAO';

        String first_name;
        String middle_name;
        String last_name;
        String email;
        String home_phone;
        String cell_phone;
        String work_phone;
        
        String address;
        String city;
        String state;
        String county;
        String zip_code;
        String loan_number;
        Decimal loan_amount=0;
        String unit=''; 
        String tax_id_number='';
        
        String first_name_contact='';
        String middle_name_contact='';
        String last_name_contact='';
        String email_contact='';
        String home_phone_contact='';
        
        if(recordId.startsWith('006')){
            Opportunity opportunity = [SELECT ID, Investment_Amount__c, Property__r.Property_Address__c, 
            Property__c, Property__r.Street__c, Property__r.Unit__c,
            Property__r.City__c, Property__r.State_Province__c, Property__r.County__c, Property__r.Zip_Postal_Code__c, 
            Owner.FirstName,Owner.MiddleName,Owner.LastName, Contact_Phone__c, Owner_Email__c, Splitero_File_Number__c,
            Processor__c,Processor__r.FirstName,Processor__r.MiddleName,Processor__r.LastName,Processor__r.Email,Processor__r.Phone,
            (Select Id, Legal_First_Name__c,Legal_Middle_Name__c,Legal_Last_Name__c,Email__c,
             Social_Security_Number__c,Phone_Number__c From Applications__r)
            FROM Opportunity WHERE Id = :recordId LIMIT 1];
            
            loan_amount=opportunity.Investment_Amount__c!=null?opportunity.Investment_Amount__c:0;
            
            first_name=opportunity.Owner.FirstName!=null?opportunity.Owner.FirstName:'';
            middle_name=opportunity.Owner.MiddleName!=null?opportunity.Owner.MiddleName:'';
            last_name=opportunity.Owner.LastName!=null?opportunity.Owner.LastName:'';
            email=opportunity.Owner_Email__c!=null?opportunity.Owner_Email__c:'';
            home_phone = opportunity.Contact_Phone__c!=null?opportunity.Contact_Phone__c:'';
            cell_phone = '';
            work_phone = '';
            
            if(opportunity.Applications__r.size()>0){
                first_name=opportunity.Applications__r[0].Legal_First_Name__c!=null?opportunity.Applications__r[0].Legal_First_Name__c:'';
                middle_name=opportunity.Applications__r[0].Legal_Middle_Name__c!=null?opportunity.Applications__r[0].Legal_Middle_Name__c:'';
                last_name=opportunity.Applications__r[0].Legal_Last_Name__c!=null?opportunity.Applications__r[0].Legal_Last_Name__c:'';
                email=opportunity.Applications__r[0].Email__c!=null?opportunity.Applications__r[0].Email__c:'';
                home_phone = opportunity.Applications__r[0].Phone_Number__c!=null?opportunity.Applications__r[0].Phone_Number__c:'';
                cell_phone = opportunity.Applications__r[0].Phone_Number__c!=null?opportunity.Applications__r[0].Phone_Number__c:'';
                tax_id_number = opportunity.Applications__r[0].Social_Security_Number__c!=null?opportunity.Applications__r[0].Social_Security_Number__c:'';
            }
        
            //address = opportunity.Property__r.Property_Address__c!=null?opportunity.Property__r.Property_Address__c:'';
            address = opportunity.Property__r.Street__c!=null?opportunity.Property__r.Street__c:'';
            city = opportunity.Property__r.City__c!=null?opportunity.Property__r.City__c:'';
            state = opportunity.Property__r.State_Province__c!=null?opportunity.Property__r.State_Province__c:'';
            county = opportunity.Property__r.County__c!=null?opportunity.Property__r.County__c:'';
            zip_code = opportunity.Property__r.Zip_Postal_Code__c!=null?opportunity.Property__r.Zip_Postal_Code__c:'';
            loan_number=opportunity.Splitero_File_Number__c!=null?opportunity.Splitero_File_Number__c:'';
            
			unit = opportunity.Property__r.Unit__c!=null?opportunity.Property__r.Unit__c:'';            
        
            if(opportunity.Processor__c!=null){
                first_name_contact=opportunity.Processor__r.FirstName!=null?opportunity.Processor__r.FirstName:'';
                middle_name_contact=opportunity.Processor__r.MiddleName!=null?opportunity.Processor__r.MiddleName:'';
                last_name_contact=opportunity.Processor__r.LastName!=null?opportunity.Processor__r.LastName:'';
                email_contact=opportunity.Processor__r.Email!=null?opportunity.Processor__r.Email:'';
                home_phone_contact=opportunity.Processor__r.Phone!=null?opportunity.Processor__r.Phone:'';
            }
            
            
        }
        else{
            Lead leadRecord = [Select Id,Property__c,Property__r.Property_Address__c,Property__r.City__c,
            Property__r.County__c,Property__r.State_Province__c,Property__r.Zip_Postal_Code__c,
            Owner.FirstName,Owner.MiddleName,Owner.LastName,Owner.Email,Owner.Phone,
            Alternate_Phone_2__c,Co_Owner_Phone__c,Phone,Splitero_File_Number__c,Email
            From Lead Where ID =:recordId Limit 1] ;

            first_name=leadRecord.Owner.FirstName!=null?leadRecord.Owner.FirstName:'';
            middle_name=leadRecord.Owner.MiddleName!=null?leadRecord.Owner.MiddleName:'';
            last_name=leadRecord.Owner.LastName!=null?leadRecord.Owner.LastName:'';
            email=leadRecord.Email!=null?leadRecord.Email:'';
            home_phone = leadRecord.Phone!=null?leadRecord.Phone:'';
            cell_phone = leadRecord.Co_Owner_Phone__c!=null?leadRecord.Co_Owner_Phone__c:'';
            work_phone = leadRecord.Alternate_Phone_2__c!=null?leadRecord.Alternate_Phone_2__c:'';
        
            address = leadRecord.Property__r.Property_Address__c!=null?leadRecord.Property__r.Property_Address__c:'';
            city = leadRecord.Property__r.City__c!=null?leadRecord.Property__r.City__c:'';
            state = leadRecord.Property__r.State_Province__c!=null?leadRecord.Property__r.State_Province__c:'';
            county = leadRecord.Property__r.County__c!=null?leadRecord.Property__r.County__c:'';
            zip_code = leadRecord.Property__r.Zip_Postal_Code__c!=null?leadRecord.Property__r.Zip_Postal_Code__c:'';
            loan_number=leadRecord.Splitero_File_Number__c!=null?leadRecord.Splitero_File_Number__c:'';
            
            // For lead, its not having lookup for Processor
            first_name_contact=first_name;
            middle_name_contact=middle_name;
            last_name_contact=last_name;
            email_contact=email;
            home_phone_contact=home_phone;
            
        }
       
        
        
        //String borrowers ='"borrowers":[{"primary":true,"first_name":"'+first_name+'","middle_name":"'+middle_name+'","last_name":"'+last_name+'","email":"'+email+'","home_phone":"'+home_phone+'","cell_phone":"'+cell_phone+'","work_phone":"'+work_phone+'"}]';
        String borrowers ='"borrowers":[{"primary":true,"first_name":"'+first_name+'","middle_name":"'+middle_name+'","last_name":"'+last_name+'","email":"'+email+'","home_phone":"'+home_phone+'","cell_phone":"'+cell_phone+'","tax_id_number":"'+tax_id_number+'"}]';
		//String contacts ='"contacts":[{"first_name":"'+first_name+'","middle_name":"'+middle_name+'","last_name":"'+last_name+'","email":"'+email+'","phone":"'+home_phone+'"}]';
        String contacts ='"contacts":[{"first_name":"'+first_name_contact+'","middle_name":"'+middle_name_contact+'","last_name":"'+last_name_contact+'","email":"'+email_contact+'","phone":"'+home_phone_contact+'"}]';
        
        //String body = '{'+borrowers+','+contacts+',"mortgage_type":"CONV","property_usage_type":"PRIMARY","transaction_type":"HELOC","loan_amount":"1000","address":"'+address+'","unit":"","city":"'+city+'","county":"'+county+'","state":"'+state+'","zip_code":"'+zip_code+'","loan_number":"'+loan_number+'"}' ;
		String body = '{'+borrowers+','+contacts;
        
        body+=',"transaction_type":"HELOC"';
        body+=',"loan_amount":"'+loan_amount+'"';
        body+=',"address":"'+address+'"';
        body+=',"unit":"'+unit+'"';
        body+=',"city":"'+city+'"';
        body+=',"county":"'+county+'"';
        body+=',"state":"'+state+'"';
        body+=',"zip_code":"'+zip_code+'"';
        body+=',"loan_number":"'+loan_number+'"';
        body+=',"mortgage_type":""';
        body+=',"property_usage_type":""';          
        body+='}';
         
        System.debug('body-->'+body);
        SPR_Doma_API__c domaAPI = [SELECT Id, Client_Id__c, Client_Secret__c, API_Domain__c FROM SPR_Doma_API__c LIMIT 1];
          
        String endPoint = 'https://'+domaAPI.API_Domain__c+'/orders/';
        System.debug('endPoint: '+endPoint);
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(endPoint);
        req.setHeader('Authorization','Bearer '+accessToken);
        req.setHeader('Accept','*/*');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');         
        req.setHeader('charset','UTF-8'); 
        req.setMethod('POST');
        req.setBody(body);

        System.debug('body: '+body);
        
        HTTP httpCallout = new HTTP();

        HTTPResponse res = httpCallout.send(req);
 
        System.debug('responseStr: '+res.getBody());
        Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        if(res.getStatusCode() == 200)
        {
             
            String orderId=String.valueOf(responsePayloadMAP.get('id')).replace('order_','');
            String status=String.valueOf(responsePayloadMAP.get('order_status')) ;
            
            Title_and_Escrow__c tes = new Title_and_Escrow__c();
 
            tes.Title_and_Escrow_Source__c = 'Doma';
            if(recordId.startsWith('006')){
            	tes.Opportunity__c = recordId;
            }else{
                tes.Lead__c = recordId;
            }
			tes.Transaction_ID__c = orderId;  
            tes.Order_Status__c=status;
            try{
                insert tes;
                message = 'Success';
            }catch(Exception e){
                System.debug('Error while inserting Title_and_Escrow_Source__c record -->'+e.getMessage());
                message = e.getMessage();
            }
            
        }
        else if(res.getStatusCode() == 422)
        {
            if(responsePayloadMAP.containsKey('loan_number')){
                System.debug('Loan number already exist' );
                System.debug(responsePayloadMAP.get('loan_number') );
                message = 'Loan number already exist'+String.valueOf(responsePayloadMAP.get('loan_number'));
            }else{
                System.debug('Improper data' );
                //message = res.getBody();
                message = 'Improper data';
            }
            
        }else{
            System.debug('Error while submitting order' );
            message = 'Error while submitting order';
        }
        return message;
        
    }
    

	@AuraEnabled
    public static void getOrderDetail(Title_and_Escrow__c record ){

        //'order_2211322727'; 
        String orderId='order_'+record.Transaction_ID__c;
        String message;   
        String accessToken = 'access token';
        if(!Test.isRunningTest())        	 
        	accessToken=accessToken();
        
        system.debug('accessToken===>'+accessToken);
        
        //leadId = '00Q3C000004YSLxUAO';
         
        SPR_Doma_API__c domaAPI = [SELECT Id, Client_Id__c, Client_Secret__c, API_Domain__c FROM SPR_Doma_API__c LIMIT 1];
          
        String endPoint = 'https://'+domaAPI.API_Domain__c+'/orders/'+orderId;
        System.debug('endPoint: '+endPoint);
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(endPoint);
        req.setHeader('Authorization','Bearer '+accessToken);
        req.setHeader('Accept','*/*');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');         
        req.setHeader('charset','UTF-8'); 
        req.setMethod('GET');
        //req.setBody(body);

        //System.debug('body: '+body);
        
        HTTP httpCallout = new HTTP();

        HTTPResponse res = httpCallout.send(req);
 
        System.debug('responseStr: '+res.getBody());
        Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
		System.debug('responsePayloadMAP: '+responsePayloadMAP);        
        if(res.getStatusCode() == 200)
        {
             
            record.Transaction_Type__c=String.valueOf(responsePayloadMAP.get('transaction_type'));
            record.Loan_Amount__c =Decimal.valueOf(String.valueOf(responsePayloadMAP.get('loan_amount')));
            record.Loan_Number__c=String.valueOf(responsePayloadMAP.get('loan_number'));
            record.Address__c=String.valueOf(responsePayloadMAP.get('address'));
            record.Unit__c=String.valueOf(responsePayloadMAP.get('unit'));
            record.City__c=String.valueOf(responsePayloadMAP.get('city'));
            record.County__c=String.valueOf(responsePayloadMAP.get('county'));
            record.Zip_Code__c=String.valueOf(responsePayloadMAP.get('zip_code'));
            record.State__c=String.valueOf(responsePayloadMAP.get('state'));
            record.Mortgage_Type__c=String.valueOf(responsePayloadMAP.get('mortgage_type'));
            record.Property_Usage_Type__c=String.valueOf(responsePayloadMAP.get('property_usage_type'));
            record.Order_Status__c=String.valueOf(responsePayloadMAP.get('order_status'));
            record.File_Number__c=String.valueOf(responsePayloadMAP.get('file_number'));
            record.Status__c=True;
            //update record;
        }
        
        // Retrieve the document
        // /orders/order_2211322727/documents/doc_4062265438
        String endPointDocument = 'https://'+domaAPI.API_Domain__c+'/orders/'+orderId+'/documents';
        System.debug('endPointDocument: '+endPointDocument);
        HTTPRequest reqDocument = new HTTPRequest();
        reqDocument.setEndpoint(endPointDocument);
        reqDocument.setHeader('Authorization','Bearer '+accessToken);
        reqDocument.setHeader('Accept','*/*');
        reqDocument.setHeader('Content-Type','application/json');
        reqDocument.setHeader('Accept','application/json');         
        reqDocument.setHeader('charset','UTF-8'); 
        reqDocument.setMethod('GET');
         
        HTTP httpCalloutDocument = new HTTP();

        HTTPResponse resDocument = httpCalloutDocument.send(reqDocument);
        System.debug('resDocument-->'+resDocument);
        System.debug('resDocument.getBody()-->'+resDocument.getBody());
        if(resDocument.getStatusCode() == 200){
            system.debug('resDocument '+resDocument.getBody());
            DomaJSON2Apex objResult = DomaJSON2Apex.parse(resDocument.getBody());
             
            system.debug('objResult--> '+objResult);
            system.debug('objResult.documents--> '+objResult.documents);
            
            List<Title_and_Valuation_Document__c> tvdListExisting =[Select Id,Document_Id__c From Title_and_Valuation_Document__c Where Title_and_Escrow__c=:record.Id ];
            system.debug('tvdListExisting--> '+tvdListExisting);
            Map<String,Title_and_Valuation_Document__c> tvdListExistingMap =new Map<String,Title_and_Valuation_Document__c>();
            if(tvdListExisting.size()>0){
                for(Title_and_Valuation_Document__c tvd: tvdListExisting){
                    tvdListExistingMap.put(tvd.Document_Id__c,tvd);
                }
            }
            system.debug('tvdListExistingMap--> '+tvdListExistingMap);
            List<Title_and_Valuation_Document__c> tvdList = new List<Title_and_Valuation_Document__c>();
            if(objResult!=null && objResult.documents!=null && objResult.documents.size()>0){
                
                for(DomaJSON2Apex.cls_documents cls:objResult.documents){
                    system.debug('cls--> '+cls);
                    if(!tvdListExistingMap.containsKey(cls.id)){
                        Title_and_Valuation_Document__c tvd = new Title_and_Valuation_Document__c();
                        tvd.Document_Id__c=cls.id;
                        tvd.Document_Type__c=cls.type;
                        tvd.Href__c=cls.href;
                        tvd.Title_and_Escrow__c=record.Id;
                        tvd.Order_Id__c=orderId;
                        tvdList.add(tvd);
                    }
                }
            }
            system.debug('tvdList--> '+tvdList);
            if(tvdList.size()>0){
                insert tvdList;
            }
             
            // updated Title and Escrow 
            update record;
             
            
        }
               
    }
    
    public static void getDocumentAndSave(Title_and_Valuation_Document__c record){
        String accessToken = 'access token';
        if(!Test.isRunningTest())        	 
        	accessToken=accessToken();
        
        SPR_Doma_API__c domaAPI = [SELECT Id, Client_Id__c, Client_Secret__c, API_Domain__c FROM SPR_Doma_API__c LIMIT 1];
       
        
        String endPointDocument = 'https://'+domaAPI.API_Domain__c+record.Href__c;
        System.debug('endPointDocument: '+endPointDocument);
        HTTPRequest reqDocument = new HTTPRequest();
        reqDocument.setEndpoint(endPointDocument);
        reqDocument.setHeader('Authorization','Bearer '+accessToken);
        reqDocument.setHeader('Accept','*/*');
        reqDocument.setHeader('Content-Type','application/json');
        reqDocument.setHeader('Accept','application/json');         
        reqDocument.setHeader('charset','UTF-8'); 
        reqDocument.setMethod('GET');
        HTTP httpCalloutDocument = new HTTP();

        HTTPResponse resDocument = httpCalloutDocument.send(reqDocument);
        System.debug('resDocument-->'+resDocument);
        System.debug('resDocument.getBody()-->'+resDocument.getBody());
        if(resDocument.getStatusCode() == 200){
            
            Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(resDocument.getBody());
            System.debug('responsePayloadMAP-->'+responsePayloadMAP);
            if(responsePayloadMAP.containsKey('content')){
                System.debug('filename-->'+responsePayloadMAP.get('filename'));
                System.debug('content-->'+responsePayloadMAP.get('content'));
                String filename =String.valueOf(responsePayloadMAP.get('filename'));
                String content =String.valueOf(responsePayloadMAP.get('content'));
                ContentVersion cv = new ContentVersion();
                cv.Title = filename; 
                cv.PathOnClient = 'Doma-'+record.Id+'.pdf';
                cv.VersionData =   EncodingUtil.base64Decode(content); 
                 
                insert cv;
                
                ContentVersion cvv = [SELECT Id, Title, ContentDocumentId 
                                      FROM ContentVersion 
                                      WHERE Id = :cv.Id LIMIT 1];
                system.debug('cvv '+cvv.ContentDocumentId);
                
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = record.Id;
                contentlink.ContentDocumentId = cvv.ContentDocumentId;
                insert contentlink;
                
                record.File_Name__c=filename;
                record.Status__c=true;
                update record;
                
            }
             
        }
        
    }
    /* ================================================================================================================ */
    
      @AuraEnabled
    public static String runDomaOppWsSubmitOrder(String recordId){

        System.debug('recordId-->'+recordId);
        String message;   
        String accessToken = 'access token';
        //if(!Test.isRunningTest())        	 
        	accessToken=accessToken();
        
        system.debug('accessToken===>'+accessToken);
        
        //leadId = '00Q3C000004YSLxUAO';

        String first_name;
        String middle_name;
        String last_name;
        String email;
        String home_phone;
        String cell_phone;
        String work_phone;
        
        String address;
        String city;
        String state;
        String county;
        String zip_code;
        String loan_number;
        Decimal loan_amount=0;
        String unit=''; 
        String tax_id_number='';
        
        String first_name_contact='';
        String middle_name_contact='';
        String last_name_contact='';
        String email_contact='';
        String home_phone_contact='';
        String oppId ='';
        if(recordId.startsWith('a3d')){
            Opportunity_Worksheet__c oppWorksheet  = [SELECT Id, Name, Opportunity__c FROM Opportunity_Worksheet__c WHERE Id =: recordId LIMIT 1];
            
            Opportunity opportunity = [SELECT ID, Investment_Amount__c, Property__r.Property_Address__c, 
            Property__c, Property__r.Street__c, Property__r.Unit__c,
            Property__r.City__c, Property__r.State_Province__c, Property__r.County__c, Property__r.Zip_Postal_Code__c, 
            Owner.FirstName,Owner.MiddleName,Owner.LastName, Contact_Phone__c, Owner_Email__c, Splitero_File_Number__c,
            Processor__c,Processor__r.FirstName,Processor__r.MiddleName,Processor__r.LastName,Processor__r.Email,Processor__r.Phone,
            (Select Id, Legal_First_Name__c,Legal_Middle_Name__c,Legal_Last_Name__c,Email__c,
             Social_Security_Number__c,Phone_Number__c From Applications__r)
            FROM Opportunity WHERE Id = :oppWorksheet.Opportunity__c LIMIT 1];
            oppId = opportunity.Id;
            
            loan_amount=opportunity.Investment_Amount__c!=null?opportunity.Investment_Amount__c:0;
            
            first_name=opportunity.Owner.FirstName!=null?opportunity.Owner.FirstName:'';
            middle_name=opportunity.Owner.MiddleName!=null?opportunity.Owner.MiddleName:'';
            last_name=opportunity.Owner.LastName!=null?opportunity.Owner.LastName:'';
            email=opportunity.Owner_Email__c!=null?opportunity.Owner_Email__c:'';
            home_phone = opportunity.Contact_Phone__c!=null?opportunity.Contact_Phone__c:'';
            cell_phone = '';
            work_phone = '';
            
            if(opportunity.Applications__r.size()>0){
                first_name=opportunity.Applications__r[0].Legal_First_Name__c !=null?opportunity.Applications__r[0].Legal_First_Name__c:'';
                middle_name=opportunity.Applications__r[0].Legal_Middle_Name__c!=null?opportunity.Applications__r[0].Legal_Middle_Name__c:'';
                last_name=opportunity.Applications__r[0].Legal_Last_Name__c!=null?opportunity.Applications__r[0].Legal_Last_Name__c:'';
                email=opportunity.Applications__r[0].Email__c!=null?opportunity.Applications__r[0].Email__c:'';
                home_phone = opportunity.Applications__r[0].Phone_Number__c!=null?opportunity.Applications__r[0].Phone_Number__c:'';
                cell_phone = opportunity.Applications__r[0].Phone_Number__c!=null?opportunity.Applications__r[0].Phone_Number__c:'';
                tax_id_number = opportunity.Applications__r[0].Social_Security_Number__c!=null?opportunity.Applications__r[0].Social_Security_Number__c:'';
            }
        
            //address = opportunity.Property__r.Property_Address__c!=null?opportunity.Property__r.Property_Address__c:'';
            address = opportunity.Property__r.Street__c!=null?opportunity.Property__r.Street__c:'';
            city = opportunity.Property__r.City__c!=null?opportunity.Property__r.City__c:'';
            state = opportunity.Property__r.State_Province__c!=null?opportunity.Property__r.State_Province__c:'';
            county = opportunity.Property__r.County__c!=null?opportunity.Property__r.County__c:'';
            zip_code = opportunity.Property__r.Zip_Postal_Code__c!=null?opportunity.Property__r.Zip_Postal_Code__c:'';
            loan_number=opportunity.Splitero_File_Number__c!=null?opportunity.Splitero_File_Number__c:'';
            
			unit = opportunity.Property__r.Unit__c!=null?opportunity.Property__r.Unit__c:'';            
            system.debug('opportunity.Processor__c=====> ' + opportunity.Processor__c);
            if(opportunity.Processor__c!=null){
                first_name_contact=opportunity.Processor__r.FirstName!=null?opportunity.Processor__r.FirstName:'';
                middle_name_contact=opportunity.Processor__r.MiddleName!=null?opportunity.Processor__r.MiddleName:'';
                last_name_contact=opportunity.Processor__r.LastName!=null?opportunity.Processor__r.LastName:'';
                email_contact=opportunity.Processor__r.Email!=null?opportunity.Processor__r.Email:'';
                home_phone_contact=opportunity.Processor__r.Phone!=null?opportunity.Processor__r.Phone:'';
            }
            
            
        }
        else{
            Lead leadRecord = [Select Id,Property__c,Property__r.Property_Address__c,Property__r.City__c,
            Property__r.County__c,Property__r.State_Province__c,Property__r.Zip_Postal_Code__c,
            Owner.FirstName,Owner.MiddleName,Owner.LastName,Owner.Email,Owner.Phone,
            Alternate_Phone_2__c,Co_Owner_Phone__c,Phone,Splitero_File_Number__c,Email
            From Lead Where ID =:recordId Limit 1] ;

            first_name=leadRecord.Owner.FirstName!=null?leadRecord.Owner.FirstName:'';
            middle_name=leadRecord.Owner.MiddleName!=null?leadRecord.Owner.MiddleName:'';
            last_name=leadRecord.Owner.LastName!=null?leadRecord.Owner.LastName:'';
            email=leadRecord.Email!=null?leadRecord.Email:'';
            home_phone = leadRecord.Phone!=null?leadRecord.Phone:'';
            cell_phone = leadRecord.Co_Owner_Phone__c!=null?leadRecord.Co_Owner_Phone__c:'';
            work_phone = leadRecord.Alternate_Phone_2__c!=null?leadRecord.Alternate_Phone_2__c:'';
        
            address = leadRecord.Property__r.Property_Address__c!=null?leadRecord.Property__r.Property_Address__c:'';
            city = leadRecord.Property__r.City__c!=null?leadRecord.Property__r.City__c:'';
            state = leadRecord.Property__r.State_Province__c!=null?leadRecord.Property__r.State_Province__c:'';
            county = leadRecord.Property__r.County__c!=null?leadRecord.Property__r.County__c:'';
            zip_code = leadRecord.Property__r.Zip_Postal_Code__c!=null?leadRecord.Property__r.Zip_Postal_Code__c:'';
            loan_number=leadRecord.Splitero_File_Number__c!=null?leadRecord.Splitero_File_Number__c:'';
            
            // For lead, its not having lookup for Processor
            first_name_contact=first_name;
            middle_name_contact=middle_name;
            last_name_contact=last_name;
            email_contact=email;
            home_phone_contact=home_phone;
            
        }
       
        //String borrowers ='"borrowers":[{"primary":true,"first_name":"'+first_name+'","middle_name":"'+middle_name+'","last_name":"'+last_name+'","email":"'+email+'","home_phone":"'+home_phone+'","cell_phone":"'+cell_phone+'","work_phone":"'+work_phone+'"}]';
        String borrowers ='"borrowers":[{"primary":true,"first_name":"'+first_name+'","middle_name":"'+middle_name+'","last_name":"'+last_name+'","email":"'+email+'","home_phone":"'+home_phone+'","cell_phone":"'+cell_phone+'","tax_id_number":"'+tax_id_number+'"}]';
		//String contacts ='"contacts":[{"first_name":"'+first_name+'","middle_name":"'+middle_name+'","last_name":"'+last_name+'","email":"'+email+'","phone":"'+home_phone+'"}]';
        String contacts ='"contacts":[{"first_name":"'+first_name_contact+'","middle_name":"'+middle_name_contact+'","last_name":"'+last_name_contact+'","AccountId":"0013C00000k7HR9QAM","email":"'+email_contact+'","phone":"'+home_phone_contact+'"}]';
        
        //String body = '{'+borrowers+','+contacts+',"mortgage_type":"CONV","property_usage_type":"PRIMARY","transaction_type":"HELOC","loan_amount":"1000","address":"'+address+'","unit":"","city":"'+city+'","county":"'+county+'","state":"'+state+'","zip_code":"'+zip_code+'","loan_number":"'+loan_number+'"}' ;
		String body = '{'+borrowers+','+contacts;
        
        body+=',"transaction_type":"HELOC"';
        body+=',"loan_amount":"'+loan_amount+'"';
        body+=',"address":"'+address+'"';
        body+=',"unit":"'+unit+'"';
        body+=',"city":"'+city+'"';
        body+=',"county":"'+county+'"';
        body+=',"state":"'+state+'"';
        body+=',"zip_code":"'+zip_code+'"';
        body+=',"loan_number":"'+loan_number+'"';
        body+=',"mortgage_type":""';
        body+=',"property_usage_type":""';          
        body+='}';
        
        System.debug('body-->'+body);
        SPR_Doma_API__c domaAPI = [SELECT Id, Client_Id__c, Client_Secret__c, API_Domain__c FROM SPR_Doma_API__c LIMIT 1];
          
        String endPoint = 'https://'+domaAPI.API_Domain__c+'/orders/';
        System.debug('endPoint: '+endPoint);
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(endPoint);
        req.setHeader('Authorization','Bearer '+accessToken);
        req.setHeader('Accept','*/*');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');         
        req.setHeader('charset','UTF-8'); 
        req.setMethod('POST');
        req.setBody(body);

        System.debug('body: '+body);
        
        HTTP httpCallout = new HTTP();

        HTTPResponse res = httpCallout.send(req);
 
        System.debug('responseStr: '+res.getBody());
        System.debug('res.getStatusCode(): '+res.getStatusCode());
        System.debug('res.getStatusCode(): '+res.getStatus());
        //System.debug('response ===> : '+res);
        Map<String, Object> responsePayloadMAP = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        system.debug('responsePayloadMAP==========> ' + responsePayloadMAP);
        //responsePayloadMAP.put('loan_number',loan_number);
        if(res.getStatusCode() == 200) 
        { 
             
            String orderId=String.valueOf(responsePayloadMAP.get('id')).replace('order_','');
            String status=String.valueOf(responsePayloadMAP.get('order_status')) ;
            
            Title_and_Escrow__c tes = new Title_and_Escrow__c();
 
            tes.Title_and_Escrow_Source__c = 'Doma';
            
            if(recordId.startsWith('a3d')){
            	tes.Opportunity__c = oppId;
                tes.Opportunity_Worksheet__c = recordId;
            }else{
                tes.Lead__c = recordId;
            }
			tes.Transaction_ID__c = orderId;  
            tes.Order_Status__c=status;
            try{
                insert tes;
                message = 'Success';
            }catch(Exception e){
                System.debug('Error while inserting Title_and_Escrow_Source__c record -->'+e.getMessage());
                message = e.getMessage();
            }
            
        }
        else if(res.getStatusCode() == 422)
        {
            if(responsePayloadMAP.containsKey('loan_number')){
                System.debug('Loan number already exist' );
                System.debug(responsePayloadMAP.get('loan_number') );
                message = 'Loan number already exist'+String.valueOf(responsePayloadMAP.get('loan_number'));
            }else{
                System.debug('Improper data' );
                //message = res.getBody();
                message = 'Improper data';
            }
            
        }else{
            System.debug('Error while submitting order' );
            message = 'Error while submitting order';
        } 
        return message;
        
    }
    
    
}