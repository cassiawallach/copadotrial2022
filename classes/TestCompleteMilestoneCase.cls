@isTest
private  class TestCompleteMilestoneCase{
    @testSetup static void setupTestData(){
        testMethodUtilities.setupEntitlements();
    }
    static testMethod void TestCompleteMilestoneCase(){
        
        Contact oContact = new Contact(lastname = 'test',email='email@email.com');
        insert oContact;
        String contactId = oContact.Id;
        Entitlement entl = [select id from Entitlement limit 1];
        String entlId;
        if (entl != null)
            entlId = entl.Id;
        List<Case> cases = new List<Case>{};
            if (entlId != null){
                Case c = new Case(Subject='Test Case with Entitlement ', EntitlementId=entlId, ContactId=contactId);
                cases.add(c);
            }
        if (cases.isEmpty()==false){
            insert cases;
            List<Id> caseIds = new List<Id>();
            for (Case cL : cases){
                caseIds.add(cL.Id);
            }
            milestoneUtils.completeMilestone(caseIds, 'First Response', System.now());
        }
    }
    static testMethod void testCompleteMilestoneViaCase(){
        //entitlement are created on the setupEntitlement method
        Entitlement entl = [select id from Entitlement limit 1];
        String entlId;
        if (entl != null)entlId = entl.Id;
        List<Case> cases = new List<Case>{};
            for(Integer i = 0; i < 1; i++){
                Case c = new Case(Subject='Test Case '+i, SuppliedEmail='test@test.com', SuppliedCompany='Test', SuppliedName='Test User');
                cases.add(c);
                if (entlId != null){
                    c = new Case(Subject='Test Case with Entitlement '+i, EntitlementId=entlId, SuppliedEmail='test@test.com', SuppliedCompany='Test', SuppliedName='Test User');
                    cases.add(c);
                }
            }
        insert cases;
        List<CaseComment> ccs = new List<CaseComment>{};
            for(Case c : cases){
                CaseComment cc = new CaseComment(CommentBody='TestPublic', IsPublished=true, ParentId=c.Id);
                ccs.add(cc);
                cc = new CaseComment(CommentBody='TestPrivate', IsPublished=false, ParentId=c.Id);
                ccs.add(cc);
            }
        if (ccs.isEmpty()==false)
            insert ccs;
        List<EmailMessage> emails = new List<EmailMessage>();
        for(Case c : cases){
            emails.add(new EmailMessage(parentId = c.id));
        }
        if(emails.isEmpty()==false)
            database.insert(emails);
        for(Case c : cases){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddr = new String[] {'user@company.com'};
                mail.setToAddresses(toAddr);
            mail.setSaveAsActivity(false);
            mail.setTargetObjectId(c.ContactId);
            mail.setWhatId(c.Id);
            mail.setHtmlBody('TestHTMLBody');
            mail.setPlainTextBody('TestTextBody');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        for(Case c : cases){
            c.Status = 'Closed';
        }
        update cases;
        List<Case> insertedCases = [SELECT Subject,
                                    Description,
                                    (SELECT IsPublished, CommentBody From CaseComments),
                                    (SELECT TextBody, Subject, Incoming From EmailMessages)
                                    FROM Case
                                    WHERE Id IN :cases];
    }
}