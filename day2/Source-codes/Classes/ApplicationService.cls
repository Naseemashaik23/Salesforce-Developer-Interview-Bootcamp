public with sharing class ApplicationService {

    public static void validateApplications(List<Application__c> applications){

        Set<Id> studentIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();

        for(Application__c app : applications){

            if(app.Student__c != null)
                studentIds.add(app.Student__c);

            if(app.Job__c != null)
                jobIds.add(app.Job__c);

        }

        Map<Id, Student__c> studentMap = new Map<Id, Student__c>(

            [

                SELECT Id,
                       CGPA__c

                FROM Student__c

                WHERE Id IN :studentIds

            ]

        );

        Map<Id, Job__c> jobMap = new Map<Id, Job__c>(

            [

                SELECT Id,
                       Minimum_CGPA__c,
                       Closing_Date__c

                FROM Job__c

                WHERE Id IN :jobIds

            ]

        );

        for(Application__c app : applications){

            Student__c student = studentMap.get(app.Student__c);

            Job__c job = jobMap.get(app.Job__c);

            if(student == null){

                app.addError('Please select a valid Student.');

                continue;

            }

            if(job == null){

                app.addError('Please select a valid Job.');

                continue;

            }

            // CGPA Validation
            if(student.CGPA__c < job.Minimum_CGPA__c){

                app.addError('Student CGPA is below the minimum CGPA required.');

            }

            // Closing Date Validation
            if(job.Closing_Date__c != null &&
               Date.today() > job.Closing_Date__c){

                app.addError('Application deadline has passed.');

            }

            // Default Status
            app.Status__c = 'Applied';

        }

    }

}
