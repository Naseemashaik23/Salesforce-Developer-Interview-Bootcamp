import { LightningElement } from 'lwc';

export default class PlacementHome extends LightningElement {

    studentName = 'Naseema';
    rollNumber = '23pa1a05m4';
    department = 'CSE';

    welcomeMessage = '';

    status = 'Not Applied';

    todayDate = '31 July 2026';
    companies = 25;
    jobs = 63;
    applications = 5;

    showMessage() {
        this.welcomeMessage = 'Welcome to Salesforce Development.';
    }

    changeStatus() {
        this.status = 'Applied';
    }
}
