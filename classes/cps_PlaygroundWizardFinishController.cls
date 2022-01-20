public without sharing class cps_PlaygroundWizardFinishController {
    
    @AuraEnabled
    public static void ActivatePlayground(String playgroundId) {
      Playground__c playground = [SELECT Status__c, Stage__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];
      playground.Status__c = 'Activated';
      playground.Stage__c = 'Completed';

      try {
        update playground;
      } catch (Exception e) {
         throw e;
      }
    }


    // Deletes a playground
    @AuraEnabled
    public static void DeletePlayground(String playgroundId) {
        Playground_Enviroment__c playgroundEnv = [SELECT Org_Id__c FROM Playground_Enviroment__c WHERE Playground__c = :playgroundId AND Type__c = 'CoE_Org' LIMIT 1];

        List<sfLma__License__c> licenses = [SELECT sfLma__Status__c FROM sfLma__License__c WHERE sfLma__Subscriber_Org_ID__c = :playgroundEnv.Org_Id__c];
        if (!licenses.isEmpty()) {
            licenses.get(0).sfLma__Status__c = 'Suspended';
            UPDATE licenses;
        }

        Playground__c playground = [SELECT Name, Stage__c, Status__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];
        
        try{
            delete playground;
        }catch(Exception e){
            throw e;
        }
    }
}