import { LightningElement } from 'lwc';
import { api,wire, track } from 'lwc';

export default class ProductComparisonComponent extends LightningElement {
    MAX_PRODUCTS = 4;  
    
    @track selectedArea;

    @track products = [
        {
            id:1,
            haveContent:false
        }
    ]

    @track showTabs = false;


    
    checkTabs(){
        for(let i=0; i<this.products.length; i++){
            if(this.products[i].haveContent){
                this.showTabs = true;
                return;
            }
        }
        this.showTabs = false;
    }
    filterProducts(){
       this.products = this.products.filter(product => product.haveContent);
       if(this.products.length != this.MAX_PRODUCTS){
            
            this.products.push({
                id: this.products.length !=0 ? this.products[this.products.length-1].id + 1 : 1,
                haveContent:false
            })
       }
    }
    handleButtonClick(event) {
        this.selectedArea = event.detail;
    }
    handleAddCar(event){
        if(this.products.length < this.MAX_PRODUCTS){
            this.products.push({
                id:this.products[this.products.length-1].id+1,
                haveContent:false
            })
        }
        const car = this.products.filter(car => car.id == event.detail)[0];
        car.haveContent = true;
        this.checkTabs();
        this.filterProducts();
    }
    handleRemoveCar(event){      
        const car = this.products.filter(car => car.id == event.detail)[0];
        car.haveContent = false;
        this.checkTabs();
        this.filterProducts();
    }
}