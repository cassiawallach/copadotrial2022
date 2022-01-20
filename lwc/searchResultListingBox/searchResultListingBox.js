import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubSub';

export default class SearchResultListingBox extends LightningElement {
    @api ListingType;
    @api ListingTitle;
    @api searchResults = {};
    @api renderBox = false;
	@wire(CurrentPageReference) pageRef;
    
    connectedCallback() {
		registerListener('search_results_received', this.renderResults, this);
	}
	disconnectedCallback() {
		unregisterAllListeners(this);
    }

	renderResults(results) {
		console.log(this.ListingType+' ==> ', results, results[this.ListingType]);
        this.searchResults = {};
        if (results && results.hasOwnProperty([this.ListingType])) {
            this.renderBox = true;
			this.searchResults = results[this.ListingType];
        }
	}
}