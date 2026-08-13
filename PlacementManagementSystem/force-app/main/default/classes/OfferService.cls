public with sharing class OfferService {

    public static void processAcceptedOffers(
    List<Offer__c> newOffers,
    Map<Id, Offer__c> oldOffers
){

    for(Offer__c offer : newOffers){

        Offer__c oldOffer = oldOffers.get(offer.Id);

        // Status changed to Accepted
        if(
            oldOffer.Offer_Status__c != 'Accepted' &&
            offer.Offer_Status__c == 'Accepted'
        ){

            System.enqueueJob(
                new OfferPostProcessingJob(offer.Id)
            );

        }

    }

}

}