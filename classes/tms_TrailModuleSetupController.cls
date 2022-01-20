global without sharing class tms_TrailModuleSetupController {
    static final String COE_ORG_TYPE = 'CoE_Org';
    static final String SCRATCH_ORG_ORG_TYPE = 'Scratch_Org';

    // Return current user session id for Lightning to connect with CometD
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }

    @AuraEnabled
    global static String hasConfigStep(String moduleId) {
        List<redwing__Learning_Assignment__c> modules = [select Id, redwing__Learning__r.Configuration_Steps_Definition__c, redwing__Learning__r.Is_Dynamic__c,
                                                         redwing__Training_Plan_Section_Item__c, redwing__Training_Plan_Section_Item__r.Show_Trail_Setup__c
                                                         from redwing__Learning_Assignment__c
                                                   where Id=:moduleId and 
                                                   redwing__Learning__r.Configuration_Steps_Definition__c!=null and 
                                                   redwing__Learning__r.Configuration_Steps_Definition__r.Status__c ='Active'];
        return (modules.size()>0 && modules[0].redwing__Learning__r.Is_Dynamic__c )?modules[0].redwing__Learning__r.Configuration_Steps_Definition__c:null; 
    }
    
    @AuraEnabled
    public static void assignCredits(String playgroundId) {
        system.debug('Start Credit Assignment');
        if(playgroundId==null) return;

        List<Playground__c> pgs = [select Id, Api_Key__c, Org_Credential__c, Org_Credential__r.copado__SFDC_Org_ID__c from Playground__c where Id=:playgroundId];
        if(pgs.size()==0) return;
        
        try {
            List<Salesforce_Org__c> sfOrgs = [ select Id from Salesforce_Org__c where OrgId__c=:pgs[0].Org_Credential__r.copado__SFDC_Org_ID__c.subString(0,18) ];
            if(sfOrgs.size()==0) return;

            system.debug('Assign org with credits');
            admin_utilities.addTransaction(sfOrgs[0].Id, 'addCredits', 1000);
        }
        catch(Exception e) {
            system.debug('Error assigning credits: '+e.getMessage());
        }
    }
    public static List<Configuration_Step__c> getConfigurationStep(String learningAssignmentId){
        List<redwing__Learning_Assignment__c> modules = [select Id, redwing__Learning__r.Configuration_Steps_Definition__c 
                                                        from redwing__Learning_Assignment__c where Id=:learningAssignmentId];
                                                        
        if(modules.size()>0 && modules[0].redwing__Learning__r.Configuration_Steps_Definition__c != null){
            List<Configuration_Step__c> configSteps = [Select Id, Name, Org__c, Type__c, Apex_Script__c, Branch__c, Package_Id__c, Order__c, Configuration_Steps_Definition__c 
                                                        From Configuration_Step__c 
                                                        Where Configuration_Steps_Definition__c =:modules[0].redwing__Learning__r.Configuration_Steps_Definition__c 
                                                        AND Configuration_Steps_Definition__r.Status__c = 'Active'];
            return (configSteps.isEmpty()) ? null : configSteps;
        } else {
            return null; 
        } 
    }

    @AuraEnabled
    public static String runOrgConfigurationStep(String playgroundId, String learningAssignmentId){
        try {
            if(playgroundId != null) {

                List<Step_Execution__c> stepExecution = getStepExecution(playgroundId, learningAssignmentId);
                if (stepExecution != null && !stepExecution.isEmpty()) {
                    String configExecutionId = null;
                    for (Step_Execution__c se : stepExecution) {
                        if (se.Configuration_Execution__r.Status__c == 'Failed' || se.Status__c == 'Failed') {
                            configExecutionId = se.Configuration_Execution__c;
                            break;
                        }
                    }

                    if (configExecutionId != null) {
                        Configuration_Execution__c ve = new Configuration_Execution__c(Id = configExecutionId);
                        ve.Status__c = 'In progress';
                        update ve;
                    }

                    return 'Setup Execution Restarted';
                }
                List<Configuration_Step__c> configSteps = getConfigurationStep(learningAssignmentId);

                if (configSteps == null || configSteps.isEmpty()) {
                    return 'Configure Steps not setup yet';
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

                Configuration_Execution__c configExecutionToBeInsert = new Configuration_Execution__c(
                    Learning_Assignment__c = learningAssignmentId,
                    Playground__c = playgroundId,
                    Configuration_Steps_Definition__c = configSteps[0].Configuration_Steps_Definition__c
                );

                insert configExecutionToBeInsert;

                String api_key = pgs.isEmpty() ? null : pgs[0].Api_Key__c;
                String trialOrgCredentialId = pgs.isEmpty() ? null : pgs[0].Org_Credential__c;

                List<Step_Execution__c> stepExecutionToBeInsert = new List<Step_Execution__c>();
                for (Configuration_Step__c configStep : configSteps) {
                    String orgName = (configStep.Org__c == 'Trial') ? 'Copado' : configStep.Org__c;
                    if(playgroundEnvs.containsKey(orgName)){
                        String orgCredentialId = cps_Helper.getOrgCredentialIdFromAuthorizationUrl(playgroundEnvs.get(orgName).Authorization_URL__c);
                        stepExecutionToBeInsert.add(createStepExecution(configStep, configExecutionToBeInsert.Id, orgCredentialId, api_key, playgroundEnvs.get(orgName).InstanceUrl__c, trialOrgCredentialId));
                    }
                }
                insert stepExecutionToBeInsert;
                
                Configuration_Execution__c configExecutionStart = new Configuration_Execution__c(
                    Id = configExecutionToBeInsert.Id,
                    Status__c = 'In progress'
                );
                update configExecutionStart;
            }
            return 'Execution Started';
        }catch(Exception e){
            System.debug(e);
            return null;
        }
           
    }

    public static Step_Execution__c createStepExecution(
        Configuration_Step__c configStep,
        String configExecutionId,
        String orgCredentialId,
        String api_key, 
        String targetInstanceURL, 
        String trialOrgCredentialId
    ) {

        Step_Execution__c step = new Step_Execution__c(
            Name = configStep.Name,
            Configuration_Step__c = configStep.Id,
            Configuration_Execution__c = configExecutionId,
            OrgCredentialId__c = orgCredentialId,
            ApiKey__c = api_key,
            Target_Instance_URL__c = targetInstanceURL,
            Trial_Org_Credential_Id__c = trialOrgCredentialId
        );

        return step;
    }

    @AuraEnabled
    public static String createFrontDoorRequest(Id orgId) {
        Playground_Enviroment__c playgroundEnviroment = [SELECT Authorization_URL__c, Playground__r.Api_Key__c FROM Playground_Enviroment__c 
                        WHERE Playground__c = :orgId AND Type__c = 'CoE_Org' LIMIT 1];
        if (playgroundEnviroment != null && playgroundEnviroment.Authorization_URL__c != null) {
            String OrgCredentialId = cps_Helper.getOrgCredentialIdFromAuthorizationUrl(playgroundEnviroment.Authorization_URL__c);
            String apiKeyToOpenEnv = cps_Crypto.decryptString(playgroundEnviroment.Playground__r.Api_Key__c);
            
            return cps_InteractiveModule_Utils.createFrontDoorRequest(OrgCredentialId, apiKeyToOpenEnv);
        }
        return null;
    }

    @AuraEnabled
    public static List<Step_Execution__c> getStepExecution(String playgroundId, String learningAssignmentId){
        List<Step_Execution__c> inProgressStepExecution = [Select Id, Name, Status__c, Configuration_Execution__r.Status__c 
                From Step_Execution__c 
                Where Configuration_Execution__c IN 
                (Select Id From Configuration_Execution__c Where Learning_Assignment__c = :learningAssignmentId AND Playground__c =:playgroundId)
                Order By Configuration_Step__r.Order__c ASC];

        return inProgressStepExecution;
    }

    @AuraEnabled
    global static void resetStepExecutionById(String stepId) {
        if (stepId != null) {
            Step_Execution__c se = new Step_Execution__c(Id = stepId, Status__c = 'In progress');
            update se;
        }
    }
}