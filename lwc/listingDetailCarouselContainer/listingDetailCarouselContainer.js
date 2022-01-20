import { LightningElement, api } from 'lwc';

export default class ListingDetailCarouselContainer extends LightningElement {
    @api mediatype;
    @api src;
    @api description;
}