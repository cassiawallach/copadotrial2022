import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubSub';

export default class SearchResultsQueryInput extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    
    handleKeyUp(event) {
        const isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            console.log(event.target.value);
            fireEvent(this.pageRef, 'search_query_term', event.target.value);
        }
    }
    handleClick() {
        let q = this.template.querySelector('[data-id="txtSearch"]').value;
        console.log("Clicked value: "+q);
        fireEvent(this.pageRef, 'search_query_term', q);
    }
}