@isTest
(SeeAllData=true)
private class TestInvoicePDFextension {

    static testMethod void myUnitTest() {
    	Invoice__c inv = new Invoice__c();
        try{
            inv = [select id from Invoice__c order by createddate desc limit 1];
        }
        catch (Exception e){
            Account acc = new Account();
            acc.name = 'test';
            insert acc;
            
            
            inv.account__c = acc.id;
            inv.Status__c = 'Paid';
            insert inv;
        }
        PageReference pageRef = new PageReference('/invoicepdf?id='+inv.id);
        Test.setCurrentPage(pageRef);
        
        invoicePDFextension ext = new invoicePDFextension(new Apexpages.Standardcontroller(inv));
    }
}