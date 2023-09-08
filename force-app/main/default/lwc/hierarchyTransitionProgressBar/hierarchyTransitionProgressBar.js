import { LightningElement, api } from 'lwc';

export default class HierarchyTransitionProgressBar extends LightningElement {
    @api items;

    get maxItems() {
        return this.items.length;
    }

    get itemsProgress() {
        let counterProgress = 1;
        this.items.forEach((item) => {
            if (item.completed) {
                counterProgress++;
            }
        });
        return counterProgress;
    }
}