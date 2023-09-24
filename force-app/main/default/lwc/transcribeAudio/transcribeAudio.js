import { LightningElement, api, track } from 'lwc';
import queryAudioTranscription from "@salesforce/apex/CallClassificationController.queryAudioTranscription";

export default class TranscribeAudio extends LightningElement {
    loading = false;
    transcribedAudioList;
    @track transcribedAudioSectionsList;    
    error;

    @api
    getItemDataHook() {
      return this.transcribedAudioList;
    }

    @api
    initializeItem(itemData) {
        const contentDocumentId = itemData;
        this.loading = true;

        queryAudioTranscription({ contentDocumentId: contentDocumentId })
        .then((result) => {
          this.transcribedAudioList = result;
          this.categorizeSpeakerSections();
        })
        .catch((error) => {
          this.error = error;
          console.log(error);
        })
        .finally(() => {
            this.loading = false;
        });
    }

    categorizeSpeakerSections() {
      this.transcribedAudioSectionsList = [];
      this.transcribedAudioList.forEach((transcribedAudioSection) => {
        if (transcribedAudioSection.includes('Speaker 0:')) {
          this.transcribedAudioSectionsList.push({
            'inbound': false,
            'outbound': true, 
            'text': transcribedAudioSection.replace('Speaker 0:', '')
          });
        } else if (transcribedAudioSection.includes('Speaker 1:')) {
          this.transcribedAudioSectionsList.push({
            'inbound': true, 
            'outbound': false,
            'text': transcribedAudioSection.replace('Speaker 1:', '')
          });
        }
      });
    }

}