import { LightningElement, api, wire } from 'lwc';
import getImpactedAreas from '@salesforce/apex/CustomStringSearchLookupController.getImpactedAreas';
const DELAY = 300; // dealy apex callout timing in miliseconds

export default class CustomStringSearchLookup extends LightningElement {
	@api label;
	@api required = false;
	@api placeholder;
	@api sObjectApiName;
	@api formName;
	@api containerClass;
	// private properties
	listResult = []; // to store list of returned records
	tempResult = []; // to store the list of temp records with <mark> tag
	tempInput = ''; // to store the temp input which is not in our impacted areas
	hasRecords = true;
	searchKey = ''; // to store input field value
	isSearchLoading = false; // to control loading spinner
	delayTimeout;
	selectedRecord = {}; // to store selected lookup record in object formate
	input;

	@api
	setCustomValidity(str) {
		this.input.setCustomValidity(str);
	}
	@api
	reportValidity() {
		this.input.reportValidity();
	}
	@api
	checkValidity() {
		return this.input.checkValidity();
	}
	@api
	focus() {
		this.input.focus();
	}

	renderedCallback() {
		if(this.input == null) {
			this.input = this.template.querySelector('lightning-input');
		}
	}

	// wire function property to fetch search record based on user input
	@wire(getImpactedAreas, { searchKey: '$searchKey', formName : '$formName', sObjectApiName : '$sObjectApiName' })
	 searchResult(value) {
		const { data, error } = value;
		this.isSearchLoading = false;
		this.tempResult = [];
		if (data && !data.isError) {
			this.listResult = data.result;
			for (let i in this.listResult) {
					let index = this.listResult[i].Name.toLowerCase().indexOf(this.searchKey.toLowerCase());
					let resultText = `${this.listResult[i].Name.substring(0,index)}<mark style="background-color:yellow">${this.listResult[i].Name.substring(index,index+this.searchKey.length)}</mark>${this.listResult[i].Name.substring(index + this.searchKey.length)}`;
					let tempObj = {Id : this.listResult[i].Id, Name: resultText};
					this.tempResult.push(tempObj);
				}
				if(this.searchKey && this.searchKey != 'undefined' && this.searchKey != '') {
					this.hasRecords = this.listResult.length == 0 ? false : true;
				}
				if(!this.hasRecords) {
					this.tempInput = '';
					this.tempInput = `<mark style="background-color:yellow">${this.searchKey}</mark>`;
				}
		 }
		else if (data && data.isError) {
			console.log('(server error---> ' + 'There is an error while fetching data.');
			this.dispatchCustomEvent('error', "Server error while loading the form data.");
		 }
		else if (error) {
			console.log('(error---> ' + JSON.stringify(error));
			this.dispatchCustomEvent('error', 'Error while loading the form data.');
		}
	};

	// update searchKey property on input field change
	handleKeyChange(event) {
		// Debouncing this method: Do not update the reactive property as long as this function is
		// being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
		this.setCustomValidity('');
		this.reportValidity();
		this.isSearchLoading = true;
		window.clearTimeout(this.delayTimeout);
		const searchKey = event.target.value;
		this.showHideLookupDropdown(searchKey);
		this.delayTimeout = setTimeout(() => {
			this.searchKey = searchKey;
		}, DELAY);
	}

	// This method is used to show hide the lookup dropdown before selection of record
	showHideLookupDropdown(searchKey) {
		const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
		const clsList = lookupInputContainer.classList;
		if(searchKey.trim() != '' && !clsList.contains('slds-is-open')) {
			clsList.add('slds-is-open');
		}
		else if(searchKey.trim() == '' && clsList.contains('slds-is-open')){
			clsList.remove('slds-is-open');
		}
	}

	// method to clear selected lookup record
	handleRemove(){
		this.searchKey = '';
		this.selectedRecord = {};
		this.lookupUpdatehandler(undefined); // update value on parent component as well from helper function

		// remove selected pill and display input field again
		const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
		searchBoxWrapper.classList.remove('slds-hide');
		searchBoxWrapper.classList.add('slds-show');
		const pillDiv = this.template.querySelector('.pillDiv');
		pillDiv.classList.remove('slds-show');
		pillDiv.classList.add('slds-hide');
	}

	// method to update selected record from search result
	handelSelectedRecord(event){
		var objId = event.target.getAttribute('data-recid'); // get selected record Id
		var textData;
		let tempSelectedRecord = this.listResult.find(data => data.Id === objId); // find selected record from list of impacted area
		// if selected record found in list, else create a custom option based on user input
		if(tempSelectedRecord) {
			this.selectedRecord = tempSelectedRecord;
		}
		else {
			this.selectedRecord = Object.assign({}, tempSelectedRecord, { /*matchFound: false,*/ Name: objId.replace('<mark style="background-color:yellow">','').replace('</mark>','')});
		}
		this.lookupUpdatehandler(this.selectedRecord); // update value on parent component as well from helper function
		this.handelSelectRecordHelper(); // helper function to show/hide lookup result container on UI
	}

	/*COMMON HELPER METHOD STARTED*/
	handelSelectRecordHelper(){
		this.template.querySelector('.lookupInputContainer').classList.remove('slds-is-open');
		const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
		searchBoxWrapper.classList.remove('slds-show');
		searchBoxWrapper.classList.add('slds-hide');
		const pillDiv = this.template.querySelector('.pillDiv');
		pillDiv.classList.remove('slds-hide');
		pillDiv.classList.add('slds-show');
	}

	// send selected lookup record to parent component using custom event
	lookupUpdatehandler(value){
		const oEvent = new CustomEvent('lookupupdate',
			{
				'detail': {selectedRecord: value}
			}
		);
		this.dispatchEvent(oEvent);
	}

	get hasSearchKey(){
		return (this.searchKey && this.searchKey != null && this.searchKey != 'undefined' && this.searchKey != '');
	}

	get containerDivClass() {
		return (this.containerClass && this.containerClass != null && this.containerClass != 'undefined') ?
			('slds-form-element ' + this.containerClass) : 'slds-form-element';
	}

	dispatchCustomEvent(eventName, result) {
		const oEvent = new CustomEvent(eventName,
			{
				'detail': result
			}
		);
		this.dispatchEvent(oEvent);
	}
}