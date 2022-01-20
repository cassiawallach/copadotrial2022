@isTest
private class TestAdmin_utilities {

    static testMethod void test_checkSyncFeatures(){
        Salesforce_Org__c org = new Salesforce_Org__c(Name='TestSyncOrg', OrgId__c='AABBBCCCC566789');
        insert org;

        //Sync Features with US-Server
        org.Copado_Server__c = 'US-East';
        update org;
        admin_utilities.syncFeatures(org.Id);

        //Sync Features with EU-Server
        org.Copado_Server__c = 'EU-West';
        update org;
        admin_utilities.syncFeatures(org.Id);

        //Sync Features with Private Space Server
        org.Copado_Server__c = 'Other';
        org.Server_URL__c = 'www.copa.do';
        update org;
        admin_utilities.syncFeatures(org.Id);

        //Sync Features without accountId
        admin_utilities.syncFeatures();
    }

    static testMethod void test_addTransaction() {
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Transactions', OrgId__c='SOMEMOCKID123');
        insert org;

        testHttpCalloutMock request1 = new testHttpCalloutMock(200, 'Complete', '{"customerOrg":{"Name":"Copado Ltd","orgId":"orgId123","autoRecharge":true,"credits":425,"id":995},"userInfo":{"accessibilityMode__is_set":true,"accessibilityMode":false,"currencySymbol__is_set":true,"currencySymbol":"€","orgAttachmentFileSizeLimit__is_set":true,"orgAttachmentFileSizeLimit":5242880,"orgDefaultCurrencyIsoCode__is_set":true,"orgDefaultCurrencyIsoCode":"EUR","orgDisallowHtmlAttachments__is_set":true,"orgDisallowHtmlAttachments":false,"orgHasPersonAccounts__is_set":true,"orgHasPersonAccounts":false,"organizationId__is_set":true,"organizationId":"00Db0000000KFgoEAG","organizationMultiCurrency__is_set":true,"organizationMultiCurrency":false,"organizationName__is_set":true,"organizationName":"Copado Ltd","profileId__is_set":true,"profileId":"00eb0000000mWB2AAM","roleId__is_set":true,"sessionSecondsValid__is_set":true,"sessionSecondsValid":7200,"userDefaultCurrencyIsoCode__is_set":true,"userEmail__is_set":true,"userEmail":"pr@copa.do","userFullName__is_set":true,"userFullName":"Philipp Rackwitz","userId__is_set":true,"userId":"userId123","userLanguage__is_set":true,"userLanguage":"en_US","userLocale__is_set":true,"userLocale":"en_GB","userName__is_set":true,"userName":"pr@copa.do.basepackage","userTimeZone__is_set":true,"userTimeZone":"Europe/Paris","userType__is_set":true,"userType":"Standard","userUiSkin__is_set":true,"userUiSkin":"Theme3"}}');
        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('https://testMethod.com/admin/addCredits/123orgId123/0?pkey=RANDOMKEY&uid=123userId123&oppId='+org.Id+'&amount=100.00&currency=GBP&type=Credit+Order&description=Not+Available', request1);
        system.debug('################### https://testMethod.com/admin/addCredits/123orgId123/0?pkey=RANDOMKEY&uid=123userId123&oppId='+org.Id+'&amount=100.00&currency=EUR&type=Credit+Order&description=Not+Available');
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        admin_utilities.addTransaction(org.Id, 'addCredits', 288);
        //addTransaction(Id orgId, String apiMethod, 288)
        //void method but should return confirmation?
        system.assert(request1 != null);
    }
    static testMethod void test_addTransaction_Minutes() {
        Salesforce_Org__c org = new Salesforce_Org__c(Name='Test Transactions', OrgId__c='SOMEMOCKID123');
        insert org;

        testHttpCalloutMock request1 = new testHttpCalloutMock(200, 'Complete', '{"customerOrg":{"Name":"Copado Ltd","orgId":"orgId123","autoRecharge":true,"credits":425,"id":995},"userInfo":{"accessibilityMode__is_set":true,"accessibilityMode":false,"currencySymbol__is_set":true,"currencySymbol":"€","orgAttachmentFileSizeLimit__is_set":true,"orgAttachmentFileSizeLimit":5242880,"orgDefaultCurrencyIsoCode__is_set":true,"orgDefaultCurrencyIsoCode":"EUR","orgDisallowHtmlAttachments__is_set":true,"orgDisallowHtmlAttachments":false,"orgHasPersonAccounts__is_set":true,"orgHasPersonAccounts":false,"organizationId__is_set":true,"organizationId":"00Db0000000KFgoEAG","organizationMultiCurrency__is_set":true,"organizationMultiCurrency":false,"organizationName__is_set":true,"organizationName":"Copado Ltd","profileId__is_set":true,"profileId":"00eb0000000mWB2AAM","roleId__is_set":true,"sessionSecondsValid__is_set":true,"sessionSecondsValid":7200,"userDefaultCurrencyIsoCode__is_set":true,"userEmail__is_set":true,"userEmail":"pr@copa.do","userFullName__is_set":true,"userFullName":"Philipp Rackwitz","userId__is_set":true,"userId":"userId123","userLanguage__is_set":true,"userLanguage":"en_US","userLocale__is_set":true,"userLocale":"en_GB","userName__is_set":true,"userName":"pr@copa.do.basepackage","userTimeZone__is_set":true,"userTimeZone":"Europe/Paris","userType__is_set":true,"userType":"Standard","userUiSkin__is_set":true,"userUiSkin":"Theme3"}}');
        Map<String, HttpCalloutMock> calloutMap = new Map<String, HttpCalloutMock>();
        calloutMap.put('https://testMethod.com/admin/addMinutes/123orgId123/0?pkey=RANDOMKEY&uid=123userId123&oppId='+org.Id+'&amount=100.00&currency=GBP&type=Credit+Order&description=Not+Available', request1);
        system.debug('################### https://testMethod.com/admin/addMinutes/123orgId123/0?pkey=RANDOMKEY&uid=123userId123&oppId='+org.Id+'&amount=100.00&currency=EUR&type=Credit+Order&description=Not+Available');
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(calloutMap);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        admin_utilities.addTransaction(org.Id, 'addMinutes', 288);
        //void method but should return confirmation?
        system.assert(request1 != null);
    }

    static testMethod void test_getAuthToken() {

        String sid = '<sessionId might change>';
        String cdate = Datetime.now().formatGMT('yyyy-MM-dd');
        String myData =  'Copado Deployer by Copado LtduserIdorgId'+sid+cdate;
        Blob hash = Crypto.generateDigest('MD5',Blob.valueOf(myData));
        String expected = EncodingUtil.convertToHex(hash);

        String result = admin_utilities.getAuthToken('orgId', 'userId');
        system.assertEquals(expected, result);
    }
    static testMethod void test_setAuthHeaders(){
        HttpRequest req = new HttpRequest();
        admin_utilities.setAuthHeaders(req, 'uId', 'oId', 'sId');
        system.assertEquals('uId', req.getHeader('userId'));
        system.assertEquals('oId', req.getHeader('orgId'));
        system.assertEquals('sId', req.getHeader('sessionId'));
    }
}