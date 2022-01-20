import { LightningElement, api } from 'lwc';

export default class ListingDetailHeadlineDetails extends LightningElement {
    @api record;
    @api communityname;
    
    handleGetItNowClick() {
        const modal = this.template.querySelector('c-get-it-now-modal');
        modal.openModal();
    }

    get pricingHeader(){
        if (this.record.fields.Price__c.value=='Free') return 'Free';
        else return '';
    }
}