# Placement Management System

## Sprint 4 – Building Business Logic with Apex

This sprint focuses on implementing business logic for the Placement Management System using Apex.

## Features Implemented

### StudentService
- Register Student
- Validate CGPA
- Validate Active Backlogs
- Update Student
- Check Placement Status

### JobService
- Create Job
- Validate Minimum CGPA
- Publish Job
- Close Expired Jobs
- Update Eligibility

### ApplicationService
- Accept Job Applications
- Prevent Duplicate Applications
- Validate Eligibility
- Check Application Deadline
- Save Applications
- Return Meaningful Messages

## Technologies Used

- Salesforce Apex
- SOQL
- DML
- Lightning Web Components (LWC)
- Salesforce DX

## Business Workflow

Student Applies
↓
Duplicate Check
↓
Eligibility Check
↓
Deadline Check
↓
Save Application
↓
Success Message

## Learning Outcomes

- Understand Business Logic
- Create Service Classes
- Apply SOQL and DML
- Design Reusable Methods
- Implement Enterprise-Level Validation
