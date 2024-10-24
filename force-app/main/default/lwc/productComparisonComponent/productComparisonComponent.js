import { LightningElement } from 'lwc';
import { api,wire, track } from 'lwc';

export default class ProductComparisonComponent extends LightningElement {
    MAX_PRODUCTS = 4;  
    
    @track selectedArea;

    @track products = [
        {
            id:1            
        }
    ]

    @track showTabs = false;


    

    handleButtonClick(event) {
        this.selectedArea = event.detail;
    }
    handleAddCar(event){
        if(this.products.length < this.MAX_PRODUCTS){
            this.products.push({
                id:this.products[this.products.length-1].id+1
            })
            this.showTabs = true;
        }
    }
    handleRemoveCar(event){
        this.products = this.products.filter(product => product.id != event.detail);
        if(this.products.length==1){
            this.showTabs = false;
        }
    }
}