/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ApplicationTriggerUtility {
    
    public static void updateNumToWords(List<Application__c> appList, Map<Id,Application__c> oldmap ){        
        for(Application__c app : appList){
            if(app.Investment_Amount__c!=null && (oldmap==null || (oldmap!=null && app.Investment_Amount__c !=oldmap.get(app.Id).Investment_Amount__c ))){
                app.Investment_Amount_in_Word__c=NumberToWord.english_number(app.Investment_Amount__c) ;
            }
        }
    }
    
    /*public static void updateSyncToWeb(List<Application__c> appList ){        
        for(Application__c app : appList){
            app.Sync_to_Web__c=false;
        }
    }*/
    public static void updateLeadStatus(List<Application__c> appList, Map<Id,Application__c> appOldMap){
        
        List<Lead> leadList = new List<Lead>();
        for(Application__c app: appList){
            if(app.Lead__c!=null){
                Lead l = new Lead();
                l.Id=app.Lead__c;
                l.Status='Inquiring';
                l.Application_Started__c=app.Application_Started__c;
                l.Application_Question_Completed__c=app.Application_Question_Completed__c;
                leadList.add(l);
                
            }
        }
        if(leadList.size()>0){             
            update leadList;
        }
        
    }
    
    public static void updateLeadStatusApplying(List<Application__c> appList, Map<Id,Application__c> appOldMap){
        
        List<Lead> leadList = new List<Lead>();
        List<String> leadIds = new List<String>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        for(Application__c app: appList){
            if(app.Lead__c!=null ){
                leadIds.add(app.Lead__c);
            }
        }
        if(leadIds.size()>0){
            leadMap =new Map<Id,Lead>([Select Id, Status From Lead Where Id IN:leadIds]);
        }
        
        for(Application__c app: appList){
            if(app.Lead__c!=null && appOldMap !=null && appOldMap.get(app.Id).Step_1_Completion_Time__c ==null && app.Step_1_Completion_Time__c !=null && app.Step_2_Completion_Time__c ==null ){
                
                Lead l = new Lead();
                l.Id=app.Lead__c;
                /*l.Application_Started__c=app.Application_Started__c;
                l.Application_Question_Completed__c=app.Application_Question_Completed__c;
                
                if(app.Lead__c!=null && leadMap.containsKey(app.Lead__c) && (leadMap.get(app.Lead__c).Status=='New' || leadMap.get(app.Lead__c).Status=='Attempting Contact')){
                    if(app.Status__c=='Applying')
                        l.Status='Applying';
                }*/               
                
                l.Status='Applying';
                leadList.add(l); 
            }
        }
        if(leadList.size()>0){ 
            SPR_TriggerUtility.ByPassAllTrigger=true;
            update leadList;
        }
        
    } 
    
    public static void convertLead(List<Application__c> appList,Map<Id,Application__c> OldMap){
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        
        LeadStatus ConvertStatus = [ SELECT Id, ApiName,MasterLabel FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1 ];
        Set<String> appIdSet = new Set<String>();
        Map<String,Application__c> leadAppMap = new Map<String,Application__c>();
        Set<String> leadIdSets = new Set<String>();
        
        for(Application__c app : appList){             
            if(app.Lead__c !=null ){
                leadIdSets.add(app.Lead__c);
            }
        }
        Date startDate = date.newinstance(2022, 8, 19);
        Map<Id,Lead> leadMap = new Map<Id,Lead>([Select Id From Lead Where Id IN: leadIdSets AND CreatedDate>:startDate]);
        if(Test.isRunningTest()){
            leadMap = new Map<Id,Lead>([Select Id From Lead ]);
        }
        for(Application__c app : appList){             
            if(app.Lead__c !=null  &&
               leadMap.containsKey(app.Lead__c)
               && app.Step_7_Completion_Time__c != OldMap.get(app.Id).Step_7_Completion_Time__c 
               && OldMap.get(app.Id).Step_7_Completion_Time__c==null 
            ){
                appIdSet.add(app.Id);                 
            }
        }
        System.debug('appIdSet-->'+appIdSet);
        if(appIdSet.size()>0){
			List<Application__c> appLeadList = [Select Id, Lead__c,Lead__r.isConverted, Lead__r.OwnerId, Desired_Investment__c, 
                                                Legal_First_Name__c, Legal_Last_Name__c, Property_Address__c, 
                                                Application_Completion_Date__c,  Lead__r.Property__r.Property_Address__c,
                                                Lead__r.Email
                                                From Application__c 
                                                Where Id IN:appIdSet AND Lead__r.isConverted=:false ] ; 
            System.debug('appLeadList-->'+appLeadList);
            if(appLeadList.size()>0){ 
                Set<String> emailSet = new Set<String>();
                Map<String,Contact> emailContactMap = new Map<String,Contact>();
                for(Application__c app : appLeadList){
                    if(app.Lead__c!=null && app.Lead__r.Email!=null) emailSet.add(app.Lead__r.Email);
                }
                System.debug('emailSet-->'+emailSet);
                if(emailSet.size()>0){
                    List<Contact> conList = [Select Id,Email,AccountId From Contact Where Email IN :emailSet ];
                    if(conList.size()>0){
                        for(Contact con: conList){
                            if(con.Email!=null && con.AccountId!=null)
                            	emailContactMap.put(con.Email,con);
                        }
                    }
                }
                System.debug('emailContactMap-->'+emailContactMap);
                for(Application__c app : appLeadList){
                    System.debug('app.Lead__r.isConverted-->'+app);
                    
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(app.Lead__c);
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    if(emailContactMap.containsKey(app.Lead__r.Email)){
                        lc.setContactId(emailContactMap.get(app.Lead__r.Email).Id);
                        lc.setAccountId(emailContactMap.get(app.Lead__r.Email).AccountId);
                    }
                    leadConverts.add(lc);
                    leadAppMap.put(app.Lead__c,app);
                }
                System.debug('leadConverts-->'+leadConverts);
                Database.LeadConvertResult[] leadConvertsChunkResults = Database.convertLead(leadConverts, false);
                System.debug('leadConvertsChunkResults-->'+leadConvertsChunkResults);
                List<Application__c> appListToUpdate = new List<Application__c>();
                List<Opportunity> oppListToUpdate = new List<Opportunity>();
                for(Database.LeadConvertResult lcr: leadConvertsChunkResults){
                    String leadId=lcr.getLeadId();
                    String accId= lcr.getAccountId();
                    String conId= lcr.getContactId();

                    Application__c appUpdate = leadAppMap.get(leadId);
                    appUpdate.Lead__c=leadId;
                    appUpdate.Account__c=accId;
                    appUpdate.Contact__c=conId;
                    System.debug('appUpdate-->'+appUpdate);

                    if(lcr.getOpportunityId() != null) {
                        String oppName = appUpdate.Legal_First_Name__c+' '+appUpdate.Legal_Last_Name__c+' - '+appUpdate.Lead__r.Property__r.Property_Address__c;
                        oppName = oppName.left(120);
                        Opportunity opp = new Opportunity(Id=lcr.getOpportunityId(), 
                                                          Homeowner_Advisor__c=appUpdate.Lead__r.OwnerId,
                                                          Application_completed_date__c=DateTime.now(),
                                                          Investment_Amount_Requested__c=appUpdate.Id);
                        appUpdate.Opportunity__c = opp.Id;

                        oppListToUpdate.add(opp);
                    }

                    appListToUpdate.add(appUpdate);

                    // Debugs
                    System.debug(lcr.getErrors());
                    System.debug(lcr.isSuccess());
                    System.debug(lcr.getContactId() );
                    System.debug(lcr.getAccountId() );
                    System.debug(lcr.getLeadId() );
                }
                System.debug('appListToUpdate-->'+appListToUpdate);
                if(appListToUpdate.size()>0){
                    SPR_TriggerUtility.ByPassAllTrigger=True;
                    update appListToUpdate;
                    update oppListToUpdate;
                    SPR_TriggerUtility.ByPassAllTrigger=False;
                }
            }
        }
               
    }  
    
    public static void processLinkedProperty(List<Application__c> appList,Map<Id,Application__c> OldMap){
        Map<Id,Property__c> propertyTobeUpdate = new Map<Id,Property__c>();
        
        for(Application__c app :appList){
            if(app.Step_7_Completion_Time__c != null && app.Property__c != null && app.HOA__c != OldMap.get(app.id).HOA__c){
                propertyTobeUpdate.put( app.Property__c, new Property__c(id=app.Property__c,HOA__c =app.HOA__c ) );
            }
        }
        
        if( !propertyTobeUpdate.isEmpty()){ update propertyTobeUpdate.values(); }
    }
    
    public static void fillPropertyFromApplicationLead(List<Application__c> appList,Map<Id,Application__c> OldMap){
        Set<String> leadIds = new Set<String>();
        Map<String,String> appLeadMap = new Map<String,String>();
        for(Application__c app : appList){
            if(app.Property__c==null && app.Lead__c!=null){
                leadIds.add(app.Lead__c);
                appLeadMap.put(app.Id,app.Lead__c);
            }
        }
        
        if(leadIds.size()>0){
            Map<Id,Lead> leadMap = new Map<Id,Lead>([Select Id, Property__c From Lead Where Id IN :leadIds ]);
            for(Application__c app : appList){
                if(app.Property__c==null && app.Lead__c!=null){
                    String propertyId = leadMap.containsKey(app.Lead__c)?leadMap.get(app.Lead__c).Property__c:'';
                    app.Property__c=propertyId;
                }
            }
        }
    }
    
    public static void UpdateDocument(List<Application__c> appList , Map<Id, Application__c> OldMap){
        
        Set<String> appIdSet = New Set<String>();
        for(Application__c app : appList){
            if( (app.x1st_Loan_Mod__c!=OldMap.get(app.Id).x1st_Loan_Mod__c  ) || 
				(app.X2nd_Loan_Mod__c!= OldMap.get(app.Id).X2nd_Loan_Mod__c  )||
                (app.Marital_Status__c!=OldMap.get(app.Id).Marital_Status__c  )||
                (app.Number_of_Co_Owners_excluding_yourself__c>0)||
                (app.Vesting_Type__c!=OldMap.get(app.Id).Vesting_Type__c  )||
                (app.Vesting_Type__c!=OldMap.get(app.Id).Vesting_Type__c  )||
                (app.Solar_or_Energy_Efficient_Loan__c!=OldMap.get(app.Id).Solar_or_Energy_Efficient_Loan__c  )||
                (app.Property_listed_or_under_contract__c!=OldMap.get(app.id).Property_listed_or_under_contract__c )||
                (app.HERO_or_PACE_loan__c!=OldMap.get(app.Id).HERO_or_PACE_loan__c  ) || 
               (app.Current_or_Soon_to_Commence_Remodels__c!=OldMap.get(app.Id).Current_or_Soon_to_Commence_Remodels__c  ) || 
               (app.Ongoing_or_Pending_Lawsuits_or_actions__c!=OldMap.get(app.Id).Ongoing_or_Pending_Lawsuits_or_actions__c  ) || 
               (app.Unpermitted_WorkCode_Violations_Non_Co__c!=OldMap.get(app.Id).Unpermitted_WorkCode_Violations_Non_Co__c  ) || 
               (app.Hazardous_Substances__c!=OldMap.get(app.Id).Hazardous_Substances__c  ) || 
               (app.Major_System_Faliors__c!=OldMap.get(app.Id).Major_System_Faliors__c  ) 
               
              ){
                appIdSet.add(app.Id);          
            }   
        }
        if(appIdSet.size()>0){
            
            List<Opportunity> oppList = [Select Id , Name from Opportunity Where Application__c IN: appIdSet ];
        	System.debug('Application trigger'+oppList);
            SPR_DocumentUtility.updateDocument(oppList ) ;
        }
        
        
    }
     
    
}