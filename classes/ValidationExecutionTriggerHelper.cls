public with sharing class ValidationExecutionTriggerHelper  implements ITrigger {
    public void bulkBefore(){}
    
    public void bulkAfter(){}
    
    public void beforeInsert(SObject so){}
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Validation_Execution__c oldVe = (Validation_Execution__c)oldSo;
        Validation_Execution__c ve = (Validation_Execution__c)so;
		resetJob(oldVe, ve);
        checkPayload(oldVe, ve);
    }
    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so){}
    
    public void afterUpdate(SObject oldSo, SObject so){
        Validation_Execution__c oldVe = (Validation_Execution__c)oldSo;
        Validation_Execution__c ve = (Validation_Execution__c)so;
		sendCalloutRequest(oldVe, ve);
        stepExecutionStatusChange(oldVe, ve);
    }
    
    public void afterDelete(SObject so){}
    public void andFinally(){}

    public void resetJob(Validation_Execution__c oldVE, Validation_Execution__c ve){
        if((oldVE.Status__c =='Failed' || oldVE.Status__c == 'Completed') && (ve.Status__c == 'Pending' || ve.Status__c == 'In progress')) {
            ve.Payload__c = null;
            ve.JobId__c = null;
            ve.Platform_Job_Execution__c = null;
        }
    }

    public void checkPayload(Validation_Execution__c oldVE, Validation_Execution__c ve){
        if(ve.Payload__c == null) {return;}
        try {
            String payload = EncodingUtil.urlDecode(ve.Payload__c, 'UTF-8');
            ve.Payload__c = payload;
        	Map<String, Object> payloadObj = cps_InteractiveModule_Utils.parsePayload(ve.Payload__c);

            if (payloadObj.containsKey('hasError') && (payloadObj.get('hasError') == 'false' || payloadObj.get('hasError') == false)) {

                if (payloadObj.containsKey('data')) {
                    List<Object> data = (List<Object>)payloadObj.get('data');

                    List<Interactive_Validation_Step_Execution__c> vStepExecution = new List<Interactive_Validation_Step_Execution__c>();
                    for (Object sr : data) {
                        Map<String, Object> stepResult = (Map<String, Object>)sr;
                        for (String pKey : stepResult.keySet()) {
                            if (pKey instanceOf Id&& String.valueOf(Id.valueOf(pKey).getSObjectType()) == 'Interactive_Validation_Step_Execution__c') {
                                Map<String, Object> stepResultJSON = (Map<String, Object>)stepResult.get(pKey);
                                String validationPayload = JSON.serialize(stepResultJSON);
                                vStepExecution.add(new Interactive_Validation_Step_Execution__c(
                                    Id = pKey,
                                    Validation_Payload__c = validationPayload
                                ));
                            }
                        }
                    }

                    if (!vStepExecution.isEmpty()) {
                        update vStepExecution;
                    }
                }
            	ve.Status__c = 'Completed';
            } else {
            	ve.Status__c = 'Failed';
            }
        }
        catch (Exception e) {
        }
    }
    public void stepExecutionStatusChange(Validation_Execution__c oldVE, Validation_Execution__c ve){
        if(oldVE.Status__c != ve.Status__c && (ve.Status__c == 'Pending' || ve.Status__c == 'In progress' || ve.Status__c == 'Failed')) {
            List<Interactive_Validation_Step_Execution__c> stepExeToBeUpdate = new List<Interactive_Validation_Step_Execution__c>();
            for(Interactive_Validation_Step_Execution__c se : [Select Id, Name, ExecutionStatus__c, Validation_Result__c 
                                                                From Interactive_Validation_Step_Execution__c 
                                                                Where Validation_Execution__c =:ve.Id]){
                se.ExecutionStatus__c = (ve.Status__c == 'Failed') ? 'Pending' : ve.Status__c;
                stepExeToBeUpdate.add(se);
            }

            if(!stepExeToBeUpdate.isEmpty()){
                update stepExeToBeUpdate;
            }
        }

        if (oldVE.Status__c != ve.Status__c) {
            Validation_Execution_Event__e validationExeEvent = new Validation_Execution_Event__e(
                Record_Id__c = ve.Id,
                Status__c = ve.Status__c,
                IsFinished__c = (ve.Status__c == 'Completed' || ve.Status__c == 'Failed'),
                Learning_Assignment_Id__c = ve.Learning_Assignment__c
            );
    
            EventBus.publish(validationExeEvent);
        }
    }

    public void sendCalloutRequest(Validation_Execution__c oldVE, Validation_Execution__c ve){
        if(oldVE.Status__c != ve.Status__c && ve.Status__c == 'In progress') {

            Interactive_Modules_Setting__mdt interactiveModulesSetting = [
                SELECT C1P_API_Endpoint__c, Platform_Job_Id__c, C1P_API_Key__c, Production_API_Key__c, X_Client_Key__c, Github_Repository_URL__c, Github_Readonly_Key__c
                FROM Interactive_Modules_Setting__mdt
                WHERE QualifiedApiName = :cps_InteractiveModule_Utils.SETTINGS_NAME
                LIMIT 1
            ];
            Map<String, String> paramBodyToBeSend = new Map<String, String>();
            List<Map<String, Map<String, String>>> paramBodyValidationList = new List<Map<String, Map<String, String>>>();

            List<Interactive_Validation_Step_Execution__c> interactiveVSEs = [Select Id, Trial_Org_Credential_Id__c, OrgCredentialId__c, Target_Instance_URL__c, ApiKey__c, Interactive_Validation_Step__c,
            Interactive_Validation_Step__r.Type__c, Interactive_Validation_Step__r.Expected_Result__c, Interactive_Validation_Step__r.ExecutionDetails__c
            From Interactive_Validation_Step_Execution__c 
            Where Validation_Execution__c =: ve.Id];

            Map<String, List<Map<String, String>>> validationMetadataMap = prepareValidationMetadataJSON(interactiveVSEs);

            for(Interactive_Validation_Step_Execution__c se : interactiveVSEs){

                Map<String, String> paramBody = new Map<String, String>();
                
                if(se.Interactive_Validation_Step__r.Type__c == 'Validate Data'){
                    paramBody.put('ACTION', 'DATA_VALIDATION');
                    String executionDetail = EncodingUtil.urlEncode(se.Interactive_Validation_Step__r.ExecutionDetails__c, 'UTF-8').replace('+', '%20');
                    paramBody.put('DATA_VALIDATION_QUERY', executionDetail);

                    String expectedResult = (se.Interactive_Validation_Step__r.Expected_Result__c != null) ? String.valueOf(se.Interactive_Validation_Step__r.Expected_Result__c) : null;
                    paramBody.put('EXPECTED_RESULT', expectedResult);
                } else if(se.Interactive_Validation_Step__r.Type__c == 'Validate Metadata'){
                    paramBody.put('ACTION', 'METADATA_VALIDATION');
                    List<Map<String, String>> validationMetadataList = validationMetadataMap.get(se.Interactive_Validation_Step__c);
                    Map<String, List<Map<String, String>>> validationMetadataFinalMap = new Map<String, List<Map<String, String>>>();
                    validationMetadataFinalMap.put('validations', validationMetadataList);
                    String executionDetailJSON = JSON.serialize(validationMetadataFinalMap);
                    String executionDetail = EncodingUtil.urlEncode(executionDetailJSON, 'UTF-8').replace('+', '%20');
                    paramBody.put('METADATA', executionDetail);
                }
                
                String api_key = (se.ApiKey__c != null) ? cps_Crypto.decryptString(se.ApiKey__c) : '';

                paramBody.put('IVStepExecution', se.Id);
                paramBody.put('API_KEY_TARGET_ORG', api_key);
                paramBody.put('INSTANCE_URL_TARGET_ORG', se.Target_Instance_URL__c);
                paramBody.put('ORG_CREDENTIAL_ID_TARGET_ORG', se.OrgCredentialId__c);
                paramBody.put('C1P_ORGCREDENTIALID_CLIENT', se.Trial_Org_Credential_Id__c);
    
                paramBody.put('API_KEY', interactiveModulesSetting.Production_API_Key__c);
                paramBody.put('X_CLIENT_KEY', interactiveModulesSetting.X_Client_Key__c);

                Map<String, Map<String, String>> paramBodyValidationMap = new Map<String, Map<String, String>>();
                paramBodyValidationMap.put(se.Id, paramBody);
                paramBodyValidationList.add(paramBodyValidationMap);
            }
            paramBodyToBeSend.put('ACTION', 'VALIDATION');
            paramBodyToBeSend.put('VALIDATION_LIST', JSON.serialize(paramBodyValidationList));
            cps_InteractiveModule_Utils.startC1PJob(paramBodyToBeSend, ve.Id);
        }
    }

    private Map<String, List<Map<String, String>>> prepareValidationMetadataJSON(List<Interactive_Validation_Step_Execution__c> interactiveVSEs){
        Set<Id> ivsIds = new Set<Id>();
        Map<String, List<Map<String, String>>> validationMetadataMap = new Map<String, List<Map<String, String>>>();

        for(Interactive_Validation_Step_Execution__c se : interactiveVSEs){
            ivsIds.add(se.Interactive_Validation_Step__c);
        }

        for(Validation_Step_Metadata__c vsm : [Select Id, Interactive_Validation_Step__c, Expected_To_Exist__c, Field_Name__c, Object_Name__c, Type__c
                            From Validation_Step_Metadata__c Where Interactive_Validation_Step__c IN :ivsIds]){
            Map<String, String> vsmRow = new Map<String, String>();

            vsmRow.put('type', vsm.Type__c);
            vsmRow.put('objectName', vsm.Object_Name__c);
            vsmRow.put('expectedToExist', String.valueOf(vsm.Expected_To_Exist__c));
            if (vsm.Type__c == 'CustomField') {
                vsmRow.put('fieldName', vsm.Field_Name__c);
            }
            
            if(!validationMetadataMap.containsKey(vsm.Interactive_Validation_Step__c)){
                validationMetadataMap.put(vsm.Interactive_Validation_Step__c, new List<Map<String, String>>());
            }
            validationMetadataMap.get(vsm.Interactive_Validation_Step__c).add(vsmRow);
        }

        return validationMetadataMap;
    }
}