public without sharing class cps_PlaygroundWizardInstallController {

    // Get all the playground jobs for a given playground
    @AuraEnabled
    public static List<Playground_Job__c> getPlaygroundJobs(String playgroundId){
        return cps_PlaygroundWizardController.GetPlaygroundJobs(playgroundId);
    }
    
    @AuraEnabled
    public static boolean isPlaygroundJobRetriable(String PlaygroundJobId, string jobName){
        DateTime Last24HoursDateTime = SYSTEM.NOW();
        Last24HoursDateTime = Last24HoursDateTime.addHours(-24);
        List<Playground_Job__History> playJobHistory = new List<Playground_Job__History>();
        
        List<Playground_Job__c> last24HoursInProgressPlaygroundJobs = new list<Playground_Job__c>(
            [
                SELECT 
                Id,
                createddate, 
                status__c
                FROM 
                playground_job__c 
                WHERE ID =:PlaygroundJobId
                AND (Status__c = 'Failed' OR
                (Status__c = 'In progress' AND LastModifiedDate <:Last24HoursDateTime))
                AND Name =:jobName                 
            ]
        );
        if(last24HoursInProgressPlaygroundJobs.size()>0) {
            playJobHistory = [SELECT CreatedDate, ParentId FROM Playground_Job__History WHERE 
                                                        ParentId =:PlaygroundJobId AND 
                                                        Field = 'Status__c'                                                                                                                 
                                                        order by createdDate desc limit 1];
        }     
       
        if(playJobHistory.size()>0){
            RETURN TRUE;
        } else { 
        RETURN FALSE;
        } 
    }
    
    @AuraEnabled
    public static void resetPlaygroundJobById(String PlaygroundJobId){
        Playground_Job__c ResetJob = [SELECT ID,Status__c FROM Playground_Job__c WHERE Id =: PlaygroundJobId];
        ResetJob.Status__c = '';
        UPDATE ResetJob;
        ResetJob.Status__c = 'In progress';
        UPDATE ResetJob;
    }
}