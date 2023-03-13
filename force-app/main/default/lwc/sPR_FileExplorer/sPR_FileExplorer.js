import { LightningElement,api } from 'lwc';

import getFileExplorer from "@salesforce/apex/SPRU_FilePreviewController.getFileExplorer";
import generateAwsFileURL from "@salesforce/apex/SPRU_FilePreviewController.generateAwsFileURL";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SPR_FileExplorer extends LightningElement {
 

    @api recordId;
    @api folderName;

    fileURL = "";
    isModalOpen = false;
    tableData = [];
    s3fileId = "";
    folderData=[];
    isFolderData=true;
    isFolder=false;
    isRecord=true;
    isDocumentVisible=false;

    connectedCallback(){
        console.log(this.recordId);
        console.log(this.folderName); 
        this.getListOfFile();         
    }

    getListOfFile(){
        getFileExplorer({recordId:this.recordId,folderName:this.folderName})
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

    getFileDetails(){
        generateAwsFileURL({s3fileId:this.s3fileId})
        .then((data)=>{
            console.log(data);  
            this.fileURL = data.fileUrl;
            console.log("spr Application previoew generateAwsFileURL=" , this.fileURL );
            //window.open(data.fileUrl, '_blank');            
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