public with sharing class StatisticsService {

    public static void updatePlacementStatistics(

        List<Application__c> applications,
        Map<Id, Application__c> oldMap

    ){

        for(Application__c app : applications){

            Application__c oldApp = oldMap.get(app.Id);

            if(
                app.Status__c == 'Selected' &&
                oldApp.Status__c != 'Selected'
            ){

                System.debug(
                    'Placement Statistics Updated'
                );

            }

        }

    }

}