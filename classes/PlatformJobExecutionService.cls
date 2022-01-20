public with sharing class PlatformJobExecutionService {

    public static void updateRelatedStepExecution(copado1p__Platform_Job_Execution__c oldPje, copado1p__Platform_Job_Execution__c pje) {
        if (oldPje.copado1p__Status__c != pje.copado1p__Status__c && pje.copado1p__Copado_Job_ID__c != null) {
            String stepExecutionStatus;
            if (pje.copado1p__Status__c == 'Starting') {
                stepExecutionStatus = 'Pending';
            } else if (pje.copado1p__Status__c == 'Running') {
                stepExecutionStatus = 'In progress';
            } else if (pje.copado1p__Status__c == 'Success') {
                stepExecutionStatus = 'Completed';
            } else if (pje.copado1p__Status__c == 'Failure') {
                stepExecutionStatus = 'Failed';
            }

            // Update Step Execution for Interactive Module

            List<Configuration_Execution__c> configExecutionToBeUpdate = new List<Configuration_Execution__c>();
            for (Configuration_Execution__c se : [Select Id, Status__c, Platform_Job_Execution__c From Configuration_Execution__c Where JobID__c =:pje.copado1p__Copado_Job_ID__c Order by LastModifiedDate DESC Limit 1]) {
                se.Status__c = stepExecutionStatus;
                se.Platform_Job_Execution__c = pje.Id;
                configExecutionToBeUpdate.add(se);
            }

            if (!configExecutionToBeUpdate.isEmpty()) {
                update configExecutionToBeUpdate;
            }

            // Update Step Execution for Interactive Validation
            List<Validation_Execution__c> validationExecutionToBeUpdate = new List<Validation_Execution__c>();
            for (Validation_Execution__c ve : [Select Id, Status__c, Platform_Job_Execution__c From Validation_Execution__c Where JobId__c =:pje.copado1p__Copado_Job_ID__c Order by LastModifiedDate DESC Limit 1]) {
                ve.Status__c = stepExecutionStatus;
                ve.Platform_Job_Execution__c = pje.Id;
                validationExecutionToBeUpdate.add(ve);
            }

            if (!validationExecutionToBeUpdate.isEmpty()) {
                update validationExecutionToBeUpdate;

            }
            
        }
    }
}