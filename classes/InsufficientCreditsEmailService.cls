global class InsufficientCreditsEmailService implements Messaging.InboundEmailHandler{
	
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
    	Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        /*String[] messageSplit = email.htmlBody.split('INFO  ~ ');
        system.debug('### '+messageSplit);
        String orgId = '';
        String description = '';
        boolean msgSplitValid = false;

        orgId = messageSplit[1].substring(0,18);
        system.debug('### ORG ID: '+orgId+' length:'+orgId.length());
        msgSplitValid = (orgId.startsWith('00D'));
        if(!msgSplitValid)throw new applicationException('Supposed org Id did not start with 00D. Actual org Id was: '+ orgId+'(length:'+orgId.length()+')');
        system.debug('### message split: '+messageSplit);
        description = messageSplit[1].split('</p>')[0];
        description = description.deleteWhitespace();
        system.debug('DESCRIPTION: '+description);

        Profile admin = [select Id, Name from Profile where Name = 'System Administrator' limit 1];
        User adminUser = [select Id, isActive, ProfileId from User where isActive=true and ProfileId=:admin.Id limit 1];
        system.debug('### ' + adminUser);

        List<Account> accounts = [select Id, OrgId__c from Account where OrgId__c = :orgId ];
        system.debug('### ' + accounts);
        //if account was not yet created by the batchLeadConvert class
        sfLma__License__c license = new sfLma__License__c();
        if(accounts.size() == 0){
            license = [select Id, sfLma__Subscriber_Org_ID__c, sfLma__Lead__c from sfLma__License__c where sfLma__Subscriber_Org_ID__c=:orgId.substring(0,15)];
        }
        Task task = new Task();
        task.Subject='Insufficient credits';
        task.Description=description;
        if(accounts.size() != 0)task.whatId=accounts.get(0).Id;
        if(accounts.size() == 0)task.whoId=license.sfLma__Lead__c;
        task.OwnerId=adminUser.Id;
        task.ActivityDate = system.today();
        insert task;*/
        return result;
    }
    public class applicationException extends Exception {}

    public void errorProcessingEmail(String msg){
        system.debug('Error detected: '+msg);
    }
}