public class SPR_PhotoPreview {

    
     @AuraEnabled
    public static List<Map<String, String>> generateAwsPhotosURL(String recordId)
    {
        String s3fileId = recordId;
        String  objectApiName = SPR_AWSFolderViewController.findObjectNameFromRecordIdPrefix(recordId);
        System.debug('objectApiName-->' + objectApiName);
        if(objectApiName == 'Lead'){
            objectApiName = 'Lead__c';
        }else if(objectApiName == 'Opportunity'){
            objectApiName = 'Opportunity__c';
        }
        System.debug('s3fileId-->' + s3fileId); 
          
        /*List < Amazon_S3_Files__c > s3 = [SELECT id, File_Name__c, File_Path__c, AWS_File_Key__c, 
                                          Loan_Application__c, File_Type__c, Folder_Name__c, Loan_Origination__c 
                                          FROM Amazon_S3_Files__c WHERE AWS_File_Key__c =: s3fileId];
        System.debug('s3-->' + s3);*/

        String query = ' Select id, File_Name__c, File_Path__c, AWS_File_Key__c, File_Type__c, Folder_Name__c From Amazon_S3_Files__c Where Folder_Name__c=\'Photos\' AND '+objectApiName+' =\''+recordId+'\'';
        System.debug('query-->' + query);
        List<Amazon_S3_Files__c> s3 = Database.query(query) ;
        System.debug('s3-->' + s3);
         
		List<Map<String, String >> responseList = new List<Map<String, String >>();
        if (s3.size() > 0)
        {
            for(Amazon_S3_Files__c s3file: s3){             
                // String imageUrl = SUN_FilePreviewController.getSignedURL(EncodingUtil.urlDecode(s3file.AWS_File_Key__c, 'UTF-8'));  
                 
                Map <String, String> response = new Map<String, String>();
                response.put('Id', s3file.Id);
                // response.put('imageUrl', imageUrl);
                response.put('Folder_Name', s3file.Folder_Name__c);                 
                response.put('Amazon_S3_Files_Id', s3file.Id); 
                
                responseList.add(response) ;
                System.debug('response-->' + response);
            }
        }
        System.debug('responseList-->' + responseList);
        return responseList;
    }
    
    
    
}