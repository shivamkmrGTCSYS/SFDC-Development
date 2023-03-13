public with sharing class SPR_RadianAPIUtil 
{
   @AuraEnabled
   public static String sendRequest(String recordId)
   {return '';}
   @AuraEnabled    
   public static String sendRequest(String recordId, String nameIdentifier)
   {
      String street = '';
      String city = '';
      String state = '';
      String country = '';
      String postalCode = '';

      String status;
      String message;

      String dtTime = String.valueof(System.now().getTime());
      String requestDueDate = String.valueof(System.now().getTime());
      String referenceId = String.valueof(Integer.valueof(Math.random() * 10000))+''+String.valueof(System.now().getTime());

      if(recordId.startsWith('006'))
      {
         Opportunity opportunity = [SELECT ID, Property__c, Property__r.Street__c, Property__r.City__c, Property__r.State_Province__c, Property__r.County__c, Property__r.Zip_Postal_Code__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
         street = String.isNotBlank( opportunity.Property__r.Street__c ) ? opportunity.Property__r.Street__c : '';
         city = String.isNotBlank( opportunity.Property__r.City__c ) ? opportunity.Property__r.City__c : '';
         state = String.isNotBlank( opportunity.Property__r.State_Province__c ) ? opportunity.Property__r.State_Province__c : '';
         country = String.isNotBlank( opportunity.Property__r.County__c ) ? opportunity.Property__r.County__c : '';
         postalCode = String.isNotBlank( opportunity.Property__r.Zip_Postal_Code__c ) ? opportunity.Property__r.Zip_Postal_Code__c : '';
      }
      else
      {
         Lead lead = [SELECT Id, Street, City, State, Country, PostalCode FROM Lead WHERE Id = :recordId LIMIT 1];
         street = String.isNotBlank( lead.Street ) ? lead.Street : '';
         city = String.isNotBlank( lead.City ) ? lead.City : '';
         state = String.isNotBlank( lead.State ) ? lead.State : '';
         country = String.isNotBlank( lead.Country ) ? lead.Country : '';
         postalCode = String.isNotBlank( lead.PostalCode ) ? lead.PostalCode : '';
      }

      String requestBody = '<REQUEST_GROUP MISMOVersionID="2.3">'+
      '<REQUESTING_PARTY _Identifier="SPLI" />'+
      '<RECEIVING_PARTY _Identifier="RBP" />'+
      '<SUBMITTING_PARTY LoginAccountIdentifier="Splitero" LoginAccountPassword="Integration2022!">'+
         '<PREFERRED_RESPONSE _Destination="Postback URL" _Format="XML" _Method="HTTPS" />'+
      '</SUBMITTING_PARTY>'+
      '<REQUEST RequestDatetime="' + dtTime + '" RequestingPartyBranchIdentifier="SPLITERO">'+
         '<KEY _Name="ReferenceId" _Value="' + referenceId + '" />'+
         '<REQUEST_DATA>'+
            '<PROPERTY_INFORMATION_REQUEST _PoolName="SPLITERO" _OrderBy="ben@splitero.com" _ActionType="Submit" _SpecialInstructionsDescription="CONTACT JOHN @111-528-5856. OWNER LIVES AT THE ADDRESS">'+
               '<_PRODUCT _CatagoryType="APPRAISAL" RequestedDueDate_extension="'+requestDueDate+'">'+
                  '<_NAME _Identifier="'+nameIdentifier+'" _Description="1004: Single Family Appraisal" />'+
               '</_PRODUCT>'+
               '<PROPERTY _StreetAddress="'+ street +' " _City="'+ city +'" _State="'+ state +'" _County="'+ country +'" _PostalCode="'+ postalCode +'" LastSalePriceAmount="250000" LastSaleDatet="" _OwnerEstimatedValueAmount="250000" />'+
            '</PROPERTY_INFORMATION_REQUEST>'+
            '<BORROWER_INFORMATION _Type="BW">'+
               '<BORROWER _FirstName="John" _LastName="Smith">'+
                  '<CONTACT_DETAIL>'+
                     '<CONTACT_POINT _Type="P" _Value="4121112222" />'+
                     '<CONTACT_POINT _Type="E" _Value="john@test.comd" />'+
                  '</CONTACT_DETAIL>'+
               '</BORROWER>'+
            '</BORROWER_INFORMATION>'+
            '<LOAN_INFORMATION _LoanId="123456789" _LoanType="" _LoanAmount="" />'+
            '<LOAN_PROCESSOR _FirstName="John" _LastName="Smith">'+
               '<CONTACT_DETAIL>'+
                  '<CONTACT_POINT _Type="P" _Value="4121112222" />'+
                  '<CONTACT_POINT _Type="E" _Value="john@test.comb" />'+
               '</CONTACT_DETAIL>'+
            '</LOAN_PROCESSOR>'+
         '</REQUEST_DATA>'+
      '</REQUEST>'+
   '</REQUEST_GROUP>';

      System.debug('== Response '+requestBody);
      HttpRequest httpRequest = new HttpRequest();
      httpRequest.setEndpoint('https://falcon.radianvaluations.com/secureapi/vibeorder/accept');
      httpRequest.setMethod('POST');
      httpRequest.setHeader('Content-Type', 'application/xml');
      httpRequest.setBody(requestBody);

      Http http = new Http();
      HTTPResponse httpResponse = http.send(httpRequest);
      system.debug('response===>'+httpResponse.getBody());

      Dom.Document doc = httpResponse.getBodyDocument();

      /*String load = '<RESPONSE_GROUP MISMOVersionID="2.3">'+
                     '<RESPONSE ResponseDateTime="">'+ 
                     '<KEY _Name="ReferenceId"  _Value="6701645433471727" />'+ 
                     '<STATUS _Condition="Failure" _Code="-900" _Name="" _Description="No valid products ordered or product(s) not in client profile."/>'+
                     '</RESPONSE></RESPONSE_GROUP>';
      Dom.Document doc = new DOM.Document();
      doc.load(load);*/
      
      Dom.XMLNode root = doc.getRootElement();

      system.debug('** root element **'+root); 
      
      for(Dom.XMLNode node : root.getChildElements()) 
      {
         system.debug('1===>'+node.getName()); 
         for(Dom.XMLNode child : node.getChildElements())
         {
               if(child.getName() == 'STATUS')
               {
                  system.debug('status===>'+child.getAttribute('_Condition',''));
                  status = child.getAttribute('_Condition','');

                  system.debug('message**===>'+child.getAttribute('_Description',''));
                  message = child.getAttribute('_Description','');
               }
         }
      }
      
      if(status == 'Success')
      {
         system.debug('Return===>'+status);
         return status;
      }
      else
      {system.debug('Return===>'+message);
         return message;
      }        
   }
}