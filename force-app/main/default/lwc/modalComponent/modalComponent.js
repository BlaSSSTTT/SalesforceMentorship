import { LightningElement, track } from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
import getYears from '@salesforce/apex/CarController.getYears';
import getBrands from '@salesforce/apex/CarController.getBrands';
import getModels from '@salesforce/apex/CarController.getModels';
import getCars from '@salesforce/apex/CarController.getCars';

export default class ModalComponent extends LightningModal {
    @track disableButton = true;
    @track comboboxes =[
        {
            id:1,
            label:"Select Car Year",
            placeholder:"Select Year",
            value:null,
            options:[],
            onchange:this.handleYearChange,
            isDisabled:false
        },
        {
            id:2,
            label:"Select Car Brand",
            placeholder:"Select Brand",
            value:null,
            options:[],
            onchange:this.handleBrandChange,
            isDisabled:true
        },
        {
            id:3,
            label:"Select Car Model",
            placeholder:"Select Model",
            value:null,
            options:[],
            onchange:this.handleModelChange,
            isDisabled:true
        },
        {
            id:4,
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
        let id = event.target.dataset.id;   
        this.disableButton = true;   
        this.comboboxes[id-1].value = Number(event.detail.value);
        this.comboboxes[id].isDisabled = false; 
        for(let i=id+1;i<this.comboboxes.length;i++){
            this.comboboxes[i].isDisabled = true;
            this.comboboxes[i].value = null;
            this.comboboxes[i].options = [];
        }
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
        let id = event.target.dataset.id;
        this.disableButton = true;
        this.comboboxes[id-1].value = event.detail.value;
        this.comboboxes[id].isDisabled = false; 
        for(let i=id+1;i<this.comboboxes.length;i++){
            this.comboboxes[i].isDisabled = true;
            this.comboboxes[i].value = null;
            this.comboboxes[i].options = [];
        }
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
        let id = event.target.dataset.id;
        this.disableButton = true;
        this.comboboxes[id-1].value = event.detail.value;
        this.comboboxes[id].isDisabled = false; 
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
        let id = event.target.dataset.id;
        this.disableButton = false;
        this.comboboxes[id-1].value = event.detail.value;
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
