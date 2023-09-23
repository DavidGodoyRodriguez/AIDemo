import { LightningElement, api } from 'lwc';
import queryAudioTranscription from "@salesforce/apex/CallClassificationController.queryAudioTranscription";

export default class TranscribeAudio extends LightningElement {
    loading = false;
    error;

    @api
    getItemDataHook() {
        return ;
    }

    @api
    initializeItem(itemData) {
        const contentDocumentId = itemData;
        this.loading = true;

        queryAudioTranscription({ contentDocumentId: contentDocumentId })
        .then((result) => {
          this.setOptions(result);
        })
        .catch((error) => {
          this.error = error;
          console.log(error);
        })
        .finally(() => {
            this.loading = false;
        });
    }

}