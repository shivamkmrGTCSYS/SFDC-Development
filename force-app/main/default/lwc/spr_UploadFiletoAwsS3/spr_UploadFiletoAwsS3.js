/* eslint-disable no-console */
import { LightningElement, api, track, wire } from "lwc";
import getUploadConfiguration from "@salesforce/apex/SPR_UploadFileToAwsS3Controller.getUploadConfiguration";
import displayUploadedFiles from "@salesforce/apex/SPR_UploadFileToAwsS3Controller.displayUploadedFiles";
import insertAttachmentRecord from "@salesforce/apex/SPR_UploadFileToAwsS3Controller.insertAttachmentRecord";
import getAllFolderName from "@salesforce/apex/SPR_UploadFileToAwsS3Controller.getAllFolderName";
import getRecordDetail from "@salesforce/apex/SPR_UploadFileToAwsS3Controller.getRecordDetail";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import awsJS from "@salesforce/resourceUrl/awsJS";

// Import custom labels
import SelectFolder from '@salesforce/label/c.SPR_Select_Folder';
import AwsS3Files from '@salesforce/label/c.SPR_AWS_S3_Files';
import progress from '@salesforce/label/c.SPR_progress';
import uploadingthefile from '@salesforce/label/c.SPR_Uploading_the_file';
import filetouploader from '@salesforce/label/c.SPR_file_to_uploader';
import Followingfilesuploaded from '@salesforce/label/c.SPR_Following_files_uploaded';
import upload from '@salesforce/label/c.SPR_Upload';
import photos from '@salesforce/label/c.SPR_Add_Interior_or_Exterior_Property_Photos';


export default class Spr_UploadFiletoAwsS3 extends LightningElement {

  // Expose the labels to use in the template.
  label = {
    SelectFolder,
    AwsS3Files,progress,uploadingthefile,filetouploader,Followingfilesuploaded,
    upload,
    photos
  };

  
  @api recordId; //get the recordId for which files will be attached.
  @api objectname;
  selectedFilesToUpload = []; //store selected files
  @track showSpinner = false; //used for when to show spinner
  @track fileName; //to display the selected file name
  @track tableData; //to display the uploaded file and link to AWS
  file; //holding file instance
  myFile;
  fileType; //holding file type
  fileReaderObj;
  base64FileData;
  @track selectedValue;
  @track selectedFolderName;
  s3;
  @track allFolderList =[] ;
  @track spliteroFileNumber;
  @track folderAPIName;

  @wire(getRecordDetail,{recordId:'$recordId',objectname:'$objectname'})
    leadRecordDetail({data,error,}) {
      if(data){
          console.log('getRecordDetails-->');
          console.log( data);
          console.log(JSON.stringify(data));
          if(data.Splitero_File_Number__c!==undefined)
            this.spliteroFileNumber=data.Splitero_File_Number__c;
      }
      else if (error) {
        console.log('erroe-->');
        console.log( error);
      }
  }

  connectedCallback(){

    console.log("connectedCallback");
    getAllFolderName({
      recordId: this.recordId,
      objectname: this.objectname 
    })
    .then((result) => {
      result.forEach((data,index)=>{
        this.allFolderList.push({label: data.Name, value: data.Id});         
      }) 
      this.allFolderList = JSON.parse(JSON.stringify(this.allFolderList));
      console.log( this.allFolderList);
    })
    .catch((error) => {
      // Error to show during retrive folder name
      window.console.log(error);
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error in retrive folder name",
          message: error.message,
          variant: "error"
        })
      );
      this.showSpinner = false;
    });



  }
  // get the file name from the user's selection
  handleSelectedFiles(event) {
    if (this.selectedValue != undefined) {
      if (event.target.files.length > 0) {
        this.selectedFilesToUpload = event.target.files;
        let filename = this.spliteroFileNumber!==undefined?(this.spliteroFileNumber+'_'):'';
        
        this.fileName = filename+this.folderAPIName+'_'+this.selectedFilesToUpload[0].name;
       
        this.fileType = this.selectedFilesToUpload[0].type;
        console.log("fileName=" + this.fileName);
        console.log("fileType=" + this.fileType);
      }
    } else {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message: "Please select a folder before uploading the file",
          variant: "error"
        })
      );
    }

    loadScript(this, awsJS).then(() => {
      /* callback */
    });
  }

  get options() {
    //return this.allFolderList;
    return  [
      { label: "Operating Agreement", value: "Operating Agreement" },
      { label: "Articles of Formation", value: "Articles of Formation" },
      { label: "2 Months Bank Statements", value: "2 Months Bank Statements" },
      { label: "Tax Returns", value: "Tax Returns" },
      { label: "Voided Check", value: "Voided Check" },
      {
        label: "Copy of Photo ID/ Passport",
        value: "Copy of Photo ID/ Passport"
      },
      { label: "Bank statements", value: "Bank statements" },
      { label: "List of properties owned", value: "List of properties owned" },
      { label: "Background Check", value: "Background Check" },
      { label: "Credit Check", value: "Credit Check" },
      {
        label: "Certificate of good standing",
        value: "Certificate of good standing"
      },
      { label: "Application", value: "Application" },
      { label: "Scope of Work", value: "Scope of Work" },
      {
        label: "Rent Roll (if applicable)",
        value: "Rent Roll (if applicable)"
      },
      { label: "Evidence of Insurance", value: "Evidence of Insurance" },
      {
        label: "Evidence of Flood Insurance (if needed)",
        value: "Evidence of Flood Insurance (if needed)"
      },
      {
        label: "Purchase and Sale Agreement",
        value: "Purchase and Sale Agreement"
      },
      { label: "Title Report", value: "Title Report" },
      { label: "Flood Certificate", value: "Flood Certificate" },
      { label: "OFAC", value: "OFAC" },
      { label: "Appraisal", value: "Appraisal" }
    ];
  }

  handleChange(event) {
    this.selectedValue = event.detail.value;
    console.log('Folder Changed-->');
    
    this.selectedFolderName = event.target.options.find(opt => opt.value === event.detail.value).label;

    this.folderAPIName=this.convertFolderAPIName(this.selectedFolderName);

    console.log('this.folderAPIName-->'+this.folderAPIName);
  }

  //parsing the file and prepare for upload.
  handleFileUpload(){
    if(this.selectedFilesToUpload.length > 0) {
        this.showSpinner = true;
        
        this.file = this.selectedFilesToUpload[0];
        //create an intance of File
        this.fileReaderObj = new FileReader();

        //this callback function in for fileReaderObj.readAsDataURL
        this.fileReaderObj.onloadend = (() => {
            //get the uploaded file in base64 format
            let fileContents = this.fileReaderObj.result;
            fileContents = fileContents.substr(fileContents.indexOf(',')+1)
            
            //read the file chunkwise
            let sliceSize = 1024;           
            let byteCharacters = atob(fileContents);
            let bytesLength = byteCharacters.length;
            let slicesCount = Math.ceil(bytesLength / sliceSize);                
            let byteArrays = new Array(slicesCount);
            for (let sliceIndex = 0; sliceIndex < slicesCount; ++sliceIndex) {
                let begin = sliceIndex * sliceSize;
                let end = Math.min(begin + sliceSize, bytesLength);                    
                let bytes = new Array(end - begin);
                for (let offset = begin, i = 0 ; offset < end; ++i, ++offset) {
                    bytes[i] = byteCharacters[offset].charCodeAt(0);                        
                }
                byteArrays[sliceIndex] = new Uint8Array(bytes);                    
            }
            
            //from arraybuffer create a File instance
            this.myFile =  new File(byteArrays, this.fileName, { type: this.fileType });
            
            //callback for final base64 String format
            let reader = new FileReader();
            reader.onloadend = (() => {
                let base64data = reader.result;
                this.base64FileData = base64data.substr(base64data.indexOf(',')+1); 
                this.fileUpload();
            });
            reader.readAsDataURL(this.myFile);                                 
        });
        this.fileReaderObj.readAsDataURL(this.file);            
    }
    else {
        this.fileName = 'Please select a file to upload!';
    }
}

  //this method calls Apex's controller to upload file in AWS
  fileUpload() {

    console.log('file type-->'+this.file.type);

    if(this.selectedFolderName===this.label.photos){ 
      if(
        this.file.type ==='image/gif' || this.file.type ==='image/jpeg' ||
        this.file.type ==='image/jpg' || this.file.type ==='image/png' 
      ){
        console.log('do nothing...Proper file for photos')
      }else{ 
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Warning",
            message:"Only images can be uploaded to "+this.label.photos+" folder",
            variant: "Warning"
          })
        );
        this.showSpinner = false;
        return false;
      }
    }
    
    getUploadConfiguration({
      parentId: this.recordId,
      objectname: this.objectname,
      fileName: this.fileName,
      folderName: this.selectedFolderName,
      fileType: this.file.type
    })
      .then((result) => {
        console.log("Upload result = " + result);
        //this.fileName = this.fileName + ' - Uploaded Successfully';
        //call to show uploaded files
        this.uploadFiles(result);
        this.showSpinner = false;
        // Showing Success message after uploading
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Upload in Progress",
            message: this.file.name + " - upload in progress to AWS S3 Cloud. Storing reference in Salesforce..",
            variant: "success"
          })
        );
      })
      .catch((error) => {
        // Error to show during upload
        window.console.log(error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error in uploading File",
            message: error.message,
            variant: "error"
          })
        );
        this.showSpinner = false;
      });
  }

  //retrieve uploaded file information to display to the user
  getUploadedFiles() {
    displayUploadedFiles({ parentId: this.recordId })
      .then((data) => {
        this.tableData = data;
        console.log("tableData=" + this.tableData);
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

  uploadFiles(config) {
    const AWS = window.AWS;
    this.s3 = new AWS.S3();

    console.log(" S3 " + this.s3);
    console.log("config", config);

    AWS.config.update({
      accessKeyId: config["key"],
      secretAccessKey: config["secret"]
    });

    console.log(" S3 " + this.s3);

    AWS.config.region = config["region"];

    this.s3 = new AWS.S3({
      apiVersion: "2006-03-01",
      params: {
        Bucket: config["bucket"],//Assigning S3 bucket name
        Prefix: 'public/'+this.spliteroFileNumber+'/'
      }
    });

    console.log(" S3 " + JSON.stringify(config));

    //starting file upload
    this.s3.putObject(
      {
        Key: config["path"],
        ContentType: this.file.type,
        Body: this.selectedFilesToUpload[0],
        ACL: "public-read"
      },
      (err) => {
        if (err) {
          this.showSpinner = false;
          console.error(err);
        } else {
          this.showSpinner = false;
          console.log("Success");
          this.listS3Objects(config["path"]);
        }
      }
    );
  }

  //listing all stored documents from S3 bucket
  listS3Objects(fileKey) {
    //console.log("AWS -> " + JSON.stringify(this.s3));
    this.s3.listObjects((err, data) => {
      if (err) {
        console.log("Error", err);
      } else {
        console.log("Success", data);
        for(var awsKey of data.Contents) {
            if(awsKey.Key === fileKey) {
                console.log(' Key: '+JSON.stringify(awsKey));
                this.insertAWSFileReference(awsKey.Key, awsKey.ETag, awsKey.Size);
                break;
            }
        }
      }
    });
  }

  insertAWSFileReference(fileKey, tag, size) {
    insertAttachmentRecord( {
        parentId : this.recordId, 
        objectname : this.objectname,
        fileName : this.file.name,
        fileType : this.file.type,
        fileKey : fileKey,        
        etag : tag,
        size : size,
        foldername: this.selectedValue
      })
        .then((data) => {
            console.log("tableData=" + data);
            this.dispatchEvent(
                new ShowToastEvent({
                  title: "Upload Completed Successfully",
                  message: this.file.name + " referenced successfully.",
                  variant: "success"
                })
            );
            window.location.reload();
          })
          .catch((error) => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error in saving record",
                message: error.message,
                variant: "error"
              })
            );
          });
  }

  convertFolderAPIName(str){
    return str.replace(/\s/g, "_");
  }

}