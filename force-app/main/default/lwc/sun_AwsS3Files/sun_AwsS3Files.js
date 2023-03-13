/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-10-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-21-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
import { LightningElement,track,api,wire } from 'lwc';

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import awsJS from "@salesforce/resourceUrl/awsJS";

import getAWSConfiguration from "@salesforce/apex/SUN_AWSFolderViewController.getAWSConfiguration";
import updateAwsFile from "@salesforce/apex/SUN_AWSFolderViewController.updateAwsFile";
import getFolderList from "@salesforce/apex/SUN_AWSFolderViewController.getFolderList";


export default class Sun_AwsS3Files extends LightningElement {
 
    @track items = [];

    @track refreshobjectname;
    @track refreshrecordname;
    @track refreshfoldername;
    @track spliteroFileNumbe;

    @api 
    recordId ; //get the recordId for which files will be attached.
    @api 
    objectname='Loan_Origination__c';

    objectapiname='Loan_Origination__c';

    awsConfig;
    s3;
    objectLabel;
    recordName;

    @track
    folderView = [];
    awsInitialized = false;

    @track loading = false;
    @track alreadyrefresh = false;
    @track objectFolderList;

    @wire(getFolderList,{recordId:'$recordId',objectname:'$objectname'})
    folderList({data,error,}) {
      if(data){
        console.log('getFolderList-->');
        console.log( data);
        console.log(JSON.stringify(data)); 
        this.objectFolderList=data;

            /*data.forEach((item,index)=>{
                console.log( index);
                console.log( item.Name);
                this.objectFolderList.push(item.Name);
            });*/
            console.log(JSON.stringify( this.objectFolderList));
      }
      else if (error) {
        console.log('erroe-->');
        console.log( error);
      }
  }

    connectedCallback(){
        this.loading = true;
    }

    renderedCallback() {
        if(this.awsInitialized == false) {
            this.setAWSConfig();
            this.awsInitialized = true;
        }
    }

    setAWSConfig() {
        getAWSConfiguration({ recordId:this.recordId, objectname:this.objectname}).then((result) => {
            this.awsConfig = result;
            this.objectname=result['objectapiname'];
            this.objectapiname=result['objectapiname'];
            this.spliteroFileNumber=result['SpliteroFileNumber'];
            //console.log(' AWS Config: '+JSON.stringify(this.awsConfig));
            loadScript(this, awsJS).then(() => {
                this.configureAWS();
                this.listS3Objects();
            });
        })
        .catch((error) => {
            // Error to show during upload
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error in receiving AWS configuration",
                    message: error.message,
                    variant: "error"
                })
            );
        });
    }

    configureAWS() {
        const AWS = window.AWS;
        this.s3 = new AWS.S3();

        //console.log(" S3 " + this.s3);

        AWS.config.update({
            accessKeyId: this.awsConfig["key"],
            secretAccessKey: this.awsConfig["secret"]
        });

        console.log(" S3 ", this.s3);

        AWS.config.region = this.awsConfig["region"];

        this.s3 = new AWS.S3({
            apiVersion: "2006-03-01",
            params: {
                Bucket: this.awsConfig["bucket"], 
                Prefix: 'public/'+this.spliteroFileNumber+'/'
            }
        });
        console.log("this.s3", this.s3);
    }

    listS3Objects() {
        //console.log("AWS -> " + JSON.stringify(this.s3));
        this.s3.listObjects((err, data) => {
            if (err) {
                console.log("Error", err);
            } else {
                console.log("Success", data);
                if(this.folderView == undefined || this.folderView.length == 0) {
                    this.prepareFolderStructure(data);
                }
            }
        });
    }

    listS3ObjectsWithPrefix(prefix) {
        //console.log("AWS -> " + JSON.stringify(this.s3));
        let params = {Prefix : prefix};
        this.s3.listObjects(params,(err, data) => {
            if (err) {
                console.log("Error", err);
            } else {
                //console.log("Success Prefix: ", data);
                let matchFound = false;
                if(this.folderView != undefined && this.folderView.length >= 0) {
                    for(let folder of this.folderView) {
                        let files = [];
                        for(let awsKey of data.Contents) {
                            console.log(folder.folderId+' --> '+awsKey.Key);
                            let folderPathOnly = folder.folderId.split('/');
                            console.log("---> "+folderPathOnly);
                            let awsFolderKey = awsKey.Key.split('/');
                            let fileStr = awsFolderKey.pop();
                            console.log("---> "+awsFolderKey);
                            if(folder.folderId.indexOf(awsFolderKey.join('/')) != -1) {
                                console.log(' --> MATCHED ');
                                let fileDetail = {
                                    fileName : fileStr,
                                    fileKey : awsKey.Key,
                                    etag : awsKey.ETag,
                                    href : '/lightning/n/SUN_DocumentPreview?c__s3fileId='+awsKey.Key
                                }
                                files.push(fileDetail);
                                matchFound = true;
                            }
                        }
                        folder.files = files;
                    }
                }

                
            }
        });
    }

    prepareFolderStructure(data) {
        let root = (this.awsConfig["objectlabel"]+"/"+this.awsConfig["name"]+"/" ).split('+').join(' ');

        root = 'public/'+this.spliteroFileNumber+'/';
        console.log('root-->');
        console.log(root);

        let filesKey = [];
        console.log("data.Contents",data.Contents);
        for(var awsKey of data.Contents) {
            console.log(' Key: '+JSON.stringify(awsKey));
             
            this.objectFolderList.forEach((item,index)=>{
                console.log( index);
                console.log( item.Name);
                let root2= root+item.Name+'/';
                if(awsKey.Key.indexOf(root2) != -1) {
                    filesKey.push(awsKey);
                }

            });

            
        }
        console.log('File Key '+JSON.stringify(filesKey));
        

        this.createItems(filesKey);
        this.loading = false;

        //console.log(' folder view '+JSON.stringify(this.folderView));
        //console.log(' folder view '+JSON.stringify(this.items));
    }

    showFiles(event) {
        //console.log('label ===> '+event.target.value);
        this.listS3ObjectsWithPrefix(event.target.value);
    }

    previewFiles(event) {
        console.log('label ===> '+event.target.value);
    }
    
    createItems(filesKey){
        console.log("createItems");
        this.items =[]; 
        for(var fileInst of filesKey) {
            //console.log('fileInst');
            //console.log(fileInst);
            let path = fileInst.Key.split('/');
            let etag = fileInst.ETag;
            let size = fileInst.Size;
            let id = fileInst.Owner.ID;
            let fkey = fileInst.Key;
            console.log("createItems>>>>");
            this.createItemsrecord(path,etag,size,id,fkey);
        } 

        ////console.log('refreshobjectname ===> '+this.refreshobjectname);
        //console.log('refreshrecordname ===> '+this.refreshrecordname);
        //console.log('refreshfoldername ===> '+this.refreshfoldername);

        this.refreshobjectname=undefined;
        this.refreshrecordname=undefined;
        this.refreshfoldername=undefined;
    }

    async createItemsrecord(path,etag,size,id,fkey){
        console.log("createItemsrecord");
        let objectName = path[0];
        let recordName = path[1];
        let folderName = path[2];
        let fileName = path[3]; 
       
        if(recordName==='LO-DUMMY')
            return ;
        
        let objexpan = true ;    
        let recexpan = false ;    
        let foldexpan = false ;    
        if(this.refreshobjectname===objectName)
            objexpan = true ;
        if(this.refreshrecordname===recordName)
            recexpan = true;
        if(this.refreshfoldername===folderName)
            foldexpan=true;
     
        let fileNameObj = {label: fileName, name: fileName,expanded: true,
            etag:etag,href : '/lightning/n/SUN_DocumentPreview?c__s3fileId='+fkey+'&c__recordId='+this.recordId,size:size, awss3fileid:id,fkey:fkey,
            recordname:recordName,foldername:folderName,objectname:objectName}
        let folderNameObj ={
            label: folderName, name: folderName,expanded: foldexpan,
            items:[fileNameObj]
        } 
        let RecordNameObj = {
            label: recordName, name: recordName,expanded: recexpan,
            items: [folderNameObj]}

        let ObjectNameObj = {
            label: objectName, name: objectName,expanded: objexpan,
            items: [RecordNameObj]
        }

        let objectNameExist = false ;        
        let objectNameIndex = 0 ;        

        this.items.forEach( (item, index)=> { 
            if(item.label===objectName){
                objectNameExist = true ;
                objectNameIndex=index;                
            }
        })

        if(objectNameExist===true){
            //console.log('object name found');  
            let recordNameArr = this.items[objectNameIndex].items;
            
            let recordNameExist = false ;        
            let recordNameIndex = 0 ;
            recordNameArr.forEach((record,recIndex)=>{
                if(record.label===recordName){
                    recordNameExist = true ;
                    recordNameIndex=recIndex;                
                }
            }); 
            if(recordNameExist===true){

                //console.log(this.items[objectNameIndex].items[recordNameIndex]);
                let folderNameArr = this.items[objectNameIndex].items[recordNameIndex].items;
  
                let folderNameExist = false ;        
                let folderNameIndex = 0 ;
                folderNameArr.forEach((folder,folderIndex)=>{
                    if(folder.label===folderName){
                        folderNameExist = true ;
                        folderNameIndex=folderIndex;                
                    }
                });

                if(folderNameExist===true){
                    this.items[objectNameIndex].items[recordNameIndex].items[folderNameIndex].items.push(fileNameObj);
                }else{
                    this.items[objectNameIndex].items[recordNameIndex].items.push(folderNameObj);                         
                }
            }else{
                this.items[objectNameIndex].items.push(RecordNameObj);
            }
        }else{
            this.items.push(ObjectNameObj);
        }
        console.log("this.items",this.items);
    }

    handleObjectLevel(event){
        //console.log('label ===> '+event.target.value);
        let objectname = event.currentTarget.dataset.objectname;
        //console.log(objectname) ;
        this.items.forEach((item,index)=>{
            if(item.label===objectname){
                item.expanded = !item.expanded ;
            }else{
                item.expanded = false;
            }
        })
    }
    handleRecordLevel(event){
        //console.log('label ===> '+event.target.value);
        let objectname = event.currentTarget.dataset.objectname;
        let recordname = event.currentTarget.dataset.recordname;
        //console.log(objectname) ;
        //console.log(recordname) ;
        this.items.forEach((item,index)=>{
            if(item.label===objectname){
                this.items[index].items.forEach((item2,index2)=>{
                    if(item2.label===recordname){
                        this.items[index].items[index2].expanded = !this.items[index].items[index2].expanded ;
                    }else{ 
                        this.items[index].items[index2].expanded = false ;
                    }
                });                
            }else{
                item.expanded = false;
            }
        })
    }

    handleFolderLevel(event){
        
        let objectname = event.currentTarget.dataset.objectname;
        let recordname = event.currentTarget.dataset.recordname;
        let foldername = event.currentTarget.dataset.foldername;

        

        //console.log(objectname) ;
        //console.log(recordname) ;
        this.items.forEach((item,index)=>{
            if(item.label===objectname){
                this.items[index].items.forEach((item2,index2)=>{
                    if(item2.label===recordname){
                        this.items[index].items[index2].items.forEach((item3,index3)=>{
                            if(item3.label===foldername){
                                this.items[index].items[index2].items[index3].expanded = !this.items[index].items[index2].items[index3].expanded ;
                            }else{
                                this.items[index].items[index2].items[index3].expanded = false ;
                            }
                        });                         
                    }else{ 
                        this.items[index].items[index2].expanded = false ;
                    }
                });                
            }else{
                item.expanded = false;
            }
        })
    }

    async refreshTimeline(event){

        if(this.alreadyrefresh===true){

            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Please wait!",
                    message: "Another folder is already in progress, please wait!",
                    variant: "warning"
                })
            );
            return ;
        }else{
            this.alreadyrefresh = true ;
        }
        const { target } = event;

        event.currentTarget.classList.add('refreshRotate');

        let objectname = event.currentTarget.dataset.objectname;
        let recordname = event.currentTarget.dataset.recordname;
        let foldername = event.currentTarget.dataset.foldername;

        let prefix = objectname+'/'+recordname+'/'+foldername+'/';
        let params = {Prefix : prefix};
        //console.log(params);
        this.s3.listObjects(params,(err, data) => {
            this.alreadyrefresh = false ;
            if (err) {
                console.log("Error", err);
            } else {
                 
                let allFiles =[] ;
                for(var awsKey of data.Contents) {
                    //console.log(awsKey);
                    let path = awsKey.Key.split('/'); 
                    let objectName   = path[0];
                    let recordName   = path[1];
                    let folderName   = path[2];
                    let fileName   = path[3];
                    let fkey = awsKey.Key;
                    let fileNameObj = {objectapiname:this.objectapiname,label: fileName,objectname:objectName, name: fileName,expanded: false,
                        size:awsKey.Size,awss3fileid:awsKey.Owner.ID,fkey:fkey,recordname:recordName,
                        foldername:folderName,recordId:this.recordId,
                        etag:awsKey.ETag,href : '/lightning/n/SUN_DocumentPreview?c__s3fileId='+fkey }
                    allFiles.push(fileNameObj);
                } 
                //console.log(allFiles);
                this.items.forEach((item, index) => {
                    if (item.label === objectname) { 
                        this.items[index].items.forEach((item2, index2) => { 
                            if (item2.label === recordname) { 
                                this.items[index].items[index2].items.forEach((item3, index3) => {
                                    if (item3.label === foldername) { 
                                        this.items[index].items[index2].items[index3].items = allFiles;
                                    }
                                });
                            }
                        });
                    }
                });                

                updateAwsFile({  awsFileList:allFiles}).then((result) => {
                     
                    //console.log(' AWS Config: '+JSON.stringify(result ));
                    target.classList.remove('refreshRotate');
                     
                })
                .catch((error) => {

                    target.classList.remove('refreshRotate');

                    // Error to show during upload
                    /*window.console.log(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Error in receiving AWS configuration",
                            message: error.message,
                            variant: "error"
                        })
                    );*/
                });

                

            }
        });


         
        /*
        this.refreshobjectname=objectname;
        this.refreshrecordname=recordname;
        this.refreshfoldername=foldername;

        const { target } = event;

        event.currentTarget.classList.add('refreshRotate');

        this.listS3Objects();

        let result = await this.s3.listObjects((err, data) => {
            if (err) {
                console.log("Error", err);
            } else {
                console.log("Success", data);
                this.prepareFolderStructure(data);
                target.classList.remove('refreshRotate');
                //event.currentTarget.classList.remove('refreshRotate');
            }
        });
        */

        //event.currentTarget.classList.remove('refreshRotate');
    }

    getAllFilesOfFOlder(prefix) {
         
        let params = {Prefix : prefix};
        //console.log(params);
        this.s3.listObjects(params,(err, data) => {
            if (err) {
                console.log("Error", err);
            } else {
                let filesKey = [];
                for(var awsKey of data.Contents) {
                    //console.log(' Key: '+JSON.stringify(awsKey));
                    filesKey.push(awsKey);
                } 
                console.log(filesKey);

            }
        });
    }

}