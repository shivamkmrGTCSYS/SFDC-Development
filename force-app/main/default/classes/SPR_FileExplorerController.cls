public class SPR_FileExplorerController {

    
    @AuraEnabled
    public static List<Amazon_S3_Files__c> getListOfApplicationFileId(Id opportunityWorksheetId,String folderId){
        List<Amazon_S3_Files__c> response = new List<Amazon_S3_Files__c>();
        System.debug('opportunityWorksheetId-->'+opportunityWorksheetId);
        System.debug('folderId-->'+folderId);
        String objectName = opportunityWorksheetId.getSObjectType().getDescribe().getName();
		System.debug('objectName-->'+objectName);
        if(objectName=='Credit_Report__c'){
            Credit_Report__c cr = [Select Id, Opportunity_Worksheet__c From Credit_Report__c Where Id=:opportunityWorksheetId Limit 1];
            opportunityWorksheetId = cr.Opportunity_Worksheet__c;
            folderId=Label.SPR_Credit_Report_Folder_Id;
        }
        if(opportunityWorksheetId!=null && folderId !=null){
            
            Opportunity_Worksheet__c ow = [Select Id, Opportunity__c From Opportunity_Worksheet__c Where Id=:opportunityWorksheetId Limit 1];
            System.debug('Opportunity__c-->'+ow.Opportunity__c);
            response = [SELECT Id, File_Name__c, File_Path__c,AWS_File_Key__c,Opportunity_Worksheet__c,Folder__c
                FROM Amazon_S3_Files__c
                WHERE Opportunity__c =:ow.Opportunity__c and Folder__c=:folderId];
        }
        return response;
        
    }
    
}