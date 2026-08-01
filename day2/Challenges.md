# Challenges – Day 2

## Challenges Faced

### 1. Understanding Business Requirements
Initially, it was challenging to identify which business requirements should be implemented using Apex Triggers instead of Validation Rules or Flows.

**Solution:**
Studied the requirements and used a Before Insert Trigger for validations and default field values.

---

### 2. Preventing Duplicate Applications
Implementing duplicate application validation while supporting bulk operations was challenging.

**Solution:**
Used Sets and SOQL queries outside loops to detect duplicate Student and Job combinations efficiently.

---

### 3. CGPA Eligibility Validation
Comparing the Student's CGPA with the Job's Minimum CGPA required querying data from multiple related objects.

**Solution:**
Used Maps to retrieve Student and Job records and performed validations before saving the application.

---

### 4. Understanding Bulkification
Learning how to avoid SOQL and DML statements inside loops was initially difficult.

**Solution:**
Implemented Lists, Sets, and Maps to make the trigger bulk-safe and follow Salesforce best practices.

---

### 5. Trigger Handler Pattern
Separating business logic into Trigger, Handler, and Service classes was a new concept.

**Solution:**
Implemented the Trigger Handler Pattern to improve code organization, readability, and maintainability.

---

## Outcome

Successfully implemented a bulkified Apex Trigger for the Student Placement Management System using the Trigger Handler Pattern and gained a better understanding of Salesforce automation and Governor Limits.
