import { LightningElement } from 'lwc';

export default class TabNavigationComponent extends LightningElement {
    selectTab(event) {
        const selectedTab = event.target.value;
        const tabChangeEvent = new CustomEvent('selecttab', { detail: selectedTab });
        this.dispatchEvent(tabChangeEvent); 
    }
}