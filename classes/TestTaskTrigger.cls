@isTest
public class TestTaskTrigger {
    static testMethod void testNonLeadObjects(){
        Account testAccount = new Account(Name='Random Account');
        insert testAccount;
        Contact testContact = new Contact(LastName='Rackwitz', AccountId=testAccount.Id);
        insert testContact;
        
        Task emailTask1 = new Task(WhoId=testContact.Id, Subject='Email: my subject random');
        test.startTest();
        insert emailTask1;
        test.stopTest();
    }
    
    static testMethod void testSuccess_insert(){
        Lead testLead1 = createTestLead();
        
        List<Task> tsks = buildListOfTasks(testLead1.Id);
        insert tsks;
        
        system.debug('my result lead....'+ getResultLead(testLead1.Id));
        system.assertEquals(2, getResultLead(testLead1.Id).contacts_made__c);
    }
    static testMethod void testSuccess_update(){   
        Lead testLead1 = createTestLead();
        List<Task> tsks = buildListOfTasks(testLead1.Id);
        insert tsks;
        
        test.startTest();
        Task t = tsks[0];
        t.Description = 'updated description';
        update t;
        
        system.assertEquals(2, getResultLead(testLead1.Id).contacts_made__c);
        
        t.Subject = 'something else';
        update t;
        test.stopTest();
        
        system.assertEquals(1, getResultLead(testLead1.Id).contacts_made__c);
    }
    static testMethod void testSuccess_delete(){    
        Lead testLead1 = createTestLead();
        List<Task> tsks = buildListOfTasks(testLead1.Id);
        insert tsks;
        
        test.startTest();
        
        Task t = tsks[0];
        delete t;
        system.assertEquals(1, getResultLead(testLead1.Id).contacts_made__c);
        
        undelete t;
        test.stopTest();
        
        system.assertEquals(2, getResultLead(testLead1.Id).contacts_made__c);
    }
    
    private static Lead createTestLead(){
        Lead testLead1 = new Lead(LastName='Phil', Company='Copado', Status='Open');
        insert testLead1;
        return testLead1;
    }
    private static Lead getResultLead(Id recordId){
        return [select Id, Contacts_made__c from Lead where Id=:recordId limit 1];
    }
    private static List<Task> buildListOfTasks(Id leadId){
        //2 are valid 1 is not valid for the "Contacts made count" and should be ignored.
        Task emailTask1 = new Task(WhoId=leadId, Subject='Email: my subject 1');
        Task emailTask2 = new Task(WhoId=leadId, Subject='→ Email: my subject 2');
        Task emailTask3 = new Task(WhoId=leadId, Subject='Mass Email: my subject 3');
        List<Task> tsks = new List<Task>();
        tsks.add(emailTask1);
        tsks.add(emailTask2);
        tsks.add(emailTask3);
        return tsks;
    }
}