import { LightningElement, api, track } from 'lwc';
import getCar from '@salesforce/apex/CarService.getCar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Імпорт для Toast

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
        console.log(year);
        console.log(brand);
        console.log(model);
        console.log(name);
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
}
