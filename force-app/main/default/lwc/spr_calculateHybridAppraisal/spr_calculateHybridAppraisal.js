import { LightningElement, api } from 'lwc';

import doCallout from '@salesforce/apex/SPR_OpportunityWorksheetUtil.calculateHybridAppraisal';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class Spr_calculateHybridAppraisal extends LightningElement {
    response='';
    isLoaded = false;
    @api recordId
    @api invoke(){
        console.log("recordId==>",this.recordId)
        doCallout({recordId : this.recordId})
        .then(result => {
            console.log('result'+result)            
            if(result === 'Success'){
                console.log("response===>"+result)                
                this.showToast("Success","Hybrid Appraisal calculated successfully!","success");
                this.isLoaded = true;
            }                
            else{
                this.isLoaded = true;
                console.log("response==>"+result)
                this.showToast("Error",result.split(':')[1],"error");
            }             

        }).catch(error => {
            console.log('error'+error)
            this.isLoaded = true;
            this.showToast("Error","Hybrid Appraisal calculation failed!","error");
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