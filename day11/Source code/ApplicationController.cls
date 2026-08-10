public with sharing class ApplicationController {

    // ==========================================================
    // APPLY FOR JOB
    // Student is identified automatically from logged-in User
    // ==========================================================

    @AuraEnabled
    public static String applyForJob(Id jobId) {

        try {

            // ======================================================
            // VALIDATE JOB ID
            // ======================================================

            if (jobId == null) {

                throw new AuraHandledException(
                    'Job record is required.'
                );

            }


            // ======================================================
            // CURRENT USER
            // ======================================================

            Id currentUserId =
                UserInfo.getUserId();


            // ======================================================
            // FIND STUDENT
            // ======================================================

            List<Student__c> students = [

                SELECT Id

                FROM Student__c

                WHERE Student_User__c = :currentUserId

                LIMIT 1

            ];


            if (students.isEmpty()) {

                throw new AuraHandledException(
                    'No Student record is linked to your Salesforce user.'
                );

            }


            // ======================================================
            // GET STUDENT
            // ======================================================

            Student__c student =
                students[0];


            // ======================================================
            // CREATE APPLICATION
            // ======================================================

            Application__c application =
                new Application__c();

            application.Student__c =
                student.Id;

            application.Job__c =
                jobId;


            // ======================================================
            // EXISTING SERVICE
            // ======================================================

            return ApplicationService.applyForJob(
                application
            );

        }

        catch (AuraHandledException error) {

            throw error;

        }

        catch (Exception error) {

            throw new AuraHandledException(
                error.getMessage()
            );

        }

    }

}
