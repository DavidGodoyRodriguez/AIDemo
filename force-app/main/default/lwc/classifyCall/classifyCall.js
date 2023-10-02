import { LightningElement, api } from 'lwc';
import classifyCall from "@salesforce/apex/CallClassificationController.classifyCall";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ClassifyCall extends LightningElement {
  loading = false;
  contacts;
  opportunities;
  products;
  tasks;

  @api
  initializeItem(itemData) {
      this.loading = true;
      
      classifyCall({ transcribedAudioList: itemData })
      .then((result) => {
        this.contacts = result.contacts;
        this.opportunities = result.opportunities;
        this.products = result.products;
        this.tasks = result.tasks;
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

  getUniqueKey() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }
  
}