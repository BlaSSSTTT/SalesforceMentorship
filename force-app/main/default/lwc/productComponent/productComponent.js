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
            const tabChangeEvent = new CustomEvent('addcar', {  });
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
            const targetElement = this.template.querySelector(`[data-section="${section}"]`);
            if (targetElement) {
                const header = this.template.querySelector('.slds-card__header');
                const yOffset = targetElement.querySelector(".slds-card__header").getBoundingClientRect().left+50+2*header.getBoundingClientRect().left; 
                const y = targetElement.getBoundingClientRect().top + window.scrollY - yOffset;
                window.scrollTo({top: y, behavior: 'smooth'});
            } else {
                console.error(`Section "${section}" not found.`);
            }
        }
        catch(error){
            console.log('Error scrolling to section: ' + error.message);
        }
        
    }
}
