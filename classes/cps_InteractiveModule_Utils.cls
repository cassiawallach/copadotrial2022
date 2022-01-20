/**
 * Class to be use to create util methods for Interactive Mudule
 */
global without sharing class cps_InteractiveModule_Utils {
    public enum HttpMethods {GET, POST, PUT}
    public static final String SETTINGS_NAME = 'Default_Values';

    @AuraEnabled
    global static Boolean checkOrgType() {
        Boolean orgType = ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox);
    
        return orgType;
    }
    
    @AuraEnabled
    global static List<Playground__c> getPlaygroundRecords() {
        String lastUsePlaygroundId = '';
        List<Playground__c> playgrounds =  new List<Playground__c>();

        Map<Id, Playground__c> playgroundMap = new Map<Id, Playground__c>([select Id, Name, Org_Credential__c from Playground__c where Status__c='Activated' and Playground_Configuration__c <> 'Light Configuration' and User__c=:UserInfo.getUserId() limit 100]);

        Validation_Execution__c ivse = new Validation_Execution__c();
        for(Validation_Execution__c ivs : [Select Id, Name, Playground__c, LastModifiedDate From Validation_Execution__c Where Playground__c IN :playgroundMap.keySet() AND Playground__c <> null Order By LastModifiedDate DESC Limit 1]){
            ivse = ivs;
        }
        
        Step_Execution__c se = new Step_Execution__c();
        for(Step_Execution__c s : [Select Id, Name, Playground__c, LastModifiedDate From Step_Execution__c Where Playground__c IN :playgroundMap.keySet() AND Playground__c <> null Order By LastModifiedDate DESC Limit 1]){
            se = s;
        }

        if(ivse != null && se != null){
            if (ivse.LastModifiedDate > se.LastModifiedDate) {
                lastUsePlaygroundId = ivse.Playground__c;
            } else {
                lastUsePlaygroundId = se.Playground__c;
            }
        } else if (ivse != null) {
            lastUsePlaygroundId = ivse.Playground__c;
        } else if (se != null) {
            lastUsePlaygroundId = se.Playground__c;
        }

        if (lastUsePlaygroundId != null && playgroundMap.containsKey(lastUsePlaygroundId)) {
            playgrounds.add(playgroundMap.get(lastUsePlaygroundId));
        }
        
        for (Id pId : playgroundMap.keySet()) {
            if (pId != lastUsePlaygroundId) {
                playgrounds.add(playgroundMap.get(pId));
            }
        }

        return playgrounds;
    }

    @AuraEnabled
    global static List<Playground_Enviroment__c> getPlaygroundEnv(String playgroundId) {
        List<Playground_Enviroment__c> playgroundEnvs = new List<Playground_Enviroment__c>();

        for(Playground_Enviroment__c pe : [Select Id, Name From Playground_Enviroment__c Where Playground__c = :playgroundId]) {
            playgroundEnvs.add(pe);
        }

        if (!playgroundEnvs.isEmpty()) {
            return playgroundEnvs;
        }
        return null;
    }

    @AuraEnabled
    public static String getFrontDoorUrl(Id orgId) {
        Playground_Enviroment__c playgroundEnviroment = [SELECT Authorization_URL__c, Playground__r.Api_Key__c FROM Playground_Enviroment__c WHERE Id = :orgId LIMIT 1];
        if (playgroundEnviroment != null && playgroundEnviroment.Authorization_URL__c != null) {
            String OrgCredentialId = cps_Helper.getOrgCredentialIdFromAuthorizationUrl(playgroundEnviroment.Authorization_URL__c);
            String apiKeyToOpenEnv = cps_Crypto.decryptString(playgroundEnviroment.Playground__r.Api_Key__c);
            
            return createFrontDoorRequest(OrgCredentialId, apiKeyToOpenEnv);
        }
        return null;
    }

    public static String createFrontDoorRequest(Id OrgCredentialId, String apiKeyToOpenEnv) {
        Playground_Setting__mdt playgroundSetting = [select Copado_Client_Key__c, C1P_Api_Key__c from Playground_Setting__mdt where QualifiedApiName=:cps_Helper.SETTINGS_NAME limit 1];
        if (apiKeyToOpenEnv == null) {
            apiKeyToOpenEnv = playgroundSetting.C1P_Api_Key__c;
        }
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://app-api.copado.com/json/v1/webhook/copadoSession/'+OrgCredentialId+'?api_key='+apiKeyToOpenEnv);
        request.setMethod(HttpMethods.GET.name());
        request.setHeader('X-Client-Key', playgroundSetting.Copado_Client_Key__c);
        
        HttpResponse httpResponse;
        
        try{
            httpResponse = http.send(request);
            system.debug('@@@' + httpResponse.getBody());
            return httpResponse.getBody();
        } catch(Exception e) {
            throw e;
        }
    }

    public static Map<String, Object> parsePayload(String payloadString) {
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

    /**
     * Executes a C1P Job in CopadoC1P, for those methods that are not in ProcessBuilder
     * This method is used by the ConnectController and WizardController.
     * @param params   Payload as a JSON
     * @return copadoJobId
     */
    @future(callout=true)
    public static void startC1PJob(Map<String, String> param, Id requestExecutionId) {

        Interactive_Modules_Setting__mdt interactiveModulesSetting = [
            SELECT C1P_API_Endpoint__c, Platform_Job_Id__c, C1P_API_Key__c, Production_API_Key__c, X_Client_Key__c, Github_Repository_URL__c, Github_Readonly_Key__c
            FROM Interactive_Modules_Setting__mdt
            WHERE QualifiedApiName = :cps_InteractiveModule_Utils.SETTINGS_NAME
            LIMIT 1
        ];

        param.put('API_KEY', interactiveModulesSetting.Production_API_Key__c);
        param.put('X_CLIENT_KEY', interactiveModulesSetting.X_Client_Key__c);

        String c1pEndpoint = interactiveModulesSetting.C1P_API_Endpoint__c + 
            interactiveModulesSetting.Platform_Job_Id__c + 
            '/start?api_key=' + 
            interactiveModulesSetting.C1P_API_Key__c;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(c1pEndpoint);
        request.setMethod(HttpMethods.POST.name());
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(param));
        HttpResponse httpResponse;
        // Send request
        try {
            httpResponse = http.send(request);
        } catch (Exception e) {
            throw e;
        }
        System.debug(':::::::::::::: sent request'+httpResponse.getStatusCode());
        if (httpResponse.getStatusCode() == 200) {
            Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());

            Schema.sObjectType soType = requestExecutionId.getSObjectType();
            if (String.valueOf(soType) == 'Validation_Execution__c') {
                Validation_Execution__c veToBeUpdate = new Validation_Execution__c(Id = requestExecutionId);
                if (Boolean.valueOf(response.get('isSuccess')) == true) {
                    veToBeUpdate.JobId__c = String.valueOf(response.get('copadoJobId'));
                } else {
                    veToBeUpdate.Status__c = 'Failed';
                }
                
                update veToBeUpdate;
            } else if (String.valueOf(soType) == 'Configuration_Execution__c') {
                Configuration_Execution__c ceToBeUpdate = new Configuration_Execution__c(Id = requestExecutionId);
                if (Boolean.valueOf(response.get('isSuccess')) == true) {
                    ceToBeUpdate.JobId__c = String.valueOf(response.get('copadoJobId'));
                } else {
                    ceToBeUpdate.Status__c = 'Failed';
                }
                
                update ceToBeUpdate;
            }
        } else {

            Schema.sObjectType soType = requestExecutionId.getSObjectType();
            if (String.valueOf(soType) == 'Validation_Execution__c') {
                Validation_Execution__c veToBeUpdate = new Validation_Execution__c(Id = requestExecutionId, Status__c = 'Failed');
                
                update veToBeUpdate;
            } else if (String.valueOf(soType) == 'Configuration_Execution__c') {
                Configuration_Execution__c ceToBeUpdate = new Configuration_Execution__c(Id = requestExecutionId, Status__c = 'Failed');
                
                update ceToBeUpdate;
            }
        }
    }
}