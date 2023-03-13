import { LightningElement, api, track } from 'lwc';
import createConsumerCalculator from "@salesforce/apex/SPR_CreateCalculatorFromOpptyWSheet.createConsumerCalculator";
export default class Spr_createCalculatorFromOpptyWsheet extends LightningElement {

    @api recordId;

    @track loading = false;
    @track message='';
    @track callout = false;

    connectedCallback(){
        setTimeout(() => {
            this.loading = true;
            console.log('record id -->'+this.recordId);
            createConsumerCalculator({ recordId:this.recordId }).then((result) => {
                console.log(JSON.stringify(result));
                this.loading = false;
                console.log(result);
                console.log(result);
                this.message=result;
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