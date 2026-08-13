public with sharing class StudentController {

    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents() {

        return [
            SELECT
                Id,
                Name,
                Roll_Number__c,
                Department__c,
                CGPA__c
            FROM Student__c
            ORDER BY Name
        ];

    }

}