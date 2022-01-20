@isTest
public class TestSalesforceCampaignTriggerHelper {
	@isTest
    public static void unitTest(){
        Test.startTest();
        Campaign cmp = TestDataFactory.createCampaign('Copado Data Deploy','EUR');
        INSERT cmp;
        cmp.Name ='Test';
        cmp.StartDate = system.today();
        UPDATE cmp;
        Test.stopTest();
       
    }
}