@isTest
public with sharing class ListingSearchServiceTest {
    
    private static void createTestData() {
        Listing_Profile__c listingProfile = new Listing_Profile__c(Name='Copado Labs');
        insert listingProfile;

        List<Listing__c> listings = new List<Listing__c>();
        Listing__c listing1 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='My SearchString 1', Type__c='Template', Price__c='Free', Rating__c=5, Reviews__c=1, Published__c=true, Get_It_Now_Action__c = 'Download');
        Listing__c listing2 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='SearchString', Type__c='Template', Price__c='Paid', Rating__c=4, Reviews__c=1, Published__c=true, Get_It_Now_Action__c = 'Download');
        Listing__c listing3 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='RandomString', Type__c='Template', Price__c='Paid', Rating__c=5, Reviews__c=1, Published__c=true, Get_It_Now_Action__c = 'Download');
        Listing__c listing4 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='SearchString', Type__c='Template', Price__c='Free', Rating__c=4, Reviews__c=1, Published__c=false, Get_It_Now_Action__c = 'Download');
        Listing__c listing5 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='SearchString', Type__c='Template', Price__c='Paid', Rating__c=4, Reviews__c=1, Published__c=false, Get_It_Now_Action__c = 'Download');
        Listing__c listing6 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='SearchString', Type__c='Integration', Price__c='Paid', Rating__c=0, Reviews__c=0, Published__c=true, Get_It_Now_Action__c = 'Download');
        Listing__c listing7 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='SearchString', Type__c='Integration', Price__c='Paid', Rating__c=0, Reviews__c=0, Published__c=false, Get_It_Now_Action__c = 'Download');
        Listing__c listing8 = new Listing__c(Listing_Profile__c=listingProfile.Id, Name='SearchString', Type__c='Integration', Price__c='Free', Rating__c=0, Reviews__c=0, Published__c=false, Get_It_Now_Action__c = 'Download');
        listings.add(listing1);
        listings.add(listing2);
        listings.add(listing3);
        listings.add(listing4);
        listings.add(listing5);
        listings.add(listing6);
        listings.add(listing7);
        listings.add(listing8);
        insert listings;
    }
    static testMethod void soslSearchtest_NoString() {
        createTestData();
        ListingSearchService.Filter filter = new ListingSearchService.Filter();
        filter.searchKey = '';
        filter.listingType = new String[]{'Template', 'Integration'};
        filter.price = '';
        filter.rating = new String[]{};
        
        Map<String, ListingSearchService.PagedResult> result = ListingSearchService.getListings(filter, 8, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(2, result.keySet().size());
        system.assertEquals(3, result.get('Template').listings.size());
        system.assertEquals(3, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(8, result.get('Template').pageSize);
        system.assertEquals(1, result.get('Integration').listings.size());
        system.assertEquals(1, result.get('Integration').total);
        system.assertEquals(1, result.get('Integration').pages);
        system.assertEquals(8, result.get('Integration').pageSize);        
    }
    static testMethod void soslSearchtest_Type() {
        createTestData();
        ListingSearchService.Filter filter = new ListingSearchService.Filter();
        filter.searchKey = 'SearchString';
        filter.listingType = new String[]{'Template'};
        filter.price = '';
        filter.rating = new String[]{};
        
        Map<String, ListingSearchService.PagedResult> result = ListingSearchService.getListings(filter, 8, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(1, result.keySet().size());
        system.assertEquals(2, result.get('Template').listings.size());
        system.assertEquals(2, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(8, result.get('Template').pageSize);

        result = ListingSearchService.getListings(filter, 1, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(1, result.keySet().size());
        system.assertEquals(1, result.get('Template').listings.size());
        system.assertEquals(2, result.get('Template').total);
        system.assertEquals(2, result.get('Template').pages);
        system.assertEquals(1, result.get('Template').pageSize);
        
        filter.listingType = new String[]{'Template', 'Integration'};
        result = ListingSearchService.getListings(filter, 8, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(2, result.keySet().size());
        system.assertEquals(2, result.get('Template').listings.size());
        system.assertEquals(2, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(8, result.get('Template').pageSize);
        system.assertEquals(1, result.get('Integration').listings.size());
        system.assertEquals(1, result.get('Integration').total);
        system.assertEquals(1, result.get('Integration').pages);
        system.assertEquals(8, result.get('Integration').pageSize);        
    }
    static testMethod void soslSearchtest_Price() {
        createTestData();
        ListingSearchService.Filter filter = new ListingSearchService.Filter();
        filter.searchKey = 'String';
        filter.listingType = new String[]{'Template', 'Integration'};
        filter.price = 'Free';
        filter.rating = new String[]{};
        
        Map<String, ListingSearchService.PagedResult> result = ListingSearchService.getListings(filter, 8, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(2, result.keySet().size());
        system.assertEquals(1, result.get('Template').listings.size());
        system.assertEquals(1, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(8, result.get('Template').pageSize);
        system.assertEquals(0, result.get('Integration').listings.size());
        system.assertEquals(0, result.get('Integration').total);
        system.assertEquals(1, result.get('Integration').pages);
        system.assertEquals(8, result.get('Integration').pageSize);
		
        filter.price = 'Paid';
        result = ListingSearchService.getListings(filter, 8, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(2, result.keySet().size());
        system.assertEquals(1, result.get('Integration').listings.size());
        system.assertEquals(1, result.get('Integration').total);
        system.assertEquals(1, result.get('Integration').pages);
        system.assertEquals(8, result.get('Integration').pageSize);
        system.assertEquals(2, result.get('Template').listings.size());
        system.assertEquals(2, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(8, result.get('Template').pageSize);
    }
    static testMethod void soslSearchtest_Rating() {
        createTestData();
        ListingSearchService.Filter filter = new ListingSearchService.Filter();
        filter.searchKey = 'String';
        filter.listingType = new String[]{'Template', 'Integration'};
        filter.price = '';
        filter.rating = new String[]{'5'};
        
        Map<String, ListingSearchService.PagedResult> result = ListingSearchService.getListings(filter, 8, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(2, result.keySet().size());
        system.assertEquals(2, result.get('Template').listings.size());
        system.assertEquals(2, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(8, result.get('Template').pageSize);
        system.assertEquals(0, result.get('Integration').listings.size());
        system.assertEquals(0, result.get('Integration').total);
        system.assertEquals(1, result.get('Integration').pages);
        system.assertEquals(8, result.get('Integration').pageSize);
        
        filter.rating = new String[]{'Not Rated'};
        result = ListingSearchService.getListings(filter, 8, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(2, result.keySet().size());
        system.assertEquals(1, result.get('Integration').listings.size());
        system.assertEquals(1, result.get('Integration').total);
        system.assertEquals(1, result.get('Integration').pages);
        system.assertEquals(8, result.get('Integration').pageSize);
        system.assertEquals(0, result.get('Template').listings.size());
        system.assertEquals(0, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(8, result.get('Template').pageSize);
        
        filter.rating = new String[]{'5', '4'};
        result = ListingSearchService.getListings(filter, 3, 1);
        system.debug('### Search Result: '+result);
        system.assertEquals(2, result.keySet().size());
        system.assertEquals(3, result.get('Template').listings.size());
        system.assertEquals(3, result.get('Template').total);
        system.assertEquals(1, result.get('Template').pages);
        system.assertEquals(3, result.get('Template').pageSize);
        system.assertEquals(0, result.get('Integration').listings.size());
        system.assertEquals(0, result.get('Integration').total);
        system.assertEquals(1, result.get('Integration').pages);
        system.assertEquals(3, result.get('Integration').pageSize);
    }
    static testMethod void whereClauseRating() {
        String[] input;
        String expectedResult;
        String actualResult;
        
        input = new String[]{ 'Not Rated' };
        expectedResult = 'Reviews__c=0 ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '1' };
        expectedResult = '(Rating__c>=0 AND Rating__c<2) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '2' };
        expectedResult = '(Rating__c>=2 AND Rating__c<3) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '3' };
        expectedResult = '(Rating__c>=3 AND Rating__c<4) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '4' };
        expectedResult = '(Rating__c>=4 AND Rating__c<5) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '5' };
        expectedResult = 'Rating__c=5 ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);

        input = new String[]{ '5', '4' };
        expectedResult = 'Rating__c=5 OR (Rating__c>=4 AND Rating__c<5) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '3', '2' };
        expectedResult = '(Rating__c>=3 AND Rating__c<4) OR (Rating__c>=2 AND Rating__c<3) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '2', '1' };
        expectedResult = '(Rating__c>=2 AND Rating__c<3) OR (Rating__c>=0 AND Rating__c<2) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
        
        input = new String[]{ '5', '4', '3' };
        expectedResult = 'Rating__c=5 OR (Rating__c>=4 AND Rating__c<5) OR (Rating__c>=3 AND Rating__c<4) ';
        actualResult = ListingSearchService.createWhereClause_Rating(input);
        system.assertEquals(expectedResult, actualResult);
    }
}