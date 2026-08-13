public with sharing class ApplicationReviewService {

    // ==========================================================
    // Shortlist Application
    // ==========================================================
    public static String shortlistApplication(Id applicationId) {

        Application__c application = [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Status__c = 'Shortlisted';

        update application;

        return 'Application Shortlisted Successfully';
    }

    // ==========================================================
    // Reject Application
    // ==========================================================
    public static String rejectApplication(Id applicationId) {

        Application__c application = [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Status__c = 'Rejected';

        update application;

        return 'Application Rejected Successfully';
    }

}