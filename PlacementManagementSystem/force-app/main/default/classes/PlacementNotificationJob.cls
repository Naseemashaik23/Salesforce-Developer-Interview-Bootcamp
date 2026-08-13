public with sharing class PlacementNotificationJob implements Queueable {

    private Id offerId;

    public PlacementNotificationJob(Id offerId){
        this.offerId = offerId;
    }

    public void execute(QueueableContext context){

        Offer__c offer = [
            SELECT Id,
                   Name
            FROM Offer__c
            WHERE Id = :offerId
            LIMIT 1
        ];

        System.debug('Preparing Notification for Offer: ' + offer.Name);

    }

}