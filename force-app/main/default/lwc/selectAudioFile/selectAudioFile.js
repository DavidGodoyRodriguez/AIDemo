import { LightningElement, api } from 'lwc';
import getAudioFiles from "@salesforce/apex/CallClassificationController.getAudioFiles";

export default class SelectAudioFile extends LightningElement {
    @api recordId;
    options;
    value;
    error;

    connectedCallback() {
        getAudioFiles({ recordId: this.recordId })
        .then((result) => {
          this.setOptions(result);
        })
        .catch((error) => {
          this.error = error;
        });
    }

    setOptions(audioFiles) {
        this.options = [];
        audioFiles.forEach((audioFile) => {
            this.options.push({
                label: audioFile.Title + '.' + audioFile.FileExtension, 
                value: audioFile.Id
            });
        });
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    @api
    getSelectedFileId() {
        return this.value;
    }

}