import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubSub';

export default class SearchResultFilterExecute extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @api filters = {};
    
    connectedCallback() {
        registerListener('search_filter_update', this.handleFilterUpdate, this);
	}
	disconnectedCallback() {
		unregisterAllListeners(this);
    }
    
    resetFilters() {
        fireEvent(this.pageRef, 'reset_search_results_filters', this);
    }

    applyFilters() {
        console.log('Pushing filters: ', this.filters);
        fireEvent(this.pageRef, 'apply_search_filters', this.filters);
    }

    handleFilterUpdate(event) {
        let filterArray = event;
        for (let [key, value] of Object.entries(filterArray)) {
            this.filters[key] = value;
        }
        console.log(this.filters);
    }
}