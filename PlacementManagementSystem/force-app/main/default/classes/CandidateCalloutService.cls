public with sharing class CandidateCalloutService {

    public static void sendCandidate(
        Id applicationId,
        Integer retryCount
    ) {

        Application__c application = [
            SELECT Id,
                   Name,
                   Status__c,
                   Student__c,
                   Job__c,
                   Application_Date__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        Student__c student = [
            SELECT Id,
                   Name,
                   Email__c,
                   Department__c,
                   CGPA__c
            FROM Student__c
            WHERE Id = :application.Student__c
            LIMIT 1
        ];

        Job__c job = [
            SELECT Id,
                   Name,
                   Company__c
            FROM Job__c
            WHERE Id = :application.Job__c
            LIMIT 1
        ];

        // Prepare integration tracking values
        application.Integration_Status__c = 'Pending';
        application.Last_Integration_Attempt__c = System.now();
        application.Integration_Error__c = null;

        try {

            HttpRequest request = new HttpRequest();

           request.setEndpoint(
    'callout:Recruitment_API/test/500'
);

            request.setMethod('GET');

            request.setHeader(
                'Content-Type',
                'application/json'
            );

            Map<String, Object> candidate =
                new Map<String, Object>{
                    'studentId' => student.Id,
                    'name' => student.Name,
                    'email' => student.Email__c,
                    'branch' => student.Department__c,
                    'cgpa' => student.CGPA__c,
                    'jobId' => job.Id,
                    'company' => job.Company__c,
                    'role' => job.Name,
                    'selectionDate' => application.Application_Date__c
                };

            request.setBody(
                JSON.serialize(candidate)
            );

            Http http = new Http();

            HttpResponse response = http.send(request);

            Integer statusCode = response.getStatusCode();

            String responseBody = response.getBody();

            System.debug(
                'Status Code: ' + statusCode
            );

            System.debug(
                'Response Body: ' + responseBody
            );

            // SUCCESS
            if (statusCode == 201) {

                Map<String, Object> responseData =
                    (Map<String, Object>)
                    JSON.deserializeUntyped(responseBody);

                if (responseData.containsKey('id')) {

                    application.External_Candidate_Id__c =
                        String.valueOf(
                            responseData.get('id')
                        );
                }

                application.Integration_Status__c = 'Sent';

                application.Integration_Error__c = null;

                update application;
            }

            // BAD REQUEST
            else if (statusCode == 400) {

                application.Integration_Status__c = 'Failed';

                application.Integration_Error__c =
                    'Bad Request: ' + responseBody;

                update application;
            }

            // AUTHENTICATION FAILURE
            else if (statusCode == 401) {

                application.Integration_Status__c = 'Failed';

                application.Integration_Error__c =
                    'Authentication Failure: ' + responseBody;

                update application;
            }

            // FORBIDDEN
            else if (statusCode == 403) {

                application.Integration_Status__c = 'Failed';

                application.Integration_Error__c =
                    'Forbidden: ' + responseBody;

                update application;
            }

            // SERVER ERROR - RETRY ONCE
            else if (statusCode == 500) {

                if (retryCount < 1) {

                    application.Integration_Status__c =
                        'Retry Required';

                    application.Integration_Error__c =
                        'Server Error. Retry scheduled: ' +
                        responseBody;

                    update application;

                    System.enqueueJob(
                        new CandidateSyncQueueable(
                            applicationId,
                            retryCount + 1
                        )
                    );

                } else {

                    application.Integration_Status__c =
                        'Failed';

                    application.Integration_Error__c =
                        'Server Error after retry: ' +
                        responseBody;

                    update application;
                }
            }

            // OTHER ERROR
            else {

                application.Integration_Status__c =
                    'Failed';

                application.Integration_Error__c =
                    'Unexpected HTTP Status ' +
                    statusCode + ': ' +
                    responseBody;

                update application;
            }

        } catch (Exception e) {

            application.Integration_Status__c = 'Failed';

            application.Integration_Error__c =
                e.getMessage();

            update application;

            System.debug(
                'Callout Exception: ' +
                e.getMessage()
            );
        }
    }
}