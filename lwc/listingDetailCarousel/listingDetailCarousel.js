import { LightningElement, api } from 'lwc';

export default class ListingDetailCarousel extends LightningElement {
    @api record;
    @api assets;
    @api communityname;
    assetWrapper = [];
    itemCount;
    slider;
    sliderLocator = '[data-id="theSlider"]';
    
    connectedCallback() {
        this.itemCount = (this.assets && this.assets!=null)? this.assets.length : 0;
        if (this.assets && this.assets!=null) {
            for (let i=0; i<this.assets.length; i++) {
                let clonedAsset = this.clone(this.assets[i]);
                let CurrentURL = window.location.href;
                CurrentURL = CurrentURL.split('/s/')[0]+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+this.assets[i].ContentVersion_Id__c;
                clonedAsset['uri'] = CurrentURL;
                this.assetWrapper.push(clonedAsset);
            }
        }
    }
    renderedCallback() {
        this.showContainerForIndex(0);
    }    
    hideCarousel() {
        let carousel = this.template.querySelectorAll('[id="hidden-carousel"]');
        if (carousel != null) {
            carousel.style.display = 'none';
        }
    }

    previous() {
        let i = this.getDataIndex();
        console.log('next previous');
        if (i==0) {
            this.showContainerForIndex((this.itemCount-1));
        }
        else {
            i--;
            this.showContainerForIndex(i);
        }
    }
    next() {
        console.log('next click');
        let i = this.getDataIndex();
        console.log(this.slider, i);
        if (i==(this.itemCount-1)) {
            this.showContainerForIndex(0);
        }
        else {
            i++;
            this.showContainerForIndex(i);
        }
    }

    showContainerForIndex(i) {
        this.slider = this.template.querySelector(this.sliderLocator);
        this.setNavigatorDescriptionForIndex(i);
        this.setSliderOffset(i);
        this.setDataIndex(i);
    }
    setNavigatorDescriptionForIndex(i) {
        const item = (this.assetWrapper && this.assetWrapper.length>0)? this.assetWrapper[i] : {};
        const title = (item && item.hasOwnProperty('Caption__c'))?item.Caption__c : ''; 
        let slideDescription = this.template.querySelectorAll('[class="appx-carousel-navigator-description"]')[0];
        console.log(slideDescription);    
        if (title=='') {
            let slideOf = 'of';
            slideDescription.innerHTML = (i+1)+' '+slideOf+' '+this.itemCount;
        }
        else {
            let slideOf = 'of';
            slideDescription.innerHTML = (i+1)+' '+slideOf+' '+this.itemCount+': '+title;
        }
    }
    setSliderOffset(i) {
        this.slider = this.template.querySelector(this.sliderLocator);
        let pxOffset = 0 - (i * this.slider.offsetWidth);
        this.slider.style = "margin-left: "+pxOffset+"px";
    }
    setDataIndex(i) {
        this.slider = this.template.querySelector(this.sliderLocator);
        this.slider.setAttribute('data-index', i);
    }
    getDataIndex() {
        this.slider = this.template.querySelector(this.sliderLocator);
        return this.slider.getAttribute('data-index');
    }
    clone(obj) {
        if (null == obj || "object" != typeof obj) return obj;
        var copy = obj.constructor();
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
        }
        return copy;
    }
}