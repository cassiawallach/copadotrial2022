import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getAssetsBySection from '@salesforce/apex/ListingAssetService.getAssetsBySection';

/** Listing__c Schema. */
import NAME_FIELD from '@salesforce/schema/Listing__c.Name';
import COMPANY_NAME_FIELD from '@salesforce/schema/Listing__c.Company_Name__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Listing__c.Description__c';
import FIRST_LISTED_FIELD from '@salesforce/schema/Listing__c.First_Listed__c';
import GET_IT_NOW_ACTION_FIELD from '@salesforce/schema/Listing__c.Get_It_Now_Action__c';
import LATEST_RELEASE_FIELD from '@salesforce/schema/Listing__c.Latest_Release__c';
import LISTING_PROFILE_FIELD from '@salesforce/schema/Listing__c.Listing_Profile__c';
import PRICE_FIELD from '@salesforce/schema/Listing__c.Price__c';
import RATING_FIELD from '@salesforce/schema/Listing__c.Rating__c';
import REVIEWS_FIELD from '@salesforce/schema/Listing__c.Reviews__c';
import TYPE_FIELD from '@salesforce/schema/Listing__c.Type__c';
const listingFields = [NAME_FIELD, COMPANY_NAME_FIELD, DESCRIPTION_FIELD, FIRST_LISTED_FIELD, GET_IT_NOW_ACTION_FIELD, LATEST_RELEASE_FIELD,
    LISTING_PROFILE_FIELD, PRICE_FIELD, RATING_FIELD, REVIEWS_FIELD, TYPE_FIELD];

export default class ListingDetail extends LightningElement {
    @api recordId;
    @api communityname;
        
    @wire(getRecord, { recordId: '$recordId', fields: listingFields })
    listing;
    
    @wire(getAssetsBySection, { listingId: '$recordId', section: 'Carousel' })
    listingAssets;

    connectedCallback() {
        this.recordId = this.getRecordId();
        console.log('Listing connected callback: '+this.recordId, this.communityname);
        this.getCarouselAssets();
    }
    renderedCallback() {
        console.log('Listing rendered callback: '+this.recordId, this.communityname);
    }
    
    getCarouselAssets(){
        getAssetsBySection(this.recordId, 'Carousel');
    }

    getRecordId() {
        var url = new URL(window.location);
        var rid = url.searchParams.get("recordId");
        return (rid && rid.length>0)? rid : null;
    }
}