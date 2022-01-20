/*
	SOQl queries for the SBQQ__Quote__c object

    JNC
    Silver Softworks
    12/06/2018
*/
public with sharing class CPQQuoteSelector extends SelectorBase {
	public Map<Id, SBQQ__Quote__c> GetQuoteById(Set<Id> quoteIDs)
	{
		// Build the query as a string
        String query = String.format('SELECT {0}, (select Id, SBQQ__ProductFamily__c, SBQQ__ListPrice__c, SBQQ__ListTotal__c, SBQQ__ProrateMultiplier__c, SBQQ__PackageTotal__c, SBQQ__DefaultSubscriptionTerm__c, SBQQ__CustomerPrice__c from SBQQ__LineItems__r where SBQQ__ProductFamily__c != \'\'Services\'\') FROM SBQQ__Quote__c WHERE ID IN :quoteIDs', new List<String> { GetFieldNamesString() } );
        List<SBQQ__Quote__c> quoteist = Database.query(query);
        
        return new Map<Id, SBQQ__Quote__c>(quoteist);
	}

	/*
        Populate fields which should be returned from SOQL queries
    */
    List<Schema.SObjectField> GetFields()
    {
        return new List<Schema.SObjectField>
        {
            SBQQ__Quote__c.Id,
            SBQQ__Quote__c.Name,
            SBQQ__Quote__c.SBQQ__Opportunity2__c,
            SBQQ__Quote__c.Number_of_Months__c
        };
    }
}