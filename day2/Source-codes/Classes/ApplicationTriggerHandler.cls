public class ApplicationTriggerHandler {

    public static void preventDuplicateApplications(List<Application__c> newApplications) {

        Set<Id> studentIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();

        for (Application__c app : newApplications) {

            if (app.Student__c != null && app.Job__c != null) {
                studentIds.add(app.Student__c);
                jobIds.add(app.Job__c);
            }

        }

        List<Application__c> existingApps = [

            SELECT Student__c, Job__c
            FROM Application__c
            WHERE Student__c IN :studentIds
            AND Job__c IN :jobIds

        ];

        Set<String> existingKeys = new Set<String>();

        for (Application__c app : existingApps) {

            existingKeys.add(app.Student__c + '-' + app.Job__c);

        }

        for (Application__c app : newApplications) {

            String key = app.Student__c + '-' + app.Job__c;

            if (existingKeys.contains(key)) {

                app.addError('Duplicate application is not allowed.');

            }

        }

    }

    public static void validateApplications(List<Application__c> applications){

        ApplicationService.validateApplications(applications);

    }

    public static void updateStudentPlacementStatus(List<Application__c> applications){

        List<Student__c> studentsToUpdate = new List<Student__c>();

        for(Application__c app : applications){

            if(app.Status__c == 'Selected'){

                studentsToUpdate.add(

                    new Student__c(

                        Id = app.Student__c,
                        Placement_Status__c = 'Placed'

                    )

                );

            }

        }

        if(!studentsToUpdate.isEmpty()){

            update studentsToUpdate;

        }

    }

}
