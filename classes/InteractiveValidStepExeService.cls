public with sharing class InteractiveValidStepExeService {
    
    public static void resetJob(Interactive_Validation_Step_Execution__c oldSe, Interactive_Validation_Step_Execution__c se) {
        if((oldSe.ExecutionStatus__c=='Failed' || oldSe.ExecutionStatus__c=='Completed') && (se.ExecutionStatus__c=='Pending' || se.ExecutionStatus__c=='In progress')) {
            se.Validation_Payload__c = null;
        }
    }
	//Method to update Validation status on learning assignment
    public static void updateValidationonLAssignment(Interactive_Validation_Step_Execution__c oldSe, Interactive_Validation_Step_Execution__c se) {
        if(se.Validation_Execution__c == null) {return;}
        
        if(oldSe.Validation_Result__c != se.Validation_Result__c  && (se.Validation_Result__c == 'Success' || se.Validation_Result__c == 'Failed')) {
            Boolean isAllFinished = true;
            String learningAssignmentValidationStatus = 'Success';
            String learningAssignmentId = null;
            for(Interactive_Validation_Step_Execution__c seTemp : [Select Id, Name, Validation_Result__c, Interactive_Validation_Step__r.ExecutionOrder__c, Validation_Execution__r.Learning_Assignment__c 
                                            From Interactive_Validation_Step_Execution__c 
                                            Where Validation_Execution__c =:se.Validation_Execution__c
                                            Order By Interactive_Validation_Step__r.ExecutionOrder__c ASC]){
                if (learningAssignmentId == null) {
                    learningAssignmentId = seTemp.Validation_Execution__r.Learning_Assignment__c;
                }
                if (seTemp.Validation_Result__c != 'Success' && seTemp.Validation_Result__c != 'Failed') {
                    isAllFinished = false;
                    break;
                } else if (seTemp.Validation_Result__c == 'Failed') {
                    learningAssignmentValidationStatus = 'Failed';
                }
            }

            if (isAllFinished && learningAssignmentId != null) {
                redwing__Learning_Assignment__c learningAssignment = new redwing__Learning_Assignment__c(Id = learningAssignmentId, Validation_Status__c = learningAssignmentValidationStatus);

                update learningAssignment;
            }
        }
    }

    public static void checkPayload(Interactive_Validation_Step_Execution__c oldSe, Interactive_Validation_Step_Execution__c se) {
        if(se.Validation_Payload__c == null) {return;}
        try {
            String payload = EncodingUtil.urlDecode(se.Validation_Payload__c, 'UTF-8');
            se.Validation_Payload__c = payload;
        	Map<String, Object> payloadObj = cps_InteractiveModule_Utils.parsePayload(se.Validation_Payload__c);
            if (payloadObj.containsKey('hasError') && (payloadObj.get('hasError') == 'false' || payloadObj.get('hasError') == false)) {
            	se.ExecutionStatus__c = 'Completed';
                if (payloadObj.containsKey('validationResult') && payloadObj.get('validationResult') == 'Success') {
                    se.Validation_Result__c = 'Success';
                } else if (payloadObj.containsKey('validationResult') && payloadObj.get('validationResult') == 'Failed') {
                    se.Validation_Result__c = 'Failed';
                }

            } else {
            	se.ExecutionStatus__c = 'Failed';
            }
        }
        catch (Exception e) {
        }
    }
}