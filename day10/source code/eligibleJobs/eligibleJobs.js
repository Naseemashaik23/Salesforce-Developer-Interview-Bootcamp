import { LightningElement } from 'lwc';

import getEligibleJobs
    from '@salesforce/apex/EligibleJobsController.getEligibleJobs';

import {
    NavigationMixin
} from 'lightning/navigation';


export default class EligibleJobs
    extends NavigationMixin(LightningElement) {


    // ==========================================================
    // VARIABLES
    // ==========================================================

    jobs = [];

    isLoading = true;

    errorMessage = '';


    // ==========================================================
    // LOAD JOBS WHEN COMPONENT OPENS
    // ==========================================================

    connectedCallback() {

        this.loadJobs();

    }


    // ==========================================================
    // GET ELIGIBLE JOBS FROM APEX
    // ==========================================================

    async loadJobs() {

        this.isLoading = true;

        this.errorMessage = '';


        try {

            const result =
                await getEligibleJobs();


            // ==================================================
            // CONVERT SALESFORCE DATA FOR UI
            // ==================================================

            this.jobs = result.map(job => {

                return {

                    // REAL SALESFORCE JOB ID
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
    // ==========================================================

    handleViewDetails(event) {

        // ======================================================
        // GET JOB ID FROM JOB CARD EVENT
        // ======================================================

        const jobId =
            event.detail.jobId;


        // ======================================================
        // SAFETY CHECK
        // ======================================================

        if (!jobId) {

            this.errorMessage =
                'Unable to identify the selected job.';

            return;

        }


        // ======================================================
        // EXISTING JOB DETAILS NAVIGATION
        // ======================================================

        this[NavigationMixin.Navigate]({

            type: 'standard__component',

            attributes: {

                componentName: 'c__jobDetails'

            },

            state: {

                c__jobId: jobId

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


        return 'Unable to load eligible jobs. Please try again later.';

    }

}
