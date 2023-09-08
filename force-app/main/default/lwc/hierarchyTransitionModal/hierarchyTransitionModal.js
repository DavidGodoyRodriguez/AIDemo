import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class HierarchyTransitionModal extends LightningElement {
    @api modalTitle;
    @track items = [];
    currentItem = {};
    isFirstItem = true;
    isLastItem = false;
    activeItem = 1;

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
        //let activeItemIndex = this.currentItem.itemObject.order;
        this.isLastItem = false;

        this.hideItem(false);
        this.activeItem--;
        this.showItem(this.activeItem);

        if (this.activeItem === 1) {
            this.isFirstItem = true;
        }
    }

    handleNext() {
        this.isFirstItem = false;

        this.hideItem(true);
        this.activeItem++;
        this.showItem(this.activeItem);

        if (this.activeItem === this.items.length) {
            this.isLastItem = true;
        }
    }

    hideItem(completed) {
        this.currentItem.itemObject.hide();
        this.currentItem.completed = completed;
        this.currentItem.active = false;
    }

    showItem(order) {
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