import { LightningElement } from 'lwc';
import { api,wire, track } from 'lwc';
import ModalComponent from 'c/modalComponent';
export default class ProductComparisonComponent extends LightningElement {
    @track isButton1Visible = true;
    @track isButton2Visible = true;
    @track isButton3Visible = true;
    @track isButton4Visible = true;

    @track product1Info;
    @track product2Info;
    @track product3Info;
    @track product4Info;


    async openModal(event) {
        const buttonId = event.target.dataset.id;

        const result = await ModalComponent.open({
            size: 'small'
        });
        if(!result.cancel){
            const carInfo = {
                year: result.year,
                brand: result.brand,
                model: result.model,
                name: result.name
            };
            if (buttonId === '1') {
                this.product1Info = { ...carInfo };
                this.isButton1Visible = false;
            } else if (buttonId === '2') {
                this.product2Info = { ...carInfo };  
                this.isButton2Visible = false;
            } else if (buttonId === '3') {
                this.product3Info = { ...carInfo };
                this.isButton3Visible = false;
            } else if (buttonId === '4') {
                this.product4Info = { ...carInfo };
                this.isButton4Visible = false;
            }
        }
    }
}