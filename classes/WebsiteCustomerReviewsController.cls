public class WebsiteCustomerReviewsController {
    
    public Set<String> industries {get;set;}
    public List<Customer_Review__c> reviews {get;set;}
    public String industry {get;set;}
    
    public PageReference init(){
        industry = ApexPages.currentPage().getParameters().get('industry');
		getReviews(industry);
        createIndustryList();
        return null;
    }
    public void getReviews(String i){
        reviews = new List<Customer_Review__c>();
        if(String.isNotEmpty(i) && i!='All'){
            reviews = [SELECT Id, Review__c, Contact__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Account.Name, Contact__r.Account.Industry
                   FROM Customer_Review__c where Published__c=true and Contact__r.Account.Industry=:industry order by Order__c ASC];
        }
        else{
            reviews = [SELECT Id, Review__c, Contact__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Account.Name, Contact__r.Account.Industry
                   FROM Customer_Review__c where Published__c=true order by Order__c ASC];
        }
    }
    public void createIndustryList(){
        industries = new Set<String>();
        industries.add('All');
        for(Customer_Review__c cr : [select Id, Contact__r.Account.Industry from Customer_Review__c where Published__c=true order by Contact__r.Account.Industry DESC]){
            industries.add(cr.Contact__r.Account.Industry);
        }
    }
}