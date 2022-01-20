global class cps_Helper {
    // Constants and enums
    public enum HttpMethods {
        GET,
        POST,
        PUT
    }
    public static final String SETTINGS_NAME = 'Default_Values';

    /**
     * Executes a C1P Job in CopadoC1P, for those methods that are not in ProcessBuilder
     * This method is used by the ConnectController and WizardController.
     * @param params   Payload as a JSON
     * @return copadoJobId
     */
    public static String StartC1PJob(Map<String, String> params) {
        Playground_Setting__mdt playgroundSetting = [
            SELECT C1P_API_Endpoint__c, C1P_Platform_Job_Id__c, C1P_API_Key__c
            FROM Playground_Setting__mdt
            WHERE QualifiedApiName = :cps_Helper.SETTINGS_NAME
            LIMIT 1
        ];

        String c1pEndpoint =
            playgroundSetting.C1P_API_Endpoint__c +
            playgroundSetting.C1P_Platform_Job_Id__c +
            '/start?api_key=' +
            playgroundSetting.C1P_API_Key__c;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(c1pEndpoint);
        request.setMethod(HttpMethods.POST.name());
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(params));

        HttpResponse httpResponse;
        // Send request
        try {
            httpResponse = http.send(request);
        } catch (Exception e) {
            throw e;
        }
        if (httpResponse.getStatusCode() == 200) {
            Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
            if (Boolean.valueOf(response.get('isSuccess')) == true) {
                return String.valueOf(response.get('copadoJobId'));
            } else {
                return null;
            }
        }

        return null;
    }

    /**
     * This is used by ConnectController to save the orgId from the authenticated Org Credential and save it to the corresponding Environment.
     * @param playgroundId  The ID of the playground record
     * @return void         We use a try catch in the ConnectController and throw and exception.
     */
    public static void saveOrgIdFromOrgCredential(Id playgroundId) {
        try {
            Playground__c playground = [SELECT Org_Credential__c FROM Playground__c WHERE Id = :playgroundId];
            Playground_Enviroment__c env = [
                SELECT Org_Id__c
                FROM Playground_Enviroment__c
                WHERE Type__c = 'CoE_Org' AND Playground__c = :playgroundId
            ];
            env.Org_Id__c = getOrgIdFromOrgCredential(playground.Org_Credential__c);
            update env;
        } catch (Exception e) {
            throw e;
        }
    }

    // Gets an org id given a credential
    public static String getOrgIdFromOrgCredential(Id orgCredentialId) {
        String ret = '';

        List<copado__Org__c> cred = [SELECT copado__Username__c, copado__SFDC_Org_ID__c FROM copado__Org__c WHERE Id = :orgCredentialId];
        if (!cred.isEmpty()) {
            copado__Org__c credential = cred.get(0);
            if (credential.copado__SFDC_Org_ID__c != null) {
                ret = credential.copado__SFDC_Org_ID__c.split('_').get(0);
            } else {
                List<copado__Org__c> authorizedCredential = [
                    SELECT copado__SFDC_Org_ID__c
                    FROM copado__Org__c
                    WHERE copado__Username__c = :credential.copado__Username__c AND copado__SFDC_Org_ID__c != null
                    LIMIT 1
                ];
                ret = authorizedCredential.get(0).copado__SFDC_Org_ID__c.split('_').get(0);
            }
        }

        return ret;
    }

    public static String getOrgCredentialIdFromAuthorizationUrl(String authorizationUrl) {
      String res = authorizationUrl;

      res = res.replace('https://app-api.copado.com/Authorize/loginCustomRedirect?orgId=', '');
      res = res.substring(0,18);

      return res;
    }

    // Get the integration user org credentials to call C1P
    public static Id getIntegrationUserOrgCredentialId(Id userId) {
        User u = [SELECT Username FROM User WHERE Id = :userId];
        List<copado__Environment__c> env = [
            SELECT Id, (SELECT Id FROM copado__Org_Credentials__r WHERE copado__Username__c = :u.Username)
            FROM copado__Environment__c
            WHERE copado__Org_Id__c = :UserInfo.getOrganizationId()
        ];
        String ret = null;
        if (!env.isEmpty()) {
            ret = env.get(0).copado__Org_Credentials__r.get(0).Id;
        }
        return ret;
    }

    public static Integer makeRequest(String endpoint, String apiKey, String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('apiKey', apiKey);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);

        HttpResponse response;

        try {
            response = http.send(request);
        } catch (Exception e) {
            System.debug('####@@@@e.getMessage()' + e.getMessage());
            throw e;
        }
        //Exceptions are thrown. All other requests/responses return 200
        return 200;
    }

    public static Playground_Job__c createPlaygroundJob(
        Integer iOrder,
        String name,
        String action,
        Id playgroundId,
        Id recordTypeId,
        String status,
        String sandboxName
    ) {
        if (String.isEmpty(status))
            status = 'Pending';

        Playground_Job__c job = new Playground_Job__c(
            Name = name,
            Action__c = action,
            Playground__c = playgroundId,
            RecordTypeId = recordTypeId,
            Status__c = status,
            Order__c = iOrder
        );
        if (String.isNotEmpty(sandboxName))
            job.Sandbox_Name__c = sandboxName;

        return job;
    }

    //------------- START OF METHODS TO BE USED BY PROCESS BUILDER TO KICK-OFF C1P JOBS
    global class PlaygroundC1PRequest {
        @InvocableVariable(required=true)
        global ID playgroundJobId;
        @InvocableVariable(required=false)
        global Integer daysOfLicense;
        @InvocableVariable(required=false)
        global String subAction;
    }

    @InvocableMethod(label='Call C1P Actions')
    public static void callC1Pactions(List<PlaygroundC1PRequest> requests) {
        Playground_Setting__mdt settings = [
            SELECT Community_URL__c, Copado_Client_Key__c, Current_Org_Type__c, Integration_User_Id__c, Production_Api_Key__c, Licensing_Endpoint__c, VSM_Package_Id__c, Copado_Deployer_Package_Id__c
            FROM Playground_Setting__mdt
            WHERE DeveloperName = :cps_Helper.SETTINGS_NAME
        ];
        Id orgCredential = cps_Helper.getIntegrationUserOrgCredentialId(settings.Integration_User_Id__c);

        Set<Id> ids = new Set<Id>();
        for (PlaygroundC1PRequest request : requests) {
            ids.add(request.playgroundJobId);
        }
        Map<Id, Playground_Job__c> playgroundJobMap = new Map<Id, Playground_Job__c>(
            [
                SELECT
                    Status__c,
                    Action__c,
                    JobId__c,
                    Sandbox_Name__c,
                    Playground__r.Custom_Signup_Request__c,
                    Playground__r.Custom_Signup_Request__r.Username__c,
                    Playground__r.Custom_Signup_Request__r.Status__c,
                    Playground__r.Using_Trial_Org__c,
                    Playground__r.Trial_Org_Id__c,
                    Playground__r.Org_Id__c,
                    Playground__r.Org_Credential__r.copado__Environment__c,
                    Playground__c,
                    Playground__r.Name,
                    Playground__r.Org_Credential__c,
                    Playground__r.Git_Token__c,
                    Playground__r.Git_Username__c,
                    Playground__r.Api_Key__c,
                    Playground__r.Commit_Hash__c
                FROM Playground_Job__c
                WHERE Id IN :ids
            ]
        );

        Set<Id> playgroundIds = new Set<Id>();
        for (Playground_Job__c job : playgroundJobMap.values()) {
            playgroundIds.add(job.Playground__c);
        }
        Map<String, List<Playground_Enviroment__c>> playgroundEnvironmentMap = new Map<String, List<Playground_Enviroment__c>>();
        for (Playground_Enviroment__c pe : [
            SELECT Id, Name, Org_Credential__c, Org_Id__c, Type__c, Playground__c, Access_Token__c, InstanceUrl__c
            FROM Playground_Enviroment__c
            WHERE Playground__c IN :playgroundIds
        ]) {
            List<Playground_Enviroment__c> tmp = (playgroundEnvironmentMap.containsKey(pe.Playground__c))
                ? playgroundEnvironmentMap.get(pe.Playground__c)
                : new List<Playground_Enviroment__c>();
            tmp.add(pe);
            playgroundEnvironmentMap.put(pe.Playground__c, tmp);
        }

        for (PlaygroundC1PRequest request : requests) {
            Playground_Job__c job = playgroundJobMap.get(request.playgroundJobId);

            if (job.Action__c == 'CreateCoeCredential') {
                if (job.Status__c != 'Completed') {
                    Map<String, Object> responseJson = new Map<String, Object>();
                    responseJson.put('hasError', false);
                    responseJson.put('Action', job.Action__c);
                    responseJson.put('error', null);
                    try {
                        if (job.Playground__r.Org_Credential__c == null) {
                            copado__Org__c coeCredential = new copado__Org__c();

                            String username = UserInfo.getUserName();
                            if (job.Playground__r.Custom_Signup_Request__c != null) {
                                if (job.Playground__r.Custom_Signup_Request__r.Username__c != null) {
                                    username = job.Playground__r.Custom_Signup_Request__r.Username__c;
                                }
                            }

                            coeCredential.Name = 'PLG+' + username + '+' + job.Playground__r.Name;
                            coeCredential.copado__Org_Type__c = 'Production/Developer';
                            coeCredential.copado__Test_Frequency__c = 'None';
                            coeCredential.copado__Username__c = username;
                            insert coeCredential;

                            Playground__c playground = new Playground__c(Id = job.Playground__c, Org_Credential__c = coeCredential.Id);
                            update playground;
                            responseJson.put('isSucccess', true);
                            responseJson.put('isFinished', true);
                            responseJson.put('message', 'Org Credential was created and Playground updated.');
                        } else {
                            responseJson.put('message', 'An Org Credential already existed. It was not overwritten.');
                        }
                        job.Status__c = 'Completed';
                        job.Payload__c = JSON.serializePretty(responseJson);
                        update job;
                    } catch (Exception e) {
                        responseJson.put('hasError', true);
                        responseJson.put('isSucccess', false);
                        responseJson.put('isFinished', true);
                        responseJson.put('message', e.getMessage());
                        responseJson.put('error', String.valueOf(e));
                        job.Payload__c = JSON.serializePretty(responseJson);
                        update job;
                    }
                }
            }

            if (job.Action__c == 'ExecutePostInstallScript') {
              if (job.Status__c != 'Completed') {
                Map<String, String> paramBody = new Map<String, String>();
                paramBody.put('C1P_ORGCREDENTIALID_CLIENT', job.Playground__r.Org_Credential__c);
                paramBody.put('ACTION', job.Action__c);
                paramBody.put('playgroundJobId', job.Id);


                paramBody.put('COPADO_DEPLOYER_PACKAGE_ID', settings.Copado_Deployer_Package_Id__c);
                cps_Helper.StartC1PJobFuture(paramBody);
              }
            }

            if (job.Action__c == 'AssignPermissionSet' ) {
                if (job.Status__c != 'Completed') {
                    Map<String, String> paramBody = new Map<String, String>();
                    paramBody.put('C1P_ORGCREDENTIALID_CLIENT', job.Playground__r.Org_Credential__c);
                    paramBody.put('ACTION', job.Action__c);
                    paramBody.put('playgroundJobId', job.Id);
                    cps_Helper.StartC1PJobFuture(paramBody);
                }
            }

            if (job.Action__c == 'ProvisionLicenses') {
                if (job.Status__c != 'Completed' && job.Status__c != 'Failed') {
                    if (request.daysOfLicense == 0)
                        request.daysOfLicense = 30;
                    Playground_Enviroment__c coe = new Playground_Enviroment__c();
                    for (Playground_Enviroment__c pe : playgroundEnvironmentMap.get(job.Playground__c)) {
                        if (pe.Type__c == 'CoE_Org')
                            coe = pe;
                    }

                    // Id has to be in 15 characters format
                    String orgId = coe.Org_Id__c;
                    if (orgId.length() == 18)
                        orgId = orgId.left(15);

                    // Setting up constants
                    String apiKey = cps_Crypto.decryptString(settings.Production_Api_Key__c);
                    String baseUrl = settings.Licensing_Endpoint__c;
                    String convertEndpoint = baseUrl + '/convertLead/' + orgId;
                    String provisionEndpoint = baseUrl + '/provisionLicenses/' + orgId;
                    String updateEndpoint = baseUrl + '/updatelicense/' + orgId;
                    String expireInDays = String.valueOf(request.daysOfLicense);
                    String body = '';
                    Integer responseCode = 400;

                    Map<String, String> paramBody = new Map<String, String>();
                    paramBody.put('C1P_ORGCREDENTIALID_CLIENT', job.Playground__r.Org_Credential__c);
                    paramBody.put('ACTION', job.Action__c);
                    paramBody.put('ORGID', orgId);
                    paramBody.put('APIKEY', apiKey);
                    paramBody.put('BASEENDPOINT', baseUrl);
                    paramBody.put('EXPIREINDAYS', expireInDays);
                    paramBody.put('playgroundJobId', job.Id);
                    cps_Helper.StartC1PJobFuture(paramBody);
                }
            }

            if (job.Action__c == 'CreateEnvironment' || job.Action__c == 'CreateScratchOrgEnvironment') {
                if (job.Status__c != 'Completed') {
                    String environmentNames = '';
                    for (Playground_Enviroment__c env : playgroundEnvironmentMap.get(job.Playground__c)) {
                        if ((env.Type__c == 'Sandbox' || env.Type__c == 'Scratch_Org') && (env.Access_Token__c == null && env.InstanceUrl__c == null )) {
                            environmentNames += env.Name + ';';
                        }
                    }
                    environmentNames = environmentNames.removeEnd(';');
                    Map<String, String> paramBody = new Map<String, String>();
                    paramBody.put('C1P_ORGCREDENTIALID_CLIENT', job.Playground__r.Org_Credential__c);
                    paramBody.put('ACTION', job.Action__c);
                    paramBody.put('ENVIRONMENT_NAMES', environmentNames);
                    paramBody.put('playgroundJobId', job.Id);
                    cps_Helper.StartC1PJobFuture(paramBody);
                }
            }

            if (job.Action__c == 'CreateOrgCredentials') {
                if (job.Status__c != 'Completed') {
                    String orgNames = '';
                    String orgTypes = '';
                    for (Playground_Enviroment__c env : playgroundEnvironmentMap.get(job.Playground__c)) {
                        orgNames += env.Name + ';';
                        orgTypes += env.Type__c == 'CoE_Org' ? 'Production/Developer;' : 'Sandbox;';
                    }

                    String redirectUrl = settings.Community_URL__c + '/s/playground/' + job.Playground__c + '/' + job.Playground__r.Name;

                    Map<String, String> paramBody = new Map<String, String>();
                    paramBody.put('C1P_ORGCREDENTIALID_CLIENT', job.Playground__r.Org_Credential__c);
                    paramBody.put('ACTION', job.Action__c);
                    paramBody.put('ORGCREDENTIAL_NAMES', orgNames);
                    paramBody.put('ORGCREDENTIAL_TYPES', orgTypes);
                    paramBody.put('REDIRECT_URL', redirectUrl);
                    paramBody.put('X_CLIENT_KEY', settings.Copado_Client_Key__c);
                    paramBody.put('playgroundJobId', job.Id);
                    cps_Helper.StartC1PJobFuture(paramBody);
                }
            }

            if (job.Action__c == 'AddingFinishingTouches') {
                Map<String,Map<String, String>> Parambodies = new Map<String,Map<String, String>>();
                if (job.Status__c != 'Completed') {
                    Map<String, String> paramBody = new Map<String, String>();
                    //EnableUser
                    paramBody.put('C1P_ORGCREDENTIALID_CLIENT', job.Playground__r.Org_Credential__c);
                    paramBody.put('ACTION', job.Action__c);
                    paramBody.put('playgroundJobId', job.Id);

                    //GitSetupFinish
                    String gitToken = (job.Playground__r.Git_Token__c != null) ? cps_Crypto.decryptString(job.Playground__r.Git_Token__c) : '';
                    paramBody.put('GIT_ACCESS_TOKEN', gitToken);
                    paramBody.put('GIT_USERNAME', job.Playground__r.Git_Username__c);
                    paramBody.put('GIT_REPONAME', 'Copado-' + job.Playground__r.Name.replaceAll(' ', ''));

                        String branchesName = '';
                    String environmentNames = '';
                        for (Playground_Enviroment__c env : playgroundEnvironmentMap.get(job.Playground__c)) {
                            if (env.Type__c == 'Sandbox' || env.Type__c == 'Scratch_Org' ) {
                            environmentNames += env.Name + ';';
                                if (env.Name != 'Production')
                                    branchesName += env.Name + ';';
                            }
                        }
                        paramBody.put('COMMIT_HASH', job.Playground__r.Commit_Hash__c);
                        paramBody.put('BRANCHES', branchesName);
                    String apiKey = (job.Playground__r.Api_Key__c != null) ? cps_Crypto.decryptString(job.Playground__r.Api_Key__c) : '';
                    paramBody.put('API_KEY', apiKey);

                    paramBody.put('ENVIRONMENT_NAMES', environmentNames);
                    paramBody.put('VSM_PACKAGE_ID', settings.VSM_Package_Id__c);

                    cps_Helper.StartC1PJobFuture(paramBody);
                }
            }
        }
    }

    @future(callout=true)
    public static void StartC1PJobFuture(Map<String, String> params) {
        Playground_Setting__mdt playgroundSetting = [
            SELECT C1P_API_Endpoint__c, C1P_Platform_Job_Id__c, C1P_API_Key__c
            FROM Playground_Setting__mdt
            WHERE QualifiedApiName = :cps_Helper.SETTINGS_NAME
            LIMIT 1
        ];

        String c1pEndpoint =
            playgroundSetting.C1P_API_Endpoint__c +
            playgroundSetting.C1P_Platform_Job_Id__c +
            '/start?api_key=' +
            playgroundSetting.C1P_API_Key__c;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(c1pEndpoint);
        request.setMethod(HttpMethods.POST.name());
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(params));

      Playground_Job__c job = new Playground_Job__c(Id = params.get('playgroundJobId'));
        HttpResponse httpResponse;
        try {
            httpResponse = http.send(request);
        } catch (Exception e) {
            job.Status__c = 'Failed';
            job.Output__c = 'retry=true';
            job.Label__c = 'Exception message: ' + e.getMessage();
            update job;
            return;
        }

        if (httpResponse.getStatusCode() == 200) {
            Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
            if (Boolean.valueOf(response.get('isSuccess')) == true) {
                job.JobId__c = String.valueOf(response.get('copadoJobId'));
            } else {
                job.Status__c = 'Failed';
                job.Output__c = 'retry=true';
                job.Label__c = 'Error:\n' +  httpResponse.getBody();
            }
        } else {
            job.Status__c = 'Failed';
            job.Output__c = 'retry=true';
            job.Label__c = 'Status ' + httpResponse.getStatusCode() + '(' + httpResponse.getStatus() + '): ' + httpResponse.getBody();
        }
        update job;
    }

    // Wrapper class for my custom exception data
    public class cpsResponse {
        public String name;
        public String message;
        public Boolean isSuccess;
        public Integer code;

        public cpsResponse(String name, String message, Boolean isSuccess, Integer code) {
            this.name = name;
            this.message = message;
            this.isSuccess = isSuccess;
            this.code = code;
        }
    }
}