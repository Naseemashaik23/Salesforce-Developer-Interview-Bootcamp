# Learning Notes – Day 2

## Date
Day 2 – Salesforce Interview Readiness Bootcamp

---

# Topics Learned

## 1. Apex Triggers
- Apex Triggers execute automatically when records are inserted, updated, deleted, or undeleted.
- Used a **Before Insert Trigger** to validate records before saving.
- Used an **After Update Trigger** to update related Student records.

---

## 2. Business Rules Implemented
- Prevent duplicate job applications.
- Validate Student CGPA against the Job's Minimum CGPA.
- Reject applications submitted after the Job Closing Date.
- Automatically set the Application Status to **Applied**.
- Display meaningful error messages when validation fails.

---

## 3. Governor Limits
- Salesforce uses Governor Limits to ensure fair resource usage in a multi-tenant environment.
- Learned to avoid SOQL and DML statements inside loops.
- Improved trigger performance using bulkified code.

---

## 4. Bulkification
- Used **Lists**, **Sets**, and **Maps** to process multiple records efficiently.
- Queried all required records in a single SOQL query.
- Wrote code that supports bulk record processing.

---

## 5. Collections

### List
- Stores multiple records.
- Used to process Application and Student records.

### Set
- Stores unique values only.
- Used to collect unique Student and Job IDs.

### Map
- Stores data as Key–Value pairs.
- Used to quickly retrieve Student and Job records using their IDs.

---

## 6. Trigger Handler Pattern
Implemented the following architecture:

ApplicationTrigger
↓
ApplicationTriggerHandler
↓
ApplicationService

This separates trigger logic from business logic, making the code easier to maintain and reuse.

---

# Key Takeaways

- Learned how to design Apex Triggers based on business requirements.
- Understood the importance of Before Insert Triggers for validation.
- Learned how to bulkify Apex code using Lists, Sets, and Maps.
- Improved understanding of Governor Limits and Trigger Handler Pattern.
- Gained hands-on experience implementing automation for a Student Placement Management System.
