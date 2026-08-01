public with sharing class ApplicationService {

    // ==========================================================
    // Apply for Job
    // ==========================================================
    public static String applyForJob(Application__c application){

        Student__c student = getStudent(application.Student__c);
        Job__c job = getJob(application.Job__c);

        if(checkDuplicate(student.Id, job.Id)){
            return 'You have already applied for this job.';
        }

        String deadlineResult = checkDeadline(job);

        if(deadlineResult != 'SUCCESS'){
            return deadlineResult;
        }

        String eligibilityResult = validateEligibility(student, job);

        if(eligibilityResult != 'SUCCESS'){
            return eligibilityResult;
        }

        saveApplication(application);

        return 'Application Submitted Successfully';
    }

    // ==========================================================
    // Get Student
    // ==========================================================
    private static Student__c getStudent(Id studentId){

        return [
            SELECT Id,
                   CGPA__c,
                   Department__c,
                   Active_Backlogs_c__c,
                   Graduation_Year_c__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];
    }

    // ==========================================================
    // Get Job
    // ==========================================================
    private static Job__c getJob(Id jobId){

        return [
            SELECT Id,
                   Minimum_CGPA__c,
                   Graduation_Year_c__c,
                   Closing_Date__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];
    }

    // ==========================================================
    // Duplicate Validation
    // ==========================================================
    private static Boolean checkDuplicate(Id studentId, Id jobId){

        Integer applicationCount = [
            SELECT COUNT()
            FROM Application__c
            WHERE Student__c = :studentId
            AND Job__c = :jobId
        ];

        return applicationCount > 0;
    }

    // ==========================================================
    // Deadline Validation
    // ==========================================================
    private static String checkDeadline(Job__c job){

        if(Date.today() > job.Closing_Date__c){
            return 'Application Deadline Expired';
        }

        return 'SUCCESS';
    }

    // ==========================================================
    // Eligibility Validation
    // ==========================================================
    private static String validateEligibility(Student__c student, Job__c job){

        if(student.CGPA__c < job.Minimum_CGPA__c){
            return 'CGPA Not Eligible';
        }

        // Active_Backlogs_c__c is a Picklist
        if(student.Active_Backlogs_c__c != '0'){
            return 'Active Backlogs Found';
        }

        // Department validation removed because Job has no Allowed_Department field

        if(student.Graduation_Year_c__c != job.Graduation_Year_c__c){
            return 'Graduation Year Not Eligible';
        }

        return 'SUCCESS';
    }

    // ==========================================================
    // Save Application
    // ==========================================================
    private static void saveApplication(Application__c application){

        insert application;
    }
    // ==========================================================
// Validate Applications (Called from Trigger)
// ==========================================================
public static void validateApplications(List<Application__c> applications){

    for(Application__c application : applications){

        Student__c student = getStudent(application.Student__c);
        Job__c job = getJob(application.Job__c);

        // Duplicate Check
        if(checkDuplicate(student.Id, job.Id)){
            application.addError('You have already applied for this job.');
            continue;
        }

        // Deadline Check
        String deadlineResult = checkDeadline(job);

        if(deadlineResult != 'SUCCESS'){
            application.addError(deadlineResult);
            continue;
        }

        // Eligibility Check
        String eligibilityResult = validateEligibility(student, job);

        if(eligibilityResult != 'SUCCESS'){
            application.addError(eligibilityResult);
        }
    }

}

}
