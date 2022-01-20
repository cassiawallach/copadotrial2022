import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ListingBreadcrumb extends NavigationMixin(LightningElement) {
    @api searchResultsPage;

    handleClick(event) {
        event.preventDefault();
            
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: this.searchResultsPage,
            },
            state: {}
        });
    }
}