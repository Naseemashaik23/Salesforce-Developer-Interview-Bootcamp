public with sharing class CandidateSyncQueueable
    implements Queueable, Database.AllowsCallouts {

    private Id applicationId;
    private Integer retryCount;

    public CandidateSyncQueueable(Id applicationId) {
        this(applicationId, 0);
    }

    public CandidateSyncQueueable(
        Id applicationId,
        Integer retryCount
    ) {
        this.applicationId = applicationId;
        this.retryCount = retryCount;
    }

    public void execute(QueueableContext context) {

        Application__c application = [
            SELECT Id,
                   Integration_Status__c,
                   External_Candidate_Id__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        // Prevent duplicate integration
        if (
            application.Integration_Status__c == 'Sent' &&
            application.External_Candidate_Id__c != null
        ) {
            System.debug(
                'Candidate already synchronized. Skipping callout.'
            );

            return;
        }

        CandidateCalloutService.sendCandidate(
            applicationId,
            retryCount
        );
    }
}