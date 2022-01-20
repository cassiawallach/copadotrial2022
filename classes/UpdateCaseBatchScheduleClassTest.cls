@isTest
public class UpdateCaseBatchScheduleClassTest {
    @isTest
    public static void unitTest(){
        Test.StartTest();
        UpdateCaseBatchScheduleClass testsche = new UpdateCaseBatchScheduleClass();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}