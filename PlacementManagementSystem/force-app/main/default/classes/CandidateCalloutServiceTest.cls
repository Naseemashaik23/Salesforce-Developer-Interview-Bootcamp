@IsTest
private class CandidateCalloutServiceTest {

    private class SuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();

            response.setStatusCode(201);
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"id":"EXT-1001"}');

            return response;
        }
    }

    @IsTest
    static void testSuccessfulCandidateIntegration() {

        Student__c student = new Student__c(
            Name = 'Test Student',
            Email__c = 'test@example.com',
            Department__c = 'CSE',
            CGPA__c = 8.5
        );
        insert student;

        Job__c job = new Job__c(
            Name = 'Salesforce Developer'
        );
        insert job;

        Application__c application = new Application__c(
    Student__c = student.Id,
    Job__c = job.Id,
    Status__c = 'Selected',
    Application_Date__c = Date.today()
);
        insert application;

        Test.setMock(
            HttpCalloutMock.class,
            new SuccessMock()
        );

        Test.startTest();

        CandidateCalloutService.sendCandidate(
            application.Id,
            0
        );

        Test.stopTest();

        Application__c result = [
            SELECT Integration_Status__c,
                   External_Candidate_Id__c,
                   Integration_Error__c
            FROM Application__c
            WHERE Id = :application.Id
        ];

        System.assertEquals(
            'Sent',
            result.Integration_Status__c
        );

        System.assertEquals(
            'EXT-1001',
            result.External_Candidate_Id__c
        );

        System.assertEquals(
            null,
            result.Integration_Error__c
        );
    }
}