import { LightningElement,api, track } from 'lwc';
import displayUploadedFiles from "@salesforce/apex/SPRU_FilePreviewController.displayUploadedFiles";
import getListOfApplicationFileId from "@salesforce/apex/SPRU_FilePreviewController.getListOfApplicationFileId";
import generateAwsFileURL from "@salesforce/apex/SPRU_FilePreviewController.generateAwsFileURL";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SPR_ShowAWSFolderAndFiles extends LightningElement {
 

    @api recordId;     
    @api opportunityWorksheetId;
    @api folderId;

    fileURL = "";
    isModalOpen = false;
    tableData = [];
    s3fileId = "";
    folderData=[];
    isFolderData=true;
    isFolder=false;
    isRecord=true;
    isDocumentVisible=false;

    @track notes=[];
    @track notsAvailable=false;

    connectedCallback(){
        console.log(this.recordId);
        console.log(this.folderId); 
        if(this.recordId===undefined){
            this.isFolder=true;
            this.isRecord=false;
            this.getListOfApplicationFile();
            console.log('record is undefined');
        }else{
            const first3 = this.recordId.substring(0, 3);
            console.log(first3);

            if(first3==='a3R'){
                this.isFolder=true;
                this.isRecord=false;
                this.opportunityWorksheetId=this.recordId;
                this.getListOfApplicationFile();
            }else{
                this.isFolder=false;
                this.isRecord=true;
                this.getUploadedFiles();
            }
            
        }
        //this.getUploadedFiles();
    }

    getListOfApplicationFile(){
        getListOfApplicationFileId({opportunityWorksheetId:this.opportunityWorksheetId,folderId:this.folderId})
        .then((data)=>{
            console.log(data);
            this.folderData=data;
            if(this.folderData.length>0){
                this.isFolderData=true;
                this.isDocumentVisible=false;
            }else{
                this.isFolderData=false;
                this.isDocumentVisible=false;
            }
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
    getUploadedFiles() {
        displayUploadedFiles({ parentId: this.recordId })
          .then((data) => {
            this.tableData = data;
            if(this.tableData.length > 0){
                //this.fileURL = "/sfc/servlet.shepherd/version/download/"+this.tableData[0].FileURL__c;
                this.s3fileId = ""+this.tableData[0].AWS_File_Key__c;
                console.log("spr Application previoew displayUploadedFiles1=" , this.s3fileId );
                this.getFileDetails();
            }else{
                //this.fileURL = "/sfc/servlet.shepherd/version/download/0683C000001ZHWc";
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

}