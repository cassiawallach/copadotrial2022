@isTest
public class Copado_Package_installerTest {

    static testMethod void testGetAllReleaseRecords(){
        copado__Release__c release = TestDataFactory.createRelease('test copadopackage');
        release.Visible_in_Community__c=true;
        release.copado__Description__c ='Test Released';
        release.copado__Version__c ='1.0';
        release.Installation_Link_in_Sandbox__c ='https://test.salesforce.com/';
        release.Installation_Link_in_Production__c ='https://login.salesforce.com/';
        release.Documentation_Release_Notes__c ='Test Released Note';        
        release.copado__Planned_Date__c = system.today();
        release.copado__Status__c = 'Released';
        Insert release;
        Copado_Package_installer.getAllReleaseRecords();
    } 
}