# Salesforce Developer Interview Bootcamp - Day 1

# Student Placement Management System

## Project Overview

This project was developed as part of the Salesforce Developer Bridge Program Day 1 assignment. The objective was to design a Student Placement Management System using Salesforce by creating a data model, writing SOQL queries, implementing Apex Triggers, and building a Lightning Web Component (LWC).

---

## Objectives

- Design a custom data model
- Create relationships between objects
- Practice SOQL queries
- Develop an Apex Trigger with a Trigger Handler
- Build a Lightning Web Component using @wire
- Display student records on the Lightning Home Page

---

## Custom Objects

- Student__c
- Company__c
- Job__c
- Application__c

---

## Relationships

- Company → Job (Lookup)
- Student → Application (Lookup)
- Job → Application (Lookup)

---

## Features Implemented

### Data Model
- Created four custom objects
- Added custom fields
- Configured lookup relationships

### SOQL Practice
- WHERE Clause
- ORDER BY with LIMIT
- Relationship Query
- Aggregate Query using COUNT()
- Comparison Operator (>=)

### Apex Trigger
- Prevent duplicate job applications
- Update related student placement status
- Trigger logic implemented using a separate Trigger Handler class

### Lightning Web Component
- Built a Student List component
- Retrieved student records using @wire
- Displayed student details on the Lightning Home Page

---

## Technologies Used

- Salesforce Developer Org
- Apex
- SOQL
- Lightning Web Components (LWC)
- VS Code
- Salesforce CLI

---

## Folder Structure

```
Sprint-01/
│
├── Source-Code/
│   ├── Apex/
│   └── LWC/
│
├── Screenshots/
│
├── SOQL-Queries.txt
│
└── README.md
```

---

## Learning Outcomes

- Understood Salesforce custom objects and relationships
- Practiced writing different types of SOQL queries
- Learned how Apex Triggers work
- Implemented the Trigger Handler pattern
- Built and deployed a Lightning Web Component using @wire

---

## Future Enhancements

- CGPA Eligibility Validation
- Job Closing Date Validation
- Default Application Status
- Bulkified Apex Trigger
- Trigger Handler + Service Pattern

---

## Author

**Shaik Naseema**

B.Tech Computer Science Engineering

Aspiring Salesforce Developer
