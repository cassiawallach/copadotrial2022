public with sharing class ConfigExecutionTriggerHelper implements ITrigger {
    public void bulkBefore(){}
    
    public void bulkAfter(){}
    
    public void beforeInsert(SObject so){}
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Configuration_Execution__c oldCe = (Configuration_Execution__c)oldSo;
        Configuration_Execution__c ce = (Configuration_Execution__c)so;
		resetJob(oldCe, ce);
        checkPayload(oldCe, ce);
    }
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){
        Configuration_Execution__c oldCe = (Configuration_Execution__c)oldSo;
        Configuration_Execution__c ce = (Configuration_Execution__c)so;
		sendCalloutRequest(oldCe, ce);
        stepExecutionStatusChange(oldCe, ce);
    }
    
    public void afterDelete(SObject so){}
    public void andFinally(){}

    public void resetJob(Configuration_Execution__c oldCe, Configuration_Execution__c ce){
        if((oldCe.Status__c =='Failed' || oldCe.Status__c == 'Completed') && (ce.Status__c == 'Pending' || ce.Status__c == 'In progress')) {
            ce.Payload__c = null;
            ce.JobId__c = null;
            ce.Platform_Job_Execution__c = null;
        }
    }

    public void checkPayload(Configuration_Execution__c oldCe, Configuration_Execution__c ce){
        if(ce.Payload__c == null) {return;}
        try {
            String payload = EncodingUtil.urlDecode(ce.Payload__c, 'UTF-8');
            ce.Payload__c = payload;
        	Map<String, Object> payloadObj = cps_InteractiveModule_Utils.parsePayload(ce.Payload__c);

            if (payloadObj.containsKey('hasError') && (payloadObj.get('hasError') == 'false' || payloadObj.get('hasError') == false)) {

                if (payloadObj.containsKey('data')) {
                    List<Object> data = (List<Object>)payloadObj.get('data');

                    List<Step_Execution__c> stepExecution = new List<Step_Execution__c>();
                    for (Object sr : data) {
                        Map<String, Object> stepResult = (Map<String, Object>)sr;
                        for (String pKey : stepResult.keySet()) {
                            if (pKey instanceOf Id && String.valueOf(Id.valueOf(pKey).getSObjectType()) == 'Step_Execution__c') {
                                Map<String, Object> stepResultJSON = (Map<String, Object>)stepResult.get(pKey);
                                String stepExecutionPayload = JSON.serialize(stepResultJSON);
                                stepExecution.add(new Step_Execution__c(
                                    Id = pKey,
                                    Payload__c = stepExecutionPayload
                                ));
                            }
                        }
                    }

                    if (!stepExecution.isEmpty()) {
                        update stepExecution;
                    }
                }
            	ce.Status__c = 'Completed';
            } else {
            	ce.Status__c = 'Failed';
            }
        }
        catch (Exception e) {
        }
    }
    public void stepExecutionStatusChange(Configuration_Execution__c oldCe, Configuration_Execution__c ce){
        if(oldCe.Status__c != ce.Status__c && (ce.Status__c == 'Pending' || ce.Status__c == 'In progress' || ce.Status__c == 'Failed')) {
            List<Step_Execution__c> stepExeToBeUpdate = new List<Step_Execution__c>();
            for(Step_Execution__c se : [Select Id, Name, Status__c From Step_Execution__c 
                                                                Where Configuration_Execution__c =:ce.Id
                                                                AND Status__c <> 'Completed']){
                se.Status__c = (ce.Status__c == 'Failed') ? 'Pending' : ce.Status__c;
                stepExeToBeUpdate.add(se);
            }

            if(!stepExeToBeUpdate.isEmpty()){
                update stepExeToBeUpdate;
            }
        }

        if (oldCe.Status__c != ce.Status__c) {
            Step_Execution_Event__e stepExeEvent = new Step_Execution_Event__e(
                Record_Id__c = ce.Id,
                Status__c = ce.Status__c,
                IsFinished__c = (ce.Status__c == 'Completed' || ce.Status__c == 'Failed'),
                Learning_Assignment_Id__c = ce.Learning_Assignment__c
            );
    
            EventBus.publish(stepExeEvent);
        }
    }

    public void sendCalloutRequest(Configuration_Execution__c oldCe, Configuration_Execution__c ce){
        if(oldCe.Status__c != ce.Status__c && ce.Status__c == 'In progress') {

            Interactive_Modules_Setting__mdt interactiveModulesSetting = [
                SELECT C1P_API_Endpoint__c, Platform_Job_Id__c, C1P_API_Key__c, Production_API_Key__c, X_Client_Key__c, Github_Repository_URL__c, Github_Readonly_Key__c
                FROM Interactive_Modules_Setting__mdt
                WHERE QualifiedApiName = :cps_InteractiveModule_Utils.SETTINGS_NAME LIMIT 1];
            Map<String, String> paramBodyToBeSend = new Map<String, String>();
            List<Map<String, Map<String, String>>> paramBodySetupList = new List<Map<String, Map<String, String>>>();

            for(Step_Execution__c se : [Select Id, ApiKey__c, Target_Instance_URL__c, OrgCredentialId__c, Trial_Org_Credential_Id__c,
                            Configuration_Step__r.Type__c, Configuration_Step__r.Apex_Script__c, Configuration_Step__r.Branch__c,
                            Configuration_Step__r.Package_Id__c, Configuration_Step__r.Org__c, Configuration_Step__r.Package_Installation_Key__c
                            From Step_Execution__c 
                            Where Configuration_Execution__c =: ce.Id AND Status__c <> 'Completed']){

                Map<String, String> paramBody = new Map<String, String>();
            
                if(se.Configuration_Step__r.Type__c == 'Package Installation'){
                    paramBody.put('ACTION', 'INSTALL_PACKAGE');
                    paramBody.put('PACKAGE_ID', se.Configuration_Step__r.Package_Id__c);
                    String packageInstallationKey = (se.Configuration_Step__r.Package_Installation_Key__c != null) ? cps_Crypto.decryptString(se.Configuration_Step__r.Package_Installation_Key__c) : '';
                    paramBody.put('PACKAGE_INSTALLATION_KEY', packageInstallationKey);
                } else if(se.Configuration_Step__r.Type__c == 'Metadata Deploy'){
                    paramBody.put('ACTION', 'DEPLOY_METADATA');
                    paramBody.put('BRANCH_NAME', se.Configuration_Step__r.Branch__c);
                    paramBody.put('PRIVATE_REPOSITORY_URL', interactiveModulesSetting.Github_Repository_URL__c);
                    paramBody.put('GITHUB_READONLY_KEY', interactiveModulesSetting.Github_Readonly_Key__c);
                    
                } else if(se.Configuration_Step__r.Type__c == 'Anonymous Apex'){
                    paramBody.put('ACTION', 'ANONYMOUS_EXECUTION');
                    String apexScript = EncodingUtil.urlEncode(se.Configuration_Step__r.Apex_Script__c, 'UTF-8').replace('+', '%20');
                    paramBody.put('APEX_BODY', apexScript);
                } else if(se.Configuration_Step__r.Type__c == 'Data Deploy'){
                    paramBody.put('ACTION', 'DATA_IMPORT');
                    List<String> contDocIds = new List<String>();
                    List<ContentVersion> contVersions = new List<ContentVersion>();
                    Map<String, String> contVersionData = new Map<String, String>();
                    for(ContentDocumentLink contLink : [Select ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:se.Configuration_Step__c]){
                        contDocIds.add(contLink.ContentDocumentId);
                    }
                    if (!contDocIds.isEmpty()) {
                        for(ContentVersion contVersion : [Select Id, Title, VersionData, FileExtension, FileType 
                                From ContentVersion Where FileType = 'JSON' AND ContentDocumentId IN:contDocIds]){
                            contVersionData.put(contVersion.Title+'.'+contVersion.FileExtension, contVersion.VersionData.toString());
                        }
                    }

                    String allDataContent = EncodingUtil.urlEncode(JSON.serialize(contVersionData), 'UTF-8').replace('+', '%20');
                    paramBody.put('IMPORT_DATA_JSON', allDataContent);
                }
                
                String api_key = (se.ApiKey__c != null) ? cps_Crypto.decryptString(se.ApiKey__c) : '';
    
                paramBody.put('StepExecution', se.Id);
                paramBody.put('API_KEY_TARGET_ORG', api_key);
                paramBody.put('INSTANCE_URL_TARGET_ORG', se.Target_Instance_URL__c);
                paramBody.put('ORG_CREDENTIAL_ID_TARGET_ORG', se.OrgCredentialId__c);
                paramBody.put('C1P_ORGCREDENTIALID_CLIENT', se.Trial_Org_Credential_Id__c);
    
                paramBody.put('API_KEY', interactiveModulesSetting.Production_API_Key__c);
                paramBody.put('X_CLIENT_KEY', interactiveModulesSetting.X_Client_Key__c);

                Map<String, Map<String, String>> paramBodySetupMap = new Map<String, Map<String, String>>();
                paramBodySetupMap.put(se.Id, paramBody);
                paramBodySetupList.add(paramBodySetupMap);
            }
            paramBodyToBeSend.put('ACTION', 'SETUP');
            paramBodyToBeSend.put('SETUP_LIST', JSON.serialize(paramBodySetupList));
            cps_InteractiveModule_Utils.startC1PJob(paramBodyToBeSend, ce.Id);
        }
    }
}