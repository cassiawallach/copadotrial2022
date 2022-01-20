@IsTest
private class LeadTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Contact conTest = new Contact(
            FirstName = 'Test1', LastName = 'Test1', Email = 'Test1@salesforce.com',
            ClickDeploy_Enterprise_Trial_Expiry_Date__c = Date.today(),
            ClickDeploy_Enterprise_Trial_Started__c = true,
            ClickDeploy_Total_Deploy_Attempt__c = 100,
            ClickDeploy_User_Id__c = 100,
            ClickDeploy_Last_Login_Date__c = Date.today(),
            ClickDeploy_Created_Date__c = Date.today(),
            ClickDeploy_Salesforce_Org_Id__c = 'Test_Org_Id',
            ClickDeploy_Salesforce_Username__c = 'Test1@salesforce.com'
        );
        insert conTest;
    }
    @isTest
    static void testLeadCreate()
    {
        /*
        Contact conTest = new Contact(
            FirstName = 'Test2', LastName = 'Test2', Email = 'Test2@salesforce.com',
            //ClickDeploy_Enterprise_Trial_Expiry_Date__c = Date.today(),
            ClickDeploy_Enterprise_Trial_Started__c = false,
            ClickDeploy_Total_Deploy_Attempt__c = 0,
            ClickDeploy_User_Id__c = 50,
            ClickDeploy_Last_Login_Date__c = Date.today(),
            ClickDeploy_Created_Date__c = Date.today(),
            ClickDeploy_Salesforce_Org_Id__c = 'Test_Org_Id',
            ClickDeploy_Salesforce_Username__c = 'Test2@salesforce.com',
            ClickDeploy_License_Type__c = 'Free'
        );
        insert conTest;
        // lead created
        system.assertEquals(2, [SELECT Id FROM Lead].size());
        conTest.ClickDeploy_Total_Deploy_This_Month__c = 3;
        conTest.ClickDeploy_Total_Deploy_Attempt__c = 3;
        conTest.ClickDeploy_License_Type__c = 'Free';
        update conTest;
        Lead l = [SELECT Id, Status, MQL__c FROM Lead 
            WHERE 
            ClickDeploy_User_Id__c = 50];
        //system.assertEquals(true, l.MQL__c);
        */
        Lead l = new Lead(LastName='LastName', Company='Company');
        insert l;
        update l;
        LeadTriggerHelper lh = new LeadTriggerHelper();
    }
}