import { LightningElement, track,wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import getMyVehicle from '@salesforce/apex/SmartCarController.getMyVehicle';

import MessageChannel from '@salesforce/messageChannel/MessageChannel__c';
import SmartCarLocation from 'c/smartCarLocation'; 
export default class CarHeader extends LightningElement {
    @wire(MessageContext)
        messageContext;
    @track vehicle;
    @track error;

    connectedCallback(){
        this.getVeh();       
    }

    async getVeh(){
        try{
            this.vehicle = await getMyVehicle();  
            this.error = null;
            publish(this.messageContext, MessageChannel, this.vehicle);
        }catch(e){
            this.error = e;
            this.vehicle = undefined;
        }
            
    }
    async handleGetLocation(){
        try{
            await SmartCarLocation.open({
            size: 'small',
            id: this.vehicle.id
        });
        }catch(e){
            console.error(e);
        }
        
    }
}