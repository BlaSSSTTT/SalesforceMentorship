import { LightningElement, track } from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
import getYears from '@salesforce/apex/CarService.getYears';
import getBrands from '@salesforce/apex/CarService.getBrands';
import getModels from '@salesforce/apex/CarService.getModels';
import getCars from '@salesforce/apex/CarService.getCars';

export default class ModalComponent extends LightningModal {
    @track comboboxes =[
        {
            label:"Select Car Year",
            placeholder:"Select Year",
            value:null,
            options:[],
            onchange:this.handleYearChange,
            isDisabled:false
        },
        {
            label:"Select Car Brand",
            placeholder:"Select Brand",
            value:null,
            options:[],
            onchange:this.handleBrandChange,
            isDisabled:true
        },
        {
            label:"Select Car Model",
            placeholder:"Select Model",
            value:null,
            options:[],
            onchange:this.handleModelChange,
            isDisabled:true
        },
        {
            label:"Select Car",
            placeholder:"Select Car",
            value:null,
            options:[],
            onchange:this.handleMakeChange,
            isDisabled:true
        }
    ]



    connectedCallback() {
        this.loadYearOptions();
    }

    async loadYearOptions() {
        
        try {
            const result = await getYears();
            this.comboboxes[0].options = result.map(year => ({ label: year, value: year }));
        } catch (error) {
            console.error('Error loading years: ', error);
            this.showToast('Error', 'Error loading years: ' + error.body.message, 'error'); 
        }
    }

    handleYearChange(event) {        
        this.comboboxes[0].value = event.detail.value;
        this.comboboxes[1].isDisabled = false; 
        this.comboboxes[2].isDisabled = true;
        this.comboboxes[3].isDisabled = true;
        this.comboboxes[2].options = [];
        this.comboboxes[3].options = [];
        this.loadBrandOptions(); 
    }

    async loadBrandOptions() {
        try {
            const result = await getBrands({ year: this.comboboxes[0].value });
            this.comboboxes[1].options = result.map(brand => ({ label: brand, value: brand }));
        } catch (error) {
            console.error('Error loading brands: ', error);
            this.showToast('Error', 'Error loading brands: ' + error.body.message, 'error');
        }
    }

    handleBrandChange(event) {
        this.comboboxes[1].value = event.detail.value;
        this.comboboxes[2].isDisabled = false; 
        this.comboboxes[3].isDisabled = true;
        this.comboboxes[3].options = [];
        this.loadModelOptions(); 
    }

    async loadModelOptions() {
        try {
            const result = await getModels({ year: this.comboboxes[0].value, Brand: this.comboboxes[1].value });
            this.comboboxes[2].options = result.map(model => ({ label: model, value: model }));
        } catch (error) {
            console.error('Error loading models: ', error);
            this.showToast('Error', 'Error loading models: ' + error.body.message, 'error'); 
        }
    }

    handleModelChange(event) {
        this.comboboxes[2].value = event.detail.value;
        this.comboboxes[3].isDisabled = false; 
        this.loadMakeOptions(); 
    }

    async loadMakeOptions() {
        try {
            const result = await getCars({ year: this.comboboxes[0].value, Brand: this.comboboxes[1].value, Model: this.comboboxes[2].value });
            
            this.comboboxes[3].options = result.map(make => ({ label: make, value: make }));
            console.log(this.comboboxes[3].options)
        } catch (error) {
            console.error('Error loading makes: ', error);
            this.showToast('Error', 'Error loading makes: ' + error.body.message, 'error'); 
        }
    }
    
    handleMakeChange(event) {
        this.comboboxes[3].value = event.detail.value;
    }

    handleSubmit() {
        this.close({
            year:  this.comboboxes[0].value,
            brand: this.comboboxes[1].value,
            model: this.comboboxes[2].value,
            name: this.comboboxes[3].value
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
