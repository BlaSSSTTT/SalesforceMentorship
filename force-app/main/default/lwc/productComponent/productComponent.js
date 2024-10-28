import { LightningElement, api, track } from 'lwc';

import getCar from '@salesforce/apex/CarService.getCar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ModalComponent from 'c/modalComponent'; 
export default class ProductComponent extends LightningElement {
    @api productId;
    @track car;
    @track activeTab = 'basic-info';

    get cardTitle() {
        return this.car ? `${this.car.Name} Car Details` : 'Car Details';
    }
    get carUrl() {
        return `/lightning/r/Car__c/${this.car.Id}/view`;
    }
    handleTabChange(event) {
        this.activeTab = event.detail; 
    }
    async openModal(event) {
        
        const result = await ModalComponent.open({
            size: 'small'
        });
        
        if(result && !result.cancel){
            const carInfo = {
                year: result.year,
                brand: result.brand,
                model: result.model,
                name: result.name
            };
            this.fetchCarDetails(carInfo);
            const tabChangeEvent = new CustomEvent('addcar', {detail: this.productId });
            this.dispatchEvent(tabChangeEvent); 
        }
    }
    handleClose(){
        this.car = null;
        const tabChangeEvent = new CustomEvent('removecar', {detail: this.productId });
        this.dispatchEvent(tabChangeEvent); 
    }
    fetchCarDetails(productInfo) {
        const { year, brand, model, name } = productInfo;
        getCar({ year, brand, model, name })
            .then(result => {
                this.car = result;
            })
            .catch(error => {
                console.error('Error fetching car details: ', error.body.message);
                this.showToast('Error', 'Error fetching car details: ' + error.body.message, 'error'); 
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
    




     _shownArea;
    @api
    set shownArea(value) {
        this._shownArea = value;
        if (value) {
            this.scrollToSection(value);
        }
    }

    get shownArea() {
        return this._shownArea;
    }

    scrollToSection(section) {
        try{
            const headers = this.template.querySelectorAll('h2.slds-card__header-title');

            let targetElement = null;
            headers.forEach(header => {
                if (header.textContent.trim() === section) {
                    targetElement = header.closest('div.slds-card.custom-card');
                }
            });
            if (targetElement) {
                const header = this.template.querySelector('.slds-card__header');
                const yOffset = targetElement.querySelector(".slds-card__header").clientHeight+20+2*header.clientHeight; 
                const y = targetElement.getBoundingClientRect().top + window.scrollY - yOffset;
                window.scrollTo({top: y, behavior: 'smooth'});
            } 
        }
        catch(error){
            console.log('Error scrolling to section: ' + error.message);
        }
        
    }
}
