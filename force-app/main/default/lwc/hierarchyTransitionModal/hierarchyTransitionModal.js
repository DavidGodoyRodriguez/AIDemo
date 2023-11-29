import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class HierarchyTransitionModal extends LightningElement {
    @api modalTitle;
    @track items = [];
    currentItem = {};
    isFirstItem = true;
    isLastItem = false;

    renderedCallback() {
        if (this.items.length === 0) {
            this.querySelectorAll('c-hierarchy-transition-item').forEach((element) => {
                let item = {
                    "itemObject": element,
                    "active": element.order === "1" ? true : false,
                    "completed": false
                };
                this.items.push(item);
                if (element.order === "1") {
                    this.currentItem = item;
                }
            });

            if (this.items.length === 1) {
                this.lastItem = true;
            }
        }
    }

    handlePrevious() {
        let activeItemIndex = this.currentItem.itemObject.order;
        this.isLastItem = false;

        this.hideCurrentItem(false);
        this.showNewItem(--activeItemIndex);

        if (activeItemIndex === 1) {
            this.isFirstItem = true;
        }
    }

    handleNext() {
        let activeItemIndex = this.currentItem.itemObject.order;
        this.isFirstItem = false;

        this.validateCurrentItem();
        let itemData = this.getCurrentItemData();
        this.hideCurrentItem(true);
        this.showNewItem(++activeItemIndex);
        this.initializeNextItem(itemData);


        if (activeItemIndex === this.items.length) {
            this.isLastItem = true;
        }
    }

    validateCurrentItem() {
        // TODO - Run a validation hook function
    }

    getCurrentItemData() {
        return this.currentItem.itemObject.getSlotData();
    }

    initializeNextItem(itemData) {
        // Wait some time for the components to render
        setTimeout(() => this.currentItem.itemObject.initializeItemHook(itemData), 500);
    }

    hideCurrentItem(completed) {
        this.currentItem.itemObject.hide();
        this.currentItem.completed = completed;
        this.currentItem.active = false;
    }

    showNewItem(order) {
        this.items.forEach((item) => {
            if (item.itemObject.order ===  order.toString()) {
                item.itemObject.show();
                item.active = true;
                this.currentItem = item;
            }
        });
    }

    handleCancel() {
        this.closeModal();
    }

    handleSubmit() {
        this.closeModal();
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent({ bubbles: true, composed: true }));
    }

}