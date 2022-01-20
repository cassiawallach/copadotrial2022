import { track, LightningElement } from 'lwc';
import { guid } from 'c/utils';

export default class CarouselItem extends LightningElement {

    @track tabIndex = '-1';
    @track ariaHidden = 'true';

    _selected = false;

    initialRender = true;

    constructor() {
        super();
        this.selected = false;
    }

    connectedCallback() {
        this.setAttribute('data-handles-touch', true);
    }

    set selected(value) {
        this._selected = value;

        if (value === true) {
            this.ariaHidden = 'false';
            this.setTabIndex('0');
        } else {
            this.ariaHidden = 'true';
            this.setTabIndex('-1');
        }
    }

    get selected() {
        return this._selected;
    }

    setLabelledBy(value) {
        this.panelElement.setAttribute('aria-labelledby', value);
    }

    setTabIndex(value) {
        this.tabIndex = value;
    }

    select() {
        const privateimageselect = new CustomEvent('privateimageselect', {
            bubbles: true,
            composed: true
        });

        this.selected = true;
        this.dispatchEvent(privateimageselect);
    }

    unselect() {
        this.selected = false;
    }

    isSelected() {
        return this.selected;
    }

    renderedCallback() {
        if (this.initialRender) {
            this.panelElement = this.template.querySelector('div');

            const privateimageregister = new CustomEvent(
                'privateimageregister',
                {
                    bubbles: true,
                    detail: {
                        callbacks: {
                            select: this.select.bind(this),
                            unselect: this.unselect.bind(this),
                            isSelected: this.isSelected.bind(this),
                            setTabIndex: this.setTabIndex.bind(this),
                            setLabelledBy: this.setLabelledBy.bind(this)
                        },

                        contentId: this.panelElement.getAttribute('id'),
                        guid: guid()
                    }
                }
            );

            this.classList.add('slds-carousel__panel');
            this.dispatchEvent(privateimageregister);
            this.initialRender = false;
        }
    }
}