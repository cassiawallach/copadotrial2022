@isTest
private class ClickDeployLeadConversionTest {
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
    static void testClickDeployLeadConversion()
    {
        // nr mock test 
        List<Lead> theLeads = new List<Lead>();

        Lead l = new Lead();
        l.LastName = 'dummy';
        l.Company = 'dummy';
        insert l;
        theLeads.add(l);

        ClickDeployLeadConversion.convertLead(theLeads);
    }
}