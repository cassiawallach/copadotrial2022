import { LightningElement, api } from 'lwc';

export default class DisplayImage extends LightningElement {
    @api fileId;
    @api height;
    @api width;
    @api alt;
    @api title;

    get url() {
        return '/sfc/servlet.shepherd/document/download/' + this.fileId;
    }
}