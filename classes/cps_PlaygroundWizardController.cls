public without sharing class cps_PlaygroundWizardController {

    // Return current user session id for Lightning to connect with CometD
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }

    // Query for how many playgrounds the user has been allowed
    @AuraEnabled
    public static Decimal GetAllowedPlaygrounds() {
        User currentUser = [SELECT ContactId, Allowed_Playgrounds__c
                                FROM User
                                WHERE Id = :UserInfo.getUserId()
                                LIMIT 1];

        if (currentUser == null) {
            return 1000;
        }
        else {
            return currentUser.Allowed_Playgrounds__c;
        }
    }

    // Query for how many playgrounds more can be created
    @AuraEnabled
    public static Decimal GetAvailablePlaygrounds() {
        User currentUser = [SELECT ContactId, Allowed_Playgrounds__c
                                FROM User
                                WHERE Id = :UserInfo.getUserId()
                                LIMIT 1];

        if (currentUser == null) {
            return 1000;
        }
        else {
            Decimal allowed = (currentUser.Allowed_Playgrounds__c==null)? 0: currentUser.Allowed_Playgrounds__c;
            Integer used = GetMyPlaygrounds().size();
            Decimal available = allowed - used;
            return available;
        }
    }

    // Deletes a playground
    @AuraEnabled
    public static void DeletePlayground(String playgroundId) {
        Playground_Enviroment__c playgroundEnv = [SELECT Org_Id__c FROM Playground_Enviroment__c WHERE Playground__c = :playgroundId AND Type__c = 'CoE_Org' LIMIT 1];
        Playground_Setting__mdt settings = [SELECT Production_Api_Key__c, Licensing_Endpoint__c
                                            FROM Playground_Setting__mdt
                                            WHERE DeveloperName =: cps_Helper.SETTINGS_NAME
                                            LIMIT 1];

        // If there isn't coe2coe auth then there also isn't an org
        if (playgroundEnv.Org_Id__c != null) {
            // Id has to be in 15 characters format
            String orgId = playgroundEnv.Org_Id__c;
            if(orgId.length() == 18) orgId = orgId.left(15);
            String apiKey = cps_Crypto.decryptString(settings.Production_Api_Key__c);
            String baseUrl = settings.Licensing_Endpoint__c;
            String updateEndpoint = baseUrl + '/updatelicense/' + orgId;
            String body = '{"status": "Suspended", "forceactive": true, "licenses": 1}';
            Integer responseCode = cps_Helper.makeRequest(updateEndpoint, apiKey, body);
        }

        Playground__c playground = [SELECT Name, Stage__c, Status__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];

        try{
            delete playground;
        }catch(Exception e){
            throw e;
        }
    }

    // Gets a playground id and returns its information to the frontend
    @AuraEnabled
    public static Playground__c getPlayground(String id) {
        Playground__c playground = [SELECT Name, Stage__c, Status__c, All_Sandboxes_Authorized__c FROM Playground__c WHERE Id = :id];
        return playground;
    }

    // Get all the playground for the current community user
    @AuraEnabled
    public static List<Playground__c> GetMyPlaygrounds() {
        List<Playground__c> playgrounds = [SELECT Name, Stage__c, Status__c, Playground_Configuration__c FROM Playground__c WHERE User__c = :UserInfo.getUserId()];

        return playgrounds;
    }

    // Updates playground stage from: Start, Connect, Install, Setup, Finish
    @AuraEnabled
    public static Playground__c updatePlaygroundStage(String playgroundId, String stage){
        Playground__c playground = [SELECT Name, Stage__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];
        playground.Stage__c = stage;

        try{
            update playground;
        }catch(Exception e){
            throw e;
        }

        return playground;
    }

    // Updates a given job status and returns the job information to the frontend
    @AuraEnabled
    public static Playground_Job__c UpdateJobStatus(String playgroundId, String jobId, String status){
        Playground_Job__c job = [select Id, Status__c, Payload__c, Playground__c from Playground_Job__c where Playground__c=:playgroundId and Id=:jobId];
        job.Status__c = status;

        if (status == 'Failed') {
            try {
            	Playground__c playground = new Playground__c(Id=playgroundId, Status__c = 'Failed');
                update playground;
            } catch (Exception e) {
                throw e;
            }
        }

        try {
            update job;
        } catch(Exception e){
            throw e;
        }
        return job;
    }

    @AuraEnabled
    public static List<Playground_Job__c> GetPlaygroundJobs(String playgroundId){
        List<Playground_Job__c> jobs = [select Id, Name, Action__c, Status__c, JobId__c, Sandbox_Name__c, Payload__c, Order__c,CreatedDate
                                        from Playground_Job__c
                                        where Playground__c=:playgroundId order by Order__c ASC];
        return jobs;
    }

    @AuraEnabled
    public static Map<String, Object> getPlaygroundDetails(String playgroundId) {
      Playground__c playground = [SELECT Name, Status__c, Stage__c, Playground_Configuration__c, Error_Message__c, All_Sandboxes_Authorized__c, Git_Username__c, Org_Credential__r.copado__Username__c, LastModifiedDate FROM Playground__c WHERE Id =: playgroundId LIMIT 1];

        List<Playground_Enviroment__c> environments = [SELECT Id, Name, Status__c, Type__c, LastModifiedDate FROM Playground_Enviroment__c WHERE Playground__c =: playgroundId];

        Map<String, Object> pgd = new Map<String, Object>();
        pgd.put('playground', playground);
        pgd.put('environments', environments);

      return pgd;
    }

    @AuraEnabled
    public static Playground_Job__c callStandardC1PAction(String playgroundId, String actionName) {
        Playground__c playground = [SELECT Org_Credential__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];

        Playground_Job__c job = [SELECT Status__c, Action__c, JobId__c FROM Playground_Job__c WHERE Playground__c = :playgroundId AND Action__c = :actionName LIMIT 1];

        if (job.Status__c != 'Completed') {
            Map<String, String> paramBody = new Map<String, String>();
            paramBody.put('ACTION', actionName);
            paramBody.put('C1P_ORGCREDENTIALID_CLIENT', playground.Org_Credential__c);
            String jobId = cps_Helper.StartC1PJob(paramBody);

            job.Status__c = 'In progress';
            job.JobId__c = jobId;

            try{
                update job;
            }catch(Exception e){
                throw e;
            }
        }

        return job;
    }

    @AuraEnabled
    public static Playground_Setting__mdt getPlaygroundUnderMaintenance() {
        Playground_Setting__mdt playgroundSetting = [
            SELECT Are_Playgrounds_Under_Maintenance__c, Is_Playground_Wizard_under_maintenance__c
            FROM Playground_Setting__mdt
            WHERE QualifiedApiName =: cps_Helper.SETTINGS_NAME
            LIMIT 1];

        Boolean isPlaygroundsTestUser = [
            SELECT Is_Playgrounds_Test_User__c
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ].Is_Playgrounds_Test_User__c;

        Boolean arePlaygroundsUnderMaintenance = playgroundSetting.Are_Playgrounds_Under_Maintenance__c && !isPlaygroundsTestUser;
        playgroundSetting.Are_Playgrounds_Under_Maintenance__c = arePlaygroundsUnderMaintenance;

        return playgroundSetting;
    }

    @AuraEnabled
    public static String createFrontDoorRequest(Id orgId) {
      Playground_Setting__mdt playgroundSetting = [select Copado_Client_Key__c from Playground_Setting__mdt where QualifiedApiName=:cps_Helper.SETTINGS_NAME limit 1];
      Playground_Enviroment__c playgroundEnviroment = [SELECT Authorization_URL__c, Playground__r.Api_Key__c FROM Playground_Enviroment__c WHERE Id = :orgId LIMIT 1];
      String OrgCredentialId = cps_Helper.getOrgCredentialIdFromAuthorizationUrl(playgroundEnviroment.Authorization_URL__c);

      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://app-api.copado.com/json/v1/webhook/copadoSession/' + OrgCredentialId + '?api_key=' + cps_Crypto.decryptString(playgroundEnviroment.Playground__r.Api_Key__c));
      request.setMethod('GET');
      request.setHeader('X-Client-Key', playgroundSetting.Copado_Client_Key__c);

      HttpResponse httpResponse;

      try{
        httpResponse = http.send(request);
        return httpResponse.getBody();
      } catch(Exception e) {
        throw e;
      }
    }
}