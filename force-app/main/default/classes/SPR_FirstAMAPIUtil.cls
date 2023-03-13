public with sharing class SPR_FirstAMAPIUtil {
    @AuraEnabled    
    public static String sendRequest( String recordId )
    {        
        SPR_FirstAMAPI__c firstAM = [SELECT Id, User_Name__c, Password__c, Endpoint__c FROM SPR_FirstAMAPI__c LIMIT 1];
        
        String request = prepareRequest(recordId);

        Blob headerValue = Blob.valueOf(firstAM.User_Name__c + ':' + firstAM.Password__c);

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);        

        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', authorizationHeader);
        req.setEndpoint(firstAM.Endpoint__c);
        req.setMethod('POST');
        req.setBody(request);

        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        system.debug('reponse===>'+res.getBody());
        String message = createRecord(res.getBody(), recordId);

        return message;
    }
    public static String prepareRequest(String recordId)
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
        
        if(recordId.startsWith('006'))
        {
            Opportunity opportunity = [SELECT ID, Property__c, Property__r.Street__c, Property__r.City__c, Property__r.State_Province__c, Property__r.County__c, Property__r.Zip_Postal_Code__c,Property__r.APN__c, Property__r.Property_Type__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
            street = String.isNotBlank( opportunity.Property__r.Street__c ) ? opportunity.Property__r.Street__c : '';
            city = String.isNotBlank( opportunity.Property__r.City__c ) ? opportunity.Property__r.City__c : '';
            state = String.isNotBlank( opportunity.Property__r.State_Province__c ) ? opportunity.Property__r.State_Province__c : '';
            country = String.isNotBlank( opportunity.Property__r.County__c ) ? opportunity.Property__r.County__c : '';
            postalCode = String.isNotBlank( opportunity.Property__r.Zip_Postal_Code__c ) ? opportunity.Property__r.Zip_Postal_Code__c : '';
            APN = String.isNotBlank( opportunity.Property__r.APN__c ) ? opportunity.Property__r.APN__c : '';
            propertyType = String.isNotBlank( opportunity.Property__r.Property_Type__c ) ? opportunity.Property__r.Property_Type__c : null;
            
            propertyId = opportunity.Property__c;
        }
        else
        {
            Lead lead = [SELECT Id, Street, City, State, Country, PostalCode, Property__c FROM Lead WHERE Id = :recordId LIMIT 1];
            street = String.isNotBlank( lead.Street ) ? lead.Street : '';
            city = String.isNotBlank( lead.City ) ? lead.City : '';
            state = String.isNotBlank( lead.State ) ? lead.State : '';
            country = String.isNotBlank( lead.Country ) ? lead.Country : '';
            postalCode = String.isNotBlank( lead.PostalCode ) ? lead.PostalCode : '';

            propertyId = lead.Property__c;
        }

        Map< String, Object > prepareRequest = new Map< String, Object >();

        prepareRequest.put('appSource', 'Splitero');        
        prepareRequest.put('service', 'EscrowTitle');
        prepareRequest.put('transactionType', 'SaleWithMortgage');        
        prepareRequest.put('externalTrackingId', 'salesforceo-office-audateri417z3"');
        prepareRequest.put('officeId', 'd');
        prepareRequest.put('escrowOfficerCode', '');        
        prepareRequest.put('titleOfficerCode', '');

        List< Map< String, Object> > parties = new List< Map< String, Object> >();

            Map< String, Object> party = new Map< String, Object> ();

            party.put('legalEntity', 'BusinessEntity');
            party.put('primaryName', 'Sample Business Entity');
            party.put('role', 'Lender');

                List< Map< String, Object> > contacts = new List< Map< String, Object> >();

                    Map< String, Object> contact = new Map< String, Object> ();
                    
                    contact.put('firstName', 'Joe');
                    contact.put('lastName', 'BusinessEntity');
                    contact.put('role', 'Other');

                        List< Map< String, Object> > contactPoints = new List< Map< String, Object> >();

                            Map< String, Object> contactPoint = new Map< String, Object> ();

                            contactPoint.put('contactPointType', 'Work');
                            contactPoint.put('emailAccount', 'sample@firstam.com');
                            contactPoint.put('phoneNumber', '1234571425');

                        contactPoints.add(contactPoint);  

                    contact.put('contactPoints', contactPoints);

                contacts.add(contact);

            party.put('contacts', contacts);

        parties.add(party);

        /**------ */

        Map< String, Object> party1 = new Map< String, Object> ();

            party1.put('firstName', 'Joe');
            party1.put('lastName', 'REAgent');
            party1.put('role', 'SellerRealEstateAgent');                

                List< Map< String, Object> > contactPoints1 = new List< Map< String, Object> >();

                    Map< String, Object> contactPoint1 = new Map< String, Object> ();

                    contactPoint1.put('contactPointType', 'Work');
                    contactPoint1.put('emailAccount', 'sample@firstam.com');
                    contactPoint1.put('phoneNumber', '9876571425');

                contactPoints1.add(contactPoint1); 

            party1.put('contactPoints', contactPoints1);

        parties.add(party1);

        /**------ */

        prepareRequest.put('parties', parties);




       // Map< String, Object> parties = new Map< String, Object>();

        Map< String, Object> propertyAddress = new Map< String, Object>();

        propertyAddress.put('addressLine1', street);
        propertyAddress.put('cityName', city);
        propertyAddress.put('postalCode', postalCode);
        propertyAddress.put('stateCode', state);
        propertyAddress.put('countyName', country);
        propertyAddress.put('propertyType', null);
        propertyAddress.put('APN', '');

        prepareRequest.put('propertyAddress', propertyAddress);  

        Map< String, Object> loan = new Map< String, Object>();

        loan.put('loanNumber', 'Loan12345-345');
        loan.put('loanAmount', '1234');
        loan.put('loanType', 'FHA');

        prepareRequest.put('loan', loan);

        Map< String, Object> transactionDetails = new Map< String, Object>();

        transactionDetails.put('contractSignedDate', '');
        transactionDetails.put('earnestMoneyDeposit', '234');
        transactionDetails.put('inspectionEndDate', '');
        transactionDetails.put('homeOwnersAssociation', 'false');
        transactionDetails.put('closeOfEscrowDate', '');
        transactionDetails.put('acquisitionPrice', '1290');

        List< Map< String, Object> > payoffInformations = new List< Map< String, Object> >();

        for(Integer i=0; i<1; i++)
        {
            Map< String, Object> payoffInformation = new Map< String, Object>();
            payoffInformation.put('payoffType', 'LenderOrderSubordinate');
            payoffInformation.put('loanNumber', '787782232');
            payoffInformation.put('loanAmount', '70000');
            payoffInformation.put('lienPosition', '1');
            payoffInformation.put('liabilityType', 'MortgageLoan');
            payoffInformation.put('lenderName', 'Wells Fargo');
            payoffInformation.put('lenderPhone', '1112223333');

            payoffInformations.add(payoffInformation);
        }

        transactionDetails.put('payoffInformations', payoffInformations);
        prepareRequest.put('transactionDetails', transactionDetails);

        system.debug('prepareRequest===>'+JSON.serialize(prepareRequest));
        String request = JSON.serialize(prepareRequest);
        return request;
    }
    public static String createRecord(String response, String recordId)
    {
        Title_and_Escrow__c tes = new Title_and_Escrow__c();

        if(recordId.startsWith('006'))
        {
            tes.Title_and_Escrow_Source__c = 'First American';
            tes.Opportunity__c = recordId;
        }
        else
        {
            tes.Title_and_Escrow_Source__c = 'First American';
            tes.Lead__c = recordId;
        }

        insert tes;
        return 'Success';
    }
}