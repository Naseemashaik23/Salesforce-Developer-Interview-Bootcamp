public with sharing class OfferTriggerHandler {

    public static void afterUpdate(
        List<Offer__c> newOffers,
        Map<Id, Offer__c> oldOffers
    ){

        OfferService.processAcceptedOffers(newOffers, oldOffers);

    }

}