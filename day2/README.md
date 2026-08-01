# Salesforce Interview bootcamp – Day 2

# Student Placement Management System

## Project Overview

This project was developed as part of the Salesforce Interview Readiness Bootcamp Day 2 assignment. The objective was to design and implement a bulkified Apex Trigger to automate the student placement application process based on business requirements.

---

# Objectives

- Design an Apex Trigger from business requirements.
- Implement validation logic using Apex.
- Write a bulkified Trigger following Salesforce best practices.
- Use the Trigger Handler Pattern.
- Understand Governor Limits and Collections.

---

# Business Requirements

The following business rules were implemented:

- Prevent duplicate job applications.
- Validate Student CGPA against the Job's Minimum CGPA.
- Reject applications submitted after the Job Closing Date.
- Automatically assign the Application Status as **Applied**.
- Display meaningful validation error messages.

---

# Project Structure

```
ApplicationTrigger
        │
        ▼
ApplicationTriggerHandler
        │
        ▼
ApplicationService
```

The Trigger only invokes methods.

The Handler manages the trigger events.

The Service class contains all business logic.

---

# Features Implemented

## Duplicate Application Prevention
Prevents a student from applying for the same job more than once.

## CGPA Eligibility Validation
Checks whether the student's CGPA satisfies the minimum CGPA required for the selected job.

## Closing Date Validation
Rejects applications submitted after the job's closing date.

## Default Status
Automatically sets the Application Status to **Applied** when a valid application is created.

## Placement Status Update
Updates the related Student's Placement Status to **Placed** when the Application Status changes to **Selected**.

---

# Why did you choose a Trigger?

A Trigger was chosen because the business validations must execute automatically whenever an Application record is created or updated. Triggers ensure that all users follow the same business rules regardless of how records are inserted.

---

# Why Before Insert?

A Before Insert Trigger allows validations to be performed before the record is saved. It also enables the Status field to be automatically populated without requiring an additional DML operation.

---

# How did you bulkify your code?

The trigger was bulkified by:

- Using Lists to process multiple records.
- Using Sets to collect unique Student and Job IDs.
- Using Maps to retrieve related Student and Job records efficiently.
- Avoiding SOQL queries inside loops.
- Avoiding DML statements inside loops.

This ensures the trigger works efficiently even when hundreds of records are processed in a single transaction.

---

# Technologies Used

- Salesforce Developer Org
- Apex
- SOQL
- Lightning Web Components (LWC)
- VS Code
- Salesforce CLI

---

# Source Code

- ApplicationTrigger
- ApplicationTriggerHandler
- ApplicationService
- StudentController

---

# Screenshots Included

- Duplicate Application Validation
- CGPA Validation
- Successful Application Creation
- Status Automatically Set to Applied

---

# What I Learned Today

- Designed Apex Triggers based on business requirements.
- Implemented the Trigger Handler Pattern.
- Understood Governor Limits and Bulkification.
- Used Lists, Sets, and Maps for efficient processing.
- Learned how to validate records before saving.
- Improved debugging and Apex coding skills.
