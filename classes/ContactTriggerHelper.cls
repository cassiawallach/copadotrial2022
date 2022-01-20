public with sharing class ContactTriggerHelper {
    
    public static Map<String, Contact> contactMap = new Map<String, Contact>();
    //SG 2019-12-14 - Kangaroo Integreation Method
    public static Set<String> orgIds = new Set<String>();
    public static Map<String, Contact> mapOrgIdToContact = new Map<String, Contact>();
    public static Map<String, Account> mapIdAccounts = new Map<String, Account>();
    public static Map<String, Lead> mapIdLeads = new Map<String, Lead>();
    public static Map<Id,User> UserMap;
    public static EmailTemplate LinkedIn_Company_UpdateEmailTemplate;
    public static OrgWideEmailAddress[] OrgWideEmailAddressValue;
    //internal class to map JSON marketing data string
    public class MarketingSourceData{
        public String utm_source;
        public String utm_medium;
        public String utm_campaign;
        public String utm_term;
        public String utm_content;
        public String initial_Referrer;
        public String initial_landling_page;
        public String last_referer;
        
        public MarketingSourceData(){
            
        }
        
    }
    
    public static void prepareData(List<SObject> records){
        Set<String> emailSet = new Set<String>();
        Set<String> Ownerids = new Set<String>();
        for(SObject so : records){
            Contact c = (Contact)so;
            emailSet.add(c.Email);
            Ownerids.add(c.Ownerid);
            //SG 2019-12-14 - Kangaroo Integreation Method
            if (c.ClickDeploy_Salesforce_Org_Id__c != null) {
                orgIds.add(c.ClickDeploy_Salesforce_Org_Id__c);
                mapOrgIdToContact.put(c.ClickDeploy_Salesforce_Org_Id__c, c);  
            }
        }
        UserMap = new Map<Id,User>([SELECT Id,FirstName,LastName,Email FROM USER WHERE Id IN:Ownerids]);
        
       /* for(Contact c : [select Id, Email from Contact where 
                         Account.RecordType.Name='Corporate Entity' and Email IN :emailSet]){
                             contactMap.put(c.Email, c);
                         }*/
        //SG 2019-12-14 - Kangaroo Integreation Method
        if(orgIds.size()>0){
            for(Account acc : [SELECT Id, ClickDeploy_Salesforce_Org_Id__c FROM Account WHERE ClickDeploy_Salesforce_Org_Id__c IN :orgIds]) {
                mapIdAccounts.put(acc.ClickDeploy_Salesforce_Org_Id__c, acc);
            }
        }
        
        //SG 2020-01-12 - ClickDeploy Marketing Stack Integration
       /* for(Lead lead : [SELECT Id, ClickDeploy_Salesforce_Org_Id__c FROM Lead WHERE 
                         ClickDeploy_Salesforce_Org_Id__c IN :orgIds]) {
                             mapIdLeads.put(lead.ClickDeploy_Salesforce_Org_Id__c, lead);
                         }*/
        OrgWideEmailAddressValue = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = 'academy@copa.do' LIMIT 1];
        LinkedIn_Company_UpdateEmailTemplate = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = :System.Label.LinkedIn_Company_Update_Email_template_Name LIMIT 1];
    }
    
    public static void updateContact(Contact newContact){
        if(!String.isEmpty(newContact.FirstName) && (newContact.FirstName != newContact.LastName)){ 
            if(newContact.LastName.startsWith(newContact.FirstName)){
                newContact.LastName = newContact.LastName.substringAfter(newContact.FirstName);
                newContact.FirstName = newContact.FirstName.normalizeSpace();
                newContact.LastName = newContact.LastName.normalizeSpace();
            }
        }
    }
    
    //SG 2019-12-14 - Kangaroo Integreation Method
    public static void checkExistAccount(Contact newContact){
        List<Account> insAccounts = new List<Account>();
        //Id clickdeployId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Clickdeploy').getRecordTypeId();
        for (String orgId : orgIds) {
            if (!mapIdAccounts.containsKey(orgId)) {
                Contact relatedContact = mapOrgIdToContact.get(orgId);
                String accountName = 'ClickDeploy - ' + relatedContact.ClickDeploy_Salesforce_Username__c.subStringAfter('@');
                Account insAccount = new Account(
                    Name = accountName,
                    ClickDeploy_Salesforce_Org_Id__c = orgId,
                    Type = 'ClickDeploy');
                //RecordTypeId = clickdeployId);
                insAccounts.add(insAccount);
                mapIdAccounts.put(orgId, insAccount);
            }
        }
        insert insAccounts;
        if (newContact.ClickDeploy_Salesforce_Org_Id__c != null) newContact.AccountId = mapIdAccounts.get(newContact.ClickDeploy_Salesforce_Org_Id__c).Id;
    }
    
    //SG 2020-04-04 - ClickDeploy Marketing Source Integration
    public static void parseMarketingSourceData(Contact theContact){
        
        if(theContact.ClickDeploy_Marketing_Source__c != null){
            
            System.debug('==========> ClickDeploy_Marketing_Source__c = ' + theContact.ClickDeploy_Marketing_Source__c);
            try{
                MarketingSourceData results = 
                    (MarketingSourceData)JSON.deserialize(
                        theContact.ClickDeploy_Marketing_Source__c, MarketingSourceData.class);
                
                System.debug('==========> deserialize() results = ' + results);
                
                //map the values
                theContact.ClickDeploy_utm_source__c = String.isNotEmpty(results.utm_source) ? 
                    EncodingUtil.urlDecode(results.utm_source,'UTF-8') : '';
                theContact.ClickDeploy_utm_medium__c = String.isNotEmpty(results.utm_medium) ?
                    EncodingUtil.urlDecode(results.utm_medium,'UTF-8') : '';  
                theContact.ClickDeploy_utm_campaign__c = String.isNotEmpty(results.utm_campaign) ?
                    EncodingUtil.urlDecode(results.utm_campaign,'UTF-8') : '';           
                theContact.ClickDeploy_utm_term__c = String.isNotEmpty(results.utm_term) ?
                    EncodingUtil.urlDecode(results.utm_term,'UTF-8') : '';              
                theContact.ClickDeploy_utm_content__c = String.isNotEmpty(results.utm_content) ?
                    EncodingUtil.urlDecode(results.utm_content,'UTF-8') : '';               
                theContact.ClickDeploy_initial_Referrer__c = String.isNotEmpty(results.initial_Referrer) ?
                    EncodingUtil.urlDecode(results.initial_Referrer,'UTF-8') : '';               
                theContact.ClickDeploy_initial_landling_page__c = String.isNotEmpty(results.initial_landling_page) ?
                    EncodingUtil.urlDecode(results.initial_landling_page,'UTF-8') : '';              
                theContact.ClickDeploy_last_referer__c = String.isNotEmpty(results.last_referer) ?
                    EncodingUtil.urlDecode(results.last_referer,'UTF-8'): '';
                
            } catch (System.JSONException JE){
                System.debug('==========> JSONException = ' + JE.getMessage());
            }
        }
    }
    
    
    public static void sendanemailOnLikedInValueUpdate(Contact OldContact, Contact NewContact){
        // Create the email 
        if(OldContact.LID__LinkedIn_Company_Id__c != NewContact.LID__LinkedIn_Company_Id__c){
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
                String EmailHtmlValue = LinkedIn_Company_UpdateEmailTemplate.HtmlValue.replaceAll('(\\r|\\n)+', '');
            String oldLinkedInCompanyId= OldContact.LID__LinkedIn_Company_Id__c==NULL?'BLANK VALUE': OldContact.LID__LinkedIn_Company_Id__c;
            String NewLinkedInCompanyId= NewContact.LID__LinkedIn_Company_Id__c==NULL?'BLANK VALUE': NewContact.LID__LinkedIn_Company_Id__c;
            String ContactName= NewContact.FirstName==NULL?'': NewContact.FirstName+' ';
           	ContactName += NewContact.LastName==NULL?'': NewContact.LastName;
            String contactId= NewContact.Id==NULL?'': System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+NewContact.Id;
            String accountId= NewContact.AccountId==NULL?'': System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+NewContact.AccountId;
            String AccountName= NewContact.accountId__c==NULL?'BLANK VALUE': NewContact.accountId__c.split('\\|')[1];

            EmailHtmlValue = EmailHtmlValue.replace('LinkedInCompanyOldValue', oldLinkedInCompanyId ).replace('LinkedInCompanyNewValue', NewLinkedInCompanyId).replace('RecipientUserFirstName',UserMap.get(NewContact.OwnerId).FirstName );
            EmailHtmlValue = EmailHtmlValue.replace('ContactName',ContactName);
            EmailHtmlValue = EmailHtmlValue.replace('contactId',contactId);
            EmailHtmlValue = EmailHtmlValue.replace('accountId',accountId);
            EmailHtmlValue = EmailHtmlValue.replace('AccountName',AccountName);
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHtmlBody(EmailHtmlValue);
            mail.setSaveAsActivity(true);
            String[] toAddresses = new String[]{UserMap.get(NewContact.OwnerId).Email};
                mail.setToAddresses(toAddresses);
            if(OrgWideEmailAddressValue.size() != 0)mail.setOrgWideEmailAddressId(OrgWideEmailAddressValue[0].id);
            emails.add(mail);
            Messaging.SendEmailResult[] er = Messaging.sendEmail(emails, false);
        }
        
    }
    
}