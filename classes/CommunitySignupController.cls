global without sharing class CommunitySignupController  {
    
    @AuraEnabled
    public static InitDataWrapper fetchInitData(){
        InitDataWrapper wrap = new InitDataWrapper();
        
        SObjectField picklistUsingGlobal = SObjectType.Contact.fields.Job_Role__c.getSObjectField();
        List<PicklistEntry> entries = picklistUsingGlobal.getDescribe().getPicklistValues();
        List<String> jobRoleList = new List<String>();
        for(PicklistEntry pl : entries){
            jobRoleList.add(pl.getLabel());
        }
        
        List<Country__mdt> countries = [SELECT Id, MasterLabel, Country_Code__c FROM Country__mdt ORDER BY MasterLabel];
        List<String> countryList = new List<String>();
        for(Country__mdt con : countries){
            countryList.add(con.MasterLabel);
        }
        
        List<State__mdt> states = [SELECT Id, MasterLabel, Country__c, Country__r.MasterLabel, State_Code__c FROM State__mdt ORDER BY MasterLabel];
        Map<String, List<String>> stateMap = new Map<String, List<String>>();
        List<String> stateList;
        for(State__mdt st : states){
            stateList = stateMap.containsKey(st.Country__r.MasterLabel) ? stateMap.get(st.Country__r.MasterLabel) : new List<String>();
            stateList.add(st.MasterLabel);
            stateMap.put(st.Country__r.MasterLabel, stateList);
        }
        
        wrap.jobRoleList = jobRoleList;
        wrap.countryList = countryList;
        wrap.stateMap = stateMap;
        return wrap;
    }
    
    @AuraEnabled
    public static responseWrap createCommunityUser(String jsonUser){
        ResponseWrap response = new ResponseWrap();
        response.status=false;
        
        UserWrap userWrapObj = userParse(jsonUser);
        
        list<User> userList = [SELECT Id,email FROM USER WHERE UserName =: userWrapObj.email AND IsActive = TRUE];
        if(userList.size()==0){
            String accountId = SYSTEM.LABEL.SuccessCommunityGuestUserAccountId;
            if(Test.isRunningTest()){
                accountId = [Select Id from account limit 1].id;
            }
            list<Account_email_Domain__c> accountemailDomainlist = new list<Account_email_Domain__c>();
            if(String.isNotBlank(userWrapObj.corporateEmail) ){
                String userEmailDomain = userWrapObj.corporateEmail.split('@')[1];
                accountemailDomainlist = new list<Account_email_Domain__c>([SELECT Id,Account__c,Domain__c FROM Account_email_Domain__c WHERE domain__c =: userEmailDomain LIMIT 1]);
                if(accountemailDomainlist.size()>0){
                    if(accountemailDomainlist.get(0).Account__c!=NULL){
                        // accountId = accountemailDomainlist.get(0).Account__c;
                    }
                }
            }
            
            Account accountObj = [SELECT Id,OwnerId FROM Account WHERE Id =:accountId LIMIT 1];
            
            contact conObj = new contact();
            conObj.firstName = userWrapObj.firstName;
            conObj.lastName = userWrapObj.lastName;
            conObj.email = userWrapObj.email;
            conObj.AccountId = accountObj.Id;
            conObj.OwnerId = accountObj.OwnerId;
            conObj.Corporate_Email__c = userWrapObj.corporateEmail;
            conObj.Job_Role__c = userWrapObj.jobRole;
            conObj.Title = userWrapObj.title;
            conObj.MailingCountry = userWrapObj.country;
            conObj.MailingCity = userWrapObj.city;
            conObj.MailingState = userWrapObj.state;
            conObj.MailingPostalCode = userWrapObj.zipcode;
            conObj.I_am_existing_customer__c = false;
            conObj.I_am_existing_partner__c = false;
            if(userWrapObj.iAmExistingCustomer!=null && userWrapObj.iAmExistingCustomer){
                conObj.I_am_existing_customer__c = userWrapObj.iAmExistingCustomer;
            }
            if(userWrapObj.iAmExistingPartner!=null && userWrapObj.iAmExistingPartner){
                conObj.I_am_existing_partner__c = userWrapObj.iAmExistingPartner;
            }
            Insert conObj;
            
            string nick = conObj.email!=null?conObj.email.substring(0, conObj.email.indexOf('@')):'';
            nick += Datetime.now().getTime();
            
            User u = new User(
                Alias = userWrapObj.email.substring(0,3), 
                email=userWrapObj.email, 
                emailEncodingKey='UTF-8', 
                lastName=userWrapObj.lastName,
                firstName=userWrapObj.firstName, 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', 
                ProfileId = SYSTEM.LABEL.SuccessCommunityGuestUserProfileId, 
                IsActive =true,
                CommunityNickname =nick,
                TimeZoneSidKey='GMT',
                UserName=userWrapObj.email
            );
            u.contactId = conObj.Id;
            u.CompanyName = userWrapObj.companyName;
            u.country = userWrapObj.country;
            u.city = userWrapObj.city;
            u.Job_Role__c = userWrapObj.jobRole;
            u.State = userWrapObj.state;
            u.PostalCode = userWrapObj.zipcode;
            u.Title = userWrapObj.title;
            u.Corporate_Email__c = userWrapObj.corporateEmail;
            u.I_am_existing_customer__c = false;
            u.I_am_existing_partner__c = false;
            if(userWrapObj.iAmExistingCustomer!=null && userWrapObj.iAmExistingCustomer){
                if(accountemailDomainlist.size()>0){
                    u.ProfileId = SYSTEM.LABEL.SuccessCustomerCommunityUserProfileId;
                }
                u.I_am_existing_customer__c = userWrapObj.iAmExistingCustomer;
            }
            if(userWrapObj.iAmExistingPartner!=null && userWrapObj.iAmExistingPartner){
                if(accountemailDomainlist.size()>0){
                    u.ProfileId = SYSTEM.LABEL.SuccessPartnerCommunityUserProfileId;
                }
                u.I_am_existing_partner__c = userWrapObj.iAmExistingPartner;
            }
            Insert u;
            
            response.message= 'UserId::'+u.id;
        }
        else{
            response.status= true;
            response.message= 'duplicate email';
        }
        return response;
    }
    
    public class ResponseWrap{
        @AuraEnabled Public boolean status;
        @AuraEnabled Public String message;
    }
    public class UserWrap{
        public String firstName;
        public String lastName;
        public String email;
        public String jobRole;
        public String country;
        public String state;
        public String city;
        public String zipcode;
        public String companyName;
        public String corporateEmail;
        public String title;
        public boolean iAmExistingCustomer;
        public boolean iAmExistingPartner;
    }
    public class InitDataWrapper{
        @AuraEnabled public List<String> jobRoleList;
        @AuraEnabled public List<String> countryList;
        @AuraEnabled public Map<String, List<String>> stateMap;
    }
    public static UserWrap userParse(String json) {
        return (UserWrap) System.JSON.deserialize(json, UserWrap.class);
    }
}