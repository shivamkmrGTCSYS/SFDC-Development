import { LightningElement, api, track, wire} from 'lwc';
 
    import generateAwsFileURL from "@salesforce/apex/SPR_FilePreviewController.generateAwsFileURL";
    import { CurrentPageReference } from 'lightning/navigation';
    
    
    export default class Spr_AwsS3FilesPreviewLWC extends LightningElement {
    
        @track fileId=true;
        @api s3fileId   ;
    
        @api recordid;
        @api parentid;
        @api fileUrl ='';
        @api Folder_Name ='';
        @api Object_Name ='';
        @api Automation_API_Name ='Update_Document_Status';
        @api Amazon_S3_Files_Id ;  
        @api Loan_Origination_Id ;
        @api recordURI;
    
        @api width;
        @api height; 
        @api name;
        @api flowParams;
        url;
        urlStateParameters = null;
        currentPageReference = null; 

        @track notes=[];
        @track notsAvailable=false;

        @wire(CurrentPageReference)
            getStateParameters(currentPageReference) {
            console.log(' ==> wire called');
            if (currentPageReference) {
                console.log(' ==> wire called in '+JSON.stringify(currentPageReference));
                this.urlStateParameters = currentPageReference.state;
                this.s3fileId = this.urlStateParameters.c__s3fileId;

                this.showfilePreview();
                console.log('c this.s3fileId-->'+this.s3fileId);
            }
        }
    
        constructor() {
            super();
            console.log('calbackfunction--->');
            let sfIdent = 'force.com';
            this.url = window.location.href.substring(0, window.location.href.indexOf(sfIdent) + sfIdent.length);
    
        }
    
        showfilePreview(){
            generateAwsFileURL({s3fileId:this.s3fileId})
            .then((data)=>{
                console.log(data);
                
                this.fileUrl=data.fileUrl;            
                this.Folder_Name=data.Folder_Name;            
                this.Object_Name=data.Object_Name; 
                this.recordid=data.Amazon_S3_Files_Id;
                this.parentid=data.Loan_Origination_Id;
                this.recordURI = '/'+this.recordid;
                this.notes=JSON.parse(data.notes);
                if(this.notes.length===0){
                    console.log('length zero');
                }else{
                    this.notsAvailable=true;
                }
  
            }).catch((error)=>{
                console.log(error);
            });
        }
    
    
        refereshPage(){
            window.location.reload();
        }
    
        downloadFile(){
            generateAwsFileURL({s3fileId:this.s3fileId})
            .then((data)=>{
                console.log(data);   
                window.open(data.fileUrl, '_blank');            
            }).catch((error)=>{
                console.log(error);
            });       
        }
    
       
        
     
    
    }