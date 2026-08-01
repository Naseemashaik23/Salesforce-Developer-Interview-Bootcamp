public with sharing class StudentService {

    // ==========================================================
    // Register Student
    // ==========================================================
    public static String registerStudent(Student__c student){

        String validationResult = validateStudent(student);

        if(validationResult != 'SUCCESS'){
            return validationResult;
        }

        saveStudent(student);

        return 'Student Registered Successfully';
    }

    // ==========================================================
    // Validate Student
    // ==========================================================
    private static String validateStudent(Student__c student){

        if(!validateCGPA(student)){
            return 'Invalid CGPA';
        }

        if(!validateBacklogs(student)){
            return 'Active Backlogs Found';
        }

        if(student.Department__c == null){
            return 'Department is Required';
        }

        if(student.Graduation_Year_c__c == null){
            return 'Graduation Year is Required';
        }

        return 'SUCCESS';
    }

    // ==========================================================
    // Validate CGPA
    // ==========================================================
    private static Boolean validateCGPA(Student__c student){

        if(student.CGPA__c == null){
            return false;
        }

        return student.CGPA__c >= 0 && student.CGPA__c <= 10;
    }

    // ==========================================================
    // Validate Backlogs
    // ==========================================================
    private static Boolean validateBacklogs(Student__c student){

        if(student.Active_Backlogs_c__c == null){
            return false;
        }

        // Eligible only when there are no active backlogs
        return student.Active_Backlogs_c__c == '0';
    }

    // ==========================================================
    // Save Student
    // ==========================================================
    private static void saveStudent(Student__c student){

        insert student;
    }

    // ==========================================================
    // Update Student
    // ==========================================================
    public static String updateStudent(Student__c student){

        update student;

        return 'Student Updated Successfully';
    }

    // ==========================================================
    // Check Placement Status
    // ==========================================================
    public static String checkPlacementStatus(Id studentId){

        Student__c student = [
            SELECT Placement_Status__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];

        return student.Placement_Status__c;
    }

}
