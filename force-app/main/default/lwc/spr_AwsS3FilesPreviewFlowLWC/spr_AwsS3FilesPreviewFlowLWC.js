import { LightningElement, api, track, wire} from 'lwc';
 
    import generateAwsFileURL from "@salesforce/apex/SPR_FilePreviewController.generateAwsFileURL";
    import { CurrentPageReference } from 'lightning/navigation';
    
    
    export default class Spr_AwsS3FilesPreviewFlowLWC extends LightningElement {
    
        @track fileId=true;
        @api s3fileId   ;
    
        @api recordId;
        @api recordid;
        @api parentid;
        @api fileUrl ='';
        @api Folder_Name ='';
        @api Object_Name ='';
        @api Automation_API_Name ='Update_Document_Status';
        @api Amazon_S3_Files_Id ='';  
        @api Loan_Origination_Id='' ;
    
        @api width;
        @api height; 
        @api name;
        @api flowParams;
        
        url;

        urlStateParameters = null;
        currentPageReference = null; 

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
    
        connectedCallback(){
            console.log('Sun_AwsS3FilesPreviewFlowLWC calbackfunction--->');
            console.log('this.s3fileId-->'+this.s3fileId);
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
                this.Automation_API_Name=data.Automation_API_Name;  
               
                this.flowParams = [{  name:'s3fileId',  type:'String',  value:this.s3fileId },
                {  name:'recordid', type:'String',  value:this.recordid },
                {  name:'parentid',  type:'String',  value:this.parentid  }  ];
            }).catch((error)=>{
                console.log(error);
            });

            console.log('herea... '+ this.parentid);
            console.log(this.flowParams);
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
    
        
    
        get fullUrl() {
            let params = (this.flowParams ? '&arguments=' + encodeURI(JSON.stringify(this.flowParams)) : '');
            let origin = (this.url ? '&origin=' + encodeURI(this.url) : '');
            console.log(this.url + '/flow/runtime.apexp?flowDevName=' + this.Automation_API_Name +  params+origin);
            return this.url + '/flow/runtime.apexp?flowDevName=' + this.Automation_API_Name +  params+origin;
    
            //https://sundae--sunuat.lightning.force.com/flow/runtime.apexp?flowDevName=X4th_Event_Attendees_ME
    
            //return 'https://sundae--sunuat--c.visualforce.com/flow/runtime.apexp?flowDevName=X4th_Event_Attendees_ME';
        }
    
    }