public without sharing class newTrialSignupController {

    @auraEnabled
    public static User getUserInfo() {
        User currentUser = [select Id, FirstName, LastName, Email, CompanyName, ContactId from User where Id=:UserInfo.getUserId() limit 1];
        return currentUser;
    }

    // Get all the playground jobs for a given playground
    @auraEnabled
    public static List<Playground_Job__c> getPlaygroundJobs(String playgroundId){
        return cps_PlaygroundWizardController.GetPlaygroundJobs(playgroundId);
    }

    @auraEnabled
    public static Signup_Request__c getSignupRequest(String recordId) {
        Signup_Request__c sr = [select Id, Status__c, Error_Code__c, Created_Org_Id__c from Signup_Request__c where Id=:recordId limit 1];
        return sr;
    }

    @auraEnabled
    public static Signup_Request__c createSignupRequest(String username, String domain, String country, String playgroundId) {
        try {
            Playground_Setting__mdt playgroundSetting = [select Id, TSO_Template_Id__c, Template_Id_without_Copado_Deployer__c, Edition__c
                                                    from Playground_Setting__mdt
                                                    where QualifiedApiName =: cps_Helper.SETTINGS_NAME limit 1];
            User currentUser = [select Id, FirstName, LastName, Email, CompanyName, ContactId, Country from User where Id=:UserInfo.getUserId() limit 1];

            Playground_Job__c job = [select Id, Playground__c, Playground__r.Playground_Configuration__c from Playground_Job__c where Playground__c=:playgroundId and Action__c='CreateTrialOrg' limit 1];

            Signup_Request__c sr = new Signup_Request__c();
            sr.First_Name__c = currentUser.FirstName;
            sr.Last_Name__c = (currentUser.LastName==null)?'Not Provided':currentUser.LastName;
            sr.Email__c = currentUser.Email;
            sr.Company__c = (currentUser.CompanyName==null)?'Not Provided':currentUser.CompanyName;
            sr.User__c = currentUser.Id;
            sr.Country__c = (country==null)?'US':country;
            sr.Domain__c = (domain==null)?'null':domain;
            sr.Username__c = username;
            sr.Signup_Source__c = 'Playground Community';
            sr.Playground_Job__c = job.Id;
            sr.Preferred_Language__c = 'en_US';
            if (playgroundSetting.Edition__c == null || playgroundSetting.Edition__c == '') {
                if (job.Playground__r.Playground_Configuration__c == 'Full Configuration - Scratch Orgs') {
                	sr.Template__c = playgroundSetting.Template_Id_without_Copado_Deployer__c;
            	} else {
                	sr.Template__c = playgroundSetting.TSO_Template_Id__c;
            	}            	
            } else {
                 sr.Edition__c = playgroundSetting.Edition__c;               
            }
            insert sr;

            Playground__c playground = new Playground__c(Id=job.Playground__c, Custom_Signup_Request__c=sr.Id);
            update playground;

            currentUser.Country = country;
            update currentUser;
            return sr;
        } catch (Exception ex) {
            system.debug(ex.getMessage());
            String beautifulError = beautifyErrorMessage(ex.getMessage());
            AuraHandledException e = new AuraHandledException(beautifulError);
            e.setMessage(beautifulError);
            system.debug(e);
            throw e;
        }
    }

    public static String beautifyErrorMessage(String err) {
        if (err==null) return '';
        if (err.contains('LIMIT_EXCEEDED')) {
            return 'The Salesforce daily limit of SignupRequests has been reached.';
        }
        if (err.contains('The username provided is not in a valid email address format.')){
            return 'The username provided is not in a valid email address format.  Please see the example provided in the help text.';
        }
        if (err.contains('INVALID_SUBDOMAIN')) {
            return 'Invalid Subdomain. Select a name that does not contain double hyphens, spaces, end in a hyphen, include restricted words (e.g. sfdc) or exceed 22 characters.';
        }
        return err;
    }
}