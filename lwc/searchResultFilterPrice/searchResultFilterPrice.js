import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubSub';

export default class SearchResultFilterPrice extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    connectedCallback() {
        registerListener('reset_search_results_filters', this.handleResetSearchResultsFilters, this);
	}
	disconnectedCallback() {
		unregisterAllListeners(this);
    }
    handleResetSearchResultsFilters() {
        let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]');
        for(let i=0; i<checkboxes.length; i++) {
            checkboxes[i].checked = true;
        }
        this.handleFilterUpdate();
    }
    handleFilterUpdate() {
        let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]');
        const obj = Object.create({});
        for(let i=0; i<checkboxes.length; i++) {
            obj[checkboxes[i].getAttribute('data-value')] = checkboxes[i].checked;
        }
        console.log('Price: ', obj);
        fireEvent(this.pageRef, 'search_filter_update', {"Price": obj});
    }
}