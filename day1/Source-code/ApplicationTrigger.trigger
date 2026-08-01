trigger ApplicationTrigger on Application__c (before insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ApplicationTriggerHandler.preventDuplicateApplications(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        ApplicationTriggerHandler.updateStudentPlacementStatus(Trigger.new);
    }

}
