public with sharing class ApplicationTriggerHandler {

    // ==========================================================
    // Validate Applications
    // ==========================================================
    public static void validateApplications(List<Application__c> applications){

        ApplicationService.validateApplications(applications);

    }

    // ==========================================================
    // Update Student Placement Status
    // ==========================================================
    public static void updateStudentPlacementStatus(

        List<Application__c> applications,
        Map<Id, Application__c> oldMap

    ) {

        List<Student__c> studentsToUpdate = new List<Student__c>();

        for (Application__c app : applications) {

            Application__c oldApp = oldMap.get(app.Id);

            if (
                app.Status__c == 'Selected' &&
                oldApp.Status__c != 'Selected'
            ) {

                studentsToUpdate.add(

                    new Student__c(

                        Id = app.Student__c,
                        Placement_Status__c = 'Placed'

                    )

                );

            }

        }

        if (!studentsToUpdate.isEmpty()) {

            update studentsToUpdate;

        }

    }

    // ==========================================================
    // Update Placement Statistics
    // ==========================================================
    public static void updatePlacementStatistics(

        List<Application__c> applications,
        Map<Id, Application__c> oldMap

    ) {

        StatisticsService.updatePlacementStatistics(
            applications,
            oldMap
        );

    }

}