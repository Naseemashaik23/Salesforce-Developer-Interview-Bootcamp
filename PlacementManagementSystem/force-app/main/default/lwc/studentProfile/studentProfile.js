import { LightningElement, wire } from 'lwc';

import getStudentProfile
    from '@salesforce/apex/StudentProfileController.getStudentProfile';

import updateStudentProfile
    from '@salesforce/apex/StudentProfileController.updateStudentProfile';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

import {
    MessageContext,
    publish
} from 'lightning/messageService';

import STUDENT_PROFILE_REFRESH
    from '@salesforce/messageChannel/StudentProfileRefresh__c';


export default class StudentProfile extends LightningElement {


    // ==========================================================
    // VARIABLES
    // ==========================================================

    student = null;

    originalStudent = null;

    isLoading = true;

    isSaving = false;

    errorMessage = '';


    // ==========================================================
    // LIGHTNING MESSAGE SERVICE
    // ==========================================================

    @wire(MessageContext)
    messageContext;


    // ==========================================================
    // BRANCH OPTIONS
    // ==========================================================

    departmentOptions = [

        {
            label: 'CSE',
            value: 'CSE'
        },

        {
            label: 'ECE',
            value: 'ECE'
        },

        {
            label: 'EEE',
            value: 'EEE'
        },

        {
            label: 'MECH',
            value: 'MECH'
        },

        {
            label: 'CIVIL',
            value: 'CIVIL'
        }

    ];


    // ==========================================================
    // COMPONENT LOAD
    // ==========================================================

    connectedCallback() {

        this.loadStudent();

    }


    // ==========================================================
    // LOAD CURRENT STUDENT
    // ==========================================================

    async loadStudent() {

        this.isLoading = true;

        this.errorMessage = '';


        try {

            const result =
                await getStudentProfile();


            // Create separate objects so Cancel can restore
            // the original values.

            this.student = {
                ...result
            };

            this.originalStudent = {
                ...result
            };

        }

        catch (error) {

            this.student = null;

            this.originalStudent = null;

            this.errorMessage =
                this.getErrorMessage(error);

        }

        finally {

            this.isLoading = false;

        }

    }


    // ==========================================================
    // SAVE BUTTON LABEL
    // ==========================================================

    get saveButtonLabel() {

        if (this.isSaving) {

            return 'Saving...';

        }

        return 'Save Profile';

    }


    // ==========================================================
    // HANDLE FIELD CHANGE
    // ==========================================================

    handleChange(event) {

        const fieldName =
            event.target.name;

        let fieldValue =
            event.target.value;


        // CGPA should be sent as a number to Apex.

        if (fieldName === 'CGPA__c') {

            fieldValue =
                fieldValue === ''
                    ? null
                    : Number(fieldValue);

        }


        if (!this.student) {

            return;

        }


        this.student = {

            ...this.student,

            [fieldName]: fieldValue

        };

    }


    // ==========================================================
    // CANCEL
    // ==========================================================

    handleCancel() {

        if (this.isSaving) {

            return;

        }


        if (this.originalStudent) {

            this.student = {
                ...this.originalStudent
            };

        }

    }


    // ==========================================================
    // SAVE PROFILE
    // ==========================================================

    async handleSave() {

        // ======================================================
        // CLIENT-SIDE VALIDATION
        // ======================================================

        const inputs =
            this.template.querySelectorAll(
                'lightning-input, lightning-combobox, lightning-textarea'
            );


        let isValid = true;


        inputs.forEach(input => {

            if (!input.reportValidity()) {

                isValid = false;

            }

        });


        if (!isValid) {

            return;

        }


        // ======================================================
        // EXTRA CGPA VALIDATION
        // ======================================================

        if (
            this.student.CGPA__c == null ||
            this.student.CGPA__c < 0 ||
            this.student.CGPA__c > 10
        ) {

            this.showToast(
                'Error',
                'CGPA must be between 0 and 10.',
                'error'
            );

            return;

        }


        this.isSaving = true;

        this.errorMessage = '';


        try {

            // ==================================================
            // CALL APEX
            // ==================================================

            const result =
                await updateStudentProfile({

                    phone:
                        this.student.Phone__c,

                    email:
                        this.student.Email__c,

                    department:
                        this.student.Department__c,

                    cgpa:
                        this.student.CGPA__c,

                    skills:
                        this.student.Skills__c,

                    preferredLocation:
                        this.student.Preferred_Location__c

                });


            // ==================================================
            // UPDATE UI WITH SAVED DATA
            // ==================================================

            this.student = {
                ...result
            };

            this.originalStudent = {
                ...result
            };


            // ==================================================
            // SUCCESS TOAST
            // ==================================================

            this.showToast(
                'Success',
                'Student profile updated successfully.',
                'success'
            );


            // ==================================================
            // NOTIFY OTHER COMPONENTS
            // ==================================================
            // EligibleJobs listens to this message.
            // When the profile changes, EligibleJobs
            // reloads the eligible jobs.

            publish(
                this.messageContext,
                STUDENT_PROFILE_REFRESH,
                {
                    refresh: true
                }
            );

        }

        catch (error) {

            this.showToast(
                'Error',
                this.getErrorMessage(error),
                'error'
            );

        }

        finally {

            this.isSaving = false;

        }

    }


    // ==========================================================
    // ERROR MESSAGE
    // ==========================================================

    getErrorMessage(error) {

        if (
            error &&
            error.body &&
            error.body.message
        ) {

            return error.body.message;

        }


        return 'Unable to update student profile. Please try again.';

    }


    // ==========================================================
    // TOAST
    // ==========================================================

    showToast(
        title,
        message,
        variant
    ) {

        this.dispatchEvent(

            new ShowToastEvent({

                title,

                message,

                variant

            })

        );

    }

}