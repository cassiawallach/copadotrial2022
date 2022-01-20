import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ListingResultRow extends NavigationMixin(LightningElement) {
    @api row;
    
    handleClick(event) {
        let elemnt = event.currentTarget;
        let recordId = elemnt.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'listing-detail',
            },
            state: {
                'recordId': recordId
            }
        });
    }
}