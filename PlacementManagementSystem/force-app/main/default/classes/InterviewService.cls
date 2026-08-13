public with sharing class InterviewService {

    // ==========================================================
    // SCHEDULE INTERVIEW
    // ==========================================================

    public static String scheduleInterview(
        Id applicationId,
        Date interviewDate,
        String interviewTime,
        String interviewMode,
        String interviewRound,
        String interviewer
    ) {

        // ======================================================
        // VALIDATE APPLICATION
        // ======================================================

        if (applicationId == null) {
            return 'Application is required.';
        }


        // ======================================================
        // VALIDATE DATE
        // ======================================================

        if (interviewDate == null) {
            return 'Interview date is required.';
        }


        // ======================================================
        // VALIDATE TIME
        // ======================================================

        if (String.isBlank(interviewTime)) {
            return 'Interview time is required.';
        }


        // ======================================================
        // VALIDATE MODE
        // ======================================================

        if (String.isBlank(interviewMode)) {
            return 'Interview mode is required.';
        }


        // ======================================================
        // VALIDATE ROUND
        // ======================================================

        if (String.isBlank(interviewRound)) {
            return 'Interview round is required.';
        }


        // ======================================================
        // VALIDATE INTERVIEWER
        // ======================================================

        if (String.isBlank(interviewer)) {
            return 'Interviewer is required.';
        }


        // ======================================================
        // CONVERT TIME STRING TO APEX TIME
        // ======================================================

        Time parsedInterviewTime;

        try {

            String timeValue =
                interviewTime.trim();


            if (timeValue.contains('.')) {

                timeValue =
                    timeValue.substringBefore('.');

            }


            if (timeValue.endsWith('Z')) {

                timeValue =
                    timeValue.substring(
                        0,
                        timeValue.length() - 1
                    );

            }


            List<String> timeParts =
                timeValue.split(':');


            if (timeParts.size() < 2) {

                return 'Invalid interview time format.';

            }


            Integer hour =
                Integer.valueOf(timeParts[0]);

            Integer minute =
                Integer.valueOf(timeParts[1]);

            Integer second = 0;


            if (timeParts.size() >= 3) {

                second =
                    Integer.valueOf(timeParts[2]);

            }


            parsedInterviewTime =
                Time.newInstance(
                    hour,
                    minute,
                    second,
                    0
                );

        }
        catch (Exception e) {

            return 'Invalid interview time format.';

        }


        // ======================================================
        // GET APPLICATION
        // ======================================================

        Application__c applicationRecord = [

            SELECT
                Id,
                Status__c,
                Student__c,
                Student__r.Name,
                Student__r.Email__c,
                Job__c,
                Job__r.Name,
                Job__r.Company__r.Name

            FROM Application__c

            WHERE Id = :applicationId

            LIMIT 1

        ];


        // ======================================================
        // APPLICATION MUST BE SHORTLISTED
        // ======================================================

        if (
            applicationRecord.Status__c
            != 'Shortlisted'
        ) {

            return
                'Interview can only be scheduled for a shortlisted application.';

        }


        // ======================================================
        // CHECK EXISTING INTERVIEW
        // ======================================================

        List<Interview_c__c> existingInterviews = [

            SELECT
                Id

            FROM Interview_c__c

            WHERE Application__c = :applicationId

            LIMIT 1

        ];


        if (!existingInterviews.isEmpty()) {

            return
                'An interview has already been scheduled for this application.';

        }


        // ======================================================
        // CREATE INTERVIEW
        // ======================================================

        Interview_c__c newInterview =
            new Interview_c__c();


        newInterview.Application__c =
            applicationId;


        newInterview.Interview_Date__c =
            interviewDate;


        newInterview.Interview_Time__c =
            parsedInterviewTime;


        newInterview.Interview_Mode__c =
            interviewMode;


        newInterview.Interview_Round__c =
            interviewRound;


        newInterview.Interviewer__c =
            interviewer;


        // ======================================================
        // INSERT INTERVIEW
        // ======================================================

        insert newInterview;


        // ======================================================
        // SEND EMAIL NOTIFICATIONS
        // ======================================================

        try {

            List<String> emailAddresses =
                new List<String>();


            // ==================================================
            // STUDENT EMAIL
            // ==================================================

            if (
                applicationRecord.Student__r != null &&
                !String.isBlank(
                    applicationRecord.Student__r.Email__c
                )
            ) {

                emailAddresses.add(
                    applicationRecord.Student__r.Email__c
                );

            }


            // ==================================================
            // PLACEMENT COORDINATOR EMAIL
            // CURRENT SALESFORCE USER
            // ==================================================

            String coordinatorEmail =
                UserInfo.getUserEmail();


            if (
                !String.isBlank(coordinatorEmail)
            ) {

                if (
                    !emailAddresses.contains(
                        coordinatorEmail
                    )
                ) {

                    emailAddresses.add(
                        coordinatorEmail
                    );

                }

            }


            // ==================================================
            // SEND EMAIL ONLY IF RECIPIENT EXISTS
            // ==================================================

            if (!emailAddresses.isEmpty()) {

                Messaging.SingleEmailMessage email =
                    new Messaging.SingleEmailMessage();


                email.setToAddresses(
                    emailAddresses
                );


                // ==================================================
                // SUBJECT
                // ==================================================

                email.setSubject(
                    'Interview Scheduled - '
                    + applicationRecord.Job__r.Name
                );


                // ==================================================
                // EMAIL BODY
                // ==================================================

                String emailBody =
                    'Dear '
                    + applicationRecord.Student__r.Name
                    + ',\n\n';


                emailBody +=
                    'Your interview has been scheduled successfully.\n\n';


                emailBody +=
                    'Interview Details:\n';


                emailBody +=
                    'Company: '
                    + applicationRecord.Job__r.Company__r.Name
                    + '\n';


                emailBody +=
                    'Job: '
                    + applicationRecord.Job__r.Name
                    + '\n';


                emailBody +=
                    'Interview Date: '
                    + String.valueOf(interviewDate)
                    + '\n';


                emailBody +=
                    'Interview Time: '
                    + String.valueOf(parsedInterviewTime)
                    + '\n';


                emailBody +=
                    'Interview Mode: '
                    + interviewMode
                    + '\n';


                emailBody +=
                    'Interview Round: '
                    + interviewRound
                    + '\n';


                emailBody +=
                    'Interviewer: '
                    + interviewer
                    + '\n\n';


                emailBody +=
                    'Please be available at the scheduled time.\n\n';


                emailBody +=
                    'Regards,\n'
                    + 'Placement Management Team';


                email.setPlainTextBody(
                    emailBody
                );


                Messaging.sendEmail(
                    new List<Messaging.SingleEmailMessage>{
                        email
                    }
                );

            }

        }
        catch (Exception emailException) {

            // ==================================================
            // EMAIL FAILURE MUST NOT REMOVE INTERVIEW
            // ==================================================

            System.debug(
                'Interview email failed: '
                + emailException.getMessage()
            );

        }


        // ======================================================
        // SUCCESS
        // ======================================================

        return 'Interview Scheduled Successfully';

    }

}