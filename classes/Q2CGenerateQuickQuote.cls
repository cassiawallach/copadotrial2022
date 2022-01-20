public class Q2CGenerateQuickQuote {

// This is an Extension Controller. Thus, we must invoke the standard controller.
    public Q2CGenerateQuickQuote(ApexPages.StandardController controller) {
    }

// Method for creating Quote 


    public static PageReference genQuote() {
        String mydomain = System.Url.getSalesforceBaseUrl().toExternalForm().substringBefore('.').substringBeforeLast('c');

        String instanceName = [SELECT InstanceName FROM Organization LIMIT 1].InstanceName;
        String quoteId;
        Id acctId = ApexPages.currentPage().getParameters().get('id');
        Account acct  = [Select Id, Name from Account where id=:acctId];
        Opportunity opp = new Opportunity(CloseDate = Date.today(), AccountId = acctId, Amount = 0, StageName = 'Marketing Qualification', Name = acct.Name + ' - ' + 'Marketing Qualification', LeadSource='Advertisement');
        
        Database.insert(opp);
        Id oppId = opp.Id;
        
        SBQQ__Quote__c q = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Account__c = acctId, 
            SBQQ__SubscriptionTerm__c = 12, SBQQ__Opportunity2__c = oppId, SBQQ__Status__c = 'Draft', 
            SBQQ__Type__c = 'Quote', SBQQ__SalesRep__c=UserInfo.getUserId(), 
            SBQQ__StartDate__c = date.today().addMonths(1).toStartofMonth(), 
            SBQQ__EndDate__c = date.today().addyears(1).addMonths(1).toStartofMonth().addDays(-1));
        
        List<Contact> contactList = [SELECT Id FROM Contact WHERE AccountId = :acctId LIMIT 1];
        if (contactList.size() > 0) {
            q.SBQQ__PrimaryContact__c = contactList.get(0).Id;
        }
        Database.insert(q);
        quoteId = q.Id;
        //Returns URL and redirects the Visualforce page
        // return new PageReference(mydomain + 'sbqq.' + instanceName + '.visual.force.com/apex/sb?scontrolCaching=1&id=' + quoteId + '#quote/le?qId=' + quoteId);

        return new PageReference('/apex/sbqq__sb?scontrolCaching=1&id=' + quoteId + '#quote/le?qId=' + quoteId);
    }
}