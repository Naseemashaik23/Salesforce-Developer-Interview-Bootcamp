# Day 31 – Challenges and Reflection

## Challenges Faced

1. Faced Salesforce CLI deployment and connection issues.
2. Faced problems while exposing and testing the Student Profile component.
3. Implemented communication between Student Profile and Eligible Jobs using Lightning Message Service.
4. Debugged the Apply workflow between LWC and Apex.
5. Faced a Record-Triggered Flow error during Application creation.
6. Investigated the `CANNOT_EXECUTE_FLOW_TRIGGER` error related to the Send Email action.

## Reflection

Today I worked on connecting the major modules of the Placement Management System into a single workflow.

I understood how Student Profile information can affect job eligibility and how Lightning Message Service can be used to refresh another component when profile information changes.

I also learned that Apex DML can trigger Salesforce Flows and that a failure in a Flow can cause the original Apex transaction to fail.

The project is now much closer to a complete end-to-end placement application system.
