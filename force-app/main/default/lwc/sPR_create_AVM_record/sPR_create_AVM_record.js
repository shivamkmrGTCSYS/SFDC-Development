import { LightningElement, api, wire } from 'lwc';
import doCallout from '@salesforce/apex/SPR_DataTreeAVM_API_util.doCallout';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class SPR_create_AVM_record extends LightningElement {
    response='';
    isLoaded = false;
    @api recordId
    @api invoke(){
        console.log("recordId==>",this.recordId)
        doCallout({recordId : this.recordId})
        .then(result => {
            console.log('result',result)            
            if(result === 'Success'){
                console.log("response===>",result)                
                this.showToast("Success","Record Created","success");
                this.isLoaded = true;
            }                
            else{
                this.isLoaded = true;
                console.log("response==>",result)
                this.showToast("Error",result,"error");
            }             

        }).catch(error => {
            console.log('error',error)
            this.isLoaded = true;
            this.showToast("Error","Record Creation Failed","error");
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