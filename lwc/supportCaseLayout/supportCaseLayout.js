import { LightningElement, track } from 'lwc';
import supportIcons from '@salesforce/resourceUrl/Community';

export default class SupportCaseLayout extends LightningElement {
	copadoAcademySupportLogo;
	copadoPlaygroundSupportLogo;
	copadoSupportLogo;
	showSuccess;
	showError;
	formName;
	errorMessage = '';
	form = {
		copadoSupport: {show: false,
			label: 'Copado Support'},
		academy: {show: false,
			label: 'Training/Certification Support'},
		playground:{show: false,
			label: 'Playground Support'}
	};
	@track createdCase;

	constructor() {
		super();
		this.setIcons(this.formName);
	}

	showSupportCaseForm(event) {
		this.resetForm();
		let formName = event.currentTarget.dataset.name;
		this.formName = formName;
		this.setIcons(this.formName);
		if(this.form && this.form.hasOwnProperty(formName) && this.form[formName].hasOwnProperty('show')){
			this.form[formName]['show'] = true;
		}
	}

	setIcons(formName) {
		this.copadoAcademySupportLogo = supportIcons + '/CommunityResources/supportIcons/Academy.png';
		this.copadoPlaygroundSupportLogo = supportIcons + '/CommunityResources/supportIcons/Playground.png';
		this.copadoSupportLogo = supportIcons + '/CommunityResources/supportIcons/CopadoSupport.png';
		if(formName == 'copadoSupport') {
			this.copadoSupportLogo = supportIcons + '/CommunityResources/supportIcons/CopadoSupport1.png';
		}
		else if(formName == 'academy') {
			this.copadoAcademySupportLogo = supportIcons + '/CommunityResources/supportIcons/Academy1.png';
		}
		else if(formName == 'playground') {
			this.copadoPlaygroundSupportLogo = supportIcons + '/CommunityResources/supportIcons/Playground1.png';
		}
	}

	handleSubmit(event) {
		this.createdCase = event.detail;
		this.resetForm();
		this.setIcons(this.formName);
		this.showSuccess = true;
	}

	handleError(event) {
		this.resetForm();
		this.setIcons(this.formName);
		this.errorMessage = event.detail;
		this.showError = true;
	}

	resetForm() {
		this.showSuccess = false;
		this.showError = false;
		this.errorMessage = '';
		this.formName = '';
		this.form = {
			copadoSupport: {show: false,
				label: 'Copado Support'},
			academy: {show: false,
				label: 'Academy Support'},
			playground:{show: false,
				label: 'Playground Support'}
		};
	}
}