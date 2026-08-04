# Day-7: Apex Triggers – Making Software Respond Automatically

## Objective
Learn how Apex Triggers automatically respond to business events while keeping business logic inside Service classes. This sprint focuses on building event-driven automation using clean Salesforce architecture.

---

## What I Built

During this sprint, I implemented automatic validation for the Placement Management System using Apex Triggers.

### Implemented Features

- Created an Apex Trigger on the "Application__c" object.
- Delegated validation logic to the "ApplicationService" class.
- Retrieved Student and Job records using SOQL.
- Prevented duplicate applications.
- Validated student eligibility before saving records.
- Automatically created Application records after successful validation.
- Tested the Trigger using Execute Anonymous.
- Verified Trigger execution through Debug Logs.

---

## Apex Trigger

Apex Triggers execute automatically whenever records are inserted, updated, or deleted. Instead of containing business logic, the Trigger simply detects the event and delegates the work to the appropriate Service class.

---

## Business Flow

New Application
        ↓
Application Trigger
        ↓
ApplicationService
        ↓
SOQL Queries
        ↓
Eligibility Validation
        ↓
Duplicate Check
        ↓
DML Insert
        ↓
Success / Error Message


## What I Learned

- Purpose of Apex Triggers.
- Difference between Trigger and Service responsibilities.
- Before Insert Trigger execution.
- Importance of keeping business logic outside the Trigger.
- How "Trigger.new" passes records to Service classes.
- Importance of clean and maintainable Trigger architecture.


## Files Included

ApplicationTrigger.trigger
ApplicationService.cls
Screenshots/
README.md
Notes.md
Reflection.md


## Outcome

Successfully implemented an Apex Trigger that automatically validates applications before insertion while following Salesforce best practices by separating Trigger logic from business logic.
