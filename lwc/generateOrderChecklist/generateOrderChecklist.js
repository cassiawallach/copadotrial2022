import { LightningElement, api, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getToday, getNumberOfDays, getDateStyleClass } from 'c/utils';

const FIELDS = [
    'kugo2p__SalesQuote__c.kugo2p__AdditionalAccountDetail__r.kugo2p__HaltReason__c',
    'kugo2p__SalesQuote__c.kugo2p__IsPrimary__c',
    'kugo2p__SalesQuote__c.kugo2p__IsRestricted__c',
    'kugo2p__SalesQuote__c.kugo2p__OrderMethod__c',
    'kugo2p__SalesQuote__c.kugo2p__RecordStatus__c',
    'kugo2p__SalesQuote__c.CreatedDate',
    'kugo2p__SalesQuote__c.kugo2p__DateRequired__c',
    'kugo2p__SalesQuote__c.kugo2p__Pricebook2Id__r.IsActive',
    'kugo2p__SalesQuote__c.kugo2p__Opportunity__c',
    'kugo2p__SalesQuote__c.kugo2p__Opportunity__r.CreatedDate',
    'kugo2p__SalesQuote__c.kugo2p__ContactBilling__c',
    'kugo2p__SalesQuote__c.kugo2p__ContactBuying__c',
    'kugo2p__SalesQuote__c.kugo2p__ContactShipping__c',
    'kugo2p__SalesQuote__c.kugo2p__BillToName__c',
    'kugo2p__SalesQuote__c.kugo2p__BillToStreetLong__c',
    'kugo2p__SalesQuote__c.kugo2p__BillToCity__c',
    //'kugo2p__SalesQuote__c.kugo2p__BillToStateProvince__c',
    'kugo2p__SalesQuote__c.kugo2p__BillToZipPostalCode__c',
    //'kugo2p__SalesQuote__c.kugo2p__BillToCountry__c',
    'kugo2p__SalesQuote__c.kugo2p__ShipToName__c',
    'kugo2p__SalesQuote__c.kugo2p__ShipToStreetLong__c',
    'kugo2p__SalesQuote__c.kugo2p__ShipToCity__c',
    //'kugo2p__SalesQuote__c.kugo2p__ShipToStateProvince__c',
    'kugo2p__SalesQuote__c.kugo2p__ShipToZipPostalCode__c',
    //'kugo2p__SalesQuote__c.kugo2p__ShipToCountry__c',
    'kugo2p__SalesQuote__c.kugo2p__DateOfferValidThrough__c',
    'kugo2p__SalesQuote__c.OwnerId',
    'kugo2p__SalesQuote__c.Owner.Name',
    'kugo2p__SalesQuote__c.kugo2p__Account__r.OwnerId',
    'kugo2p__SalesQuote__c.kugo2p__Account__r.Owner.Name',
    'kugo2p__SalesQuote__c.kugo2p__Opportunity__r.OwnerId',
    'kugo2p__SalesQuote__c.kugo2p__Opportunity__r.Owner.Name'
];

export default class GenerateOrderChecklist extends NavigationMixin(LightningElement) {

    @api recordId;

    record;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredData({ error, data }) {
        if (data)
        {
            this.record = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }

    get notSuspended()
    {
        return !getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__AdditionalAccountDetail__r.kugo2p__HaltReason__c');
    }

    get isPrimary()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__IsPrimary__c');
    }

    get notRestricted()
    {
        return !getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__IsRestricted__c');
    }

    get notCancelled()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__RecordStatus__c') != 'Cancelled';
    }

    get orderMethod()
    {
        const om = getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__OrderMethod__c');
        return om == undefined ? 'Per Quote' : om;
    }    

    get isPriceBookActive()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__Pricebook2Id__r.IsActive');
    }
    
    get hasOpportunity()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__Opportunity__c');
    }
    
    get hasContacts()
    {
        return (getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ContactBilling__c') && 
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ContactBuying__c') &&
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ContactShipping__c'));
    }

    get oppAge()
    {
        return getNumberOfDays(getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__Opportunity__r.CreatedDate'), getToday());
    }

    get quoteAge()
    {
        return getNumberOfDays(getFieldValue(this.record, 'kugo2p__SalesQuote__c.CreatedDate'), getToday());
    }

    get expiryDate()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__DateOfferValidThrough__c');
    }

    get expiryDateStyleClass()
    {
        return getDateStyleClass(this.expiryDate);
    }

    get dateRequired()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__DateRequired__c');
    }

    get dateRequiredStyleClass()
    {
        return getDateStyleClass(this.dateRequired);
    }    

    get quoteOwnerId()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.OwnerId');
    }

    get quoteOwnerName()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.Owner.Name');
    }

    get oppOwnerId()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__Opportunity__r.OwnerId');
    }

    get oppOwnerName()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__Opportunity__r.Owner.Name');
    }

    get accountOwnerId()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__Account__r.OwnerId');
    }    

    get accountOwnerName()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__Account__r.Owner.Name');
    }
    
    get hasAddresses()
    {
        return (getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__BillToName__c') && 
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__BillToStreetLong__c') &&
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__BillToCity__c') &&
                //getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__BillToStateProvince__c') && 
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__BillToZipPostalCode__c') &&
                //getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__BillToCountry__c') &&

                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ShipToName__c') && 
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ShipToStreetLong__c') &&
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ShipToCity__c') &&
                //getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ShipToStateProvince__c') && 
                getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ShipToZipPostalCode__c')); //&&
                //getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__ShipToCountry__c'));
    }
    
    get hasLines()
    {
        return getFieldValue(this.record, 'kugo2p__SalesQuote__c.kugo2p__DateRequired__c');
    }    

    get completedItemsCount()
    {
        let counter = 0;
        if (this.notSuspended) counter++;
        if (this.notCancelled) counter++;
        if (this.isPrimary) counter++;
        if (this.notRestricted) counter++;
        if (this.isPriceBookActive) counter++;
        if (this.hasOpportunity) counter++;
        if (this.hasContacts) counter++;
        if (this.hasAddresses) counter++;
        if (this.hasLines) counter++;

        return counter;
    }

    get percentValue()
    {
        return (this.completedItemsCount / 9) * 100;
    }    

    get disableGenerateOder()
    {
        return this.percentValue != 100;
    }

    generateOrder(event) {
        // Navigate to the Generate Order page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/kugo2p__kontroller?action=createSalesOrder&qId=' + this.recordId
            },
        });
    }
}