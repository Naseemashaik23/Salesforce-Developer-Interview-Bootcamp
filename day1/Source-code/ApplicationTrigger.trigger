trigger ApplicationTrigger on Application__c (before insert) {
    ApplicationTriggerHandler.preventDuplicateApplications(Trigger.new);
}
