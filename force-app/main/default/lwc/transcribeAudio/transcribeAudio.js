import { LightningElement, api } from 'lwc';

export default class TranscribeAudio extends LightningElement {

    @api
    getItemDataHook() {
        return ;
    }

    @api
    initializeItem(itemData) {
        const contentDocumentId = itemData;
        // TODO - Display spinner

        // TODO - Call to the backend
        



    }

}