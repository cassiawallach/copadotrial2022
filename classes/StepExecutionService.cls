public with sharing class StepExecutionService {
    
    public static void resetJob(Step_Execution__c oldSe, Step_Execution__c se) {
        if((oldSe.Status__c=='Failed' || oldSe.Status__c=='Completed') && (se.Status__c=='Pending' || se.Status__c=='In progress')) {
            se.Payload__c = null;
        }
    }

    public static void checkPayload(Step_Execution__c oldSe, Step_Execution__c se) {
        if(se.Payload__c == null) {return;}
        try {
            String payload = EncodingUtil.urlDecode(se.Payload__c, 'UTF-8');
            se.Payload__c = payload;
        	Map<String, Object> payloadObj = cps_InteractiveModule_Utils.parsePayload(se.Payload__c);
            if (payloadObj.containsKey('hasError') && (payloadObj.get('hasError') == 'false' || payloadObj.get('hasError') == false)) {
            	se.Status__c = 'Completed';
            } else {
            	se.Status__c = 'Failed';
            }
        }
        catch (Exception e) {
        }
    }
}