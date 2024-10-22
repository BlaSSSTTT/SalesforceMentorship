import { LightningElement, api, track } from 'lwc';
import getCar from '@salesforce/apex/CarService.getCar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
export default class ProductComponent extends LightningElement {
    @track car;
    @track error;
    @track show = false;
    @track activeTab = 'basic-info';

    _productInfo;

    @api
    set productInfo(value) {
        this._productInfo = value;
        if (value) {
            this.fetchCarDetails();
        }
    }

    get productInfo() {
        return this._productInfo;
    }

    get cardTitle() {
        return this.car ? `${this.car.Name} Car Details` : 'Car Details';
    }

    handleTabChange(event) {
        this.activeTab = event.detail; 
    }

    fetchCarDetails() {
        const { year, brand, model, name } = this.productInfo;
        getCar({ year, brand, model, name })
            .then(result => {
                this.car = result;
                this.show = true;
            })
            .catch(error => {
                this.error = error;
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
