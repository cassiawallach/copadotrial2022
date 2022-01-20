@isTest
public class ExpOpptyWarningCtrlTest{

    static testmethod void ExpansionOpptyHelperMethod(){
        Account a = new Account(Name='My Account');
        insert a;
        
        Contact con = new Contact(FirstName='Test', LastName='Test', AccountId=a.Id);
        insert con;
        
        Id expRecdTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Expansion').getRecordTypeId();
        Opportunity o = new Opportunity(Name='My Opp', AccountId=a.Id, RecordTypeId = expRecdTypeId , StageName='Marketing Qualification', CloseDate=Date.today()+10, CurrencyIsoCode='EUR');
        o.Amount = 99.0;
        o.LeadSource = 'Advertisement' ;
        o.ExpansionOppWarningLeadSource__c = false;
        insert o;       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        ExpOpportunityWarningCtrl expWarning = new ExpOpportunityWarningCtrl(sc);
        
        PageReference pageRef = Page.ExpOpportunityWarning;
        pageRef.getParameters().put('id', String.valueOf(o.Id));
        Test.setCurrentPage(pageRef);
        expWarning.updateOpportunity();
           
    }
}