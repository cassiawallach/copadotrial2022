global class ReleaseCommunicationBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global final String emailTemplateId;
    global final String releaseId;
    global Set<String> blackList;
    global Set<Id> targetIds;
    global Set<String> emailSet;
    global ReleaseCommunicationBatch(Id etId, Id rId) {
        emailTemplateId = etId;
        releaseId = rId;
        targetIds = new Set<Id>();
        blackList = new Set<String>();
		emailSet = new Set<String>();
    }
    global Iterable<sObject> start(Database.BatchableContext BC) {
        List<SObject> iterable = new List<SObject>();
        //create a black list of email addresses that has opt-out of your communications.
        for(Contact c:[select Email from Contact where HasOptedOutOfEmail=true and email!=null])blackList.add(c.Email.toLowerCase());
        for(Lead le:[select Email from Lead where HasOptedOutOfEmail=true and email!=null])blackList.add(le.Email.toLowerCase());
        
        //get the list of accounts that has an active license
        List<sfLma__License__c> licenses = [select Id, sfLma__Contact__c, sfLma__Contact__r.AccountId, sfLma__Contact__r.Email, sfLma__Contact__r.HasOptedOutOfEmail, sfLma__Contact__r.Mass_Email_Filter__c, sfLma__Lead__c, sfLma__Lead__r.Email, sfLma__Lead__r.HasOptedOutOfEmail, sfLma__Lead__r.Mass_Email_Filter__c from sfLma__License__c 
                                            where sfLma__Status__c='Active'];
        Set<Id> accIds = new Set<Id>();
        for(sfLma__License__c l : licenses){
            if(l.sfLma__Contact__r.AccountId!=null)accIds.add(l.sfLma__Contact__r.AccountId);
        }  
        //get all the contacts that are on those accounts but haven't opt-out or have invalid email addresses or 
        //that had opt-in to our release communications
        return [select Id, Email from Contact where (Last_Release_Communication_Sent__c!= :releaseId and isEmailBounced=false and AccountID IN :accIds and Email!=null and Email!='unknown@unknown.com' and HasOptedOutOfEmail=false) or (Last_Release_Communication_Sent__c!= :releaseId and isEmailBounced=false and HasOptedOutOfEmail=false and Receive_Release_Communication__c = true)];
    }
    global void execute(Database.BatchableContext BC, List<Contact> contactList) {
        if(releaseId == null){
            throw new BatchException('No release ID passed to the batch process');
        }
        if(emailTemplateId == null){
            throw new BatchException('No email tempalte ID passed to the batch process');
        }
        List<Contact> toUpdate = new List<Contact>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Contact c : contactList){
            String emailAddress = c.Email.toLowerCase();
            if(emailset.contains(emailAddress) || blackList.contains(emailAddress)){
                continue;
            }
            emailSet.add(emailAddress);
            emails.add(createEmail(c.id,releaseId,true,emailTemplateId));
            toUpdate.add(c);
        }
        boolean skipEmails = [select isSandbox from Organization limit 1].isSandbox || Test.isRunningTest();
        
        if(!skipEmails){
         	List<Messaging.SendEmailResult> result = Messaging.sendEmail(emails,true);
            for(Messaging.SendEmailResult r:result){
                if(!r.isSuccess()){
                    System.debug('@@@ Email ERROR: ' + r.getErrors());
                    return;
                }
            }   
        }
        for(Contact c:toUpdate){
        	c.Last_Release_Communication_Sent__c = releaseId;
        }
        update toUpdate;
    }
    private static Messaging.SingleEmailMessage createEmail(Id targetId, Id whatId, boolean saveAsActivity, Id emailTemplateId){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(targetId);
        email.setReplyTo('support@copa.do');
        email.setSenderDisplayName('Copado Solutions');
        email.setBccSender(false);
        email.setUseSignature(false);
        email.setWhatId(whatId);
        email.setSaveAsActivity(saveAsActivity);
        email.setTemplateId(emailTemplateId);
        return email;
    }
    global void finish(Database.BatchableContext BC) {
    	Task t = new Task();
        t.ownerId = UserInfo.getUserId();
        t.subject = 'Release Communication Sent';
        t.ActivityDate = Date.today();
        t.Status = 'Not started';
        insert t;
    }
    public class BatchException extends Exception{}
}