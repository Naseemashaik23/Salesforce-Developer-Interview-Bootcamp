public with sharing class ApplicationService {

    // ==========================================================
    // Apply for Job (Used by UI / Controller)
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

        insert application;

        return 'Application Submitted Successfully';
    }

    // ==========================================================
    // Trigger Validation
    // ==========================================================
    public static void validateApplications(List<Application__c> applications){
    validateApplicationsBulk(applications);
}

    // ==========================================================
    // Get Student
    // ==========================================================
    private static Student__c getStudent(Id studentId){

        return [
            SELECT Id,
                   CGPA__c,
                   Department__c,
                   Backlogs__c,
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

        // CGPA
        if(student.CGPA__c < job.Minimum_CGPA__c){
            return 'CGPA Not Eligible';
        }

        // Backlogs (Checkbox)
        if(student.Backlogs__c){
            return 'Active Backlogs Found';
        }

        // Graduation Year
        if(student.Graduation_Year_c__c != job.Graduation_Year_c__c){
            return 'Graduation Year Not Eligible';
        }

        return 'SUCCESS';

    }
    // ==========================================================
// Bulk Duplicate Validation
// ==========================================================
private static Set<String> getExistingApplications(
    Set<Id> studentIds,
    Set<Id> jobIds
){

    Set<String> existingApplications = new Set<String>();

    for(Application__c app : [

        SELECT Student__c,
               Job__c
        FROM Application__c
        WHERE Student__c IN :studentIds
        AND Job__c IN :jobIds

    ]){

        String key =
            String.valueOf(app.Student__c) + '-' +
            String.valueOf(app.Job__c);

        existingApplications.add(key);

    }

    return existingApplications;

}
    // ==========================================================
// Bulk Trigger Validation
// ==========================================================
public static void validateApplicationsBulk(List<Application__c> applications) {

    // Collect Student Ids and Job Ids
    Set<Id> studentIds = new Set<Id>();
    Set<Id> jobIds = new Set<Id>();

    for (Application__c app : applications) {
        if (app.Student__c != null) {
            studentIds.add(app.Student__c);
        }

        if (app.Job__c != null) {
            jobIds.add(app.Job__c);
        }
    }

    // Query Students Once
    Map<Id, Student__c> students = new Map<Id, Student__c>(
        [SELECT Id,
                CGPA__c,
                Department__c,
                Backlogs__c,
                Graduation_Year_c__c
         FROM Student__c
         WHERE Id IN :studentIds]
    );

    // Query Jobs Once
    Map<Id, Job__c> jobs = new Map<Id, Job__c>(
        [SELECT Id,
                Minimum_CGPA__c,
                Graduation_Year_c__c,
                Closing_Date__c
         FROM Job__c
         WHERE Id IN :jobIds]
    );
    Set<String> existingApplications =
    getExistingApplications(studentIds, jobIds);

    // Process all Applications in memory
    for (Application__c app : applications) {

        Student__c student = students.get(app.Student__c);
        Job__c job = jobs.get(app.Job__c);

        if (student == null || job == null) {
            continue;
        }
        String key =
    String.valueOf(app.Student__c) + '-' +
    String.valueOf(app.Job__c);

if(existingApplications.contains(key)){
    app.addError('You have already applied for this job.');
    continue;
}

        // Deadline Validation
        if (Date.today() > job.Closing_Date__c) {
            app.addError('Application Deadline Expired');
            continue;
        }

        // CGPA Validation
        if (student.CGPA__c < job.Minimum_CGPA__c) {
            app.addError('CGPA Not Eligible');
        }

        // Backlog Validation
        if (student.Backlogs__c) {
            app.addError('Active Backlogs Found');
        }

        // Graduation Year Validation
        if (student.Graduation_Year_c__c != job.Graduation_Year_c__c) {
            app.addError('Graduation Year Not Eligible');
        }
    }
}


}  
