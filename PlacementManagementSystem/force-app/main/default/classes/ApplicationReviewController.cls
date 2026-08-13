public with sharing class ApplicationReviewController {

    // ==========================================================
    // Get All Applied Applications
    // ==========================================================
    @AuraEnabled(cacheable=true)
    public static List<Application__c> getAppliedApplications(){

        return [
            SELECT Id,
                   Name,
                   Status__c,
                   Student__r.Name,
                   Job__r.Name,
                   Job__r.Company__r.Name
            FROM Application__c
            WHERE Status__c = 'Applied'
            ORDER BY CreatedDate DESC
        ];

    }


    // ==========================================================
    // Get All Shortlisted Applications
    // ==========================================================
    @AuraEnabled(cacheable=true)
    public static List<Application__c> getShortlistedApplications(){

        return [
            SELECT Id,
                   Name,
                   Status__c,
                   Student__r.Name,
                   Job__r.Name,
                   Job__r.Company__r.Name
            FROM Application__c
            WHERE Status__c = 'Shortlisted'
            ORDER BY CreatedDate DESC
        ];

    }


    // ==========================================================
    // Get All Rejected Applications
    // ==========================================================
    @AuraEnabled(cacheable=true)
    public static List<Application__c> getRejectedApplications(){

        return [
            SELECT Id,
                   Name,
                   Status__c,
                   Student__r.Name,
                   Job__r.Name,
                   Job__r.Company__r.Name
            FROM Application__c
            WHERE Status__c = 'Rejected'
            ORDER BY CreatedDate DESC
        ];

    }


    // ==========================================================
    // Shortlist Application
    // ==========================================================
    @AuraEnabled
    public static String shortlistApplication(Id applicationId){

        return ApplicationReviewService.shortlistApplication(applicationId);

    }


    // ==========================================================
    // Reject Application
    // ==========================================================
    @AuraEnabled
    public static String rejectApplication(Id applicationId){

        return ApplicationReviewService.rejectApplication(applicationId);

    }

}