import { LightningElement, api } from 'lwc';
import doCallout from '@salesforce/apex/SPR_CalculatorVersionCloneController.getCalculatorVersionDetail';
import cloneCalculatorVersion from '@salesforce/apex/SPR_CalculatorVersionCloneController.cloneCalculatorVersion';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import { CloseActionScreenEvent } from 'lightning/actions';
  
 
export default class SPR_CalculatorVersionClone extends NavigationMixin(  LightningElement  ) {
   @api recordId;
   @api objectApiName;
 
   recordName='';
   isLoaded = false;
   recordNameHeader='';

connectedCallback(){

    console.log("recordId==>",this.recordId) 
    setTimeout(() => {
        console.log("recordId==>",this.recordId)
        doCallout({recordId : this.recordId})
        .then(result => {
            console.log("recordId==>",this.recordId) 
            console.log('result'+result)            
            console.log(JSON.stringify(result));  
            this.recordName=result.Name; 
            this.isLoaded = true;  
            this.recordNameHeader='Clone - '+ result.Name;     

        }).catch(error => {
            console.log('error'+error)
            this.isLoaded = true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: ' failed!',
                    variant: 'error'
                })
            ); 
            this.isLoaded = true;  
        })
    },200);
}

   closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    cloneAction(){
        console.log(this.recordId);
        this.isLoaded = false;  
        cloneCalculatorVersion({recordId : this.recordId,recordName:this.recordName})
        .then(result => {
            console.log("recordId==>",this.recordId) 
            console.log('result'+result)            
            console.log(JSON.stringify(result));  
            this.dispatchEvent(new CloseActionScreenEvent());            

            this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result.Id,
                    actionName: 'view',
                },
            }).then((url) => {

                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: url
                    }
                },
                true  
                );
 
                const event = new ShowToastEvent({
                    title: 'Success!',
                    message: 'Record cloned',                     
                    variant: 'success'
                });
                this.dispatchEvent(event);
            });
                   
            this.isLoaded = true;  
        }).catch(error => {
            console.log('error'+error)
            this.isLoaded = true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: ' failed!',
                    variant: 'error'
                })
            ); 
            this.isLoaded = true;  
        })

    }

    recordNameChange(event){
        this.recordName=event.detail.value;
    }


}