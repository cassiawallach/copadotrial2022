/* 
 * Test class for CommunityUserCounterController class
*/
@isTest
public class CommunityUserCounterControllerTest {
    @isTest
    public static void getUserCount(){
        Test.startTest();
        Integer count = CommunityUserCounterController.getUserRecords();
        Test.stopTest();
        System.assertNotEquals(0, count, 'User shold be available there');
    }
}