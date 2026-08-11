# Salesforce Sprint 11 – Integration & API Development

## Overview

Sprint 11 focused on Salesforce integration and API development. During this sprint, I learned how Salesforce communicates with external systems using REST APIs, Apex HTTP Callouts, Named Credentials, Queueable Apex, authentication, error handling, retry mechanisms, integration tracking, and API contracts.

As part of the practical implementation, I extended the **Placement Management System** to integrate selected candidates with an external recruitment system.

---

## Learning & Development

### 1. APIs

An API (Application Programming Interface) allows two different software systems to communicate with each other. I learned how Salesforce can exchange data with external applications through APIs.

### 2. REST APIs

I learned the fundamentals of REST-based integration and how Salesforce communicates with external services using HTTP methods such as:

- GET
- POST
- PUT
- PATCH
- DELETE

I used a REST API integration in the Placement Management System to send selected candidate information to an external recruitment system.

### 3. HTTP Requests and Responses

I learned how an HTTP request contains an endpoint, method, headers, and request body, and how an external system returns a response containing a status code and response data.

### 4. JSON

I learned how JSON is used to exchange structured data between Salesforce and external systems.

For the candidate integration, I created a JSON payload containing:

- Student ID
- Student Name
- Email
- Department
- CGPA
- Job ID
- Company
- Role
- Selection Date

### 5. HTTP Status Codes

I learned how Salesforce can handle different API responses.

The integration handles:

- `201` – Successful request
- `400` – Bad Request
- `401` – Authentication Failure
- `403` – Forbidden
- `500` – Server Error
- Other unexpected HTTP status codes

### 6. Apex HTTP Callouts

I learned how Apex can communicate with external APIs using:

- `HttpRequest`
- `Http`
- `HttpResponse`

I implemented the `CandidateCalloutService` Apex class to perform the external recruitment API callout.

### 7. Named Credentials

I learned how Named Credentials provide a secure way to configure external API connections in Salesforce.

The Apex integration uses the Named Credential:

`Recruitment_API`

and references it through the callout endpoint instead of directly managing the external connection inside the business logic.

### 8. Authentication and Authorization

I learned the difference between authentication and authorization and why integration credentials should be handled securely.

I also learned the role of Named Credentials and Auth Providers in Salesforce integrations.

### 9. Queueable Apex

I learned how Queueable Apex is used to perform asynchronous processing.

I created:

`CandidateSyncQueueable`

which implements:

- `Queueable`
- `Database.AllowsCallouts`

The Queueable receives the Application ID and retry count and then calls the candidate integration service.

### 10. Asynchronous Callouts

I learned why external API operations can be handled asynchronously instead of being performed directly inside the main Salesforce transaction.

The implementation follows:

```text
Application
    ↓
Queueable Apex
    ↓
CandidateCalloutService
    ↓
External REST API
