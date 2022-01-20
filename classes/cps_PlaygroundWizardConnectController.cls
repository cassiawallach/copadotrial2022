public without sharing class cps_PlaygroundWizardConnectController {

    // Get all the playground jobs for a given playground
    @AuraEnabled
    public static List<Playground_Job__c> getPlaygroundJobs(String playgroundId){
        return cps_PlaygroundWizardController.GetPlaygroundJobs(playgroundId);
    }

    @AuraEnabled
    public static Playground_Job__c updateJobStatus(String playgroundId, String jobId, String status) {
        return cps_PlaygroundWizardController.UpdateJobStatus(playgroundId, jobId, status);
    }

    // Calls copado API to create the authorization link for a given environment
    @AuraEnabled
    public static Map<String, Object> getAuthLink(String playgroundId, String redirectUrl){

        Map<String, Object> ret = new Map<String, Object>();
        Playground__c playground = [SELECT Org_Credential__c, Org_Credential__r.copado__Validated_Date__c, Org_Credential__r.copado__Username__c, Org_Credential__r.copado__Environment__c,
                                    Custom_Signup_Request__c, Custom_Signup_Request__r.Username__c, Custom_Signup_Request__r.Domain__c,
                                    Using_Trial_Org__c, Trial_Org_Id__c, Org_Id__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];
        Playground_Setting__mdt setting = [SELECT Copado_Client_Key__c, Integration_User_Id__c FROM Playground_Setting__mdt WHERE DeveloperName =: cps_Helper.SETTINGS_NAME];

        String actionName = 'CoE_Authorization';
        Playground_Job__c job = [SELECT Id, Status__c, Payload__c, Output__c FROM Playground_Job__c WHERE Playground__c = :playgroundId AND Action__c = :actionName LIMIT 1];

        Map<String, Object> payloadObj = new Map<String, Object>();
        payloadObj.put('action', actionName);
        Map<String, Object> data = new Map<String, Object>();

        if ( playground.Org_Credential__r.copado__Validated_Date__c==null ||
            (playground.Org_Credential__r.copado__Validated_Date__c!=null && playground.Using_Trial_Org__c==false) ) {
            system.debug('#### ENTERED BECAUSE: '+playground.Using_Trial_Org__c);
            String orgId = playground.Org_Credential__c;
            String copadoUserId = setting.Integration_User_Id__c;
            String copadoOrgId = UserInfo.getOrganizationId();
            String endpoint = 'https://app-api.copado.com/Authorize/loginCustomRedirect?' + 'orgId=' + orgId + '&copadoOrgId=' + copadoOrgId + '&copadoUserId=' + copadoUserId + '&startURL=' + redirectUrl + '&url=' + redirectUrl;
            String clientKey = setting.Copado_Client_Key__c;
            String username = (playground.Custom_Signup_Request__r.Username__c!=null)? playground.Custom_Signup_Request__r.Username__c: '';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('X-Client-Key', clientKey);

            // Send request
            HttpResponse httpResponse = http.send(request);
            if (httpResponse.getStatusCode() == 302) {
                String usernameString = (String.isNotBlank(username))?'&prompt=login%20consent&login_hint='+username : '';
                String authLink = httpResponse.getHeader('Location')+usernameString;
                authLink = authLink.replace('login.salesforce.com', playground.Custom_Signup_Request__r.Domain__c+'.my.salesforce.com');
                ret.put('authorization_url', authLink);
            }
        }
        if (playground.Org_Credential__r.copado__Validated_Date__c!=null && playground.Using_Trial_Org__c==false) {
            try{
                copado__Org__c org = new copado__Org__c(Id=playground.Org_Credential__c);
                org.copado__Validated_Date__c = null;
                org.copado__SFDC_Org_ID__c = null;
                org.copado__username__c = null;
                update org;

                payloadObj.put('hasError', true);
                String errorMessage = 'The Org that was just authenticated did not match the Copado Trial Org for this Playground. You must authenticate the Copado Trial Org created in the previous step to proceed.';
                data.put('message', errorMessage);
                job.Output__c = 'WRONG_ORG_AUTHENTICATED';
                payloadObj.put('data', data);
            }
            catch(Exception e){
                throw e;
            }
        }
        if (playground.Using_Trial_Org__c==true) {
            job.Status__c = 'Completed';
            job.Output__c = null;
            payloadObj.put('hasError', false);
        }
        job.Payload__c = JSON.serializePretty(payloadObj);
        update job;

        ret.put('job', job);
        return ret;
    }

    // Makes a call to C1P to run a script that generates a github auth token (doesn't expire) and creates a Repo
    // script: gitRepoSetup.js
    // Because we need to pass in the AuthCode returned by the browser, we cannot move this into a ProcessBuilder job.
    @AuraEnabled
    public static Playground_Job__c GitSetup(String playgroundId, String gitAuthCode) {
        Playground__c playground = [SELECT Org_Credential__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];
        Playground_Enviroment__c playgroundEnv = [SELECT Name, Org_Credential__c, Playground__r.Name FROM Playground_Enviroment__c WHERE Playground__c = :playgroundId AND Type__c = 'CoE_Org' LIMIT 1];
        Playground_Setting__mdt playgroundSettings = [SELECT Github_Token_Url__c, Github_Client_Id__c, Github_Client_Secret__c
                                                        FROM Playground_Setting__mdt
                                                        WHERE DeveloperName =: cps_Helper.SETTINGS_NAME];

        String actionName = 'GitSetup';
        Playground_Job__c job = [SELECT Status__c, Action__c, JobId__c FROM Playground_Job__c
                                 WHERE Playground__c = :playgroundId AND Action__c = :actionName LIMIT 1];

        if (job.Status__c != 'Completed') {
            Map<String, String> paramBody = new Map<String, String>();
            paramBody.put('C1P_ORGCREDENTIALID_CLIENT', playground.Org_Credential__c);
            paramBody.put('ACTION', actionName);
            paramBody.put('GIT_AUTHCODE', gitAuthCode);
            paramBody.put('GIT_ENDPOINT', playgroundSettings.Github_Token_Url__c);
            paramBody.put('GIT_CLIENT_ID', playgroundSettings.Github_Client_Id__c);
            paramBody.put('GIT_CLIENT_SECRET', playgroundSettings.Github_Client_Secret__c);
            paramBody.put('GIT_REPONAME', 'Copado-' + playgroundEnv.Playground__r.Name.replaceAll(' ', ''));
            String jobId = cps_Helper.StartC1PJob(paramBody);

            job.JobId__c = jobId;
            job.Status__c = 'In progress';

            try{
                update job;
            }catch(Exception e){
                throw e;
            }
        }

        return job;
    }

    @AuraEnabled
    public static Map<String, String> getGithubSettings() {
        Playground_Setting__mdt playgroundSetting = [SELECT Github_Auth_Url__c, Github_Client_Id__c
                                                     FROM Playground_Setting__mdt
                                                     WHERE QualifiedApiName =: 'Default_Values'
                                                     LIMIT 1];

        Map<String, String> ret = new Map<String, String>();
        ret.put('gitAuthUrl', playgroundSetting.Github_Auth_Url__c);
        ret.put('gitClientId', playgroundSetting.Github_Client_Id__c);

        return ret;
    }
}