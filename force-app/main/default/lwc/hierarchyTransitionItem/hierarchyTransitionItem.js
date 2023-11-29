import { LightningElement, api } from 'lwc';

export default class HierarchyTransitionItem extends LightningElement {
    @api itemName;
    @api order;
    visible = false;

    connectedCallback() {
        if (this.order === "1") {
            this.visible = true;
        }
    }

    @api 
    show() {
        this.visible = true;
    }

    @api
    hide() {
        this.visible = false;
    }

    @api 
    getSlotData() {
        return this.querySelector('*').getItemDataHook();
    }

    @api
    initializeItemHook(itemData) {
        this.querySelector('*').initializeItem(itemData);
    }

}