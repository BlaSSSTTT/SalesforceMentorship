import { LightningElement, api, track } from 'lwc';

import getCar from '@salesforce/apex/CarService.getCar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ModalComponent from 'c/modalComponent'; 
export default class ProductComponent extends LightningElement {
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
        console.log(result.cancel);
        
        if(!result.cancel){
            const carInfo = {
                year: result.year,
                brand: result.brand,
                model: result.model,
                name: result.name
            };
            this.fetchCarDetails(carInfo);
        }
    }

    fetchCarDetails(productInfo) {
        const { year, brand, model, name } = productInfo;
        getCar({ year, brand, model, name })
            .then(result => {
                this.car = result;
            })
            .catch(error => {
                console.error('Error fetching car details: ', error);
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
        const targetElement = this.template.querySelector(`[data-section="${section}"]`);
        console.log(targetElement);
        if (targetElement) {
            const yOffset = document.querySelector(".slds-card__header").getBoundingClientRect().left+50; 
            const y = targetElement.getBoundingClientRect().top + window.scrollY - yOffset;
            window.scrollTo({top: y, behavior: 'smooth'});
            //targetElement.scrollIntoView({ behavior: 'smooth', block: 'start', inline: 'nearest' });
        } else {
            console.error(`Section "${section}" not found.`);
        }
    }
}
