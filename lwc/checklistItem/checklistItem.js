import { LightningElement, api } from 'lwc';

export default class ChecklistItem extends LightningElement {

    @api itemName;
    @api itemDescription;
    @api itemGridFirstColumnSize = 3;
    @api itemStyleClass;
    @api itemDataType = 'text';
    @api isSuccess = false;
    @api isLastItem = false;
    @api itemRecordId;

    get computedWrapperClassNames() {
        return this.isLastItem ? '' : 'slds-border_bottom';
    }

    get gridColumn1ClassNames() {
        return 'slds-col slds-size_' + this.itemGridFirstColumnSize + '-of-4';
    }

    get gridColumn2ClassNames() {
        return 'slds-col slds-size_' + (4 - this.itemGridFirstColumnSize) + '-of-4';
    }

    get isText() {
        return this.itemDataType == 'text';
    }

    get isDate() {
        return this.itemDataType == 'date';
    }

    get isURL() {
        return this.itemDataType == 'url';
    }

    get recordLink() {
        //return '/' + this.itemRecordId;
        return '/lightning/r/User/' + this.itemRecordId + '/view';
    }
}