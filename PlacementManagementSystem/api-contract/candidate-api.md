# Candidate Recruitment API Contract

## 1. Purpose

The Placement Management System sends selected student candidate
information from Salesforce to an external recruitment platform.

## 2. Endpoint

POST /candidates

## 3. Request Method

POST

## 4. Content Type

application/json

## 5. Request Body

```json
{
    "studentId": "STU10045",
    "name": "Ananya",
    "email": "ananya@example.com",
    "branch": "CSE",
    "cgpa": 8.4,
    "jobId": "JOB1001",
    "company": "KSquare",
    "role": "Salesforce Developer",
    "selectionDate": "2026-08-11"
}
## 6. Authentication

Authentication is handled through Salesforce Named Credential.

Named Credential:
`Recruitment_API`

The Salesforce Apex callout uses:

`callout:Recruitment_API`

No authentication credentials are hard-coded in Apex.

## 7. Success Response

HTTP Status: `201 Created`

Example:

```json
{
  "id": "101",
  "status": "created"
}