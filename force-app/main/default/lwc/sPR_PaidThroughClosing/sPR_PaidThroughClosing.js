import { LightningElement,api } from 'lwc';
import doCallout from '@salesforce/apex/SPR_OpportunityWorksheetUtil.setOpportunityWorksheetData'
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class SPR_PaidThroughClosing extends LightningElement {
    
    isLoaded = false;
    @api recordId;
    @api invoke(){

        console.log('recordId-->'+this.recordId);
        doCallout({recordId:this.recordId})
        .then(result=>{
            console.log('result-->'+result);
            if(result==='Success'){
                this.showToast("Success","Paid Through Closing calculated successfully!","success");
                this.isLoaded = true;
            }else{
                this.isLoaded = true;
                console.log("response==>"+result)
                this.showToast("Error",result.split(':')[1],"error");
            } 
        })
        .catch(error=>{
            console.log('error-->'+error);
        })

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