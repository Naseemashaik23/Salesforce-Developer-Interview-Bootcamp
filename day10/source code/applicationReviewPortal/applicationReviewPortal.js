import { LightningElement, wire } from 'lwc';

import getAppliedApplications
    from '@salesforce/apex/ApplicationReviewController.getAppliedApplications';

import getShortlistedApplications
    from '@salesforce/apex/ApplicationReviewController.getShortlistedApplications';

import getRejectedApplications
    from '@salesforce/apex/ApplicationReviewController.getRejectedApplications';

import shortlistApplication
    from '@salesforce/apex/ApplicationReviewController.shortlistApplication';

import rejectApplication
    from '@salesforce/apex/ApplicationReviewController.rejectApplication';

import { refreshApex } from '@salesforce/apex';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const COLUMNS = [

    {
        label: 'Student',
        fieldName: 'studentName'
    },

    {
        label: 'Job',
        fieldName: 'jobName'
    },

    {
        label: 'Company',
        fieldName: 'companyName'
    },

    {
        label: 'Status',
        fieldName: 'Status__c'
    },

    {
        type: 'action',

        typeAttributes: {

            rowActions: [
                {
                    label: 'Shortlist',
                    name: 'shortlist'
                },

                {
                    label: 'Reject',
                    name: 'reject'
                }
            ]

        }
    }

];


export default class ApplicationReviewPortal
    extends LightningElement {


    // ==========================================================
    // VARIABLES
    // ==========================================================

    columns = COLUMNS;

    applications = [];

    shortlistedApplications = [];

    rejectedApplications = [];

    wiredResult;

    isLoading = true;

    errorMessage = '';

    isProcessing = false;


    // ==========================================================
    // LOAD APPLIED APPLICATIONS
    // ==========================================================

    @wire(getAppliedApplications)

    wiredApplications(result) {

        this.wiredResult = result;

        if (result.data) {

            this.applications =
                this.formatApplications(result.data);

            this.errorMessage = '';

            this.isLoading = false;

        }

        else if (result.error) {

            this.applications = [];

            this.errorMessage =
                this.getErrorMessage(result.error);

            this.isLoading = false;

        }

    }


    // ==========================================================
    // LOAD SHORTLISTED APPLICATIONS
    // ==========================================================

    @wire(getShortlistedApplications)

    wiredShortlistedApplications(result) {

        if (result.data) {

            this.shortlistedApplications =
                this.formatApplications(result.data);

        }

    }


    // ==========================================================
    // LOAD REJECTED APPLICATIONS
    // ==========================================================

    @wire(getRejectedApplications)

    wiredRejectedApplications(result) {

        if (result.data) {

            this.rejectedApplications =
                this.formatApplications(result.data);

        }

    }


    // ==========================================================
    // FORMAT APPLICATION DATA
    // ==========================================================

    formatApplications(data) {

        return data.map(row => {

            return {

                Id: row.Id,

                studentName:
                    row.Student__r
                        ? row.Student__r.Name
                        : 'Student Not Available',

                jobName:
                    row.Job__r
                        ? row.Job__r.Name
                        : 'Job Not Available',

                companyName:
                    row.Job__r &&
                    row.Job__r.Company__r
                        ? row.Job__r.Company__r.Name
                        : 'Company Not Available',

                Status__c:
                    row.Status__c

            };

        });

    }


    // ==========================================================
    // SHORTLIST / REJECT
    // ==========================================================

    handleRowAction(event) {

        if (this.isProcessing) {

            return;

        }


        const action =
            event.detail.action.name;

        const row =
            event.detail.row;


        this.isProcessing = true;


        // ======================================================
        // SHORTLIST
        // ======================================================

        if (action === 'shortlist') {

            shortlistApplication({

                applicationId:
                    row.Id

            })

            .then(() => {

                this.showToast(
                    'Success',
                    'Application Shortlisted',
                    'success'
                );

                return this.refreshApplications();

            })

            .catch(error => {

                this.showToast(
                    'Error',
                    this.getErrorMessage(error),
                    'error'
                );

            })

            .finally(() => {

                this.isProcessing = false;

            });

        }


        // ======================================================
        // REJECT
        // ======================================================

        if (action === 'reject') {

            rejectApplication({

                applicationId:
                    row.Id

            })

            .then(() => {

                this.showToast(
                    'Success',
                    'Application Rejected',
                    'success'
                );

                return this.refreshApplications();

            })

            .catch(error => {

                this.showToast(
                    'Error',
                    this.getErrorMessage(error),
                    'error'
                );

            })

            .finally(() => {

                this.isProcessing = false;

            });

        }

    }


    // ==========================================================
    // REFRESH ALL APPLICATION LISTS
    // ==========================================================

    async refreshApplications() {

        await refreshApex(
            this.wiredResult
        );

        // Shortlisted and rejected wired methods
        // automatically refresh when their wire data
        // is re-evaluated.
        //
        // We will improve explicit refresh handling
        // after confirming the current workflow works.

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


        return 'Unable to process the application. Please try again.';

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
