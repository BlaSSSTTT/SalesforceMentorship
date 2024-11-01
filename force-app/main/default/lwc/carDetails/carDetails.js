import { LightningElement, track, wire} from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import MessageChannel from '@salesforce/messageChannel/MessageChannel__c';

export default class CarDetails extends LightningElement {
    @wire(MessageContext)
        messageContext;
    @track carInfo;
    connectedCallback(){
        this.subscribeToMessageChannel();
    }
 
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            MessageChannel,
            (message) => this.handleMessage(message)
        );
    }
 
    handleMessage(message) {
        this.carInfo ={ ...message};
        console.error(message);
        console.error(this.carInfo);
    }
}