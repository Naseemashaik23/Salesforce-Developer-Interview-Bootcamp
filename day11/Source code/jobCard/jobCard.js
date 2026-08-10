import { LightningElement, api } from 'lwc';


export default class JobCard extends LightningElement {


    // ==========================================================
    // JOB DATA FROM PARENT
    // ==========================================================

    @api job;


    // ==========================================================
    // CHECK WHETHER JOB DATA IS AVAILABLE
    // ==========================================================

    get hasJob() {

        return !!(
            this.job &&
            this.job.id
        );

    }


    // ==========================================================
    // VIEW DETAILS
    // EXISTING WORKING WORKFLOW
    // ==========================================================

    handleViewDetails() {

        if (!this.hasJob) {

            return;

        }


        this.dispatchEvent(

            new CustomEvent(
                'viewdetails',
                {
                    detail: {
                        jobId: this.job.id
                    }
                }
            )

        );

    }


    // ==========================================================
    // APPLY
    // CHILD → PARENT COMMUNICATION
    // ==========================================================

    handleApply() {

        if (!this.hasJob) {

            return;

        }


        this.dispatchEvent(

            new CustomEvent(
                'applyclicked',
                {
                    detail: {
                        jobId: this.job.id
                    }
                }
            )

        );

    }

}
