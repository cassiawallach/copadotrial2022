@isTest(SeeAllData=true)
private class TestAssignFreeCreditsExtension{
    static testMethod void testFailiure() {
        testHttpCalloutMock request1 = new testHttpCalloutMock(200, 'Complete', '{"Status":"OK"}');
        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('https://test-copado.herokuapp.com/admin/syncFeatures?sid=00Dm00000000XsI!ApexTestSession&url=https://cs20.salesforce.com/services/Soap/u/26.0/00Dm00000000XsI', request1);
        calloutMap.put('https://testMethod.com/admin/addCredits/123orgId123/10?pkey=RANDOMKEY&uid=123userId123&orgId=SOME_ORG_ID&amount=0.00&currency=EUR&type=Free+credits&description=Not+Available', request1);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);

        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org Assign Free Credits');
        insert org;
        PageReference pref = Page.AssignFreeCredits;
        pref.getParameters().put('id',org.id);
        Test.setCurrentPage(pref);      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        AssignFreeCreditsExtension ext = new AssignFreeCreditsExtension(new ApexPages.StandardController(org));
        ext.org.credits__c = 10;
        ext.assignCredits();
        system.assert(testMethodUtilities.hasMessage('Salesforce_Org__c has no users.'));

        Salesforce_User__c sfUser = new Salesforce_User__c(First_Name__c='John Doe', Salesforce_Org__c=org.Id);
        insert sfUser;
        pref = Page.AssignFreeCredits;
        pref.getParameters().put('id',org.id);
        Test.setCurrentPage(pref);      
        ext = new AssignFreeCreditsExtension(new ApexPages.StandardController(org));
        ext.org.credits__c = null;
        ext.assignCredits();
        Test.stopTest();
        system.assert(testMethodUtilities.hasMessage('You must enter a credit amount to proceed.'));
    }
    static testMethod void testCredits() {
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org Assign Free Credits');
        insert org;
        Salesforce_User__c sfUser = new Salesforce_User__c(First_Name__c='John Doe', Salesforce_Org__c=org.Id);
        insert sfUser;
        PageReference pref = Page.AssignFreeCredits;
        pref.getParameters().put('id',org.id);
        Test.setCurrentPage(pref);      
		
		testHttpCalloutMock request1 = new testHttpCalloutMock(200, 'Complete', '{"customerOrg":{"Name":"Copado Ltd","orgId":"orgId123","autoRecharge":true,"credits":425,"id":995},"userInfo":{"accessibilityMode__is_set":true,"accessibilityMode":false,"currencySymbol__is_set":true,"currencySymbol":"€","orgAttachmentFileSizeLimit__is_set":true,"orgAttachmentFileSizeLimit":5242880,"orgDefaultCurrencyIsoCode__is_set":true,"orgDefaultCurrencyIsoCode":"EUR","orgDisallowHtmlAttachments__is_set":true,"orgDisallowHtmlAttachments":false,"orgHasPersonAccounts__is_set":true,"orgHasPersonAccounts":false,"organizationId__is_set":true,"organizationId":"00Db0000000KFgoEAG","organizationMultiCurrency__is_set":true,"organizationMultiCurrency":false,"organizationName__is_set":true,"organizationName":"Copado Ltd","profileId__is_set":true,"profileId":"00eb0000000mWB2AAM","roleId__is_set":true,"sessionSecondsValid__is_set":true,"sessionSecondsValid":7200,"userDefaultCurrencyIsoCode__is_set":true,"userEmail__is_set":true,"userEmail":"pr@copa.do","userFullName__is_set":true,"userFullName":"Philipp Rackwitz","userId__is_set":true,"userId":"userId123","userLanguage__is_set":true,"userLanguage":"en_US","userLocale__is_set":true,"userLocale":"en_GB","userName__is_set":true,"userName":"pr@copa.do.basepackage","userTimeZone__is_set":true,"userTimeZone":"Europe/Paris","userType__is_set":true,"userType":"Standard","userUiSkin__is_set":true,"userUiSkin":"Theme3"}}');
        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('https://testMethod.com/admin/addCredits/123orgId123/10?pkey=RANDOMKEY&uid=123userId123&orgId=SOME_ORG_ID&amount=0.00&currency=EUR&type=Free+credits&description=Not+Available', request1);
        system.debug('################### https://testMethod.com/admin/addCredits/123orgId123/10?pkey=RANDOMKEY&uid=123userId123&orgId=SOME_ORG_ID&amount=0.00&currency=EUR&type=Free+credits&description=Not+Available');
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);
        
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		
        AssignFreeCreditsExtension ext = new AssignFreeCreditsExtension(new ApexPages.StandardController(org));
        system.assertEquals(false, ext.renderRefreshButton);
        ext.org.credits__c = 10;
        ext.assignCredits();
        Test.stopTest();
        system.assert(testMethodUtilities.hasMessage('Credits assigned successfully.'));
        system.assertEquals(true, ext.renderRefreshButton);
    }
    static testMethod void testMinutes() {
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Org Assign Free Minutes');
        insert org;
        Salesforce_User__c sfUser = new Salesforce_User__c(First_Name__c='John Doe', Salesforce_Org__c=org.Id);
        insert sfUser;
        
        PageReference pref = Page.AssignFreeCredits;
        pref.getParameters().put('id',org.id);
        Test.setCurrentPage(pref);

        testHttpCalloutMock request1 = new testHttpCalloutMock(200, 'Complete', '{"customerOrg":{"Name":"Copado Ltd","orgId":"orgId123","autoRecharge":true,"credits":425,"id":995},"userInfo":{"accessibilityMode__is_set":true,"accessibilityMode":false,"currencySymbol__is_set":true,"currencySymbol":"€","orgAttachmentFileSizeLimit__is_set":true,"orgAttachmentFileSizeLimit":5242880,"orgDefaultCurrencyIsoCode__is_set":true,"orgDefaultCurrencyIsoCode":"EUR","orgDisallowHtmlAttachments__is_set":true,"orgDisallowHtmlAttachments":false,"orgHasPersonAccounts__is_set":true,"orgHasPersonAccounts":false,"organizationId__is_set":true,"organizationId":"00Db0000000KFgoEAG","organizationMultiCurrency__is_set":true,"organizationMultiCurrency":false,"organizationName__is_set":true,"organizationName":"Copado Ltd","profileId__is_set":true,"profileId":"00eb0000000mWB2AAM","roleId__is_set":true,"sessionSecondsValid__is_set":true,"sessionSecondsValid":7200,"userDefaultCurrencyIsoCode__is_set":true,"userEmail__is_set":true,"userEmail":"pr@copa.do","userFullName__is_set":true,"userFullName":"Philipp Rackwitz","userId__is_set":true,"userId":"userId123","userLanguage__is_set":true,"userLanguage":"en_US","userLocale__is_set":true,"userLocale":"en_GB","userName__is_set":true,"userName":"pr@copa.do.basepackage","userTimeZone__is_set":true,"userTimeZone":"Europe/Paris","userType__is_set":true,"userType":"Standard","userUiSkin__is_set":true,"userUiSkin":"Theme3"}}');
        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('https://testMethod.com/admin/addCredits/123orgId123/10?pkey=RANDOMKEY&uid=123userId123&orgId=SOME_ORG_ID&amount=0.00&currency=EUR&type=Free+credits&description=Not+Available', request1);
        system.debug('################### https://testMethod.com/admin/addCredits/123orgId123/10?pkey=RANDOMKEY&uid=123userId123&orgId=SOME_ORG_ID&amount=0.00&currency=EUR&type=Free+credits&description=Not+Available');
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        AssignFreeCreditsExtension ext = new AssignFreeCreditsExtension(new ApexPages.StandardController(org));
        system.assertEquals(false, ext.renderRefreshButton);
        ext.org.Selenium_Minutes__c = 10;
        ext.assignMinutes();
        Test.stopTest();
        system.assert(testMethodUtilities.hasMessage('Minutes assigned successfully.'));
        system.assertEquals(true, ext.renderRefreshButton);
    }
}