@isTest
public with sharing class PlatformJobExecutionTriggerHelperTest {
    
    @testSetup 
    static void methodName() {
        copado.GlobalAPI.UserLicense copadoUserLicense = new copado.GlobalAPI.UserLicense(UserInfo.getUserId(),false,false,false,true,false);
        copado.GlobalAPI gapi = new copado.GlobalAPI();
        gapi.upsertCopadoLicense(UserInfo.getUserId(), copadoUserLicense);
    }
    
    static testMethod void unitTests () {
        copado__Git_Repository__c gr = new copado__Git_Repository__c();
        insert gr;

        copado1p__Platform_Job__c pj = new copado1p__Platform_Job__c(Name='C1P Rules Job');
        pj.copado1p__isActive__c = true;
        pj.copado1p__Git_Repository__c = gr.id;
        pj.copado1p__Branch__c = 'master';
        pj.copado1p__VM_Provider__c = 'Heroku';
        pj.copado1p__Branch__c = 'standard-1x';
        insert pj;

        copado1p__Platform_Job_Execution__c pje = new copado1p__Platform_Job_Execution__c(copado1p__Platform_Job__c=pj.Id, copado1p__Status__c = 'Running', copado1p__Copado_Job_ID__c = '12345678');
        insert pje;

        Test.startTest();
        pje.copado1p__Status__c = 'Failure';
        update pje;
        Test.stopTest();
    }
}