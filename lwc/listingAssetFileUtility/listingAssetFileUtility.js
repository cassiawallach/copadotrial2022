/**
 * @author: Philipp Rackwitz
 * @version: 1.0
 * @description: This component is for the record page to upate the ContentVersionId field taken from a file that is attached to it.
 */
import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFiles from '@salesforce/apex/listingAssetFileUtilityService.getFiles';

import ID_FIELD from '@salesforce/schema/Listing_Asset__c.Id';
import CVID_FIELD from '@salesforce/schema/Listing_Asset__c.ContentVersion_Id__c';

export default class ListingAssetFileUtility extends LightningElement {
    @api recordId;
    @api files = [];

    @track record;
    imperativeWiredFiles;

    @wire(getRecord, {recordId: '$recordId'})wiredRecord({data, error}) {
        this.record = data;
        if(data) {
            getFiles({assetId: this.recordId });
        }
    };

    @wire(getFiles, { assetId: '$recordId' })
    imperativeWiring(result) {
        this.imperativeWiredFiles = result;
        if (result.data) {
            this.files = result.data;
        }
        else if (result.error) {
            console.log('getFiles error', result.error);
            this.dispatchShowToastEvent('File retrieve error', result.error.body.message, 'error');
        }
    }

    get fcount() {
        return (this.files==null)? 0 : this.files.length;
    }

    refresh() {
        console.log('Refreshing files for '+this.recordId);
        //getFiles({assetId: this.recordId });
        return refreshApex(this.imperativeWiredFiles);
    }

    handleClick(event) {
        const cvid = event.target.getAttribute('data-id');
        
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[CVID_FIELD.fieldApiName] = cvid;
        
        const recordInput = { fields };
        
        updateRecord(recordInput)
            .then(result => {
                this.dispatchShowToastEvent('Success', 'Record updated', 'success');
            })
            .catch(error => {
                this.dispatchShowToastEvent('Error updating record', error.body.message, 'error');
            });
    }

    dispatchShowToastEvent(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({ title:title, message:message, variant:variant })
        );
    }
}