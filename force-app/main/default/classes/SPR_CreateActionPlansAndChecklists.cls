public with sharing class SPR_CreateActionPlansAndChecklists implements Database.Batchable<sObject>
{
     
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT id, StageName,Processor__c,Underwriting_QA__c,Homeowner_Advisor__c,Underwriter__c from Opportunity';
        return Database.getQueryLocator(query);
    }
  
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        
        
        
        // anything to iterate
        Opportunity opp = (Opportunity)scope[0];
		List<ActionPlan> apList = [Select Id From ActionPlan Where TargetId=:opp.Id];        
         
        if(apList.size()==0){
            SPR_OpportunityTriggerHelper.createActionPlan(new List<Opportunity>{opp},null);
        }
        
        List<Document__c> docList = [Select Id From Document__c Where Opportunity__c=:opp.Id]; 
        if(docList.size()==0){
             createDocument(new List<Opportunity>{opp}); 
        }
    }
  
    public void finish(Database.BatchableContext BC)
    {

    }
    
    public static void createDocument(List<Opportunity> oppList){
        
        Map<String, Document_Checklist_to_Stage__mdt> DctoStageMap = Document_Checklist_to_Stage__mdt.getAll();
        List<Document__c> DocumentList = New List<Document__c>();
        Map<String,String> rtMap = new Map<String,String>();
        //Id internalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        //Id externalRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
        List<RecordType> rtList = [Select Id, DeveloperName From RecordType Where sObjectType='Document__c'];
        for(RecordType rt: rtList){
            rtMap.put(rt.DeveloperName,rt.Id);
        }
        for(Opportunity opp :oppList ){
            if(opp.StageName=='Closing' || opp.StageName=='Closed Won'){
                
            }else {
            	for(Document_Checklist_to_Stage__mdt DcMap :DctoStageMap.values()){
                	Document__c Doc = New Document__c();
                    //Doc.RecordTypeId = dcMap.Make_Visible_in_Portal__c == true ? externalRecordTypeId : internalRecordTypeId;
                    if(DcMap.Record_Type__c!=null && rtMap.containsKey(DcMap.Record_Type__c)) 
                    {
                        Doc.RecordTypeId = rtMap.get(DcMap.Record_Type__c);
                    }
                    Doc.Name = DcMap.Document_Checklist_Name__c;
                    Doc.Required__c = DcMap.Required__c;
                    Doc.Opportunity__c = opp.id;
                    Doc.Document_Key__c = DcMap.DeveloperName;
                    Doc.Document_Type__c=DcMap.Document_Type__c;
                    Doc.SF_Folder_Name__c=DcMap.SF_Folder_Name__c;
                    DocumentList.add(Doc);
                }
            }
        }        
        
        if(DocumentList.size()>0){
          //insert DocumentList;
          SPR_DocumentUtility.upsertDocument(oppList, DocumentList) ;
        }
    }
    
}