/**
 * This is a generic search service class that is used by the LWC ListingResultListTemplate
 * component and others.
 * Author: Philipp Rackwitz
 * Version: 0.1
 */
 public with sharing class ListingSearchService {
    
    public class PagedResult {
        @AuraEnabled
        public Integer pageSize { get; set; }

        @AuraEnabled
        public Integer page { get; set; }

        @AuraEnabled
        public Integer pages { get; set; }

        @AuraEnabled
        public Integer total { get; set; }

        @AuraEnabled
        public List<Listing__c> listings { get; set; }
    }
    
    public class Filter {
        @AuraEnabled
        public String searchKey { get; set; }

        @AuraEnabled
        public String[] listingType { get; set; }

        @AuraEnabled
        public String price { get; set; }

        @AuraEnabled
        public String[] rating { get; set; }
    }

    /**
     * Private search method to provide SOSL support.
     * @param  filter Array with filter criteria.
     * @param  pageSize - used for pagination.
     * @param  pageNumber - used for pagination.
     * @return   PagedResult to be returned for the UI.
     */   
    @AuraEnabled(cacheable=true)
    public static Map<String, PagedResult> getListings(Filter filter, Decimal pageSize, Decimal pageNumber) {
        Map<String, PagedResult> results = new Map<String, PagedResult>();
        if(filter==null) return results;
        for (String listingType : filter.listingType) {
            PagedResult r = getListingByType(listingType, filter, pageSize, pageNumber);
            results.put(listingType, r);
        }
        return results;
    }

    public static PagedResult getListingByType(String listingType, Filter filter, Decimal pageSize, Decimal pageNumber) {
        pageSize = (pageSize==null || pageSize==0)? 1 : pageSize;
        pageNumber = (pageNumber==null || pageNumber==0)? 1 : pageNumber;
                
        Integer pSize = (Integer) pageSize;
        String key = '%' + filter.searchKey + '%';
        Integer offset = ((Integer) pageNumber - 1) * pSize;
        PagedResult r = new PagedResult();
        r.pageSize = pSize;
        r.page = (Integer) pageNumber;
        String price = filter.price;
        String[] rating = filter.rating;

        String countSQL =
            'SELECT count() FROM Listing__c WITH_SECURITY_ENFORCED WHERE Name LIKE :key AND Published__c=true ';
        if (!String.isBlank(listingType)) {
            countSQL = countSQL + 'AND Type__c = :listingType ';
        }
        if (!String.isBlank(filter.price)) {
            countSQL = countSQL + 'AND Price__c = :price ';
        }
        if (filter.rating.size()>0) {
            countSQL = countSQL + 'AND ('+createWhereClause_Rating(filter.rating)+') ';
        }
        system.debug('countSQL String: '+countSQL);
        r.total = Database.countQuery(countSQL);
        r.pages = (Math.ceil(r.total / r.pageSize)).intValue();
        if (r.pages == 0) {
            r.pages = 1;
        }
        String sql =
            'SELECT Id, Name, Latest_Release__c, Price__c, Rating__c, Reviews__c ' +
            'FROM Listing__c WITH_SECURITY_ENFORCED WHERE Name LIKE :key AND Published__c=true ';
        if (!String.isBlank(listingType)) {
            sql = sql + 'AND Type__c = :listingType ';
        }
        if (!String.isBlank(filter.price)) {
            sql = sql + 'AND Price__c = :price ';
        }
        if (filter.rating.size()>0) {
            sql = sql + 'AND ('+createWhereClause_Rating(filter.rating)+') ';
        }
        sql = sql + 'LIMIT :pSize OFFSET :offset';
        system.debug('SQL String: '+sql);
        r.listings = Database.query(sql);
        return r;
    }
    public static String createWhereClause_Rating(String[] ratings) {
        if(ratings.size()==0)return '';
        String result = '';
        for (String rating : ratings) {
            if (rating=='5') {
                result = result + ((result.length()>0)?' OR ':'') + 'Rating__c=5';
            }
            if (rating=='4') {
                result = result + ((result.length()>0)?' OR ':'') + '(Rating__c>=4 AND Rating__c<5)';
            }
            if (rating=='3') {
                result = result + ((result.length()>0)?' OR ':'') + '(Rating__c>=3 AND Rating__c<4)';
            }
            if (rating=='2') {
                result = result + ((result.length()>0)?' OR ':'') + '(Rating__c>=2 AND Rating__c<3)';
            }
            if (rating=='1') {
                result = result + ((result.length()>0)?' OR ':'') + '(Rating__c>=0 AND Rating__c<2)';
            }
            if (rating=='Not Rated') {
                result = result + ((result.length()>0)?' OR ':'') + 'Reviews__c=0';
            }
        }
        return result+' ';
    }
}