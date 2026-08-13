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

import scheduleInterview
    from '@salesforce/apex/InterviewController.scheduleInterview';

import { refreshApex } from '@salesforce/apex';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';


// ==========================================================
// PENDING APPLICATION COLUMNS
// EXISTING WORKFLOW - DO NOT CHANGE
// ==========================================================

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


// ==========================================================
// SHORTLISTED APPLICATION COLUMNS
// NEW - ONLY SCHEDULE INTERVIEW
// ==========================================================

const SHORTLISTED_COLUMNS = [

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
                    label: 'Schedule Interview',
                    name: 'scheduleInterview'
                }

            ]

        }

    }

];


// ==========================================================
// REJECTED APPLICATION COLUMNS
// ==========================================================

const REJECTED_COLUMNS = [

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
    }

];


export default class ApplicationReviewPortal
    extends LightningElement {


    // ==========================================================
    // VARIABLES
    // ==========================================================

    columns = COLUMNS;

    shortlistedColumns = SHORTLISTED_COLUMNS;

    rejectedColumns = REJECTED_COLUMNS;


    applications = [];

    shortlistedApplications = [];

    rejectedApplications = [];


    // ==========================================================
    // WIRED RESULTS
    // ==========================================================

    wiredResult;

    wiredShortlistedResult;

    wiredRejectedResult;


    // ==========================================================
    // STATE
    // ==========================================================

    isLoading = true;

    errorMessage = '';

    isProcessing = false;


    // ==========================================================
    // INTERVIEW MODAL
    // ==========================================================

    showInterviewModal = false;

    selectedApplicationId = '';

    selectedStudentName = '';

    selectedJobName = '';

    selectedCompanyName = '';


    // ==========================================================
    // LOAD APPLIED APPLICATIONS
    // EXISTING WORKFLOW
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

        this.wiredShortlistedResult = result;

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

        this.wiredRejectedResult = result;

        if (result.data) {

            this.rejectedApplications =
                this.formatApplications(result.data);

        }

    }


    // ==========================================================
    // FORMAT APPLICATION DATA
    // EXISTING LOGIC
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
    // HANDLE ROW ACTION
    // ==========================================================

    handleRowAction(event) {

        if (this.isProcessing) {

            return;

        }


        const action =
            event.detail.action.name;

        const row =
            event.detail.row;


        // ======================================================
        // NEW: SCHEDULE INTERVIEW
        // ======================================================

        if (action === 'scheduleInterview') {

            this.openInterviewModal(row);

            return;

        }


        // ======================================================
        // EXISTING SHORTLIST / REJECT WORKFLOW
        // ======================================================

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
    // OPEN INTERVIEW MODAL
    // ==========================================================

    openInterviewModal(row) {

        this.selectedApplicationId =
            row.Id;

        this.selectedStudentName =
            row.studentName;

        this.selectedJobName =
            row.jobName;

        this.selectedCompanyName =
            row.companyName;

        this.showInterviewModal = true;

    }


    // ==========================================================
    // CLOSE INTERVIEW MODAL
    // ==========================================================

    handleCloseInterviewModal() {

        if (this.isProcessing) {

            return;

        }

        this.showInterviewModal = false;

        this.selectedApplicationId = '';

        this.selectedStudentName = '';

        this.selectedJobName = '';

        this.selectedCompanyName = '';

    }


    // ==========================================================
    // SUBMIT INTERVIEW FORM
    // ==========================================================

    handleInterviewSubmit(event) {

        event.preventDefault();


        if (this.isProcessing) {

            return;

        }


        const fields =
            event.detail.fields;


        this.isProcessing = true;


        // ======================================================
        // CALL INTERVIEW CONTROLLER
        // ======================================================

        scheduleInterview({

            applicationId:
                this.selectedApplicationId,

            interviewDate:
                fields.Interview_Date__c,

            interviewTime:
                fields.Interview_Time__c,

            interviewMode:
                fields.Interview_Mode__c,

            interviewRound:
                fields.Interview_Round__c,

            interviewer:
                fields.Interviewer__c

        })

        .then(result => {

            // ==================================================
            // SUCCESS
            // ==================================================

            if (
                result ===
                'Interview Scheduled Successfully'
            ) {

                this.showToast(
                    'Success',
                    'Interview scheduled successfully.',
                    'success'
                );


                this.showInterviewModal = false;


                this.resetInterviewFields();


                // Refresh shortlisted section

                if (this.wiredShortlistedResult) {

                    return refreshApex(
                        this.wiredShortlistedResult
                    );

                }

                return null;

            }


            // ==================================================
            // BUSINESS ERROR
            // ==================================================

            this.showToast(
                'Error',
                result,
                'error'
            );

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


    // ==========================================================
    // RESET INTERVIEW DATA
    // ==========================================================

    resetInterviewFields() {

        this.selectedApplicationId = '';

        this.selectedStudentName = '';

        this.selectedJobName = '';

        this.selectedCompanyName = '';

    }


    // ==========================================================
    // REFRESH ALL APPLICATION LISTS
    // EXISTING WORKFLOW IMPROVED ONLY FOR REFRESH
    // ==========================================================

    async refreshApplications() {

        const refreshPromises = [];


        if (this.wiredResult) {

            refreshPromises.push(
                refreshApex(this.wiredResult)
            );

        }


        if (this.wiredShortlistedResult) {

            refreshPromises.push(
                refreshApex(this.wiredShortlistedResult)
            );

        }


        if (this.wiredRejectedResult) {

            refreshPromises.push(
                refreshApex(this.wiredRejectedResult)
            );

        }


        await Promise.all(refreshPromises);

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