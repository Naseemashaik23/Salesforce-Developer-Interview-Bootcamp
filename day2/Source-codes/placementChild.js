import { LightningElement, api } from 'lwc';

export default class PlacementChild extends LightningElement {

    @api studentId;

    handleClick() {
        const event = new CustomEvent('notify');
        this.dispatchEvent(event);
    }
}
