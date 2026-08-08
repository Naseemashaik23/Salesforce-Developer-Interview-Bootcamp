public with sharing class ApplicationController {

    // ==========================================================
    // Apply for Job
    // Student is identified automatically from logged-in User
    // ==========================================================
    @AuraEnabled
    public static String applyForJob(Id jobId) {

        // ======================================================
        // Validate Job ID
        // ======================================================

        if (jobId == null) {

            return 'Job record is required.';

        }


        // ======================================================
        // Get Current Salesforce User
        // ======================================================

        Id currentUserId = UserInfo.getUserId();


        // ======================================================
        // Find Student belonging to Current User
        // ======================================================

        List<Student__c> students = [

            SELECT Id

            FROM Student__c

            WHERE Student_User__c = :currentUserId

            LIMIT 1

        ];


        // ======================================================
        // Student Not Found
        // ======================================================

        if (students.isEmpty()) {

            return 'No Student record is linked to your Salesforce user.';

        }


        // ======================================================
        // Get Student
        // ======================================================

        Student__c student = students[0];


        // ======================================================
        // Create Application
        // ======================================================

        Application__c application =
            new Application__c();


        application.Student__c =
            student.Id;


        application.Job__c =
            jobId;


        // ======================================================
        // SEND TO SERVICE CLASS
        //
        // All business rules remain inside ApplicationService.
        // ======================================================

        return ApplicationService.applyForJob(
            application
        );

    }

}
