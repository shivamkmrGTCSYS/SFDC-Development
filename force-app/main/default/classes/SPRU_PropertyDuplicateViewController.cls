public class SPRU_PropertyDuplicateViewController {

    @AuraEnabled
    public static List<Lead> getDuplicateProperty (String recordId,String recordType){
        try {

            List<Lead> propertiesList=new List<Lead>();
            Lead lead =[ SELECT Id,Name FROM Lead WHERE Id=:recordId]; 
            propertiesList.add(lead);
            
            List<Lead> matchingProperties=new List<Lead>();
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(propertiesList);
            for (Datacloud.FindDuplicatesResult findDupeResult : results) {
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                        for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                            System.debug('Duplicate Record: ' + matchRecord.getRecord());
                            matchingProperties.add((Lead)matchRecord.getRecord());
                        }
                    }
                }
            }
            List<Id> propertyIds = new List<Id>(new Map<Id, Lead>(matchingProperties).keySet());
            List<Lead> propertyList=[SELECT Id,Name, street,city,country,state,postalCode FROM  Lead WHERE Id IN :propertyIds ];
            return propertyList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }
    
}