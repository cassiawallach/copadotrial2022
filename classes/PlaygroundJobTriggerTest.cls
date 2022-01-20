@isTest
public class PlaygroundJobTriggerTest {

    @testSetup 
    static void methodName() {
        copado.GlobalAPI.UserLicense copadoUserLicense = new copado.GlobalAPI.UserLicense(UserInfo.getUserId(),false,false,false,true,false);
        copado.GlobalAPI gapi = new copado.GlobalAPI();
        gapi.upsertCopadoLicense(UserInfo.getUserId(), copadoUserLicense);
    }
    
    static testMethod void tesSuccess() {
        Account testAccount = new Account(Name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='test', AccountId=testAccount.Id);
        insert testContact;
        
        Playground__c pg = new Playground__c(Name='Test 1', Contact__c=testContact.Id);
        insert pg;
        
        copado__Git_Repository__c gr = new copado__Git_Repository__c();
        insert gr;
        
        copado__Org__c o = new copado__Org__c(Name='test');
        insert o;
        
        copado1p__Platform_Job__c pj = new copado1p__Platform_Job__c(Name='C1P Rules Job');
        pj.copado1p__isActive__c = true;
        pj.copado1p__Git_Repository__c = gr.id;
        pj.copado1p__Branch__c = 'master';
        pj.copado1p__VM_Provider__c = 'Heroku';
        pj.copado1p__Branch__c = 'standard-1x';
        insert pj;
        
        copado1p__Platform_Job_Execution__c pje = new copado1p__Platform_Job_Execution__c(copado1p__Platform_Job__c=pj.Id);
        insert pje;
        
        Playground_Job__c playJob = new Playground_Job__c(Name='Test', Playground__c=pg.Id);
        playJob.Platform_Job_Execution__c = pje.Id;
        insert playJob;
        
        Test.startTest();
        
        playJob.Status__c = 'In progress';
        playJob.Payload__c = null;
        update playJob;
        Playground_Job__c result = getResult(playJob.Id);
        system.assertEquals(result.Status__c, 'In progress');
        system.assertEquals(result.Payload__c, null);
        
        playJob.Status__c = 'In progress';
        playJob.Payload__c = '%7B%22action%22%3A%22CreateCoeCredential%22%2C%22hasError%22%3Afalse%2C%22data%22%3A%7B%22Name%22%3A%22test%22%2C%22copado__Org_Type__c%22%3A%22test%22%2C%22copado__Test_Frequency__c%22%3A%22None%22%2C%22Id%22%3A%22123%22%7D%7D';
        update playJob;
        result = getResult(playJob.Id);
        system.assertEquals(result.Status__c, 'Completed');
        String expected = EncodingUtil.urlDecode(playJob.Payload__c, 'UTF-8');
        system.assertEquals(expected, result.Payload__c);
        
        playJob.Status__c = 'In progress';
        playJob.Payload__c = '%7B%22action%22%3A%22CreateCoeCredential%22%2C%22hasError%22%3Atrue%2C%22data%22%3A%7B%22Name%22%3A%22test%22%2C%22copado__Org_Type__c%22%3A%22test%22%2C%22copado__Test_Frequency__c%22%3A%22None%22%2C%22Id%22%3A%22123%22%7D%7D';
        update playJob;
        result = getResult(playJob.Id);
        system.assertEquals(result.Status__c, 'Failed');
        expected = EncodingUtil.urlDecode(playJob.Payload__c, 'UTF-8');
        system.assertEquals(expected, result.Payload__c);
    }
    private static Playground_Job__c getResult(Id recordId) {
        return [select Id, Status__c, Payload__c from Playground_Job__c where Id=:recordId limit 1];
    }
}