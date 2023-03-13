public class SPR_LeadConversionHelperCntrl {
    /*
    public static void leadConversion( Map < Id, Lead > leadMap )
    {

        Set <Id> setOpportunityIds = new Set <Id> ();	
        
        Map <Id, List <AVM__c>> avmMapWithOptyId = new Map <Id, List <AVM__c>> ();
        Map <Id, List < Property__c>> propertyMapWithOptyId = new Map <Id, List < Property__c>> ();
        Map <Id, List <Application__c>> applicationMapWithOptyId = new Map <Id, List <Application__c>> ();
        Map <Id, List <Title_and_Escrow__c>> titleAndEscrowMapWithOptyId = new Map <Id, List <Title_and_Escrow__c>> ();
        Map <Id, List <Amazon_S3_Files__c>> s3FileWithOptyId = new Map <Id, List <Amazon_S3_Files__c>> ();

        List<Lead> leadList = [SELECT Id, IsConverted, convertedOpportunityId, 
                                (SELECT Id, Opportunity__c FROM AVMs__r), 
                                (SELECT Id, Opportunity__c FROM Properties__r),
                                (SELECT Id, Opportunity__c FROM Applications__r),
                                (SELECT Id, Opportunity__c FROM Title_and_Escrow__r),
                                (SELECT Id, Opportunity__c FROM Amazon_S3_Files__r)
                              FROM Lead 
                              WHERE Id IN :leadMap.keySet()];
       
        for(Lead objLead : leadList) 
        {
            if (objLead.IsConverted /*&& objLead.IsConverted != trigger.oldMap.get( objLead.Id ).IsConverted*/ /*)
            {
                setOpportunityIds.add( objLead.convertedOpportunityId );

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
        
        
        
        List <AVM__c> avmList = new List <AVM__c> ();
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
                    for (AVM__c avm : avmMapWithOptyId.get( optyId ) )
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
                if(propertyMapWithOptyId.containsKey( opty.Id ))
                {
                    opty.Property__c = propertyMapWithOptyId.get( opty.Id )[0].Id;
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
        } 

        if ( titleAndEscrowList.size() > 0)
        {
            update titleAndEscrowList;
        }

        if ( s3FileList.size() > 0)
        {
            update s3FileList;
        }
        
        if ( opportunityList.size() > 0)
        {
            update opportunityList;
        } 
    }*/    
}