Application__c app = [
    SELECT Id
    FROM Application__c
    WHERE Name = 'APP-0008'
    LIMIT 1
];

Id jobId = System.enqueueJob(
    new CandidateSyncQueueable(app.Id)
);

System.debug('500 Test Queueable Job: ' + jobId);