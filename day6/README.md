# 📅 Day 5 - SOQL, DML & Business Transactions

## 🎯 Objective

Today I learned how Salesforce retrieves data using SOQL, performs business validation using Apex, and saves data using DML. I also understood how all these concepts work together to complete a business transaction in the Placement Management System.

---

# 📚 Topics Learned

## SOQL (Salesforce Object Query Language)

- Learned how to retrieve records from Salesforce.
- Understood that SOQL is used before making any business decision.
- Learned to retrieve only the required fields instead of all fields.
- Used the Record Id to retrieve a specific record.
- Learned the use of `:` (variable binding) inside SOQL.

Example:
- Retrieve Student Details
- Retrieve Job Details
- Check Duplicate Applications

---

## Apex

- Learned that Apex is Salesforce's programming language.
- Understood that Apex is used to write business logic.
- Used Apex to validate:
  - Student CGPA
  - Branch
  - Backlogs
  - Application Deadline
- Learned how `if` conditions and `return` work.

---

## DML (Data Manipulation Language)

Learned different DML operations:

- Insert
- Update
- Delete
- Upsert

Understood that DML should only be used after all validations are completed.

---

## Record Id

- Learned that every Salesforce record automatically gets a unique Record Id.
- No need to create an Id field manually.
- Relationships between objects use the Record Id.

---

## Application Submission Workflow

Student Clicks Apply

↓

Receive Student Id & Job Id

↓

Retrieve Student Details

↓

Retrieve Job Details

↓

Check Duplicate Application

↓

Validate Eligibility

↓

Create Application

↓

Insert Record

↓

Show Success Message

---

## Status Update Workflow

Recruiter Changes Status

↓

Retrieve Application

↓

Update Status

↓

If Status = Interview Scheduled

↓

Store Interview Date

↓

Update Record

↓

Display Success Message

---

## Software Design

Learned that it is better to divide work into separate methods instead of writing everything inside one method.

Example:

- getStudent()
- getJob()
- validateEligibility()
- checkDuplicate()
- createApplication()
- updateApplicationStatus()

This makes the code easier to understand and maintain.

---

# 💻 Practical Learning

- Wrote SOQL queries.
- Retrieved Student and Job records.
- Understood how Apex variables store retrieved records.
- Learned the difference between Insert and Update.
- Understood the complete business transaction flow.
- Learned why validation should happen before DML.

---

# ✅ Key Takeaways

- SOQL is used to retrieve data.
- Apex is used to apply business logic.
- DML is used to insert or update records.
- Every query should answer a business question.
- Retrieve only the required fields.
- Validate data before saving it.
- Use separate methods for different tasks to keep the code clean.

---

# 📝 What I Learned Today

Today I understood how SOQL, Apex, and DML work together in a real Salesforce application. I also learned that writing code is not enough; understanding the business flow and designing clean methods is equally important.

