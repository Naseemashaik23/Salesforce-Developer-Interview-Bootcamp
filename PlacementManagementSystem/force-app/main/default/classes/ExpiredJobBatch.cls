public with sharing class ExpiredJobBatch implements Database.Batchable<SObject> {

    // ==========================================================
    // START
    // ==========================================================
    public Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT Id,
                   Name,
                   Status__c,
                   Closing_Date__c
            FROM Job__c
            WHERE Closing_Date__c < :Date.today()
            AND Status__c = 'Open'
        ]);

    }

    // ==========================================================
    // EXECUTE
    // ==========================================================
    public void execute(
        Database.BatchableContext bc,
        List<Job__c> scope
    ) {

        for(Job__c job : scope){

            job.Status__c = 'Closed';

        }

        update scope;

    }

    // ==========================================================
    // FINISH
    // ==========================================================
    public void finish(Database.BatchableContext bc){

        System.debug('Expired Job Batch Completed Successfully');

    }

}