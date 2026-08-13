trigger OfferTrigger on Offer__c (after update) {

    if(Trigger.isAfter && Trigger.isUpdate){
        OfferTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }

}