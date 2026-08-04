public class ApplicationService {
    public static void validateApplications(List<Application__c> newApplications) {

    for (Application__c app : newApplications) {

        // Check duplicate application
        List<Application__c> existingApps = [
            SELECT Id
            FROM Application__c
            WHERE Student__c = :app.Student__c
            AND Job__c = :app.Job__c
        ];

        if (!existingApps.isEmpty()) {
            app.addError('Duplicate application is not allowed.');
            continue;
        }

        // Get Student
        Student__c student = [
            SELECT CGPA__c
            FROM Student__c
            WHERE Id = :app.Student__c
            LIMIT 1
        ];

        // Get Job
        Job__c job = [
            SELECT Minimum_CGPA__c
            FROM Job__c
            WHERE Id = :app.Job__c
            LIMIT 1
        ];

        // Validate CGPA
        if (student.CGPA__c < job.Minimum_CGPA__c) {
            app.addError('Student is not eligible due to low CGPA.');
        }
    }
}

    public static String submitApplication(Id studentId, Id jobId) {

        // Retrieve Student
        Student__c student = [
            SELECT Id, Name, CGPA__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];

        // Retrieve Job
        Job__c job = [
            SELECT Id, Name, Minimum_CGPA__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];

        // Check Duplicate Application
        List<Application__c> applications = [
            SELECT Id
            FROM Application__c
            WHERE Student__c = :studentId
            AND Job__c = :jobId
        ];

        if (!applications.isEmpty()) {
            return 'Duplicate application is not allowed.';
        }

        // Validate Eligibility
        if (student.CGPA__c < job.Minimum_CGPA__c) {
            return 'Student is not eligible due to low CGPA.';
        }

        // Create Application
        Application__c application = new Application__c();

        application.Student__c = studentId;
        application.Job__c = jobId;
        application.Status__c = 'Applied';
        application.Application_Date__c = Date.today();

        insert application;

        return 'Application submitted successfully.';
    }
}
