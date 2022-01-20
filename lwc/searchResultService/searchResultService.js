import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import loadListings from '@salesforce/apex/ListingSearchService.getListings';
import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubSub';

const PAGE_SIZE = 8;
export default class SearchResultService extends LightningElement {
    searchResults = {};
    error = {};
	_q = '';
	_listingTypes = ['Template', 'Integration', 'Extension'];
	_listingRatings = ['5', '4', '3', '2', '1', 'Not Rated'];
	_price = '';
	_filter = { searchKey:'$_q', listingType:this._listingTypes, price:this._price, rating:this._listingRatings };
	_page = 1;
    browserPathName;
    matches;
            
	@wire(CurrentPageReference) pageRef;
	
	@wire(loadListings, { filter: '$_filter', pageSize: PAGE_SIZE, pageNumber: '$_page' }) wiredResult({data, error}){
		if (data) {
            console.log('Results ===> ', data);
            fireEvent(this.pageRef, 'search_results_received', data);
			this.error = {};
		}
		else if (error) {
			this.error = error;
		}
	}

    connectedCallback() {
		registerListener('search_query_term', this.handleSearchQueryTerm, this);
		registerListener('apply_search_filters', this.applySearchFilter, this);
		this._filter.searchKey = '';
	}
	disconnectedCallback() {
		unregisterAllListeners(this);
	}

	handleSearchQueryTerm(event) {
		console.log('query term received: '+event);
		this._q = event;
		this._filter.searchKey = this._q;
		this.applySearchFilter(this._filter);
	}
	applySearchFilter(filters) {
		console.log('Filters received: ', filters);
		if (filters.hasOwnProperty('Type')) {
			let _types = [];
			for (let t in filters.Type) {
				if (filters.Type[t]==true) {
					_types.push(t);
				}
			}
			this._filter.listingType = _types;
		}
		if (filters.hasOwnProperty('Rating')) {
			let _ratings = [];
			for (let r in filters.Rating) {
				if (filters.Rating[r]==true) {
					_ratings.push(r);
				}
			}
			this._filter.rating = _ratings;
		}
		if (filters.hasOwnProperty('Price')) {
			if ((filters.Price.Free==true && filters.Price.Paid==true) || (filters.Price.Free==false && filters.Price.Paid==false)) {
				this._filter.price = '';
			}
			else if (filters.Price.Free==true && filters.Price.Paid==false) {
				this._filter.price = 'Free';
			}
			else if (filters.Price.Free==false && filters.Price.Paid==true) {
				this._filter.price = 'Paid';
			}
		}
		this._filter.searchKey = this._q;
		this._filter = Object.assign({}, this._filter);
		console.log('New filter: ', this._filter);
	}
}