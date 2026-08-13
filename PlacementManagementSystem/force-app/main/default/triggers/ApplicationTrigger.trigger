trigger ApplicationTrigger on Application__c (before insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {

        ApplicationTriggerHandler.validateApplications(
            Trigger.new
        );

    }

    if (Trigger.isAfter && Trigger.isUpdate) {

        // Existing workflow - DO NOT CHANGE
        ApplicationTriggerHandler.updateStudentPlacementStatus(
            Trigger.new,
            Trigger.oldMap
        );

        // Existing workflow - DO NOT CHANGE
        ApplicationTriggerHandler.updatePlacementStatistics(
            Trigger.new,
            Trigger.oldMap
        );

        // New integration workflow
        for (Application__c app : Trigger.new) {

            Application__c oldApp =
                Trigger.oldMap.get(app.Id);

            // Run only when Status changes to Selected
            if (
                app.Status__c == 'Selected' &&
                oldApp.Status__c != 'Selected'
            ) {

                System.enqueueJob(
                    new CandidateSyncQueueable(app.Id)
                );

            }
        }
    }
}