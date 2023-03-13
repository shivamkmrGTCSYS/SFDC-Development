import { LightningElement,track,api } from 'lwc';

import downloadApplicationURL from "@salesforce/apex/SPR_DownloadApplicationController.downloadApplicationURL";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from 'lightning/navigation';

export default class SPR_DownloadApplication extends NavigationMixin(LightningElement) {

    @track downloadURL;
    @track download=false;
    @api recordId;

    @api invoke() {
        console.log('Hello from invoke:', this.recordId);
      }

    connectedCallback(){
        setTimeout(() => {
            console.log("DownloadApplication");
            console.log("this.recordId-->"+this.recordId);
            downloadApplicationURL({recordId:this.recordId})
            .then((result) => {
            
                console.log(result);
                this.downloadURL=result;
                const config = {
                    type: 'standard__webPage',
                    attributes: {
                        url: result
                    }
                };
                this[NavigationMixin.Navigate](config);
                this.download=true;
            })
            .catch((error) => {
            // Error to show during retrive folder name
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                title: "Error in calling API",
                message: error.message,
                variant: "error"
                })
            );
            this.showSpinner = false;
            });
    
        }, 500);
    
    
      }


}