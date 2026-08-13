import { LightningElement, wire } from 'lwc';
import getStudents from '@salesforce/apex/StudentController.getStudents';

export default class StudentList extends LightningElement {
    @wire(getStudents)
    students;
}