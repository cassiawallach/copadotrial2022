@isTest
private class TestContactTriggerHandler {
    @TestSetup
    static void makeData(){
        Account ca = TestDataFactory.createAccount('Copado Solutions SL','EUR');
        INSERT ca;


        Contact conTest = TestDataFactory.createContact(ca.Id,'test1Demo');
        conTest.ClickDeploy_Enterprise_Trial_Expiry_Date__c = Date.today();
        conTest.ClickDeploy_Enterprise_Trial_Started__c = true;
        conTest.ClickDeploy_Total_Deploy_Attempt__c = 100;
        conTest.ClickDeploy_User_Id__c = 100;
        conTest.ClickDeploy_Last_Login_Date__c = Date.today();
        conTest.ClickDeploy_Created_Date__c = Date.today();
        conTest.ClickDeploy_Salesforce_Org_Id__c = 'Test_Org_Id';
        conTest.ClickDeploy_Salesforce_Username__c = 'Test1@salesforce.com';
        conTest.ClickDeploy_Team_Subscription_ID__c = 'sdfdsfsd';
        conTest.ClickDeploy_Total_Deploy_This_Month__c = 20;
        conTest.ClickDeploy_License_Type__c = 'Free';
        insert conTest;
        conTest.LID__LinkedIn_Company_Id__c = '46556434';
        update conTest;
    }
        
    @isTest
    static void testMarketingDataJSON(){
        String  accountId = [SELECT Id FROM Account Limit 1].Id;
        Contact conTest = TestDataFactory.createContact(accountId,'nohria');
        conTest.ClickDeploy_Enterprise_Trial_Expiry_Date__c = Date.today();
        conTest.ClickDeploy_Enterprise_Trial_Started__c = true;
        conTest.ClickDeploy_Total_Deploy_Attempt__c = 50;
        conTest.ClickDeploy_User_Id__c = 50;
        conTest.ClickDeploy_Last_Login_Date__c = Date.today();
        conTest.ClickDeploy_Created_Date__c = Date.today();
        conTest.ClickDeploy_Salesforce_Org_Id__c = 'Test_Org_Id';
        conTest.ClickDeploy_Salesforce_Username__c = 'Test2@salesforce.com';
        conTest.ClickDeploy_Team_Subscription_ID__c = 'sdfdsfsd';
        conTest.ClickDeploy_Total_Deploy_This_Month__c = 20;
        conTest.ClickDeploy_License_Type__c = 'Free';
        conTest.ClickDeploy_Marketing_Source__c = '{"utm_source": "google", "utm_medium":"cpc", "utm_campaign": "MT%20-%20Nonbrand%20-%20Salesforce%20-%20India", "utm_content": "salesforce%20deploy", "utm_term": "+salesforce%20+deploy"}';
        insert conTest;
        
        conTest = [SELECT ClickDeploy_utm_source__c, 
                   ClickDeploy_utm_medium__c, 
                   ClickDeploy_utm_campaign__c,
                   ClickDeploy_utm_content__c,
                   ClickDeploy_utm_term__c
                   FROM Contact WHERE Email=: conTest.Email];
        system.assertEquals('google', conTest.ClickDeploy_utm_source__c);
        system.assertEquals('cpc', conTest.ClickDeploy_utm_medium__c);
        system.assertEquals('MT - Nonbrand - Salesforce - India', conTest.ClickDeploy_utm_campaign__c);
        system.assertEquals('salesforce deploy', conTest.ClickDeploy_utm_content__c);
        system.assertEquals('salesforce  deploy', conTest.ClickDeploy_utm_term__c);
    }
    
    @isTest
    static void testMarketingDataJSONMalformed(){
        String  accountId = [SELECT Id FROM Account Limit 1].Id;
        Contact conTest = TestDataFactory.createContact(accountId,'Harrysmith');
        conTest.ClickDeploy_Enterprise_Trial_Expiry_Date__c = Date.today();
        conTest.ClickDeploy_Enterprise_Trial_Started__c = true;
        conTest.ClickDeploy_Total_Deploy_Attempt__c = 50;
        conTest.ClickDeploy_User_Id__c = 50;
        conTest.ClickDeploy_Last_Login_Date__c = Date.today();
        conTest.ClickDeploy_Created_Date__c = Date.today();
        conTest.ClickDeploy_Salesforce_Org_Id__c = 'Test_Org_Id';
        conTest.ClickDeploy_Salesforce_Username__c = 'Test2@salesforce.com';
        conTest.ClickDeploy_Team_Subscription_ID__c = 'test team';
        conTest.ClickDeploy_Total_Deploy_This_Month__c = 20;
        conTest.ClickDeploy_License_Type__c = 'Free';
        //pass malformed JSON to the Marketing Source Field
        conTest.ClickDeploy_Marketing_Source__c = '{utm_source": "google", "utm_medium":"cpc", "utm_campaign": "MT%20-%20Nonbrand%20-%20Salesforce%20-%20India", "utm_content": "salesforce%20deploy", "utm_term": "+salesforce%20+deploy"}';
        insert conTest;

        
        conTest = [SELECT ClickDeploy_utm_source__c, 
                   ClickDeploy_utm_medium__c, 
                   ClickDeploy_utm_campaign__c,
                   ClickDeploy_utm_content__c,
                   ClickDeploy_utm_term__c
                   FROM Contact WHERE Email =: conTest.Email];
        

        system.assertEquals(null, conTest.ClickDeploy_utm_source__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_medium__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_campaign__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_content__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_term__c);
        
        DELETE conTest;
    }
    
    @isTest
    static void testContactProcessBuilderAndFlow(){
        Test.startTest();
        Account   ca = [SELECT Id FROM Account Limit 1];
        ca.ClickDeploy_Salesforce_Org_Id__c = 'Test_Org_Id';

        
        Opportunity o = TestDataFactory.createOpportunity(ca, 'My Opp', 'ClickDeploy - Basic - Monthly');
        o.AccountId=ca.Id;
        o.CloseDate=System.Today();
        o.Main_Problems__c = 'Opp Main problem';
        o.Amount = 100;
        o.LeadSource='Advertisement';
        o.ACV__c = 1234;
        o.SRB__c = 0;
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ClickDeploy').getRecordTypeId();
        insert o;
        

        Contact conTest = TestDataFactory.createContact(ca.Id,'Harrysmith');
        conTest.ClickDeploy_Enterprise_Trial_Expiry_Date__c = Date.today();
        conTest.ClickDeploy_Enterprise_Trial_Started__c = true;
        conTest.ClickDeploy_Total_Deploy_Attempt__c = 50;
        conTest.ClickDeploy_User_Id__c = 50;
        conTest.ClickDeploy_Last_Login_Date__c = Date.today();
        conTest.ClickDeploy_Created_Date__c = Date.today();
        conTest.ClickDeploy_Salesforce_Org_Id__c = 'Test_Org_Id';
        conTest.ClickDeploy_Salesforce_Username__c = 'Test2@salesforce.com';
        conTest.ClickDeploy_Team_Subscription_ID__c = 'test team';
        conTest.ClickDeploy_Total_Deploy_This_Month__c = 20;
        conTest.ClickDeploy_License_Type__c = 'Free';
        conTest.ClickDeploy_Marketing_Source__c = '{utm_source": "google", "utm_medium":"cpc", "utm_campaign": "MT%20-%20Nonbrand%20-%20Salesforce%20-%20India", "utm_content": "salesforce%20deploy", "utm_term": "+salesforce%20+deploy"}';
        insert conTest;
        
        conTest = [SELECT ClickDeploy_utm_source__c, 
                   ClickDeploy_utm_medium__c, 
                   ClickDeploy_utm_campaign__c,
                   ClickDeploy_utm_content__c,
                   ClickDeploy_utm_term__c
                   FROM Contact WHERE Email=: conTest.Email];
        
        system.assertEquals(null, conTest.ClickDeploy_utm_source__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_medium__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_campaign__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_content__c);
        system.assertEquals(null, conTest.ClickDeploy_utm_term__c);
        
        DELETE conTest;
        Test.stopTest(); 

    }
}