@isTest
public class FeaturedUserSliderTest {
    
    @testSetup
    public static void setupMethod(){   
    }
    @isTest
    public static void test1(){
        FeaturedUserController.GetFeaturedUsers(UserInfo.getUserId());
        
    }
}