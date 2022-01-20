public without sharing class cps_PlaygroundWizardStartController {
    private static final String FULL_CONFIGURATION = 'Full Configuration';
    private static final String FULL_CONFIGURATION_ScratchOrgs = 'Full Configuration - Scratch Orgs';
    // Create a new playground and return its info to the frontend
    @AuraEnabled
    public static Playground__c createPlayground(String playgroundName, String playgroundConfiguration) {

        // Create playground
        Playground__c playground = new Playground__c ( Name = playgroundName, Playground_Configuration__c = playgroundConfiguration, User__c = UserInfo.getUserId());
        insert playground;

        // Create playground environment
        List<Playground_Enviroment__c> playgroundEnvs = new List<Playground_Enviroment__c>();
        playgroundEnvs.add(new Playground_Enviroment__c(Name = 'Copado', Playground__c = playground.Id, Type__c = 'CoE_Org'));

        Id defaultRecType = Schema.SObjectType.Playground_Job__c.getRecordTypeInfosByDeveloperName().get('Job').getRecordTypeId();
        Id c1pRecType = Schema.SObjectType.Playground_Job__c.getRecordTypeInfosByDeveloperName().get('C1P_Job').getRecordTypeId();
        Id sandboxCreationRecType = Schema.SObjectType.Playground_Job__c.getRecordTypeInfosByDeveloperName().get('Environment_Creation').getRecordTypeId();

        // Create all the playground jobs
        List<Playground_Job__c> jobsToInsert = new List<Playground_Job__c>();
        jobsToInsert.add(cps_Helper.createPlaygroundJob(1, 'Create Copado Trial Org', 'CreateTrialOrg', playground.Id, defaultRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(10, 'Create Copado Credential', 'CreateCoeCredential', playground.Id, c1pRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(20, 'Log in with Salesforce', 'CoE_Authorization', playground.Id, defaultRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(30, 'Github Setup', 'GitSetup', playground.Id, c1pRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(40, 'Running Installation Script', 'ExecutePostInstallScript', playground.Id, c1pRecType, null, null));
        jobsToInsert.add(cps_Helper.createPlaygroundJob(50, 'Provisioning Licenses', 'ProvisionLicenses', playground.Id, c1pRecType, null, null)); // Provision APO Licenses
        if(playgroundConfiguration != FULL_CONFIGURATION_ScratchOrgs){
            jobsToInsert.add(cps_Helper.createPlaygroundJob(60, 'Creating Sandbox Environments', 'CreateEnvironment', playground.Id, sandboxCreationRecType, null, null));
        }
        else if(playgroundConfiguration == FULL_CONFIGURATION_ScratchOrgs){
            jobsToInsert.add(cps_Helper.createPlaygroundJob(60, 'Creating Scratch Org Environments', 'CreateScratchOrgEnvironment', playground.Id, sandboxCreationRecType, null, null));
        }


        if(playgroundConfiguration == FULL_CONFIGURATION || playgroundConfiguration == FULL_CONFIGURATION_ScratchOrgs) {
            jobsToInsert.add(cps_Helper.createPlaygroundJob(61, 'Granting Permissions', 'AssignPermissionSet', playground.Id, c1pRecType, null, null));
            jobsToInsert.add(cps_Helper.createPlaygroundJob(70, 'Creating Org Credentials', 'CreateOrgCredentials', playground.Id, c1pRecType, null, null));
            jobsToInsert.add(cps_Helper.createPlaygroundJob(80, 'Connect to your Trial Org', 'AuthorizeSandbox', playground.Id, sandboxCreationRecType, null, 'Copado'));
            jobsToInsert.add(cps_Helper.createPlaygroundJob(140, 'Adding Finishing Touches', 'AddingFinishingTouches ', playground.Id, c1pRecType, null, null));
        }
        List<Playground_Sandbox__mdt> plSandboxes = [SELECT DeveloperName, Type__c, Order__c FROM Playground_Sandbox__mdt WHERE Active__c=true order by Order__c ASC LIMIT 10000];

        for(Playground_Sandbox__mdt plSandbox: plSandboxes){
            Integer authOrder = 80+Integer.valueOf(plSandbox.Order__c);
            if(playgroundConfiguration != FULL_CONFIGURATION_ScratchOrgs){
                playgroundEnvs.add(new Playground_Enviroment__c(Name = plSandbox.DeveloperName, Playground__c = playground.Id, Type__c = 'Sandbox'));
                if(playgroundConfiguration == FULL_CONFIGURATION) {
                    String authorizeName = 'Connect to your ' + plSandbox.DeveloperName + ' Sandbox';
                    jobsToInsert.add(cps_Helper.createPlaygroundJob(authOrder, authorizeName, 'AuthorizeSandbox', playground.Id, sandboxCreationRecType, null, plSandbox.DeveloperName));
                }
            }
            else if(playgroundConfiguration == FULL_CONFIGURATION_ScratchOrgs){
                playgroundEnvs.add(new Playground_Enviroment__c(Name = plSandbox.DeveloperName, Playground__c = playground.Id, Type__c = 'Scratch_Org'));
                String authorizeName = 'Connect to your ' + plSandbox.DeveloperName + ' ScratchOrg';
                jobsToInsert.add(cps_Helper.createPlaygroundJob(authOrder, authorizeName, 'AuthorizeSandbox', playground.Id, sandboxCreationRecType, null, plSandbox.DeveloperName));

            }

        }

        try{
            insert jobsToInsert;
            insert playgroundEnvs;
        }catch(Exception e){
            throw e;
        }

        return playground;
    }

    @AuraEnabled
    public static Boolean canCreate(){
        return cps_PlaygroundWizardController.GetAvailablePlaygrounds() > 0;
    }

    @AuraEnabled
    public static Playground_Setting__mdt fetchPlaygroundSetting(){
        Playground_Setting__mdt setting = [SELECT Full_Configuration_Enabled__c, Full_Configuration_Scratch_Org_Enabled__c,Light_Configuration_Enabled__c FROM Playground_Setting__mdt WHERE DeveloperName =: cps_Helper.SETTINGS_NAME LIMIT 1];
        return setting;
    }
}