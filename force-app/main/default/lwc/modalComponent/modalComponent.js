import { LightningElement, track } from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
import getYears from '@salesforce/apex/CarService.getYears';
import getBrands from '@salesforce/apex/CarService.getBrands';
import getModels from '@salesforce/apex/CarService.getModels';
import getCars from '@salesforce/apex/CarService.getCars';

export default class ModalComponent extends LightningModal {
    @track selectedYear;
    @track selectedBrand;
    @track selectedModel;
    @track selectedMake;

    @track yearOptions = [];
    @track brandOptions = [];
    @track modelOptions = [];
    @track makeOptions = [];

    @track disableBrand = true;
    @track disableModel = true;
    @track disableMake = true;

    connectedCallback() {
        this.loadYearOptions();
    }

    async loadYearOptions() {
        try {
            const result = await getYears();
            this.yearOptions = result.map(year => ({ label: year, value: year }));
        } catch (error) {
            console.error('Error loading years: ', error);
            this.showToast('Error', 'Error loading years: ' + error.body.message, 'error'); 
        }
    }

    handleYearChange(event) {
        this.selectedYear = event.detail.value;
        this.disableBrand = false; 
        this.loadBrandOptions(); 
    }

    async loadBrandOptions() {
        try {
            const result = await getBrands({ year: this.selectedYear });
            this.brandOptions = result.map(brand => ({ label: brand, value: brand }));
        } catch (error) {
            console.error('Error loading brands: ', error);
            this.showToast('Error', 'Error loading brands: ' + error.body.message, 'error');
        }
    }

    handleBrandChange(event) {
        this.selectedBrand = event.detail.value;
        this.disableModel = false; 
        this.loadModelOptions(); 
    }

    async loadModelOptions() {
        try {
            const result = await getModels({ year: this.selectedYear, Brand: this.selectedBrand });
            this.modelOptions = result.map(model => ({ label: model, value: model }));
        } catch (error) {
            console.error('Error loading models: ', error);
            this.showToast('Error', 'Error loading models: ' + error.body.message, 'error'); 
        }
    }

    handleModelChange(event) {
        this.selectedModel = event.detail.value;
        this.disableMake = false; 
        this.loadMakeOptions(); 
    }

    async loadMakeOptions() {
        try {
            const result = await getCars({ year: this.selectedYear, Brand: this.selectedBrand, Model: this.selectedModel });
            this.makeOptions = result.map(make => ({ label: make, value: make }));
        } catch (error) {
            console.error('Error loading makes: ', error);
            this.showToast('Error', 'Error loading makes: ' + error.body.message, 'error'); 
        }
    }

    handleMakeChange(event) {
        this.selectedMake = event.detail.value;
    }

    handleSubmit() {
        this.close({
            year: this.selectedYear,
            brand: this.selectedBrand,
            model: this.selectedModel,
            name: this.selectedMake
        });
    }

    handleCloseForm() {
        this.close({ cancel: true });
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
