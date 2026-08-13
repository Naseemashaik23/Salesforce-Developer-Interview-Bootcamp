public with sharing class InterviewController {

    // ==========================================================
    // SCHEDULE INTERVIEW
    // ==========================================================

    @AuraEnabled
    public static String scheduleInterview(
        Id applicationId,
        Date interviewDate,
        String interviewTime,
        String interviewMode,
        String interviewRound,
        String interviewer
    ) {

        return InterviewService.scheduleInterview(
            applicationId,
            interviewDate,
            interviewTime,
            interviewMode,
            interviewRound,
            interviewer
        );

    }

}