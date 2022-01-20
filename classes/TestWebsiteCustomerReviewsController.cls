@isTest
public class TestWebsiteCustomerReviewsController {
    static testMethod void fullTest(){
		
        PageReference pageRef = Page.WebsiteCustomerReviews;
		pageRef.getParameters().put('industry', '');
		Test.setCurrentPage(pageRef); 
		
        Account a1 = new Account(Name='Test 1', Industry='A1'); insert a1;
        Account a2 = new Account(Name='Test 2', Industry='A2'); insert a2;
        Account a3 = new Account(Name='Test 2', Industry='A1'); insert a3;
        
        Contact c1 = new Contact(FirstName='Phil1', LastName='Rack1', AccountId=a1.Id); insert c1;
        Contact c2 = new Contact(FirstName='Phil2', LastName='Rack2', AccountId=a2.Id); insert c2;
        Contact c3 = new Contact(FirstName='Phil3', LastName='Rack3', AccountId=a3.Id); insert c3;
        
        Customer_Review__c cr1 = new Customer_Review__c(Contact__c=c1.Id, Review__c='test', Published__c=false); insert cr1;
        Customer_Review__c cr2 = new Customer_Review__c(Contact__c=c2.Id, Review__c='test', Published__c=false); insert cr2;
        Customer_Review__c cr3 = new Customer_Review__c(Contact__c=c3.Id, Review__c='test', Published__c=false); insert cr3;
    
    	Test.startTest();
        WebsiteCustomerReviewsController con = new WebsiteCustomerReviewsController();
		con.init();
        system.assertEquals('', con.industry);
        system.assertEquals(1, con.industries.size());
        system.assertEquals(0, con.reviews.size());
        
        cr1.Published__c = true; update cr1;
        cr2.Published__c = true; update cr2;
        cr3.Published__c = true; update cr3;
        
        con = new WebsiteCustomerReviewsController();
		con.init();
        system.assertEquals('', con.industry);
        system.assertEquals(3, con.industries.size());
        system.assertEquals(3, con.reviews.size());
        
        pageRef.getParameters().put('industry', 'a1');
		Test.setCurrentPage(pageRef); 
		
        con = new WebsiteCustomerReviewsController();
		con.init();
        system.assertEquals('a1', con.industry);
        system.assertEquals(3, con.industries.size());
        system.assertEquals(2, con.reviews.size());
        
    }
}