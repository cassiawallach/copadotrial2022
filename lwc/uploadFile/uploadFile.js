import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const MAX_FILE_SIZE = 4194304;

export default class UploadFile extends LightningElement {

    @api name;
    @api label;
    @api multiple;
    @api required;
    @api divClass = '';
    @track input;
    @track files = [];

    @api
    setCustomValidity(str) {
        this.input.setCustomValidity(str);
    }

    @api
    reportValidity() {
        this.input.reportValidity();
    }

    @api
    checkValidity() {
        return this.input.checkValidity();
    }

    renderedCallback() {
        if( this.input == null ){
            this.input = this.template.querySelector('lightning-input');
        }
    }

    get isRequired() {
        return (this.required === 'true');
    }
    get isMultiple() {
        return (this.multiple === 'true');
    }
    get containerClass() {
        return this.divClass;
    }

    readFile(fileSource) {
        if (fileSource.size > MAX_FILE_SIZE) {
            this.showToast('Error!', 'error', 'File size exceeded the upload size limit.');
            return;
        }
        return new Promise((resolve, reject) => {
            const fileReader = new FileReader();
            const fileName = fileSource.name;
            fileReader.onerror = () => reject(fileReader.error);
            fileReader.onload = () => resolve({ PathOnClient: fileName, Title: fileName, VersionData: fileReader.result.split(',')[1]});
            fileReader.readAsDataURL(fileSource);
        });
    }

    async handleFileUploaded(event) {
        let tempFiles = [];
        tempFiles = await Promise.all(
            [...event.target.files].map(file => this.readFile(file))
        );
        if (!tempFiles.includes(undefined)) {
            if((this.files.length + tempFiles.length) > 10) {
                this.showToast('Error!', 'error', 'Number of files exceeded the limit of 10.');
            }
            else {
                Array.prototype.push.apply(this.files,tempFiles);
                // Here, to upload the files to the server
                // Creates the event with the data.
                const selectedEvent = new CustomEvent("filesuploaded", {
                    detail: this.files
                });

                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            }
        }
    }
    removeFile(event) {
        var index = event.currentTarget.dataset.id;
        this.files.splice(index, 1);
    }
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                variant: variant,
                message: message,
            })
        );
    }
}