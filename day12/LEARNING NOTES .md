# Sprint 11 – Salesforce Integration

## Salesforce APIs, REST Integration, Named Credentials & External Systems

---

## 📌 Overview

In this sprint, I learned how Salesforce communicates with external systems using APIs and integration techniques.

The main project scenario is connecting the **Placement Management System** with an external recruitment platform.

---

## 🎯 Topics Covered

- API
- REST API
- HTTP Methods
- Request & Response
- JSON
- Apex HTTP Callouts
- Queueable Apex
- Named Credentials
- Authentication & Authorisation
- Auth Providers
- Salesforce Connect
- External Objects
- Point-to-Point Integration
- Middleware
- Synchronous & Asynchronous Integration
- Error Handling
- Retry
- Idempotency
- Integration Design Techniques

---

# 1. API

API stands for **Application Programming Interface**.

An API allows two independent software systems to communicate.

```text
Salesforce
    ↓
   API
    ↓
External System
```

---

# 2. REST API

REST is a common style of API communication using HTTP.

| Method | Purpose |
|--------|---------|
| GET | Retrieve data |
| POST | Create/process data |
| PUT | Replace/update data |
| PATCH | Partially update data |
| DELETE | Delete data |

### Example

```text
GET /jobs
POST /applications
PATCH /applications/123
```

---

# 3. Request & Response

## Request

A request can contain:

- URL
- HTTP Method
- Headers
- Authentication
- Body

## Response

A response can contain:

- Status Code
- Headers
- Body

```text
Request
   ↓
External API
   ↓
Response
```

---

# 4. HTTP Status Codes

| Status Code | Meaning |
|-------------|---------|
| 200 | Success |
| 201 | Created |
| 204 | Success, no body |
| 400 | Bad Request |
| 401 | Authentication failure |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Server Error |

The integration should handle different responses instead of assuming every request succeeds.

---

# 5. JSON

JSON is commonly used to exchange API data.

```json
{
    "studentId": "STU10045",
    "name": "Ananya",
    "email": "ananya@example.com",
    "cgpa": 8.4,
    "branch": "CSE"
}
```

JSON contains:

- Keys
- Values
- Objects
- Arrays

---

# 6. Salesforce HTTP Callout

A callout is communication from Salesforce to an external system.

### Basic Flow

```text
HttpRequest
     ↓
Http
     ↓
send()
     ↓
HttpResponse
```

### Example

```apex
HttpRequest request = new HttpRequest();

request.setEndpoint(
    'callout:Recruitment_API/candidates'
);

request.setMethod('POST');

request.setHeader(
    'Content-Type',
    'application/json'
);

request.setBody(
    JSON.serialize(candidate)
);

Http http = new Http();

HttpResponse response =
    http.send(request);
```

---

# 7. Queueable Apex

Queueable Apex is useful when the external work can happen in the background.

For the Placement Management System:

```text
Application Selected
        ↓
      Trigger
        ↓
      Service
        ↓
    Queueable
        ↓
   HTTP Callout
        ↓
External Recruitment API
```

The user does not need to wait for the external system.

---

# 8. Named Credentials

Credentials should **not** be hard-coded in Apex.

Instead, use **Named Credentials**.

```text
Apex
 ↓
Named Credential
 ↓
Authentication
 ↓
External API
```

### Benefits

- Protects credentials
- Separates configuration from code
- Easier maintenance
- Safer deployments

---

# 9. Authentication vs Authorisation

## Authentication

**Who are you?**

Authentication identifies the user or system.

## Authorisation

**What are you allowed to do?**

Authorisation determines permissions.

```text
Authentication = Identity
Authorisation  = Permission
```

### Related Status Codes

```text
401 → Authentication problem
403 → Permission problem
```

---

# 10. Auth Provider

An Auth Provider helps Salesforce handle authentication with supported external identity providers.

```text
Identity Provider
      ↓
Auth Provider
      ↓
Named Credential
      ↓
Apex
      ↓
External API
```

---

# 11. API Contract

Before coding, the API contract should be defined.

It should contain:

- Endpoint
- HTTP Method
- Request JSON
- Response JSON
- Authentication
- Error Responses

### Example

```text
POST /candidates
```

---

# 12. Integration Design Techniques

Good integration design is not only about making an API call. It should also consider security, reliability and maintainability.

## 12.1 Separation of Responsibilities

Keep each component responsible for one task.

```text
Trigger
   ↓
Service
   ↓
Queueable
   ↓
Callout
```

| Component | Responsibility |
|-----------|----------------|
| Trigger | Detect event |
| Service | Business logic |
| Queueable | Background processing |
| Callout | External communication |

---

## 12.2 Secure Configuration

Use **Named Credentials** instead of hard-coded secrets.

```text
Apex
 ↓
Named Credential
 ↓
External API
```

---

## 12.3 Error Handling

Design the integration to handle:

```text
400
401
403
404
500
Timeout
Unexpected Response
```

---

## 12.4 Retry

Temporary failures may require a retry.

```text
Pending
   ↓
Failed
   ↓
Retry Required
   ↓
Retry
```

---

## 12.5 Idempotency

Idempotency helps prevent duplicate records when the same request is processed more than once.

Possible identifiers include:

- Application Id
- External Reference Id
- Idempotency Key

---

## 12.6 Status Tracking

Track the integration status:

```text
Pending
Sent
Failed
Retry Required
```

---

# 13. Callouts & Transactions

A cleaner design is:

```text
Salesforce Transaction
        ↓
Commit Important Data
        ↓
Queueable
        ↓
HTTP Callout
```

This separates the main Salesforce transaction from external communication.

### Important

```text
Salesforce Success
       ≠
External System Success
```

The Salesforce transaction can succeed even if the external integration later fails.

---

# 14. Salesforce Connect & External Objects

Sometimes Salesforce only needs to access external data instead of copying it into Salesforce.

```text
External System
      ↓
External Object
      ↓
Salesforce UI
```

This can help reduce data duplication.

The choice depends on:

- Data ownership
- Data volume
- Latency
- Reporting
- Security
- Business requirements

---

# 15. Integration Patterns

## 15.1 Point-to-Point

Salesforce directly communicates with another system.

```text
Salesforce
    ↕
External System
```

Suitable for simple integrations.

---

## 15.2 Middleware

Middleware sits between Salesforce and external systems.

```text
Salesforce
    ↕
Middleware
    ↕
External Systems
```

Middleware can handle:

- Transformation
- Routing
- Monitoring
- Retry
- Orchestration

The PDF mentions **MuleSoft** as a preferred integration skill.

---

# 16. Synchronous Integration

In synchronous integration, the user waits for the response.

```text
Salesforce
    ↓
External API
    ↓
Response
```

Use synchronous integration when an immediate response is required.

# 17. Asynchronous Integration

In asynchronous integration, the user does not wait.

```text
Salesforce
    ↓
Queueable
    ↓
External API
```


# 18. External Recruitment Integration

## Requirement

When an Application becomes **Selected**, candidate information should be sent to the external recruitment system.

### Candidate Data

- Student Id
- Name
- Email
- Branch
- CGPA
- Job Id
- Company
- Role
- Selection Date

### Architecture

```text
Application
    ↓
Selected
    ↓
Trigger
    ↓
Service
    ↓
Queueable
    ↓
Named Credential
    ↓
REST API
    ↓
External Recruitment System
    ↓
Response
    ↓
Integration Status
```

---

# 19. Error & Retry Flow

## Success

```text
Selected
   ↓
Pending
   ↓
Queueable
   ↓
Sent
```

## Failure

```text
Selected
   ↓
Pending
   ↓
Queueable
   ↓
Failed
   ↓
Retry Required
```

> Do not blindly retry because it may create duplicate candidates.

---


# 21. Interview Questions

## What is an API?

An API is a contract that allows software systems to communicate.

## What is REST?

REST is a common API communication style using HTTP.

## What is a Callout?

A callout is communication from Salesforce to an external system.

## Why Queueable?

Queueable is used to perform external work asynchronously.

## Why Named Credential?

Named Credentials securely manage external endpoint and authentication configuration.

## Authentication vs Authorisation?

**Authentication** identifies the user or system.

**Authorisation** determines permissions.

## What is Idempotency?

Idempotency helps prevent duplicate results when the same request is processed multiple times.

## Point-to-Point vs Middleware?

Point-to-point directly connects systems.

Middleware provides an integration layer between systems.

## Synchronous vs Asynchronous?

Synchronous waits for a response.

Asynchronous performs the work in the background.

---

# 22. Final Revision

The complete integration architecture is:

```text
Business Event
      ↓
Trigger
      ↓
Service
      ↓
Queueable
      ↓
Named Credential
      ↓
REST API
      ↓
External System
      ↓
Response
      ↓
Integration Status
      ↓
Retry / Idempotency
```



> A good integration is not just an API call. It must also handle security, failures, retries, duplicate requests and proper system architecture.
