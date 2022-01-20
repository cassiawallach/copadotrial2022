global without sharing class tms_TrailModuleValidationController {
    public enum HttpMethods {GET, POST, PUT}
    static final String COE_ORG_TYPE = 'CoE_Org';
    static final String SCRATCH_ORG_ORG_TYPE = 'Scratch_Org';
    
    // Return current user session id for Lightning to connect with CometD
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }

    @AuraEnabled
    global static String hasIMValidationConfigStep(String moduleId) {
        List<redwing__Learning_Assignment__c> modules = [select Id, Validation_Status__c, redwing__Learning__r.Interactive_Validation__c, redwing__Learning__r.Is_Dynamic__c,
                                                            redwing__Training_Plan_Section_Item__c, redwing__Training_Plan_Section_Item__r.Show_Trail_Setup__c
                                                            from redwing__Learning_Assignment__c
                                                    where Id=:moduleId and 
                                                    redwing__Learning__r.Interactive_Validation__c != null and 
                                                    redwing__Learning__r.Interactive_Validation__r.Status__c ='Active'];
        return (modules.size()>0 && modules[0].redwing__Learning__r.Is_Dynamic__c && modules[0].redwing__Learning__r.Interactive_Validation__c != null )? ((modules[0].Validation_Status__c != null) ?  modules[0].Validation_Status__c : 'Pending') : null;
    }
    
    public static List<Interactive_Validation_Step__c> getIVConfigurationStep(String learningAssignmentId){
        List<redwing__Learning_Assignment__c> modules = [select Id, redwing__Learning__r.Interactive_Validation__c 
                                                        from redwing__Learning_Assignment__c where Id=:learningAssignmentId];
                                                        
        if(modules.size()>0 && modules[0].redwing__Learning__r.Interactive_Validation__c != null){
            List<Interactive_Validation_Step__c> imVConfigSteps = [Select Id, Name, Environment__c, Type__c, ExecutionDetails__c, ExecutionOrder__c, Interactive_Validation__c 
                                                        From Interactive_Validation_Step__c 
                                                        Where Interactive_Validation__c =:modules[0].redwing__Learning__r.Interactive_Validation__c 
                                                        AND Interactive_Validation__r.Status__c = 'Active'];
            return (imVConfigSteps.isEmpty()) ? null : imVConfigSteps;
        } else {
            return null; 
        } 
    }

    @AuraEnabled
    public static String runIVOrgConfigurationStep(String playgroundId, String learningAssignmentId){
        try {
            if(playgroundId != null) {
                List<Interactive_Validation_Step_Execution__c> stepExecution = getInteractiveValidationStepExecution(playgroundId, learningAssignmentId);
                if (stepExecution != null && !stepExecution.isEmpty()) {
                    String validationExecutionId = null;
                    for (Interactive_Validation_Step_Execution__c ivse : stepExecution) {
                        if (ivse.Validation_Execution__r.Status__c == 'Failed' || ivse.Validation_Result__c != 'Success' || ivse.ExecutionStatus__c == 'Failed') {
                            validationExecutionId = ivse.Validation_Execution__c;
                            break;
                        }
                    }

                    if (validationExecutionId != null) {
                        Validation_Execution__c ve = new Validation_Execution__c(Id = validationExecutionId);
                        ve.Status__c = 'In progress';
                        update ve;
                    }

                    return 'Validation Execution Restarted';
                }

                List<Interactive_Validation_Step__c> imValidConfigSteps = getIVConfigurationStep(learningAssignmentId);

                if (imValidConfigSteps == null || imValidConfigSteps.isEmpty()) {
                    return 'Interactive Validation Configure Steps not setup yet';
                }

                List<Playground__c> pgs = [select Id, Api_Key__c, Org_Credential__c, Custom_Signup_Request__r.Domain__c from Playground__c where Id=:playgroundId];
                
                String trialOrgDomain = pgs.isEmpty() ? null : pgs[0].Custom_Signup_Request__r.Domain__c;

                Map<String, Playground_Enviroment__c> playgroundEnvs = new Map<String, Playground_Enviroment__c>();
                for(Playground_Enviroment__c env : [Select Id, Name, Authorization_URL__c, InstanceUrl__c, Type__c 
                                                    From Playground_Enviroment__c 
                                                    Where Playground__c =:playgroundId]){ 
                    if (env.Type__c != SCRATCH_ORG_ORG_TYPE) {
                        env.InstanceUrl__c = 'https://'+trialOrgDomain+ (env.Type__c == COE_ORG_TYPE ? '' : '--' + env.Name).toLowerCase() + '.my.salesforce.com';
                    }
                    
                    playgroundEnvs.put(env.Name, env);
                }

                Validation_Execution__c validationExecutionToBeInsert = new Validation_Execution__c(
                    Learning_Assignment__c = learningAssignmentId,
                    Playground__c = playgroundId,
                    Interactive_Validation__c = imValidConfigSteps[0].Interactive_Validation__c
                );

                insert validationExecutionToBeInsert;

                String api_key = pgs.isEmpty() ? null : pgs[0].Api_Key__c;
                String trialOrgCredentialId = pgs.isEmpty() ? null : pgs[0].Org_Credential__c;

                List<Interactive_Validation_Step_Execution__c> IVStepExecutionToBeInsert = new List<Interactive_Validation_Step_Execution__c>();
                for (Interactive_Validation_Step__c configStep : imValidConfigSteps) {
                    String orgName = (configStep.Environment__c == 'Trial') ? 'Copado' : configStep.Environment__c;
                    if(playgroundEnvs.containsKey(orgName)){
                        String orgCredentialId = cps_Helper.getOrgCredentialIdFromAuthorizationUrl(playgroundEnvs.get(orgName).Authorization_URL__c);
                        IVStepExecutionToBeInsert.add(createIVStepExecution(configStep, validationExecutionToBeInsert.Id, orgCredentialId, api_key, playgroundEnvs.get(orgName).InstanceUrl__c, trialOrgCredentialId));
                    }
                }
                insert IVStepExecutionToBeInsert;

                Validation_Execution__c validationExecutionStart = new Validation_Execution__c(
                    Id = validationExecutionToBeInsert.Id,
                    Status__c = 'In progress'
                );
                update validationExecutionStart;
            }
            return 'Validation Steps Execution Started';
        }catch(Exception e){
            System.debug(e);
            return null;
        }
            
    }

    public static Interactive_Validation_Step_Execution__c createIVStepExecution(
        Interactive_Validation_Step__c configStep,
        String validationExecutionId,
        String orgCredentialId,
        String api_key, 
        String targetInstanceURL, 
        String trialOrgCredentialId
    ) {

        Interactive_Validation_Step_Execution__c step = new Interactive_Validation_Step_Execution__c(
            Name = configStep.Name,
            Interactive_Validation_Step__c = configStep.Id,
            Validation_Execution__c = validationExecutionId,
            OrgCredentialId__c = orgCredentialId,
            ApiKey__c = api_key,
            Target_Instance_URL__c = targetInstanceURL,
            Trial_Org_Credential_Id__c = trialOrgCredentialId
        );

        return step;
    }
    @AuraEnabled
    public static List<Interactive_Validation_Step_Execution__c> getInteractiveValidationStepExecution(String playgroundId, String learningAssignmentId){
        List<Interactive_Validation_Step_Execution__c> inProgressIVStepExecution = [Select Id, Name, Validation_Execution__c, ExecutionStatus__c, Validation_Result__c, Interactive_Validation_Step__r.ExecutionOrder__c, 
                Validation_Execution__r.Status__c
                From Interactive_Validation_Step_Execution__c 
                Where Validation_Execution__c IN 
                (Select Id From Validation_Execution__c Where Learning_Assignment__c = :learningAssignmentId AND Playground__c =:playgroundId)
                Order By Interactive_Validation_Step__r.ExecutionOrder__c ASC];

        return inProgressIVStepExecution;
    }
}