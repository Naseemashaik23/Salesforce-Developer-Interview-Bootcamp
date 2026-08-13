public with sharing class EligibleJobsService {

    // ==========================================================
    // GET ELIGIBLE JOBS FOR CURRENT STUDENT
    // ==========================================================

    public static List<Job__c> getEligibleJobs() {

        // ======================================================
        // CURRENT LOGGED-IN USER
        // ======================================================

        Id currentUserId = UserInfo.getUserId();


        // ======================================================
        // FIND STUDENT LINKED TO CURRENT USER
        // ======================================================

        List<Student__c> students = [

            SELECT Id,
                   CGPA__c,
                   Department__c,
                   Backlogs__c,
                   Graduation_Year_c__c

            FROM Student__c

            WHERE Student_User__c = :currentUserId

            LIMIT 1

        ];


        // ======================================================
        // NO STUDENT FOUND
        // ======================================================

        if (students.isEmpty()) {

            return new List<Job__c>();

        }


        Student__c student = students[0];


        // ======================================================
        // GET JOB RECORDS
        // ======================================================

        List<Job__c> jobs = [

            SELECT Id,
                   Name,
                   Company__c,
                   Company__r.Name,
                   Closing_Date__c,
                   Graduation_Year_c__c,
                   Job_Location__c,
                   Minimum_CGPA__c,
                   Package_LPA__c,
                   Status__c

            FROM Job__c

            WHERE Closing_Date__c >= :Date.today()

            ORDER BY CreatedDate DESC

        ];


        // ======================================================
        // STORE ELIGIBLE JOBS
        // ======================================================

        List<Job__c> eligibleJobs =
            new List<Job__c>();


        // ======================================================
        // CHECK EACH JOB
        // ======================================================

        for (Job__c job : jobs) {


            // ==================================================
            // CGPA CHECK
            // ==================================================

            if (
                student.CGPA__c == null ||
                job.Minimum_CGPA__c == null ||
                student.CGPA__c < job.Minimum_CGPA__c
            ) {

                continue;

            }


            // ==================================================
            // BACKLOG CHECK
            // ==================================================

            if (student.Backlogs__c == true) {

                continue;

            }


            // ==================================================
            // GRADUATION YEAR CHECK
            // ==================================================

            if (
                student.Graduation_Year_c__c == null ||
                job.Graduation_Year_c__c == null ||
                student.Graduation_Year_c__c != job.Graduation_Year_c__c
            ) {

                continue;

            }


            // ==================================================
            // JOB PASSED ELIGIBILITY CHECKS
            // ==================================================

            eligibleJobs.add(job);

        }


        // ======================================================
        // RETURN ELIGIBLE JOBS
        // ======================================================

        return eligibleJobs;

    }

}