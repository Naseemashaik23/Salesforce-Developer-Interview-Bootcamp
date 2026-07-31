import { LightningElement } from 'lwc';

export default class PlacementParent extends LightningElement {

    studentId = '';
    message = 'Waiting for Student Action...';

    handleChange(event) {
        this.studentId = event.target.value;
    }

    handleNotify() {
        alert('Parent Received Event');
        this.message = 'Application Submitted Successfully!';
    }
}
