import { LightningElement, api } from 'lwc';
import sendRequest from '@salesforce/apex/SPR_DomaAPIUtil.runDomaOppWsSubmitOrder';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class Spr_runDomaOppWs extends LightningElement {
 response='';
    isLoaded = false;
    @api recordId
    @api invoke(){
        console.log("recordId==>",this.recordId)
        sendRequest({recordId : this.recordId})
        .then(result => {
            console.log('result',result)            
            if(result === 'Success'){
                console.log("response*===>",result)                
                this.showToast("Success","Record has been created successfully!","success");
                this.isLoaded = true;
                eval("$A.get('e.force:refreshView').fire();");
            }                
            else{
                console.log("response*===>",result) 
                this.showToast("Error",result,"error");
            }             

        }).catch(error => {
            console.log('error',error)
            this.isLoaded = true;
            this.showToast("Error","Record creation failed!","error");
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