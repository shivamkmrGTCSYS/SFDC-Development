public class PropertyTriggerHandler {
    
    public static void populateSpliteroProperty(List<Property__c> propLst){
        for(Property__c prop:propLst){
            String sPType = PropertyMappingUtility.getSpliteroPropertyType(prop.Property_Type_Tax__c);
            
            if(prop.Property_Type_Tax__c !=null ){
                prop.Property_Type__c = sPType; 
                
                prop.Property_Type__c = (prop.HOA__c =='Yes' ?'HOA': prop.Property_Type__c); 
            }
            
            prop.Property_Type__c = (prop.HOA__c =='Yes' ?'HOA': sPType);
        } 
    }
    
    public static void populateSpliteroProperty(List<Property__c> propLst,Map<Id,Property__c> propOldMap){
        for(Property__c prop:propLst){
            String sPType = PropertyMappingUtility.getSpliteroPropertyType(prop.Property_Type_Tax__c);
            
            if( prop.Property_Type_Tax__c !=null && propOldMap.get(prop.id).Property_Type_Tax__c != prop.Property_Type_Tax__c ){
                prop.Property_Type__c = sPType; 
                
                prop.Property_Type__c = (prop.HOA__c =='Yes' ?'HOA': prop.Property_Type__c); 
            }
            
            if( propOldMap.get(prop.id).HOA__c != prop.HOA__c  ){
                prop.Property_Type__c = (prop.HOA__c =='Yes' ?'HOA': sPType); 
            }
            
        } 
    }
    
    public static void UpdateDocument(List<Property__c> propLst,Map<Id,Property__c> propOldMap){
        Set<String> propIdSet = New Set<String>();
        for(Property__c pro : propLst){
               
            if((pro.Number_Of_Owner__c != propOldMap.get(pro.Id).Number_Of_Owner__c)||
               ( pro.Flood_Zone__c != propOldMap.get(pro.Id).Flood_Zone__c && pro.Flood_Zone__c !=null )){ 
            	propIdSet.add(pro.Id);
            }
        }
        if(propIdSet.size()>0){
            System.debug('property-->');
            List<Opportunity> oppList = [Select Id , Name from Opportunity Where Property__c IN: propIdSet ];
            SPR_DocumentUtility.updateDocument(oppList ) ;             
        }
       
    }
    
}