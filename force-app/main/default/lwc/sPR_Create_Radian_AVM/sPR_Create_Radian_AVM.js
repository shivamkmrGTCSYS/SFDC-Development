import { LightningElement, api } from 'lwc';
import sendRequest from '@salesforce/apex/SPR_RadianAPIUtil.sendRequest';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class SPR_Create_Radian_AVM extends LightningElement {
    @api recordId
    @api invoke(){
        console.log("recordId==>",this.recordId)
        sendRequest({recordId : this.recordId, nameIdentifier : 'RDAVM'})
        .then(result => {
            console.log('result',result)            
            if(result === 'Success'){
                console.log("response===>",result)                
                this.showToast("Success","Your request has been accepted","success");                
            }                
            else{                
                this.showToast("Error",result,"error");
            }             

        }).catch(error => {
            console.log('error',error)
            this.isLoaded = true;
            this.showToast("Error","Your request not accepted","error");
        });
    }
    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title,
            message,
            variant
        })
        this.dispatchEvent(event)
    }
}