import { LightningElement, wire } from 'lwc';

import {
    CurrentPageReference,
    NavigationMixin
} from 'lightning/navigation';

import getJobDetails
    from '@salesforce/apex/JobDetailsController.getJobDetails';

import applyForJob
    from '@salesforce/apex/ApplicationController.applyForJob';


export default class JobDetails
    extends NavigationMixin(LightningElement) {


    // ==========================================================
    // VARIABLES
    // ==========================================================

    jobId;

    job;

    isLoading = true;

    errorMessage = '';

    showApplyModal = false;

    applicationSubmitted = false;

    applicationError = '';

    isApplying = false;

    hasApplied = false;


    // ==========================================================
    // GET JOB ID FROM URL
    // ==========================================================

    @wire(CurrentPageReference)
    getPageReference(pageReference) {

        if (pageReference) {

            this.jobId =
                pageReference.state.c__jobId;


            if (this.jobId) {

                this.loadJob();

            }

            else {

                this.isLoading = false;

                this.errorMessage =
                    'Job record could not be identified.';

            }

        }

    }


    // ==========================================================
    // LOAD JOB
    // ==========================================================

    async loadJob() {

        this.isLoading = true;

        this.errorMessage = '';


        try {

            const result =
                await getJobDetails({

                    jobId:
                        this.jobId

                });


            if (!result) {

                this.job = null;

                this.errorMessage =
                    'Job record could not be found.';

                return;

            }


            this.job = {

                id:
                    result.Id,

                companyName:
                    result.Company__r
                        ? result.Company__r.Name
                        : 'Company Not Available',

                jobRole:
                    result.Name,

                packageOffered:
                    result.Package_LPA__c != null
                        ? `₹${result.Package_LPA__c} LPA`
                        : 'Package Not Available',

                location:
                    result.Job_Location__c,

                workMode:
                    result.Mode_of_Work__c,

                bondDetails:
                    result.Bond_Details__c,

                internshipPeriod:
                    result.Internship_Period__c,

                expectedSkills:
                    result.Expected_Skills__c,

                jobDescription:
                    result.Job_Description__c,

                graduationYear:
                    result.Graduation_Year_c__c,

                minimumCGPA:
                    result.Minimum_CGPA__c,

                closingDate:
                    result.Closing_Date__c,

                status:
                    result.Status__c

            };

        }

        catch (error) {

            this.job = null;

            this.errorMessage =
                this.getErrorMessage(error);

        }

        finally {

            this.isLoading = false;

        }

    }


    // ==========================================================
    // APPLY BUTTON LABEL
    // ==========================================================

    get applyButtonLabel() {

        if (this.isApplying) {

            return 'Submitting...';

        }

        return 'Confirm Apply';

    }


    // ==========================================================
    // BACK
    // ==========================================================

    handleBack() {

        window.history.back();

    }


    // ==========================================================
    // OPEN APPLY MODAL
    // ==========================================================

    handleApply() {

        if (this.hasApplied) {

            return;

        }

        this.applicationError = '';

        this.showApplyModal = true;

    }


    // ==========================================================
    // CANCEL
    // ==========================================================

    handleCancel() {

        if (this.isApplying) {

            return;

        }

        this.showApplyModal = false;

        this.applicationError = '';

    }


    // ==========================================================
    // CONFIRM APPLY
    // ==========================================================

    async handleConfirmApply() {

        if (this.isApplying) {

            return;

        }


        if (this.hasApplied) {

            return;

        }


        if (!this.job || !this.job.id) {

            this.applicationError =
                'Job record could not be identified.';

            return;

        }


        this.applicationError = '';

        this.isApplying = true;


        try {

            // ==================================================
            // CALL EXISTING APEX
            // ==================================================

            const result =
                await applyForJob({

                    jobId:
                        this.job.id

                });


            // ==================================================
            // SUCCESS
            // ==================================================

            if (
                result ===
                'Application Submitted Successfully'
            ) {

                this.showApplyModal = false;

                this.applicationSubmitted = true;

                this.hasApplied = true;

            }

            // ==================================================
            // BUSINESS VALIDATION MESSAGE
            // ==================================================

            else {

                this.applicationError =
                    result ||
                    'Application could not be submitted.';

            }

        }

        catch (error) {

            this.applicationError =
                this.getErrorMessage(error);

        }

        finally {

            this.isApplying = false;

        }

    }


    // ==========================================================
    // ERROR MESSAGE
    // ==========================================================

    getErrorMessage(error) {

        // Standard Apex error
        if (
            error &&
            error.body &&
            error.body.message
        ) {

            return error.body.message;

        }


        // Salesforce UI API errors
        if (
            error &&
            error.body &&
            error.body.output
        ) {

            const output =
                error.body.output;


            if (
                output.errors &&
                output.errors.length
            ) {

                return output.errors
                    .map(item => item.message)
                    .join(' ');

            }


            if (output.fieldErrors) {

                const fieldErrors =
                    Object.values(
                        output.fieldErrors
                    ).flat();


                if (fieldErrors.length) {

                    return fieldErrors
                        .map(item => item.message)
                        .join(' ');

                }

            }

        }


        // Array-style errors
        if (
            error &&
            Array.isArray(error.body)
        ) {

            return error.body
                .map(item =>
                    item.message
                        ? item.message
                        : String(item)
                )
                .join(' ');

        }


        return 'Application could not be submitted. Please try again.';

    }


    // ==========================================================
    // CLOSE SUCCESS POPUP
    // ==========================================================

    handleCloseSuccess() {

        this.applicationSubmitted = false;

    }

}