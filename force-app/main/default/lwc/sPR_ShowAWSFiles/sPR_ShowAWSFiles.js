import { LightningElement,api,track } from 'lwc';
 
import generateAwsFileURL from "@salesforce/apex/SPRU_FilePreviewController.generateAwsFileURL";
import getListOfFiles from "@salesforce/apex/SPRU_FilePreviewController.getListOfFiles";

export default class SPR_ShowAWSFiles extends LightningElement {


    @api recordId;  
    
    folderData=[];
    isFolderData=true;
    isDocumentVisible=false;
    fileURL = "";
    @track notes=[];
    @track notsAvailable=false;
    
    connectedCallback(){
        console.log(this.recordId); 
        this.getUploadedFiles();
        

    }

    getUploadedFiles() {
        getListOfFiles({ recordId: this.recordId })
          .then((data) => {
            this.folderData = data;           
            if(this.folderData.length>0){
                this.isFolderData=true;
                this.isDocumentVisible=false;
            }else{
                this.isFolderData=false;
                this.isDocumentVisible=false;
            }
            console.log("spr Application previoew tableData=" , JSON.stringify(this.tableData) );
        })
        .catch((error) => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error in displaying data!!",
                message: error.message,
                variant: "error"
              })
            );
        });
    }

    showDocument(event){
        event.preventDefault();
        console.log('filepath => ' + event.target.dataset.filepath);
        console.log('awsfilekey => ' + event.target.dataset.awsfilekey);
        this.isDocumentVisible=true;
        this.s3fileId=event.target.dataset.awsfilekey;
        this.getFileDetails();
    }
    
    showDocumentList(event){
        event.preventDefault();
        this.isDocumentVisible=false;
    }

    getFileDetails(){
        generateAwsFileURL({s3fileId:this.s3fileId})
        .then((data)=>{
            console.log(data);  
            this.fileURL = data.fileUrl;
            console.log("spr Application previoew generateAwsFileURL=" , this.fileURL );
            //window.open(data.fileUrl, '_blank'); 
            this.notes=JSON.parse(data.notes);
                if(this.notes.length===0){
                    console.log('length zero');
                }else{
                    this.notsAvailable=true;
                }           
        }).catch((error)=>{
            console.log("spr Application previoew generateAwsFileURL= error =" , JSON.stringify(error));
        });       
    }


}