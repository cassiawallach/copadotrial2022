@IsTest
private class AccountAutomationsTest {

    @isTest static void testDefaultDescription(){
        Account acc = new Account(Name = 'My Test Account');
        insert acc;
        acc = AccountAutomations.setDefaultDescription(acc);
        System.assertEquals('Default description', acc.Description, 'When description is null, it is updated to Default description');

        acc.Description = 'New Description Manual';
        
        acc = AccountAutomations.setDefaultDescription(acc);
        System.assertNotEquals('Default description', acc.Description, 'When description is NOT null, it is NOT updated to Default description');
    }

    @isTest static void testDefaultSite(){
        Account acc = new Account(Name = 'My Test Account');
        insert acc;
        acc = AccountAutomations.setDefaultSite(acc);
        System.assertEquals('Single location', acc.Site, 'Default Site is Single location');
    }

    @isTest static void testDefaultShippingAddress(){
        Account acc = new Account(Name = 'My Test Account');
        insert acc;
        acc = AccountAutomations.setDefaultShippingAddress(acc);
        System.assertEquals('14 N Sangamon', acc.ShippingStreet, 'Default ShippingStreet is 14 N Sangamon');
        System.assertEquals('Chicago', acc.ShippingState, 'Default Shippingtate is Chicago');
        System.assertEquals('60607', acc.ShippingPostalCode, 'Default ShippingPostalCode is 60607');
    }

    @isTest static void testDefaultPhone(){
        Account acc = new Account(Name = 'My Test Account');
        insert acc;
        acc = AccountAutomations.setDefaultPhone(acc);
        System.assertEquals('8582165994', acc.Phone, 'Default phone number is 8582165994');
    }

    @isTest static void testDefaultURL(){
        Account acc = new Account(Name = 'My Test Account');
        insert acc;
        acc = AccountAutomations.setDefaultURL(acc);
        System.assertEquals('www.copado.com', acc.Website, 'Default website is www.copado.com');
    }

}