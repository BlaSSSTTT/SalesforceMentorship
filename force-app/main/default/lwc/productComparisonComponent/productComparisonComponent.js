import { LightningElement } from 'lwc';
import { api,wire, track } from 'lwc';

export default class ProductComparisonComponent extends LightningElement {
    @track showTabs = true;
    @track selectedArea;


    @track products = [
        {
            product_info:{},
            id:1            
        },
        {
            product_info:{},
            id:2
        },
        {
            product_info:{},
            id:3
        },
        {
            product_info:{},
            id:4
        }
    ]

    handleButtonClick(event) {
        this.selectedArea = event.detail;
    }

    
}