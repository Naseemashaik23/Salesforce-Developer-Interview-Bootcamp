import { LightningElement, wire } from 'lwc';

import getEligibleJobs
    from '@salesforce/apex/EligibleJobsController.getEligibleJobs';

import applyForJob
    from '@salesforce/apex/ApplicationController.applyForJob';

import {
    NavigationMixin
} from 'lightning/navigation';

import {
    MessageContext,
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE
} from 'lightning/messageService';

import STUDENT_PROFILE_REFRESH
    from '@salesforce/messageChannel/StudentProfileRefresh__c';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';


export default class EligibleJobs
    extends NavigationMixin(LightningElement) {


    // ==========================================================
    // VARIABLES
    // ==========================================================

    jobs = [];

    isLoading = true;

    errorMessage = '';

    subscription = null;

    applyingJobId = null;


    // ==========================================================
    // MESSAGE SERVICE CONTEXT
    // ==========================================================

    @wire(MessageContext)
    messageContext;


    // ==========================================================
    // COMPONENT LOAD
    // ==========================================================

    connectedCallback() {

        this.loadJobs();

        this.subscribeToProfileRefresh();

    }


    // ==========================================================
    // SUBSCRIBE TO STUDENT PROFILE CHANGES
    // ==========================================================

    subscribeToProfileRefresh() {

        if (this.subscription) {

            return;

        }


        this.subscription = subscribe(

            this.messageContext,

            STUDENT_PROFILE_REFRESH,

            () => {

                this.loadJobs();

            },

            {
                scope: APPLICATION_SCOPE
            }

        );

    }


    // ==========================================================
    // UNSUBSCRIBE
    // ==========================================================

    disconnectedCallback() {

        if (this.subscription) {

            unsubscribe(
                this.subscription
            );

            this.subscription = null;

        }

    }


    // ==========================================================
    // LOAD ELIGIBLE JOBS
    // EXISTING WORKING LOGIC
    // ==========================================================

    async loadJobs() {

        this.isLoading = true;

        this.errorMessage = '';


        try {

            const result =
                await getEligibleJobs();


            this.jobs = result.map(job => {

                return {

                    // REAL JOB ID
                    id: job.Id,

                    // COMPANY
                    companyName:
                        job.Company__r
                            ? job.Company__r.Name
                            : 'Company Not Available',

                    // JOB ROLE
                    jobRole:
                        job.Name,

                    // PACKAGE
                    packageOffered:
                        job.Package_LPA__c != null
                            ? `₹${job.Package_LPA__c} LPA`
                            : 'Package Not Available',

                    // LOCATION
                    location:
                        job.Job_Location__c,

                    // GRADUATION YEAR
                    graduationYear:
                        job.Graduation_Year_c__c,

                    // MINIMUM CGPA
                    minimumCGPA:
                        job.Minimum_CGPA__c,

                    // CLOSING DATE
                    closingDate:
                        job.Closing_Date__c,

                    // STATUS
                    status:
                        job.Status__c

                };

            });

        }

        catch (error) {

            this.jobs = [];

            this.errorMessage =
                this.getErrorMessage(error);

        }

        finally {

            this.isLoading = false;

        }

    }


    // ==========================================================
    // VIEW JOB DETAILS
    // EXISTING WORKFLOW
    // ==========================================================

    handleViewDetails(event) {

        const jobId =
            event.detail.jobId;


        if (!jobId) {

            this.errorMessage =
                'Unable to identify the selected job.';

            return;

        }


        this.navigateToJobDetails(jobId);

    }


    // ==========================================================
    // APPLY FOR JOB
    // SPRINT 31
    // ==========================================================

    async handleApplyClicked(event) {

        const jobId =
            event.detail.jobId;


        // ======================================================
        // VALIDATE JOB ID
        // ======================================================

        if (!jobId) {

            this.showToast(
                'Error',
                'Unable to identify the selected job.',
                'error'
            );

            return;

        }


        // ======================================================
        // PREVENT DOUBLE CLICK
        // ======================================================

        if (this.applyingJobId) {

            return;

        }


        this.applyingJobId = jobId;


        try {

            // ==================================================
            // CALL EXISTING APPLICATION CONTROLLER
            // ==================================================

            const result =
                await applyForJob({

                    jobId: jobId

                });


            // ==================================================
            // SHOW RESULT
            // ==================================================

            this.showToast(
                'Success',
                result || 'Application submitted successfully.',
                'success'
            );


            // ==================================================
            // REFRESH ELIGIBLE JOBS
            // ==================================================

            await this.loadJobs();

        }

        catch (error) {

            // ==================================================
            // APPLICATION / BUSINESS ERROR
            // ==================================================

            this.showToast(
                'Error',
                this.getErrorMessage(error),
                'error'
            );

        }

        finally {

            this.applyingJobId = null;

        }

    }


    // ==========================================================
    // UPDATE PROFILE FROM EMPTY STATE
    // SPRINT 30
    // ==========================================================

    handleUpdateProfile() {

        this[NavigationMixin.Navigate]({

            type: 'standard__component',

            attributes: {

                componentName:
                    'c__studentProfile'

            }

        });

    }


    // ==========================================================
    // NAVIGATE TO JOB DETAILS
    // EXISTING WORKING LOGIC
    // ==========================================================

    navigateToJobDetails(jobId) {

        if (!jobId) {

            return;

        }


        this[NavigationMixin.Navigate]({

            type: 'standard__component',

            attributes: {

                componentName:
                    'c__jobDetails'

            },

            state: {

                c__jobId:
                    jobId

            }

        });

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
