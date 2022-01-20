@isTest
public class CommunitySignupControllerTest {
	@isTest
    public static void test(){
        
        Account accountObj = TestDataFactory.createAccount('Guest Community Users','EUR');
        Insert accountObj;
        
        Account_Email_Domain__c emailDomain = TestDataFactory.createAccountEmailDomain('Testcopado.com',accountObj.Id);
        Insert emailDomain;
		
        Test.startTest();
        CommunitySignupController.fetchInitData();
        Test.stopTest();
        CommunitySignupController.UserWrap u = new CommunitySignupController.UserWrap();
        u.firstName = 'test first';
        u.lastName = 'test last';
        u.email = 'test74832748@Testcopado.com';
        u.jobRole ='Developer';
        u.country = 'US';
        u.state = 'TX';
        u.city = 'testCity';
        u.zipcode = '111';
        u.companyName = 'Demo';
        u.corporateEmail = 'test74832748@Testcopado.com';
        u.title = 'Developer';
        u.iAmExistingCustomer = true;
        u.iAmExistingPartner = false;
        CommunitySignupController.createCommunityUser(JSON.serialize(u));
    }
}