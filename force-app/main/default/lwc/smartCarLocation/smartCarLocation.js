import { LightningElement, track, api } from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCarLocation from '@salesforce/apex/SmartCarController.getCarLocation';
export default class SmartCarLocation extends LightningModal  {
    @api id;
    @track showMap = false;
    mapMarkers = [];
    async connectedCallback() {
        try {
            let location = await getCarLocation({
                id: this.id
            });
    
            if (location && location.latitude && location.longitude) {
                this.mapMarkers = [
                    {
                        location: {
                            Latitude: location.latitude,
                            Longitude: location.longitude
                        },
                        title: 'Car Location',
                        description: 'The current location of the car'
                    }
                ];
                this.showMap = true;
            } else {
                console.error('Location data is incomplete or missing.');
            }
        } catch (error) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'success'
            });
            this.dispatchEvent(event); 
            console.error('Error fetching location:', error);
        }
    }
    
    handleOkay(){
        this.close();
    }
}