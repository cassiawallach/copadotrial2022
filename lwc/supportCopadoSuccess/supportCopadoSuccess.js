import { LightningElement, api } from 'lwc';

export default class SupportCopadoSuccess extends LightningElement {
	@api successMessage = 'Your Case has been has been succesfully submitted.';
	@api subHeading = 'We\'ll get back to you soon.';
	@api createdCase;

	get caseURL() {
		return "/s/case/" + this.createdCase.Id;
	}
}