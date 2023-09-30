import { LightningElement, api } from 'lwc';
import classifyCall from "@salesforce/apex/CallClassificationController.classifyCall";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ClassifyCall extends LightningElement {
    loading = false;

    @api
    initializeItem(itemData) {
        this.loading = true;
        
        classifyCall({ transcribedAudioList: itemData })
        .then((result) => {
          // this.transcribedAudioList = result;
          // TODO - Create sections of objects to insert in Salesforce
        })
        .catch((error) => {
          this.error = error;
          console.log(error);
          this.showToast(error);
        })
        .finally(() => {
            this.loading = false;
        });

    }

    showToast(error) {
      const event = new ShowToastEvent({
          title: 'Toast Error',
          message: error.body.message,
          variant: 'error'
      });
      this.dispatchEvent(event);
  }

}