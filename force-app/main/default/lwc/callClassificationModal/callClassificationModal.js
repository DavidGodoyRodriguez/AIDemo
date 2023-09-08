import { LightningElement, wire } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';

export default class CallClassificationModal extends LightningElement {
    recordId;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }

}