trigger ApplicationTrigger on Application__c (before insert) {

    ApplicationService.validateApplications(Trigger.new);

}
