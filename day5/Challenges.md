# Challenges Faced

## 1. API Name Mismatch
The custom field API names created in Salesforce were different from the expected names, causing deployment failures.

## 2. Picklist Validation
The Active Backlogs field was a Picklist instead of a Number field, requiring changes to the validation logic.

## 3. Trigger Integration
The ApplicationTriggerHandler expected a validateApplications() method that was missing from ApplicationService.

## 5. Deployment Errors
Several deployment errors occurred due to incorrect field references and method signatures. These were resolved by updating the service classes and trigger handler.
