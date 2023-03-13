import { LightningElement,track } from 'lwc';

import downloadApplicationURL from "@salesforce/apex/SPR_DownloadApplicationController.downloadApplicationURL";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from 'lightning/navigation';

export default class DownloadApplication extends NavigationMixin(LightningElement) {

    @track downloadURL;
    @track download=false;
    connectedCallback(){

        console.log("DownloadApplication");
        downloadApplicationURL()
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
    
    
    
      }


}