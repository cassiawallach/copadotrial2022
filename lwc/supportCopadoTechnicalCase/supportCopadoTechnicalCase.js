import { LightningElement, track, api, wire } from 'lwc';
import saveInputsOfCaseForm from "@salesforce/apex/CommunitySupportCaseController.saveInputsOfCaseForm";
import getOptions from '@salesforce/apex/CommunitySupportCaseController.getOptions';
import getAcademyOrPlaygroundImpactedArea from '@salesforce/apex/CommunitySupportCaseController.getAcademyOrPlaygroundImpactedArea';
import getCertificates from '@salesforce/apex/CommunitySupportCaseController.getCertificates';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { PICKLIST_FIELDS } from "./supportCopadoTechnicalCasePickListFields";

export default class SupportCopadoTechnicalCase extends LightningElement {
	@api formName;
	@api formLabel
	@track inputFieldNameValue;
	@track filesUploaded = [];
	@track picklistFieldsMap;
	@track academyOrPlaygroundImpactedArea = [];
	@track certificates = [];
	@track selectedImpactedArea;
	status;
	isBusy;
	showHideUpdateTimezone;
	isNotProductionDeployment;
	isAffectDataIntegrity;
	haveWorkaround;
	isAffectCriticalFunctionality;
	defaultDescription = '';
	selectedCaseReason = '';
	showCertificates = false;
	hasImpactedArea = false;
	picklistFields;

	// wire function property to fetch impacted area for academy or playground forms
	@wire(getAcademyOrPlaygroundImpactedArea, { caseReason: '$selectedCaseReason', formName : '$formName'})
	getAcademyOrPlaygroundImpactedArea(value) {
		const { data, error } = value; // destructure the provisioned value
		if (data && !data.isError) {
			this.academyOrPlaygroundImpactedArea = data.result;
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

	// wire function property to fetch available certificates
	@wire(getCertificates, { fetchCertificates: '$showCertificates'})
	getCertificates(value) {
		const { data, error } = value; // destructure the provisioned value
		if (data && !data.isError) {
			this.certificates = data.result;
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

	constructor() {
		super();
		this.inputfieldNameValue = {};
		this.isBusy = true;
		this.status = {
			hasError: false,
			errorMessage: null
		};
		this.picklistFieldsMap = {};
		this.showHideUpdateTimezone = false;
	}

	connectedCallback() {
		this.picklistFields = PICKLIST_FIELDS[this.formName];
		this.setDefaultDescription();
		this._getOptions();
	}

	// return the form title based on form selection
	get formTitle() {
		if(this.formLabel) {
			return this.formLabel;
		}
		return;
	}

	get isCopadoSupportCase() {
		return (this.formName && (this.formName === 'copadoSupport') && !this.isBusy);
	}

	get isAcademyOrPlayground() {
		return (this.formName && (this.formName === 'academy' || this.formName === 'playground') && !this.isBusy);
	}

	// Set default description on field Description of form
	setDefaultDescription() {
		if(this.formName && (this.formName === 'copadoSupport')) {
			this.defaultDescription = "<p>1- <b>Brief description</b> - Specify briefly the issue you faced. </p>"
						+"<p><br></p><p>2- <b>Steps to Reproduce </b>- Please specify all the steps which will help support to reproduce the issue faced. </p>"
						+"<p><br></p><p>3- <b>Any other information about Workaround or affected records</b> - Please specify any other information which you think can expedite the support process.</p>"
						+"<p><br></p><p>4- <b>Expected vs Actual Results</b></p>";
		}
		else if(this.formName && (this.formName === 'academy' || this.formName === 'playground')) {
			this.defaultDescription = "<p>1- <b>Brief description</b> - Specify briefly the issue you faced. </p>"
						+"<p><br></p><p>2- <b>Steps to Reproduce </b>- Please specify all the steps which will help support to reproduce the issue faced. </p>"
						+"<p><br></p><p>3- <b>Any other information</b> - Please specify any other information which you think can expedite the support process.</p>"
						+"<p><br></p><p>4- <b>Expected vs Actual Results</b></p>";
		}
	}

	// Validate all the data and than save the record
	validateFieldsAndSave() {
		let dataValid = true;
		let isFocusSet = false;
		var inputs = this.template.querySelectorAll('lightning-input, lightning-textarea, c-custom-string-search-lookup, lightning-combobox, c-input-rich-text, lightning-radio-group');
		inputs.forEach(element => {
			// Trimming the element value if any spaces except impactedArea as it contains object
			if(element.value && element.name != 'impactedArea' && element.value.trim() === "") {
				element.value = null;
			}
			if(element.name == 'description') {
				if(!element.value) {
					element.setInvalid();
					dataValid = false;
					isFocusSet = this._setFocus(element, isFocusSet);
				}
			}
			else if (element.name == 'impactedArea') {
				if(!this.selectedImpactedArea) {
					element.setCustomValidity('Complete this field.');
					element.reportValidity();
					dataValid = false;
					isFocusSet = this._setFocus(element, isFocusSet);
				}
				else {
					element.value = this.selectedImpactedArea;
				}
			}
			else {
				element.reportValidity();
				if(!element.checkValidity()) {
					dataValid = false;
					isFocusSet = this._setFocus(element, isFocusSet);
				}
			}
		});

		// Save the record if all the data entered is valid
		if(dataValid) {
			this.inputFieldNameValue = this._convertInputsToMap(inputs);
			this.inputFieldNameValue['files'] = this.filesUploaded;
			this._saveInputsOfCaseForm(this.inputFieldNameValue);
		}
	}

	// Set the focus on first invalid field on form
	_setFocus(element, isFocusSet) {
		if(!isFocusSet) {
			element.focus();
			isFocusSet = true;
		}
		return isFocusSet;
	}

	// Method to get the options for picklist fields of form
	_getOptions() {
		this.isBusy = true;
		getOptions({
			jsonFieldConfig: JSON.stringify(this.picklistFields),
			formName: this.formName
		})
			.then((result) => {
				if (!result.isError) {
					this.picklistFields = result.result;
					this.picklistFieldsMap = this._convertPicklistFieldsToMap(this.picklistFields);
					this.status = {
						hasError: false
					};
					this.isBusy = false;
				} else {
					this.isBusy = false;
					this.status = {
						hasError: true,
						errorMessage: result.message
					};
					this.dispatchCustomEvent('error', "Server error while loading the form data.");
				}
			})
			.catch((error) => {
				this.status = {
					hasError: true,
					errorMessage: error
						? `${error.status} | ${error.statusText}`
						: "An unexpected error has occurred."
				};
				this.isBusy = false;
				this.dispatchCustomEvent('error', this.status.errorMessage);
			});
	}

	// Convert picklist fields to map
	//i.e key is field name and value is object which contains fieldOptions and defaultOption
	_convertPicklistFieldsToMap(fields) {
		let picklistFieldsMap = {};
		for(let iterator in fields) {
			picklistFieldsMap[fields[iterator].fieldKey] = {
				fieldOptions:  fields[iterator].fieldOptions,
				defaultOption: fields[iterator].defaultOption
			};
		}
		return picklistFieldsMap;
	}

	// Convert input data of form into map
	// i.e key is field name value is the data entered by user
	_convertInputsToMap(inputs){
		let inputsFieldNameValueMap = {};
		inputs.forEach(function(element){
			if(element.type === 'checkbox') {
				inputsFieldNameValueMap[element.name] = element.checked;
			}
			else{
				inputsFieldNameValueMap[element.name] = element.value;
			}
		},this);
		return inputsFieldNameValueMap;
	}

	// Method to save the input data into server
	_saveInputsOfCaseForm(inputsFieldNameValue) {
		this.isBusy = true;
		saveInputsOfCaseForm({
			formName: this.formName,
			jsonFieldNameValue: JSON.stringify(inputsFieldNameValue)
		})
			.then((result) => {
				if (!result.isError) {
					this.isBusy = false;
					this.status = {
						hasError: false
					};
					this.dispatchCustomEvent('submit', result.result);
				} else {
					this.isBusy = false;
					this.status = {
						hasError: true,
						errorMessage: result.message
					};
					if(result.message.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
						this.showToast('Error!', 'error', result.message);
					}
					else{
						this.dispatchCustomEvent('error', "Server error while creating your case.");
					}
				}
			})
			.catch((error) => {
				this.status = {
					hasError: true,
					errorMessage: error
						? `${error.status} | ${error.statusText}`
						: "An unexpected error has occurred."
				};
				this.isBusy = false;
				this.dispatchCustomEvent('error', this.status.errorMessage);
			});
	}

	// Method to define the files data after upload
	handleFileUploaded(event) {
		this.filesUploaded = event.detail;
	}

	// Method to define the impacted area after it's selected by user
	handleImpactedArea(event) {
		this.selectedImpactedArea = event.detail.selectedRecord;
	}

	// Method to get the impacted area after it's selected by user
	get impactedArea() {
		if(this.selectedImpactedArea && this.selectedImpactedArea.Name && !this.selectedImpactedArea.hasOwnProperty('Id')) {
			return this.selectedImpactedArea.Name;
		}
	}

	get showModule() {
		return this.selectedCaseReason == "Academy Modules";
	}

	setProductionDeployment(event) {
		this.isNotProductionDeployment = (event.target.value == 'No');
	}

	setAffectDataIntegrity(event) {
		this.isAffectDataIntegrity = (event.target.value == 'Yes');
	}

	sethaveWorkaround(event) {
		this.haveWorkaround = (event.target.value == 'Yes');
	}

	setAffectCriticalFunctionality(event) {
		this.isAffectCriticalFunctionality = (event.target.value == 'Yes');
	}

	handleTimezoneChange(event) {
		this.showHideUpdateTimezone = (event.target.value != this.picklistFieldsMap.userTimezone.defaultOption);
	}

	handleCaseReasonChange(event) {
		this.selectedCaseReason = event.target.value;
		if(this.selectedCaseReason && this.selectedCaseReason != '') {
			this.hasImpactedArea = true;
		}
		else {
			this.hasImpactedArea = false;
		}
		if(this.selectedCaseReason == "Certifications") {
			this.showCertificates = true;
		}
		else {
			this.showCertificates = false;
		}
	}

	handleErrorInImpactedArea(event) {
		this.dispatchCustomEvent('error', event.detail);
	}

	dispatchCustomEvent(eventName, result) {
		const oEvent = new CustomEvent(eventName,
			{
				'detail': result
			}
		);
		this.dispatchEvent(oEvent);
	}

	showToast(title, variant, message) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: title,
				variant: variant,
				message: message
			})
		);
	}
}