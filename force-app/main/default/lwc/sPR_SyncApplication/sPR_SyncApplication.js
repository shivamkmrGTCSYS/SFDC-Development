import { LightningElement,api, track } from 'lwc';

import SyncApplicationToWeb from "@salesforce/apex/SPR_SyncApplicationToWebUtility.SyncApplicationToWeb";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SPR_SyncApplication extends LightningElement {

    @api recordId;

    @track loading = false;
 
    @track callout = false;
    @track message='';

    connectedCallback(){
        setTimeout(() => {
            this.loading = true;
            console.log('record id -->'+this.recordId);
            SyncApplicationToWeb({ recordId:this.recordId }).then((result) => {
                console.log(JSON.stringify(result));
                this.loading = false;
                console.log("success: ", result.success);
                console.log("message: ", result.message); 
                if(result.success === true){
                    this.message= 'Application has been synced to portal';
                }else{
                    let errMsg = ( result.message && result.message.errors && result.message.errors[0] && result.message.errors[0].message ? result.message.errors[0].message : '') ;
                    errMsg = ( errMsg == '' ? 'Portal Server not responded' : errMsg );
                    this.message='Application Sync failed. Reason: '+ errMsg;
                }
                
                this.callout=true;
            }).catch((error) => {
                // Error to show during upload
                console.log(JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error in sending request",
                        message: error.message,
                        variant: "error"
                    })
                );
            });
        }, 500);
    }

}