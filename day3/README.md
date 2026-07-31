# salesforce-30-days-training
# Placement Management System Automation

## Project Overview
This project enhances the Salesforce Placement Management System using Record-Triggered Flows, Validation Rules, and Apex Triggers to automate the application process and improve data quality.

---

## Features Implemented

### 1. Record-Triggered Flow
- Automatically sets the Application Date when a new Application record is created.
- Sends a confirmation email to the Placement Officer after an Application is submitted.

### 2. Validation Rules
- Student CGPA must be greater than or equal to the Job's Minimum CGPA.
- Application Date cannot be after the Job Closing Date.
- Mandatory fields cannot be left blank.

### 3. Apex Trigger
- Prevents duplicate applications by ensuring the same student cannot apply for the same job more than once.

### 4. Offer Letter Automation
- Automatically creates an Offer Letter record when the Application Status changes to "Selected".

---

## Screenshots Included

- Flow Canvas
- Start Element
- Assignment Element
- Email Action
- Successful Flow Execution
- Validation Rule Formulas
- Successful Validation Rule Execution
- Offer Letter Creation (if implemented)

---

# Assignment Questions

## 1. Which requirements did you solve using Flow?

The following requirements were implemented using Record-Triggered Flows:

- Automatically populate the Application Date.
- Send an email notification to the Placement Officer.
- Automatically create an Offer Letter record when the Application Status changes to "Selected".

---

## 2. Which requirements required Validation Rules?

The following validations were implemented using Validation Rules:

- Student CGPA must be greater than or equal to the Job's Minimum CGPA.
- Application Date cannot be after the Job Closing Date.
- Mandatory fields cannot be left blank.

---

## 3. Which requirements still needed Apex?

The following requirement required Apex Trigger:

- Prevent duplicate applications by checking whether the same student has already applied for the same job.

---

## 4. Why did you choose those solutions?

### Flow
Flows were used because they provide a no-code solution for automating business processes such as updating fields, sending emails, and creating related records.

### Validation Rules
Validation Rules were used to enforce data quality by preventing invalid records from being saved.

### Apex Trigger
Apex Trigger was used because preventing duplicate applications requires checking existing records in the database, which cannot be achieved using a simple Validation Rule.
