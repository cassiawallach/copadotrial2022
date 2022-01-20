import { LightningElement, api, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getToday, getNumberOfDays, getDateStyleClass } from 'c/utils';

const FIELDS = [
    'kugo2p__SalesOrder__c.kugo2p__AdditionalAccountDetail__r.kugo2p__HaltReason__c',
    'kugo2p__SalesOrder__c.kugo2p__IsPrimary__c',
    'kugo2p__SalesOrder__c.kugo2p__IsRestricted__c',
    'kugo2p__SalesOrder__c.kugo2p__RecordStatus__c',
    'kugo2p__SalesOrder__c.CreatedDate',
    'kugo2p__SalesOrder__c.kugo2p__DateRequired__c',
    'kugo2p__SalesOrder__c.kugo2p__Pricebook2Id__r.IsActive',
    'kugo2p__SalesOrder__c.kugo2p__CustomerPONumber__c',
    'kugo2p__SalesOrder__c.kugo2p__Opportunity__c',
    'kugo2p__SalesOrder__c.kugo2p__Opportunity__r.CreatedDate',
    'kugo2p__SalesOrder__c.kugo2p__ContactBilling__c',
    'kugo2p__SalesOrder__c.kugo2p__ContactBuying__c',
    'kugo2p__SalesOrder__c.kugo2p__ContactShipping__c',
    'kugo2p__SalesOrder__c.kugo2p__BillToName__c',
    'kugo2p__SalesOrder__c.kugo2p__BillToStreetLong__c',
    'kugo2p__SalesOrder__c.kugo2p__BillToCity__c',
    //'kugo2p__SalesOrder__c.kugo2p__BillToStateProvince__c',
    'kugo2p__SalesOrder__c.kugo2p__BillToZipPostalCode__c',
    //'kugo2p__SalesOrder__c.kugo2p__BillToCountry__c',
    'kugo2p__SalesOrder__c.kugo2p__ShipToName__c',
    'kugo2p__SalesOrder__c.kugo2p__ShipToStreetLong__c',
    'kugo2p__SalesOrder__c.kugo2p__ShipToCity__c',
    //'kugo2p__SalesOrder__c.kugo2p__ShipToStateProvince__c',
    'kugo2p__SalesOrder__c.kugo2p__ShipToZipPostalCode__c',
    //'kugo2p__SalesOrder__c.kugo2p__ShipToCountry__c',
    'kugo2p__SalesOrder__c.OwnerId',
    'kugo2p__SalesOrder__c.Owner.Name',
    'kugo2p__SalesOrder__c.kugo2p__Account__r.OwnerId',
    'kugo2p__SalesOrder__c.kugo2p__Account__r.Owner.Name',
    'kugo2p__SalesOrder__c.kugo2p__Opportunity__r.OwnerId',
    'kugo2p__SalesOrder__c.kugo2p__Opportunity__r.Owner.Name',
    'kugo2p__SalesOrder__c.kugo2p__PaymentStatus2__c'
];

export default class ReleaseOrderChecklist extends NavigationMixin(LightningElement) {

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
        return !getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__AdditionalAccountDetail__r.kugo2p__HaltReason__c');
    }

    get isPrimary()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__IsPrimary__c');
    }

    get notRestricted()
    {
        return !getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__IsRestricted__c');
    }

    get notReleasedAndCancelled()
    {
        const recordStatus = getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__RecordStatus__c');

        return recordStatus != 'Released' && recordStatus != 'Cancelled';
    }

    get paymentStatus()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__PaymentStatus2__c');
    }    

    get isPriceBookActive()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__Pricebook2Id__r.IsActive');
    }
    
    get hasOpportunity()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__Opportunity__c');
    }
    
    get hasContacts()
    {
        return (getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ContactBilling__c') && 
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ContactBuying__c') &&
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ContactShipping__c'));
    }

    get oppAge()
    {
        return getNumberOfDays(getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__Opportunity__r.CreatedDate'), getToday());
    }

    get orderAge()
    {
        return getNumberOfDays(getFieldValue(this.record, 'kugo2p__SalesOrder__c.CreatedDate'), getToday());
    }    

    get customerPONumber()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__CustomerPONumber__c');
    }
    
    get dateRequired()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__DateRequired__c');
    }

    get dateRequiredStyleClass()
    {
        return getDateStyleClass(this.dateRequired);
    }

    get orderOwnerId()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.OwnerId');
    }

    get orderOwnerName()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.Owner.Name');
    }

    get oppOwnerId()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__Opportunity__r.OwnerId');
    }

    get oppOwnerName()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__Opportunity__r.Owner.Name');
    }

    get accountOwnerId()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__Account__r.OwnerId');
    }    

    get accountOwnerName()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__Account__r.Owner.Name');
    }
    
    get hasAddresses()
    {
        return (getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__BillToName__c') && 
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__BillToStreetLong__c') &&
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__BillToCity__c') &&
                //getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__BillToStateProvince__c') && 
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__BillToZipPostalCode__c') &&
                //getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__BillToCountry__c') &&

                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ShipToName__c') && 
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ShipToStreetLong__c') &&
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ShipToCity__c') &&
                //getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ShipToStateProvince__c') && 
                getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ShipToZipPostalCode__c')); //&&
                //getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__ShipToCountry__c'));
    }
    
    get hasLines()
    {
        return getFieldValue(this.record, 'kugo2p__SalesOrder__c.kugo2p__DateRequired__c');
    }    

    get completedItemsCount()
    {
        let counter = 0;
        if (this.notSuspended) counter++;
        if (this.notReleasedAndCancelled) counter++;
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

    get disableReleaseOder()
    {
        return this.percentValue != 100;
    }

    releaseOrder(event) {
        // Navigate to the Release Order page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/kugo2p__kontroller?action=updateOrderStatus&ordId=' + this.recordId + '&status=Released'
            },
        });
    }
}