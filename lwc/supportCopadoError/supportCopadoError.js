import { LightningElement, api } from 'lwc';

export default class SupportCopadoError extends LightningElement {
	@api errorHeading = "There's been a problem.";
	@api errorMessage = "Something went wrong.";
}