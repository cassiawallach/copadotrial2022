public without sharing class PlaygroundJobService {

    public static Map<Id, Playground__c> playgroundsToUpdate = new Map<Id, Playground__c>();
    public static Map<Id, List<Playground_Enviroment__c>> pgEnvironments = new Map<Id, List<Playground_Enviroment__c>>();
    public static Map<Id, Playground_Enviroment__c> pgEnvsToUpdate = new Map<Id, Playground_Enviroment__c>();

    //public static Map<Id, Playground__c> playgroundMap = new Map<Id, Playground__c>();

    public static void prepareData(List<SObject> records){
        if(records==null) return;
        Set<Id> playgroundIds = new Set<Id>();
        List<Playground_Job__c> playgroundJobs = (List<Playground_Job__c>)records;
        for (Playground_Job__c pj : playgroundJobs) {
            playgroundsToUpdate.put(pj.Playground__c, new Playground__c(Id=pj.Playground__c));
            playgroundIds.add(pj.Playground__c);
        }
        //playgroundMap = new Map<Id, Playground__c>([select Id, Using_Trial_Org__c, Trial_Org_Id__c, Org_Id__c from Playground__c where Id IN:playgroundIds]);

        for (Playground_Enviroment__c pe : [select Id, Name, Authorization_URL__c, Status__c, Playground__c,InstanceUrl__c, Access_Token__c from Playground_Enviroment__c where Playground__c IN:playgroundIds]) {
            List<Playground_Enviroment__c> tmp = (pgEnvironments.containsKey(pe.Playground__c)) ? pgEnvironments.get(pe.Playground__c) : new List<Playground_Enviroment__c>();
            tmp.add(pe);
            pgEnvironments.put(pe.Playground__c, tmp);
            pgEnvsToUpdate.put(pe.Id, pe);
        }
    }

    public static void checkActionPayload(Playground_Job__c oldPj, Playground_Job__c pj){
        try {
            String payload = EncodingUtil.urlDecode(pj.Payload__c, 'UTF-8');
            pj.Payload__c = payload;

            handleStatusUpdate(oldPj, pj);
            handleGitSetup(oldPj, pj);
            handleCreateOrgCredentials(oldPj, pj);
            handleExecutePostInstallScript(oldPj, pj);
            handleCreateEnvironment(oldPj, pj);
            handlerCreateScratchOrgEnvironment(oldPj, pj);
            handlerAddingFinishingTouches(oldPj, pj);

            if (pj.Status__c != 'Failed' && pj.Status__c != 'Completed') {
                pj.Status__c = 'Failed';
            }
        }
        catch (Exception e) {
        }
    }
    private static void handleStatusUpdate(Playground_Job__c oldPj, Playground_Job__c pj) {
        Map<String, Object> payloadObj = parsePayload(pj.Payload__c);
        if (payloadObj.containsKey('action') && payloadObj.containsKey('hasError')) {
            pj.Status__c = (payloadObj.containsKey('hasError') && payloadObj.get('hasError')==true)? 'Failed' : 'Completed';
        }
    }
    private static void handlerAddingFinishingTouches(Playground_Job__c oldPj, Playground_Job__c pj) {
        if (pj.Action__c!='AddingFinishingTouches') return;
        Boolean hasError = false;
        Map<String, Object> payloadObj = parsePayload(pj.Payload__c);
        if (payloadObj.containsKey('enableUser') && !hasError){
            if (String.valueOf(payloadObj.get('enableUser')) == '') {
                hasError = true;
            } else {
                Map<String, Object> enableUser = (Map<String, Object>) payloadObj.get('enableUser');
                hasError = (handleEnableUser(enableUser, pj) && !hasError) ? false : true;
            }
        }
        if (payloadObj.containsKey('gitRepoFinalSetup') && !hasError){
            if (String.valueOf(payloadObj.get('gitRepoFinalSetup')) == '') {
                hasError = true;
            } else {
                Map<String, Object> gitRepoFinalSetup = (Map<String, Object>) payloadObj.get('gitRepoFinalSetup');
                hasError = (handleGitSetupFinish(gitRepoFinalSetup, pj) && !hasError)  ? false : true;
            }
        }
        if (payloadObj.containsKey('installVSMInstallation') && !hasError){
            if (String.valueOf(payloadObj.get('installVSMInstallation')) == '') {
                hasError = true;
            } else {
                Map<String, Object> installVSMInstallation = (Map<String, Object>) payloadObj.get('installVSMInstallation');
                hasError = (handleFinalTouchBasicResponse(installVSMInstallation, 'installVSM') && !hasError)  ? false : true;
            }
        }
        if (payloadObj.containsKey('createGitSnapshot') && !hasError){
            if (String.valueOf(payloadObj.get('createGitSnapshot')) == '') {
                hasError = true;
            } else {
                Map<String, Object> createGitSnapshot = (Map<String, Object>) payloadObj.get('createGitSnapshot');
                hasError = (handleCreateGitSnapshot(createGitSnapshot, pj) && !hasError)  ? false : true;
            }
        }
        if (payloadObj.containsKey('createBranches') && !hasError){
            if (String.valueOf(payloadObj.get('createBranches')) == '') {
                hasError = true;
            } else {
                Map<String, Object> createBranches = (Map<String, Object>) payloadObj.get('createBranches');
                hasError = (handleFinalTouchBasicResponse(createBranches, 'CreateBranches') && !hasError)  ? false : true;
            }
        }
        if (payloadObj.containsKey('createBoilerplate') && !hasError){
            if (String.valueOf(payloadObj.get('createBoilerplate')) == '') {
                hasError = true;
            } else {
                Map<String, Object> createBoilerplate = (Map<String, Object>) payloadObj.get('createBoilerplate');
                hasError = (handleCreateBoilerplate(createBoilerplate, pj) && !hasError)  ? false : true;
            }
        }

        if(hasError){
            pj.Status__c = 'Failed';
            pj.Output__c = 'retry=true';
        } else {
            pj.Status__c = 'Completed';
            pj.Output__c = '';
        }
    }
    private static void handleCreateOrgCredentials(Playground_Job__c oldPj, Playground_Job__c pj) {
        if (pj.Action__c!='CreateOrgCredentials') return;
        Map<String, Object> payloadObj = parsePayload(pj.Payload__c);
        if (!payloadObj.containsKey('data')) return;
        Map<String, Object> data = (Map<String, Object>) payloadObj.get('data');

        for (Playground_Enviroment__c env : pgEnvironments.get(pj.Playground__c)) {
            Playground_Enviroment__c e = pgEnvsToUpdate.get(env.Id);
            e.Authorization_URL__c = String.valueOf(data.get(e.Name));
            e.Status__c = 'Created';
            pgEnvsToUpdate.put(e.Id, e);
        }
    }
    private static void handleGitSetup(Playground_Job__c oldPj, Playground_Job__c pj) {
        if (pj.Action__c!='GitSetup') return;
        Map<String, Object> payloadObj = parsePayload(pj.Payload__c);
        if (payloadObj.containsKey('data')) {
            Map<String, Object> data = (Map<String, Object>) payloadObj.get('data');
            if (payloadObj.get('hasError')==false && data.containsKey('username') && data.containsKey('token')) {
                Playground__c playground = playgroundsToUpdate.get(pj.Playground__c);
                playground.Git_Username__c = data.get('username').toString();
                playground.Git_Token__c = (data.get('token')!=null)?cps_Crypto.encryptString(data.get('token').toString()):'';
                playgroundsToUpdate.put(pj.Playground__c, playground);
                pj.Payload__c = null;
                pj.Output__c = 'continue=true';
            }

            //{"action":"GitSetup","hasError":true,"data":{"message":"Repository creation failed.","errors":[{"resource":"Repository","code":"custom","field":"name","message":"name already exists on this account"}],"documentation_url":"https://developer.github.com/v3/repos/#create"}}
            else if (payloadObj.get('hasError')==true && data.containsKey('message') && String.valueOf(data.get('message')).contains('Repository creation failed')) {
                if (data.containsKey('errors') && ((List<Object>)data.get('errors')).size()>0) {
                    String errors = String.valueOf(data.get('errors'));
                    system.debug('errors to string: '+errors);
                    if (errors.contains('name already exists on this account')) {
                        pj.Output__c = 'DUPLICATE_GIT_REPOSITORY';
                        pj.Status__c = 'Failed';
                    }
                    pj.Label__c = errors;
                }
            }
        }
    }
    private static void handleExecutePostInstallScript(Playground_Job__c oldPj, Playground_Job__c pj) {
        if (pj.Action__c!='ExecutePostInstallScript') return;
        Map<String, Object> payloadObj = parsePayload(pj.Payload__c);
        system.debug(payloadObj);
        if (!payloadObj.containsKey('data')) return;
        Map<String, Object> data = (Map<String, Object>) payloadObj.get('data');
        pj.Payload__c = JSON.serialize(payloadObj);
        if (data.containsKey('message')) {
            pj.Output__c = data.get('message').toString();
        }
    }
    private static void handleCreateEnvironment(Playground_Job__c oldPj, Playground_Job__c pj) {
        if (pj.Action__c!='CreateEnvironment') RETURN;
        if (pj.Payload__c.contains('\'SandboxProcess\' is not supported')){
            pj.Output__c = 'SANDBOXES_NOT_SUPPORTED_FOR_ORG'; //this string will be used by ProcessBuilder.
            pj.Status__c = 'Failed';
            Map<String, Object> resultPayload = new Map<String, Object>();
            resultPayload.put('action', pj.Action__c);
            resultPayload.put('hasError', true);
            resultPayload.put('isSuccess', false);
            resultPayload.put('isFinished', true);
            Map<String, Object> dataPayload = new Map<String, Object>();
            dataPayload.put('message', 'Sandbox creation is not supported for this org. Please create a Copado Trial Org for your Playground.');
            resultPayload.put('data', dataPayload);
            pj.Payload__c = JSON.serializePretty(resultPayload);
            pj.Remaining_Retry_Attempts__c = 0;
        } else {
            Boolean hasError = false;
            Map<String, Object> payloadObj = parsePayload(pj.Payload__c);
            for (Playground_Enviroment__c env : pgEnvironments.get(pj.Playground__c)) {
                Playground_Enviroment__c e = pgEnvsToUpdate.get(env.Id);
            
                if(payloadObj.containsKey(e.Name)) {
                    Map<String, Object> data = (Map<String, Object>) payloadObj.get(e.Name);
                    if (!(data.get('hasError')==false && data.containskey('data'))) {
                        hasError = true;
                    }
                }
            }

            if(hasError) {
                pj.Status__c = 'Failed';
            } else {
                pj.Status__c = 'Completed';
            }
        }

    }
    private static void handlerCreateScratchOrgEnvironment(Playground_Job__c oldPj, Playground_Job__c pj) {
    
        if (pj.Action__c!='CreateScratchOrgEnvironment') RETURN;
        Boolean hasError = false;
        Map<String, Object> payloadObj = parsePayload(pj.Payload__c);      
        for (Playground_Enviroment__c env : pgEnvironments.get(pj.Playground__c)) {
            Playground_Enviroment__c e = pgEnvsToUpdate.get(env.Id);
           
            if(payloadObj.containsKey(e.Name)) {
                Map<String, Object> data = (Map<String, Object>) payloadObj.get(e.Name);
                if(data.get('hasError')==false && data.containskey('data')) {                                
                    Map<String,Object> result = (Map<String, Object>)data.get('data');                    
                    if(result.containsKey('result')) {
                        Map<String,Object> resultValues = (Map<String, Object>)result.get('result');                                           
                        e.Access_Token__c = resultValues.get('accessToken').toString();
                        e.InstanceUrl__c =  resultValues.get('instanceUrl').toString();                        
                        pgEnvsToUpdate.put(e.Id, e);
                    }
                } else {
                    hasError = true;
                }
            }
        } 

        if(hasError) {
            pj.Status__c = 'Failed';
        } else {
            pj.Status__c = 'Completed';
        }
    }
    private static Boolean handleEnableUser(Map<String, Object> payloadObj , Playground_Job__c pj) {
        if (payloadObj.containsKey('data')) {
            Map<String, Object> data = (Map<String, Object>) payloadObj.get('data');
            if (data.containsKey('user_api_key')) {
                Playground__c playground = playgroundsToUpdate.get(pj.Playground__c);
                playground.Api_Key__c = cps_Crypto.encryptString(data.get('user_api_key').toString());
                playgroundsToUpdate.put(pj.Playground__c, playground);
                return true;
            }
        }
        return false;
    }
    private static Boolean handleFinalTouchBasicResponse(Map<String, Object> payloadObj, String actionName) {
        if (payloadObj.containsKey('action') && payloadObj.get('action') == actionName && payloadObj.containsKey('hasError') && payloadObj.get('hasError') == false) {
            return true;
        }
        return false;
    }
    private static Boolean handleGitSetupFinish(Map<String, Object> payloadObj, Playground_Job__c pj) {
        if (payloadObj.containsKey('data') && payloadObj.containsKey('hasError') && payloadObj.get('hasError') == false) {
            Map<String, Object> data = (Map<String, Object>) payloadObj.get('data');
            if (data.containsKey('commitHash')) {
                return true;
            }
        }
        return false;
    }
    private static Boolean handleCreateGitSnapshot(Map<String, Object> payloadObj, Playground_Job__c pj) {
        if (payloadObj.containsKey('data') && payloadObj.containsKey('hasError') && payloadObj.get('hasError') == false) {
            Map<String, Object> data = (Map<String, Object>) payloadObj.get('data');
            if (data.containsKey('commitHash')) {
                if (data.get('commitHash') == null) {
                    return true;
                }
                Playground__c playground = playgroundsToUpdate.get(pj.Playground__c);
                playground.Commit_Hash__c = data.get('commitHash').toString();
                playgroundsToUpdate.put(pj.Playground__c, playground);
                return true;
            }
        }
        return false;
    }
    private static Boolean handleCreateBoilerplate(Map<String, Object> payloadObj, Playground_Job__c pj) {
        if (payloadObj.containsKey('hasError') && payloadObj.get('hasError') == false) {
            return true;
        }
        return false;
    }
    public static Map<String, Object> convertJson(String payloadString){
        RETURN parsePayload(payloadString);
    }
    private static Map<String, Object> parsePayload(String payloadString) {
        if(payloadString==null) return new Map<String, Object>();

        Map<String, Object> payloadObj = new Map<String, Object>();
        try{
            //clean payloadString of carriage returns;
            payloadString = payloadString.replaceAll('\n','');
            payloadObj = (Map<String, Object>) JSON.deserializeUntyped(payloadString);
        }
        catch(Exception e) {
            system.debug(payloadString);
            system.debug('@@@ Error parsing payloadString: '+e.getMessage());
        }
        return payloadObj;
    }

    public static void resetJob(Playground_Job__c oldPj, Playground_Job__c pj) {
        if(oldPj.Status__c=='Failed' && (pj.Status__c=='Pending' || pj.Status__c=='In progress')) {
            pj.Payload__c = null;
            pj.JobId__c = null;
            pj.Platform_Job_Execution__c = null;
        }
    }

    public static void callC1P(Playground_Job__c oldPj, Playground_Job__c pj) {
        Set<String> actions = new Set<String>{'ExecutePostInstallScript', 'AssignPermissionSet', 'EnableUser', 'ProvisionLicenses', 'CreateEnvironment', 'CreateOrgCredentials', 'GitSetupFinish', 'CreateBranches', 'CreateGitSnapshot', 'CreateBoilerplate', 'CreateCoeCredential', 'CreateScratchOrgEnvironment', 'AddingFinishingTouches' };
            if(oldPj.Status__c!=pj.Status__c && pj.Status__c=='In progress' && actions.contains(pj.Action__c)) {
                cps_Helper.PlaygroundC1PRequest playroundRequest = new cps_Helper.PlaygroundC1PRequest();
                playroundRequest.playgroundJobId = pj.Id;
                playroundRequest.daysOfLicense = 30;
                cps_Helper.callC1Pactions(new List<cps_Helper.PlaygroundC1PRequest> {playroundRequest});

                Playground_Job_Event__e playgroundJobEvent = new Playground_Job_Event__e(
                    Action__c = pj.Action__c,
                    Copado_Job_Id__c = pj.JobId__c,
                    Playground_Id__c = pj.Playground__c,
                    Record_Id__c = pj.Id,
                    Status__c = pj.Status__c,
                    IsFinished__c = (pj.Status__c == 'Completed' || pj.Status__c == 'Failed'),
                    IsSuccess__c = pj.Status__c == 'Completed'
                );

                EventBus.publish(playgroundJobEvent);
            }
    }

    public static void updatePlaygrounds() {
        if(playgroundsToUpdate!=null) update playgroundsToUpdate.values();
    }
    public static void updatePlaygroundEnvironments() {
        if(pgEnvsToUpdate!=null) update pgEnvsToUpdate.values();
    }
}