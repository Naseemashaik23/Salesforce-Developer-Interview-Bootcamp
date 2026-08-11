# Placement Management System

## Sprint 31 – Final Integration

Today I worked on connecting the main parts of the Placement Management System into one complete workflow.

## What I Completed Today

### 1. Student Profile

Created and integrated the Student Profile component.

The student can:

- View profile details
- Edit phone and email
- Update department
- Update CGPA
- Update skills
- Update preferred location
- Save changes
- Cancel changes

CGPA validation was also added before saving the profile.

---

### 2. Eligible Jobs

Updated the Eligible Jobs component to display jobs based on the student's eligibility.

The job list shows:

- Company
- Job Role
- Package
- Location
- Eligibility information

It also handles:

- Loading
- Empty job list
- Errors

---

### 3. Job Card

Created a reusable Job Card component.

Each job card contains:

- Company name
- Job role
- Package
- View Details button
- Apply button

The Job Card communicates with the parent Eligible Jobs component using Custom Events.

---

### 4. Job Details

Integrated the Job Details page.

It displays complete job information such as:

- Company
- Job Role
- Package
- Location
- Mode of Work
- Bond Details
- Internship
- Expected Skills
- Job Description
- Minimum CGPA
- Graduation Year
- Closing Date
- Status

---

### 5. Apply Workflow

Connected the Apply button with the existing Apex application logic.

The workflow is:

Student
↓
Eligible Jobs
↓
Job Card
↓
Job Details
↓
Apply
↓
Confirm Application
↓
ApplicationController
↓
ApplicationService
↓
Application Record

The logged-in Salesforce user is automatically connected with the correct Student record.

---

### 6. Lightning Message Service

Created the `StudentProfileRefresh` Message Channel.

This connects Student Profile with Eligible Jobs.

Workflow:

Student updates profile
↓
Profile saved
↓
Message sent
↓
Eligible Jobs receives message
↓
Eligible Jobs reloads

This allows the job list to update when student eligibility information changes.

---

### 7. Eligibility Testing

Tested the profile and job integration by changing the student's CGPA.

After changing the CGPA:

- Student profile was updated.
- Eligible Jobs refreshed.
- Jobs that no longer matched the eligibility disappeared.

This confirmed that student profile information affects the eligible job list.

---

### 8. Application Email Flow

The Application creation process is connected to a Salesforce Record-Triggered Flow.

Flow:

Application Created
↓
Add Recipient Email
↓
Send Email
↓
Placement Officer

During testing, the email Flow produced a
`CANNOT_EXECUTE_FLOW_TRIGGER` error.

The email Flow is currently being investigated.

The existing LWC, Apex Controller and Application Service workflow was not changed while debugging this issue.

---

## Component Flow

```text
Student Profile
       ↓
Profile Updated
       ↓
Eligible Jobs Refresh
       ↓
Select Job
       ↓
Job Details
       ↓
Apply
       ↓
ApplicationController
       ↓
ApplicationService
       ↓
Application

##Challenges Faced
Salesforce CLI connection/deployment issue
Message Channel deployment issue
Student Profile component visibility issue
Eligible Jobs refresh after profile changes
Application Email Flow error

All major component and application workflows were kept intact while fixing these issues.
##Sprint 31 Outcome

Today I connected the major components of the Placement Management System and created an end-to-end student placement workflow from Student Profile → Eligible Jobs → Job Details → Application.
