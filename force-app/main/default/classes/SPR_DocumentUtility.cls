public class SPR_DocumentUtility {
    
    public static void updateDocument(List<Opportunity> oppList ){
        
        List<Document__c> DocumentList = [Select Id,Name,Required__c,Opportunity__c,Status__c,Document_Type__c,
                                          Opportunity__r.StageName
                                          From Document__c Where Opportunity__c IN :oppList];              
        
        if(DocumentList.size()>0){ 
            SPR_DocumentUtility.upsertDocument(oppList, DocumentList) ;
        }
    }
    
    public static void upsertDocument(List<Opportunity> oppNewList, List<Document__c> DocumentList){
        
        Map<String,Opportunity> oppMAp = new Map<String,Opportunity>([ Select Id,Application__c, Property__c,Opportunity_Worksheet__c, 
                                                                      Hybrid_Appraisal_Required__c,
                                                                      Application__r.x1st_Loan_Mod__c,Application__r.X2nd_Loan_Mod__c,
                                                                      Property__r.Number_Of_Owner__c,Property__r.Flood_Zone__c, 
                                                                      Application__r.Id,Application__r.Marital_Status__c,Application__r.Number_of_Co_Owners_excluding_yourself__c,
                                                                      Application__r.Vesting_Type__c,Application__r.Property_listed_or_under_contract__c,Application__r.Status__c,
                                                                      Application__r.HERO_or_PACE_loan__c,Application__r.Solar_or_Energy_Efficient_Loan__c,
                                                                      Application__r.Major_System_Faliors__c,Application__r.Current_or_Soon_to_Commence_Remodels__c,
                                                                      Application__r.Ongoing_or_Pending_Lawsuits_or_actions__c,
                                                                      Application__r.Unpermitted_WorkCode_Violations_Non_Co__c,
                                                                      Application__r.Hazardous_Substances__c,
                                                                      Opportunity_Worksheet__r.Id,Opportunity_Worksheet__r.AVM_Eligible__c,
                                                                      Opportunity_Worksheet__r.Credit_Report__c,Opportunity_Worksheet__r.Credit_Report__r.Id,
                                                                      Application_Status1__c ,StageName
                                                                      From Opportunity 
                                                                      Where ID IN:oppNewList ]);
        
        
        Set<String> owIds = new Set<String>(); 
        
        Map<String,String> owOppIdMap = new Map<String,String>();
        Map<String,List<String>> owOppIdListMap = new Map<String,List<String>>();
        
        for(Opportunity opp : oppMAp.values()){
            
            if(opp.Opportunity_Worksheet__c!=null){
                owIds.add(opp.Opportunity_Worksheet__c);
                owOppIdMap.put(opp.Opportunity_Worksheet__c,opp.Id);
                if(!owOppIdListMap.containsKey(opp.Opportunity_Worksheet__c)){
                    owOppIdListMap.put(opp.Opportunity_Worksheet__c,new List<String>());
                }
                owOppIdListMap.get(opp.Opportunity_Worksheet__c).add(opp.Id);
                System.debug('Opportunity_Worksheet__c-->'+opp.Opportunity_Worksheet__c);
                System.debug('opp.Id-->'+opp.Id);
            }
            
        } 
        System.debug('owOppIdListMap-->'+owOppIdListMap);
        Map<String,List<Mortgage__c>> oppMortageListMap = findMortgage(owIds,owOppIdListMap);
        
        //Map<String,TitleReportWrapper> titleReportWrapperObj = findTitleReport(owIds,owOppIdMap);
        Map<String,List<Mortgage_Statement__c>> oppMortgageStatement= findMortgageStatement(owIds,owOppIdListMap);
        Map<String,List<Recorded_Instruments__c>> oppRecordedInstrument = findRecordedInstrument(owIds,owOppIdListMap);
        
        Map<String,CreditReportWrapper> creditReportWrapperObj= findCreditReportWrapper(owIds,owOppIdListMap);
        Map<String,DQHistoryWrapper>  DQHistoryWrapperObj = findDQHistoryWrapper( owIds ,owOppIdListMap);
        
        Map<String,TitleReportWrapper> titleReportWrapperObj = findTitleReportWrapper(owIds, owOppIdListMap);
        
        Map<String , Opportunity_Stage_Sequence__mdt> opportunityStageSequenceMap = Opportunity_Stage_Sequence__mdt.getAll();
        Map<String , Document_Checklist_to_Stage__mdt> documentMap = Document_Checklist_to_Stage__mdt.getAll();
        
        List<Document__c> docListToUpdate = new List<Document__c>();
        
        for(Document__c doc: DocumentList){
            Opportunity opp;
            if(oppMAp.containsKey(doc.Opportunity__c)){
                opp = oppMAp.get(doc.Opportunity__c);
            }
            Boolean checkOppSTage = checkOpportunityStage(doc.Name,doc.Opportunity__r.StageName,opportunityStageSequenceMap,documentMap) ;
            
            if(doc.Name=='ID Front' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
                Document__c docUpdated = IDFront( opp, doc) ;
                if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }
                system.debug(' checkOppSTage--->'+checkOppSTage);                
            }
            if(doc.Name=='ID Back' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated= IDBack( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }                
            }
            if(doc.Name=='Death Certificiate' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = DeathCertificiate( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }                 
            }
            if(doc.Name=='Divorce Decree' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = DivorceDecree( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }                
            } 
            if(doc.Name=='Marriage Certificate' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = MarriageCertificate( opp, doc) ;
              if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }                
            }
            if(doc.Name=='Insurance Dec Page' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = InsuranceDecPage( opp, doc) ; 
                if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }
            }
            if(doc.Name=='Estimated Settlement Statement' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
                Document__c docUpdated = EstimatedSettlementStatement( opp, doc) ; 
                if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }
            }  
            if(doc.Name=='Preliminary Title Report' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = PreliminaryTitleReport( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }                
            }
            if(doc.Name=='Tax Cert' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = TaxCert( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }                
            }
            if(doc.Name=='Vesting Deed' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = VestingDeed ( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Wiring Instructions' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = WiringInstructions( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Bankruptcy PACER Report' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = BankruptcyPACERReport( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Evidence Of Insurance' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = EvidenceOfInsurance( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Insurance Replacement cost Estimator' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               /*Document__c docUpdated = InsuranceReplacementcostEstimator( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } */
            }
            if(doc.Name=='Credit Report' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
              Document__c docUpdated = CreditReport( opp, doc) ;  
              if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                }  
            }
            if(doc.Name=='Data Tree reports' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = DataTreereports( opp, doc) ;  
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Flood insurance cert' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = Floodinsurancecert( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }  
            if(doc.Name=='HEIE Initial' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = HEIEInitial( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='HEIE Initial Signed' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = HEIEInitialSigned( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Estimate 2-6' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = Estimate( opp, doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            } if(doc.Name=='HEIE Final' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = HEIEFinal( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='HEIE Final Signed' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = HEIEFinalSigned ( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Notice of Incompleteness' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
               Document__c docUpdated = NoticeofIncompleteness( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Co Owner ID Front' && doc.Opportunity__c!=null &&  checkOppSTage ){                	  
                //&& doc.Opportunity__r.StageName=='Processing')               
               Document__c docUpdated = CoOwnerIDFront( opp, doc) ;
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Co Owner ID Back' && doc.Opportunity__c!=null && checkOppSTage ){
               Document__c docUpdated = CoOwnerIDFront( opp, doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='1st Mortgage Statement' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = IstMortgageStatement(doc,oppMortageListMap,titleReportWrapperObj);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='2nd Mortgage Statement' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = IIndMortgageStatement(doc,oppMortageListMap,titleReportWrapperObj);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Mortgage Note' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = MortgageNote(oppRecordedInstrument ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }           
            if(doc.Name=='Loan Mod Note, Deferral Agreement' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = LoanModNoteDeferralAgreement(oppMortgageStatement,oppMAp,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Settlement Payoff Letters' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = SettlementPayoffLetters(creditReportWrapperObj ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='PACE Statement' && doc.Opportunity__c!=null && checkOppSTage){
               /*Document__c docUpdated = PACEStatement(doc,titleReportWrapperObj,opp);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } */
            }
            if(doc.Name=='Payoff Demand' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = PayoffDemand(doc,titleReportWrapperObj);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Extenuating Circumstance for BK/Foreclosure' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = ExtenuatingCircumstanceforBKForeclosure(doc,DQHistoryWrapperObj);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }            
            if(doc.Name=='Trust docs' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = Trustdocs(doc,opp);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }            
            if((doc.Name=='LLC Docs' || doc.Name=='LLC Certificate of Good Standing' || doc.Name=='LLC EIN' || doc.Name=='LLC Operating Agreement') && checkOppSTage){
               Document__c docUpdated = LLCDocs(doc,opp);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Tax Lien Release' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = TaxLienRelease(doc,titleReportWrapperObj);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Mechanics Waiver Lien' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = MechanicsWaiverLien(opp,titleReportWrapperObj ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='LOE' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = LOE(creditReportWrapperObj ,doc,opp);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Listing agreement' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = ListingAgreement(opp ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Flood Insurance' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = FloodInsurance(opp ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
                System.debug('doc-->'+doc);
            } 
            if(doc.Name=='Deed of Trust' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = DeedofTrust(titleReportWrapperObj ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Judgment or Lien recorded document' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = JudgmentorLien(titleReportWrapperObj ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }
            if(doc.Name=='Judgment or Lien release' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = JudgmentorLien(titleReportWrapperObj ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
                
            } 
            if(doc.Name=='Subordination agreement' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = SubordinationAgreement(titleReportWrapperObj ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            } 
            if(doc.Name=='Recorded title documents' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = RecordedTitleDocuments(titleReportWrapperObj ,doc);
               if(doc!=null){
                    docListToUpdate.add(doc);
                } 
            } 
            if((doc.Name=='Collateral Analytics AVM' || doc.Name=='Clear Capital AVM'  || doc.Name=='Veros AVM')&& doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = CollateralAnalyticsAVM(opp ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            } 
            if( (doc.Name=='Hybrid Appraisal' || doc.Name=='Hybrid Appraisal Invoice') && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = HybridAppraisal(opp ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            }       
            if(doc.Name=='Adverse Action Notice' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = AdverseActionNotice(opp ,doc);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            } 
            if(doc.Name=='Authorization to Obtain Consumer Credit Report' && doc.Opportunity__c!=null && checkOppSTage){
               Document__c docUpdated = AuthorizationtoObtainConsumerCreditReport(creditReportWrapperObj ,doc,opp);
               if(docUpdated!=null){
                    docListToUpdate.add(docUpdated);
                } 
            } 
            
        }     
        // upsert document
        upsert docListToUpdate;
    }
    
    public static Document__c docToEligible(Document__c doc,Boolean newRequired){
        if(doc.Required__c!=newRequired){
            doc.Required__c=newRequired;
            return doc;
        }
        return null;
    }
    public static Document__c IDFront(Opportunity opp,Document__c doc){
       /* Boolean required=false; 
        if(opp!=null && opp.StageName=='Pre-Approving' ){
            required=True;
        } 
       */
        return docToEligible(doc,true); 
    } 
    public static Document__c IDBack(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Pre-Approving' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }    
    public static Document__c DeathCertificiate(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    } 
    public static Document__c DivorceDecree(Opportunity opp,Document__c doc){
       /* Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    } 
    public static Document__c MarriageCertificate(Opportunity opp,Document__c doc){
       /* Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
       return docToEligible(doc,true);
    }  
    public static Document__c InsuranceDecPage(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
       return docToEligible(doc,true);
    }
    public static Document__c EstimatedSettlementStatement(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    } 
    public static Document__c PreliminaryTitleReport(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }      
    public static Document__c TaxCert(Opportunity opp,Document__c doc){
     /*   Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
       return docToEligible(doc,true);
    }
    public static Document__c VestingDeed(Opportunity opp,Document__c doc){
     /*   Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }
    public static Document__c WiringInstructions(Opportunity opp,Document__c doc){
       /* Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }
    public static Document__c BankruptcyPACERReport(Opportunity opp,Document__c doc){
     /*   Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
       return docToEligible(doc,true);
    }
    public static Document__c EvidenceOfInsurance(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Closing' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }
    /*public static Document__c InsuranceReplacementcostEstimator (Opportunity opp,Document__c doc){
     /*   Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } /*/
       /*return docToEligible(doc,true);
    }*/
    public static Document__c CreditReport(Opportunity opp,Document__c doc){
       /* Boolean required=false; 
        if(opp!=null && opp.StageName=='Pre-Approving' ){
            required=True;
        } /*/
       return docToEligible(doc,true);
    }
    public static Document__c DataTreereports(Opportunity opp,Document__c doc){
     /*   Boolean required=false; 
        if(opp!=null && opp.StageName=='Pre-Approving' ){
            required=True;
        } */
        return docToEligible(doc,true);
    }
    public static Document__c Floodinsurancecert(Opportunity opp,Document__c doc){
       /* Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } */
        return docToEligible(doc,true);
    }
    public static Document__c HEIEInitial(Opportunity opp,Document__c doc){
  /*      Boolean required=false; 
        if(opp!=null && opp.StageName=='Pre-Approving' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }
    public static Document__c HEIEInitialSigned(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Intent to Proceed' ){
            required=True;
        } */
       return docToEligible(doc,true);
    }
    public static Document__c Estimate(Opportunity opp,Document__c doc){
        /*Boolean required=false; 
        if(opp!=null && opp.StageName=='Processing' ){
            required=True;
        } */
        return docToEligible(doc,true);
    }
    public static Document__c HEIEFinal(Opportunity opp,Document__c doc){
     /*   Boolean required=false; 
        if(opp!=null && opp.StageName=='Underwriting' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }
    public static Document__c HEIEFinalSigned(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Final Intent to Proceed' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }
    public static Document__c NoticeofIncompleteness(Opportunity opp,Document__c doc){
      /*  Boolean required=false; 
        if(opp!=null && opp.StageName=='Closed Won' ){
            required=True;
        } /*/
        return docToEligible(doc,true);
    }
    public static Document__c CoOwnerIDFront(Opportunity opp,Document__c doc){
            Boolean required=false; 
            if(opp!=null && opp.Application__c!=null && (opp.Application__r.Marital_Status__c=='Married' || opp.Application__r.Number_of_Co_Owners_excluding_yourself__c>0) ){
                required=True;
            }else if(opp!=null && opp.Property__c!=null && opp.Property__r.Number_Of_Owner__c<=0 ){             
                required=True;
            }
        	return docToEligible(doc,required);
             
        }
    public static Document__c IstMortgageStatement(Document__c doc,Map<String,List<Mortgage__c>> oppMortageListMap,Map<String,TitleReportWrapper> oppExcpList){
        Boolean required=false; 
        if(oppMortageListMap.containsKey(doc.Opportunity__c)){             
            if(oppMortageListMap.get(doc.Opportunity__c).size()>0){
                required=true;
            }
        } 
        if(oppExcpList.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = oppExcpList.get(doc.Opportunity__c) ;
            if(newMap.excpList!=null && newMap.excpList.size()>0){
                for(Exception__c excep : newMap.excpList){                    
                    if(excep.Type__c=='Mortgage'){
                        required=true; 
                        break;
                    }             
                }
            }             
        } 
        return docToEligible(doc,required);
        
    }
    public static Document__c IIndMortgageStatement(Document__c doc,Map<String,List<Mortgage__c>> oppMortageListMap,Map<String,TitleReportWrapper> oppExcpList){
        Boolean required=false; 
        if(oppMortageListMap.containsKey(doc.Opportunity__c)){             
            if(oppMortageListMap.get(doc.Opportunity__c).size()>=2){
                required=true;
            }
        }else if(oppExcpList.containsKey(doc.Opportunity__c)){
            
            TitleReportWrapper newMap = oppExcpList.get(doc.Opportunity__c) ;            
            if(newMap.excpList!=null && newMap.excpList.size()>=2){
                system.debug('execption...');
                required=true;
            } 
        }
        return docToEligible(doc,required);
    }
    public static Document__c MortgageNote(Map<String, List<Recorded_Instruments__c>> oppRecordedInstrument ,Document__c doc){
        Boolean required=false; 
        if(oppRecordedInstrument.containsKey(doc.Opportunity__c)){
            List<Recorded_Instruments__c> rinsList = oppRecordedInstrument.get(doc.Opportunity__c); 
            for(Recorded_Instruments__c rins :rinsList){
                if((rins.Oddities__c !=null && rins.Oddities__c.split(';').indexOf('Interest Only')!=-1)||
                   (rins.Riders__c!=null &&rins.Riders__c.split(';').indexOf('Adjustable Rate')!=-1)){
                       required=true;
                       break;
                   }         
            }    
        }
        return docToEligible(doc,required); 
    }
    public static Document__c LoanModNoteDeferralAgreement(Map<String,List<Mortgage_Statement__c>> oppMortgageStatement, Map<String,Opportunity> oppMAp ,Document__c doc){
        Boolean required=false; 
        if(oppMortgageStatement.containskey(doc.Opportunity__c)){
            List<Mortgage_Statement__c> msList = oppMortgageStatement.get(doc.Opportunity__c);
            for(Mortgage_Statement__c ms :msList){
                system.debug('msList'+msList);
                if(ms.Deferred_Amount__c>0 || ms.Deferred_Amount_to_payoff__c>0){
                    required=true;
                }
            }
        } else if(oppMAp.containskey(doc.Opportunity__c)){
            Opportunity opp = oppMAp.get(doc.Opportunity__c);
            
            if(opp.Application__r.x1st_Loan_Mod__c=='YES'|| opp.Application__r.X2nd_Loan_Mod__c=='YES'){
                required=true;
            }
        }         
        return docToEligible(doc,required);
    }
    public static Document__c SettlementPayoffLetters( Map<String,CreditReportWrapper> titleReportObj ,Document__c doc){
        Boolean required=false; 
        
        if(titleReportObj.containsKey(doc.Opportunity__c)){
            CreditReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            List<CreditReportChildWrapper> creditList = newMap.creditList;            
            for(CreditReportChildWrapper crcw :creditList ){
                if(required==True){
                    break;
                }
                for(Collection__c collection : crcw.collectionList){
                    if(collection.Settlement_Amount__c>0){
                        required=True;
                        break;
                    }
                }                
            }            
            
            /*CreditReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            if(newMap.collectionList!=null && newMap.collectionList.size()>0){
                for(Collection__c collection : newMap.collectionList){
                    if(collection.Settlement_Amount__c>0){
                        required=True;
                        break;
                    }
                } 
            }*/
            
        }
        return docToEligible(doc,required);
    }
    /*public static Document__c PACEStatement(Document__c doc,Map<String,TitleReportWrapper> titleReportWrapperObj, Opportunity opp){
        Boolean required=false;
        if(titleReportWrapperObj.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = titleReportWrapperObj.get(doc.Opportunity__c) ;
            Boolean found = false;
            if(newMap.releaseList!=null && newMap.releaseList.size()>0){
                for(Release__c release : newMap.releaseList){
                    if(release.Type__c=='Hero/Pace'){
                        required=True;
                        found = true;
                        break;
                    }
                } 
            } 
            System.debug('found-->'+found);
            if(found == false){
                if(opp.Application__c!=null && opp.Application__r.HERO_or_PACE_loan__c=='Yes'){
                    System.debug('Else PACEStatement');
                    required=True;
                }
            }
        }
       return docToEligible(doc,required);
    }*/
    public static Document__c PayoffDemand(Document__c doc,Map<String,TitleReportWrapper> titleReportWrapperObj ){
        Boolean required=false;
        if(titleReportWrapperObj.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = titleReportWrapperObj.get(doc.Opportunity__c) ;            
            if(newMap.releaseList!=null && newMap.releaseList.size()>0){
                for(Release__c release : newMap.releaseList){
                    if(release.Type__c!='Easement' && release.Payoff_Required__c=='Yes'){
                        required=True;
                    }
                } 
            } 
        }
        return docToEligible(doc,required);
    }
    public static Document__c ExtenuatingCircumstanceforBKForeclosure(Document__c doc,Map<String,DQHistoryWrapper> oppDQHistoryList){
        Boolean required=false;
        if(oppDQHistoryList.containsKey(doc.Opportunity__c)){
            DQHistoryWrapper trw =oppDQHistoryList.get(doc.Opportunity__c) ;
            if(trw.dqHistoryList!=null && trw.dqHistoryList.size()>0){
                system.debug('aaa');
                for(DQ_History__c dq :trw.dqHistoryList ){                    
                    if(dq.Extenuating_Circumstances__c=='Yes'){
                        system.debug('dq.Extenuating_Circumstances__c'+dq.Extenuating_Circumstances__c);
                        required=True;
                    }                   
                }                
            }
        }
        return docToEligible(doc,required);
    }
    public static Document__c Trustdocs(Document__c doc, Opportunity opp){         
        Boolean required=false;
        if(opp.Application__c!=null && opp.Application__r.Vesting_Type__c=='Through a Trust'){
            required=True;
        }
       return docToEligible(doc,required);
    }
    public static Document__c LLCDocs(Document__c doc, Opportunity opp){         
        Boolean required=false;
        if(opp.Application__c!=null && opp.Application__r.Vesting_Type__c=='Through an LLC'){
            required=True;
        }
       return docToEligible(doc,required);
    }
    public static Document__c TaxLienRelease(Document__c doc,Map<String,TitleReportWrapper> titleReportWrapperObj ){
        Boolean required=false;
        if(titleReportWrapperObj.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = titleReportWrapperObj.get(doc.Opportunity__c) ;            
            if(newMap.releaseList!=null && newMap.releaseList.size()>0){
                for(Release__c release : newMap.releaseList){
                    if(release.Type__c=='Property Taxes' && release.Payoff_Required__c=='Yes'){
                        required=True;
                    }
                } 
            } 
        }
        return docToEligible(doc,required);
    }
    public static Document__c MechanicsWaiverLien( Opportunity opp,Map<String,TitleReportWrapper> titleReportWrapperObj ,Document__c doc){
        Boolean required=false;
        if(opp.Application__c!=null && opp.Application__r.Solar_or_Energy_Efficient_Loan__c=='Yes'){
            required=True;
        }else if(titleReportWrapperObj.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = titleReportWrapperObj.get(doc.Opportunity__c) ;            
            if(newMap.releaseList!=null && newMap.releaseList.size()>0){
                for(Release__c release : newMap.releaseList){
                    if(release.Type__c=='Solar'){
                        required=True;
                    }
                } 
            } 
        }
        return docToEligible(doc,required);
    }
    public static Document__c LOE( Map<String,CreditReportWrapper> titleReportObj ,Document__c doc, Opportunity opp){
        Boolean required=false;
        
        if(titleReportObj.containsKey(doc.Opportunity__c)){
        	CreditReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            List<CreditReportChildWrapper> creditList = newMap.creditList;            
            for(CreditReportChildWrapper crcw :creditList ){
              
                system.debug('crcw.CreditReport.SSN_DOB_Address_Mismatch__c-->'+crcw.CreditReport.SSN_DOB_Address_Mismatch__c);
                if(crcw.CreditReport.SSN_DOB_Address_Mismatch__c=='Yes'){
                    required=True;                    
                }
                if(required==True){
                    break; 
                }
                Date inquiryDate = Date.today().addDays(-120);
                for(Inquiry__c inquiry : crcw.inquiryList){                   
                    if(inquiry.Date__c>=inquiryDate){
                        required=True;
                         system.debug('in');
                        break;
                    }    
                }                
            }
              system.debug('crcw.CreditReport.SSN_DOB_Address_Mismatch__c===');
        }
        
        /*if(titleReportObj.containsKey(doc.Opportunity__c)){
            //Inquiry__c> inquiryList
            CreditReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            if(newMap.inquiryList!=null && newMap.inquiryList.size()>0){
                
                Date inquiryDate = Date.today().addDays(-120);
                for(Inquiry__c inquiry : newMap.inquiryList){                   
                    if(inquiry.Date__c>=inquiryDate){
                        required=True;
                    }    
                } 
            } 
        }*/
        
        if(opp.Application__r.Current_or_Soon_to_Commence_Remodels__c=='Yes' ||
           opp.Application__r.Ongoing_or_Pending_Lawsuits_or_actions__c=='Yes' || 
           opp.Application__r.Unpermitted_WorkCode_Violations_Non_Co__c=='Yes' || 
           opp.Application__r.Hazardous_Substances__c=='Yes'||
           opp.Application__r.Major_System_Faliors__c=='Yes'){
               required=True;
           }
        return docToEligible(doc,required);
    }
    public static Document__c ListingAgreement( Opportunity opp ,Document__c doc){
        Boolean Required=false;
        if(opp.Application__c!=null && opp.Application__r.Property_listed_or_under_contract__c=='Yes'){
            required=True;
        }
       return docToEligible(doc,required);
    }
    public static Document__c FloodInsurance( Opportunity opp ,Document__c doc){
        Boolean required=false;
        if(opp.Property__c!=null && opp.Property__r.Flood_Zone__c !=null ){ 
            if(opp.Property__r.Flood_Zone__c.indexOf('V') != -1 || opp.Property__r.Flood_Zone__c.indexOf('A') != -1 ){
                
                required=True;
            }
        }
        return docToEligible(doc,required);
    }
    public static Document__c DeedofTrust( Map<String,TitleReportWrapper> titleReportObj ,Document__c doc){
        Boolean required=false;
        if(titleReportObj.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ; 
            if(newMap.excpList!=null && newMap.excpList.size()>0){ 
                for(Exception__c excep : newMap.excpList){                    
                    if(excep.Type__c=='Mortgage'){
                        required=True;
                    }    
                } 
            } 
        }
        return docToEligible(doc,required);
        
    }
    public static Document__c JudgmentorLien( Map<String,TitleReportWrapper> titleReportObj ,Document__c doc){
        Boolean required=false;
        if(titleReportObj.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            if(newMap.releaseList!=null && newMap.releaseList.size()>0){                 
                for(Release__c release : newMap.releaseList){                    
                    if(release.Type__c=='Judgment' && release.Payoff_Required__c=='No'){
                        required=True;
                    }    
                } 
            } 
        }
        return docToEligible(doc,required);
    }
    public static Document__c SubordinationAgreement( Map<String,TitleReportWrapper> titleReportObj ,Document__c doc){
        Boolean required=false;
        if(titleReportObj.containsKey(doc.Opportunity__c)){             
            TitleReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            if(newMap.releaseList!=null && newMap.releaseList.size()>0){                 
                for(Release__c release : newMap.releaseList){                    
                    if(release.Type__c=='Solar' && release.Payoff_Required__c=='No'){
                        required=True;
                    }    
                } 
            } 
        }
       return docToEligible(doc,required);
    }
    public static Document__c RecordedTitleDocuments( Map<String,TitleReportWrapper> titleReportObj ,Document__c doc){
        Boolean required=false;
        if(titleReportObj.containsKey(doc.Opportunity__c)){
            TitleReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            if(newMap.excpList!=null && newMap.excpList.size()>0){  
                //system.debug('inside the condition');
                for(Exception__c excep : newMap.excpList){ 
                    //  system.debug('excep.Type__c');
                    if(excep.Type__c=='Other'){
                        required=True;
                    }    
                } 
            } 
        }
       return docToEligible(doc,required);
    }
    public static Document__c CollateralAnalyticsAVM(Opportunity opp, Document__c doc){
        Boolean required=false;
        if(opp.Opportunity_Worksheet__c != null && opp.Opportunity_Worksheet__r.AVM_Eligible__c=='Yes' && opp.Hybrid_Appraisal_Required__c != 'Yes'){
            required=True;
        }
       return docToEligible(doc,required);
    }
    public static Document__c HybridAppraisal(Opportunity opp, Document__c doc){
        Boolean required=false;
        if(opp.Hybrid_Appraisal_Required__c == 'Yes'){
            required=True;
        }
        return docToEligible(doc,required);
    }
    public static Document__c AdverseActionNotice(Opportunity opp, Document__c doc){
        Boolean required=false;
        if(opp.Application_Status1__c!=null && opp.Application_Status1__c == 'Denied'){
            required=True;
        }
        return docToEligible(doc,required);
    }
    public static Document__c AuthorizationtoObtainConsumerCreditReport(Map<String,CreditReportWrapper> titleReportObj ,Document__c doc, Opportunity opp){
        Boolean required=false; 
        if(titleReportObj.containsKey(doc.Opportunity__c)){
            CreditReportWrapper newMap = titleReportObj.get(doc.Opportunity__c) ;            
            List<CreditReportChildWrapper> creditList = newMap.creditList;            
            for(CreditReportChildWrapper crcw :creditList ){
            	Credit_Report__c CreditReport =crcw.CreditReport;
                Date expirationDate = Date.today();
                System.debug('expirationDate-->'+expirationDate);
                System.debug('CreditReport.Expiration_Date__c-->'+CreditReport.Expiration_Date__c);
                if(CreditReport.Expiration_Date__c<expirationDate){
                    required=true;
                    break; 
                }
            }          
        }
       return docToEligible(doc,required);
    }
    
    public static Map<String,List<Mortgage__c>> findMortgage(Set<String> owIds,Map<String,List<String>> owOppIdListMap){
        Map<String,List<Mortgage__c>> response = new Map<String,List<Mortgage__c>>();
        if(owIds.size()>0){
            List<Credit_Report__c> crList =[Select Id,Opportunity_Worksheet__c, 
                                            (Select Id From Mortgages__r)
                                            From Credit_Report__c 
                                            Where Opportunity_Worksheet__c IN:owIds];
            for(Credit_Report__c cr: crList){
                if(owOppIdListMap.containsKey(cr.Opportunity_Worksheet__c)){
                    List<String> oppIds = owOppIdListMap.get(cr.Opportunity_Worksheet__c);
                    for(String oppId : oppIds){ 
                        List<Mortgage__c> mortList = cr.Mortgages__r;
                        if(!response.containsKey(oppId)){
                            response.put(oppId,new List<Mortgage__c>());
                        }
                        response.get(oppId).addAll(mortList);
                    }
                }
                
            }
            
        }
        return response ;
    }
    public static Map<String,TitleReportWrapper> findTitleReportWrapper(Set<String> owIds,Map<String,List<String>> owOppIdListMap){
        Map<String,TitleReportWrapper> res = new Map<String,TitleReportWrapper>();
        List<Title_Report__c> trList = [Select Id,Opportunity_Worksheet__c, 
                                        (Select Id,Type__c From Exception__r),
                                        (Select Id,Type__c,Payoff_Required__c From Releases__r)
                                        
                                        From Title_Report__c
                                        Where Opportunity_Worksheet__c IN:owIds ];
        
        for(Title_Report__c tr: trList){
            System.debug('tr-->'+tr);
            String owid =tr.Opportunity_Worksheet__c;
            if(owOppIdListMap.containsKey(owid)){
                List<String> oppIds = owOppIdListMap.get(owid);
                for(String oppId : oppIds){ 
                    //String oppId = owOppIdMap.get(owid);
                    
                    System.debug('oppId-->'+oppId);
                    List<Exception__c> excpList = tr.Exception__r; 
                    List<Release__c> releaseList = tr.Releases__r;
                    
                    if(!res.containsKey(oppId)){
                        res.put(oppId,new TitleReportWrapper() );
                    }
                    TitleReportWrapper newRec = res.get(oppId);
                    newRec.oppId = oppId;
                    List<Exception__c> existingExcpList = newRec.excpList;
                    existingExcpList.addAll(excpList);
                    newRec.excpList=existingExcpList;
                    
                    List<Release__c> existingRelease = newRec.releaseList;
                    existingRelease.addAll(releaseList) ;
                    newRec.releaseList=existingRelease;
                    System.debug('newRec-->'+newRec);
                    res.put(oppId,newRec);                
                }
            }
        }        
        
        return res;
    }
    public static Map<String,DQHistoryWrapper> findDQHistoryWrapper(Set<String> owIds,Map<String,List<String>> owOppIdListMap){
        Map<String,DQHistoryWrapper> res = new Map<String,DQHistoryWrapper>();
        
        List<DQ_History__c> dqHistoryList = [Select Id, Extenuating_Circumstances__c,Opportunity_Worksheet__c	 
                                             From DQ_History__c 
                                             Where Opportunity_Worksheet__c IN:owIds 
                                             AND Extenuating_Circumstances__c='Yes'] ;
        for(DQ_History__c dqh: dqHistoryList){
            String owid =dqh.Opportunity_Worksheet__c;
            if(owOppIdListMap.containsKey(owid)){
                List<String> oppIds = owOppIdListMap.get(owid);
                for(String oppId : oppIds){ 
                    //String oppId = owOppIdMap.get(owid);
                    if(!res.containsKey(oppId)){
                        res.put(oppId,new DQHistoryWrapper()); 
                    }
                    DQHistoryWrapper trw = res.get(oppId);
                    trw.oppId=oppId;
                    List<DQ_History__c> existingDQH = trw.dqHistoryList;
                    existingDQH.add(dqh);
                    trw.dqHistoryList=existingDQH;
                    res.put(oppId,trw);
                }
            }            
        }
        
        return res;
    }
    public static Map<String,CreditReportWrapper> findCreditReportWrapper(Set<String> owIds,Map<String,List<String>> owOppIdListMap){
        Map<String,CreditReportWrapper> res = new Map<String,CreditReportWrapper>();
         
        List<Credit_Report__c> ccList = [Select Id,Opportunity_Worksheet__c,Expiration_Date__c,SSN_DOB_Address_Mismatch__c, 
                                         (Select Id, Settlement_Amount__c from Collections__r), 
                                         (Select Id,Date__c,Type__c From Inquiries__r) 
                                         From Credit_Report__c 
                                         Where Opportunity_Worksheet__c IN :owIds];
        /*
        for(Credit_Report__c cc :ccList){
            
            String owid =cc.Opportunity_Worksheet__c;
            if(owOppIdListMap.containsKey(owid)){
                List<String> oppIds = owOppIdListMap.get(owid);
                for(String oppId: oppIds){ 
                    //String oppId = owOppIdMap.get(owid);
                    
                    List<Collection__c> collectionList = cc.Collections__r; 
                    List<Inquiry__c> inquiryList = cc.Inquiries__r; 
                    
                    if(!res.containsKey(oppId)){
                        res.put(oppId,new CreditReportWrapper() );
                    }
                    CreditReportWrapper newRec = res.get(oppId);
                    newRec.oppId = oppId;
                    List<Collection__c> existingCollectionList = newRec.collectionList;
                    existingCollectionList.addAll(collectionList);
                    newRec.collectionList=existingCollectionList; 
                    List<Inquiry__c> existingInquiry = newRec.inquiryList;
                    existingInquiry.addAll(inquiryList) ;
                    newRec.inquiryList=existingInquiry;
                    
                    res.put(oppId,newRec);                
                }
            }
        }
        */       
        
        
        for(Credit_Report__c cc :ccList){
            
            String owid =cc.Opportunity_Worksheet__c;
            if(owOppIdListMap.containsKey(owid)){
                List<String> oppIds = owOppIdListMap.get(owid);
                for(String oppId: oppIds){ 
                     
					if(!res.containsKey(oppId)){
                        res.put(oppId,new CreditReportWrapper() );
                    }
                    
                    CreditReportWrapper crw = res.get(oppId);
                    
                    List<CreditReportChildWrapper> crcwExisting =  crw.creditList ;
                    
                    List<Collection__c> collectionList = cc.Collections__r; 
                    List<Inquiry__c> inquiryList = cc.Inquiries__r; 
                    //Credit_Report__c cc
                    
                    CreditReportChildWrapper ccw = new CreditReportChildWrapper();
                    ccw.CreditReport = cc;
                    ccw.collectionList = collectionList;
                    ccw.inquiryList = inquiryList;
                    crcwExisting.add(ccw);
                     
                    crw.oppId=oppId;
                    crw.oppWId=owid;
                    crw.creditList=crcwExisting;
                    
                    res.put(oppId,crw);                
                }
            }
        }
        
        return res;       
        
    }
    
    
    public static Map<String,List<Mortgage_Statement__c>> findMortgageStatement(Set<String> owIds,Map<String,List<String>> owOppIdListMap){
        
        Map<String,List<Mortgage_Statement__c>> response = new Map<String,List<Mortgage_Statement__c>>();
        List<Mortgage_Statement__c> msList = [Select Id,Deferred_Amount__c,Deferred_Amount_to_payoff__c,
                                              Opportunity_Worksheet__c
                                              From Mortgage_Statement__c 
                                              Where Opportunity_Worksheet__c IN :owIds];
        
        for(Mortgage_Statement__c ms: msList){
            if(owOppIdListMap.containsKey(ms.Opportunity_Worksheet__c)){
                List<String> oppIds = owOppIdListMap.get(ms.Opportunity_Worksheet__c);
                for(String oppId : oppIds){ 
                    //String oppId = owOppIdMap.get(ms.Opportunity_Worksheet__c);
                    if(!response.containsKey(oppId)){
                        response.put(oppId,new List<Mortgage_Statement__c>());
                    }
                    response.get(oppId).add(ms);
                }
            }
        }
        return response;
    }
    
    public static Map<String , List<Recorded_Instruments__c>> findRecordedInstrument(Set<String> owIds ,Map<String,List<String>> owOppIdListMap){
        Map<String,List<Recorded_Instruments__c>> response = new Map<String,List<Recorded_Instruments__c>>();
        
        List<Recorded_Instruments__c> riList = [Select Id,Oddities__c , Riders__c,
                                                Opportunity_Worksheet__c
                                                From Recorded_Instruments__c 
                                                Where Opportunity_Worksheet__c IN :owIds];
        for(Recorded_Instruments__c recIns :riList ){
            List<String> oppIds = owOppIdListMap.get(recIns.Opportunity_Worksheet__c);
            for(String oppId : oppIds){               
                if(!response.containsKey(oppId)){
                    response.put(oppId,new List<Recorded_Instruments__c>());
                } 
                response.get(oppId).add(recIns);
            }  
        }
        
        return response; 
    }
    
    public static Boolean checkOpportunityStage(String docName, String oppStageName,Map<String,Opportunity_Stage_Sequence__mdt> opportunityStageSequenceMap,Map<String,Document_Checklist_to_Stage__mdt> documentMap){
        Boolean response = false;
        String currentStageName='';
        for(Document_Checklist_to_Stage__mdt dc: documentMap.values()){
            if(docName==dc.Document_Checklist_Name__c){
                currentStageName=dc.Stage_at_which_to_request__c;
                break;
            }             
        }
        decimal currentSequence=0;
        Decimal oppSequence=0;
        for(Opportunity_Stage_Sequence__mdt oss: opportunityStageSequenceMap.values()){
            if(oss.Label==currentStageName){
                currentSequence=oss.Sequence_Number__c;
            }
            if(oss.Label==oppStageName){
                oppSequence=oss.Sequence_Number__c;
            }
        } 
        
        if(oppSequence>=currentSequence){
            response=true;
        }
        system.debug('docName--->'+docName);
        system.debug('oppSequence'+oppSequence);
        system.debug('oppStageName'+oppStageName);
        system.debug('currentSequence---->'+currentSequence);
        system.debug('oppStageName---->'+oppStageName);
        system.debug('currentStageName---->'+currentStageName);
        system.debug('response--->'+response);
        return response ;
        
    }
    
    
    public class TitleReportWrapper{
        String oppId;
        public List<Exception__c> excpList = new List<Exception__c>();
        public List<Release__c> releaseList=new List<Release__c>();
    }
    public class CreditReportWrapper{
        String oppId;
        String oppWId;
        public List<CreditReportChildWrapper> creditList=new List<CreditReportChildWrapper>(); 
        
        //public List<Collection__c> collectionList=new List<Collection__c>();
        //public List<Inquiry__c> inquiryList=new List<Inquiry__c>();
        
    }
    
    public class CreditReportChildWrapper{
        Credit_Report__c CreditReport ;               
        public List<Collection__c> collectionList=new List<Collection__c>();
        public List<Inquiry__c> inquiryList=new List<Inquiry__c>();        
    }
    
    
    public class DQHistoryWrapper{
        String oppId;
         
        public List<DQ_History__c> dqHistoryList=new List<DQ_History__c>();
         
        
    }
    
     
    
}