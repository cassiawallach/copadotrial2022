import { LightningElement, track, api } from 'lwc';

export default class InputRichText extends LightningElement {
    @api label;
    @api labelVisible;
    @api required;
    @api helpMessage;
    @api disabledCategories='';
    @api errorMessage = "Complete this field.";
    @api richTextClass;
    @api value;
    @track input;
    @track validity = true;

    @api
    setInvalid() {
        this.validity = false;
    }
    @api
    focus() {
        this.input.focus();
    }

    renderedCallback() {
        if(this.input == null) {
            this.input = this.template.querySelector('lightning-input-rich-text');
        }
    }

    validate(event) {
        this.value = event.target.value;
        if (!this.value && this.required) {
            this.validity = false;
        }
        else {
            this.validity = true;
        }
    }
}