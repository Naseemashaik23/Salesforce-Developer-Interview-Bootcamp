public with sharing class StudentProfileController {

    // ==========================================================
    // GET CURRENT LOGGED-IN STUDENT
    // ==========================================================

    @AuraEnabled(cacheable=true)
    public static Student__c getStudentProfile() {

        Id currentUserId = UserInfo.getUserId();


        // ======================================================
        // FIND STUDENT CONNECTED TO CURRENT USER
        // ======================================================

        List<Student__c> students = [

            SELECT
                Id,
                Name,
                Phone__c,
                Email__c,
                Department__c,
                CGPA__c,
                Skills__c,
                Preferred_Location__c,
                Graduation_Year_c__c,
                Student_User__c

            FROM Student__c

            WHERE Student_User__c = :currentUserId

            LIMIT 1

        ];


        // ======================================================
        // NO STUDENT FOUND
        // ======================================================

        if (students.isEmpty()) {

            throw new AuraHandledException(
                'No Student profile is connected to the current user.'
            );

        }


        // ======================================================
        // RETURN STUDENT
        // ======================================================

        return students[0];

    }


    // ==========================================================
    // UPDATE CURRENT LOGGED-IN STUDENT
    // ==========================================================

    @AuraEnabled
    public static Student__c updateStudentProfile(

        String phone,
        String email,
        String department,
        Decimal cgpa,
        String skills,
        String preferredLocation

    ) {


        // ======================================================
        // GET CURRENT USER
        // ======================================================

        Id currentUserId =
            UserInfo.getUserId();


        // ======================================================
        // FIND CURRENT STUDENT
        // ======================================================

        List<Student__c> students = [

            SELECT
                Id,
                Name,
                Phone__c,
                Email__c,
                Department__c,
                CGPA__c,
                Skills__c,
                Preferred_Location__c,
                Student_User__c

            FROM Student__c

            WHERE Student_User__c = :currentUserId

            LIMIT 1

        ];


        // ======================================================
        // STUDENT NOT FOUND
        // ======================================================

        if (students.isEmpty()) {

            throw new AuraHandledException(
                'No Student profile is connected to the current user.'
            );

        }


        Student__c student =
            students[0];


        // ======================================================
        // VALIDATE PHONE
        // ======================================================

        if (String.isBlank(phone)) {

            throw new AuraHandledException(
                'Phone is required.'
            );

        }


        // ======================================================
        // VALIDATE EMAIL
        // ======================================================

        if (String.isBlank(email)) {

            throw new AuraHandledException(
                'Email is required.'
            );

        }


        // ======================================================
        // VALIDATE DEPARTMENT
        // ======================================================

        if (String.isBlank(department)) {

            throw new AuraHandledException(
                'Branch is required.'
            );

        }


        // ======================================================
        // VALIDATE CGPA
        // ======================================================

        if (cgpa == null) {

            throw new AuraHandledException(
                'CGPA is required.'
            );

        }


        if (cgpa < 0 || cgpa > 10) {

            throw new AuraHandledException(
                'CGPA must be between 0 and 10.'
            );

        }


        // ======================================================
        // UPDATE STUDENT
        // ======================================================

        student.Phone__c =
            phone;

        student.Email__c =
            email;

        student.Department__c =
            department;

        student.CGPA__c =
            cgpa;

        student.Skills__c =
            skills;

        student.Preferred_Location__c =
            preferredLocation;


        // ======================================================
        // SAVE
        // ======================================================

        update student;


        // ======================================================
        // RETURN UPDATED RECORD
        // ======================================================

        return student;

    }

}