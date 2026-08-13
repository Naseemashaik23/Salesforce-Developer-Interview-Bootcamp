public with sharing class JobDetailsController {

    @AuraEnabled(cacheable=true)
    public static Job__c getJobDetails(Id jobId) {

        if (jobId == null) {
            return null;
        }

        return [
            SELECT Id,
                   Name,
                   Company__c,
                   Company__r.Name,
                   Closing_Date__c,
                   Graduation_Year_c__c,
                   Job_Location__c,
                   Minimum_CGPA__c,
                   Package_LPA__c,
                   Status__c,
                   Job_Description__c,
                   Mode_of_Work__c,
                   Bond_Details__c,
                   Internship_Period__c,
                   Expected_Skills__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];
    }

}