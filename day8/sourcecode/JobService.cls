public with sharing class JobService {

    // ==========================================================
    // Create Job
    // ==========================================================
    public static String createJob(Job__c job){

        String validationResult = validateJob(job);

        if(validationResult != 'SUCCESS'){
            return validationResult;
        }

        saveJob(job);

        return 'Job Created Successfully';
    }

    // ==========================================================
    // Validate Job
    // ==========================================================
    private static String validateJob(Job__c job){

        if(!validateCGPA(job)){
            return 'Minimum CGPA is Invalid';
        }

        if(job.Company__c == null){
            return 'Company Name is Required';
        }

        if(job.Closing_Date__c == null){
            return 'Closing Date is Required';
        }

        // Graduation Year Validation
        if(job.Graduation_Year_c__c == null){
            return 'Graduation Year is Required';
        }

        return 'SUCCESS';
    }

    // ==========================================================
    // Validate Minimum CGPA
    // ==========================================================
    private static Boolean validateCGPA(Job__c job){

        if(job.Minimum_CGPA__c == null){
            return false;
        }

        return job.Minimum_CGPA__c >= 0 && job.Minimum_CGPA__c <= 10;
    }

    // ==========================================================
    // Save Job
    // ==========================================================
    private static void saveJob(Job__c job){

        insert job;
    }

    // ==========================================================
    // Update Job Eligibility
    // ==========================================================
    public static String updateEligibility(Job__c job){

        update job;

        return 'Job Eligibility Updated Successfully';
    }

    // ==========================================================
    // Publish Job
    // ==========================================================
    public static String publishJob(Id jobId){

        Job__c job = [
            SELECT Id, Status__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];

        job.Status__c = 'Published';

        update job;

        return 'Job Published Successfully';
    }

    // ==========================================================
    // Close Expired Job
    // ==========================================================
    public static String closeExpiredJob(Id jobId){

        Job__c job = [
            SELECT Id,
                   Closing_Date__c,
                   Status__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];

        if(Date.today() > job.Closing_Date__c){

            job.Status__c = 'Closed';

            update job;

            return 'Job Closed Successfully';
        }

        return 'Job is Still Active';
    }

}
