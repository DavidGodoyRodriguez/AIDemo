import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class HierarchyTransitionModal extends LightningElement {
    @api modalTitle;
    @track items = [];
    isFirstItem = true;
    isLastItem = false;
    activeItem = 1;

    renderedCallback() {
        if (this.items.length === 0) {
            this.querySelectorAll('c-hierarchy-transition-item').forEach((element) => {
                this.items.push({
                    "itemObject": element,
                    "active": element.order === "1" ? true : false,
                    "completed": false
                })
            });

            if (this.items.length === 1) {
                this.lastItem = true;
            }
        }
    }

    handlePrevious() {
        this.isLastItem = false;

        this.hideItem(this.activeItem, false);
        this.activeItem--;
        this.showItem(this.activeItem);

        if (this.activeItem === 1) {
            this.isFirstItem = true;
        }
    }

    handleNext() {
        this.isFirstItem = false;

        this.hideItem(this.activeItem, true);
        this.activeItem++;
        this.showItem(this.activeItem);

        if (this.activeItem === this.items.length) {
            this.isLastItem = true;
        }
    }

    hideItem(order, completed) {
        this.items.forEach((item) => {
            if (item.itemObject.order ===  order.toString()) {
                item.itemObject.hide();
                item.completed = completed;
                item.active = false;
            }
        });
    }

    showItem(order) {
        this.items.forEach((item) => {
            if (item.itemObject.order ===  order.toString()) {
                item.itemObject.show();
                item.active = true;
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