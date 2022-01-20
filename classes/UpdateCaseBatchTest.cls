@isTest
public class UpdateCaseBatchTest {
    @isTest
    public static void unitTest(){
        Case c = new Case(SuppliedEmail='test@test.com', SuppliedCompany='Test', SuppliedName='Test User', NoReplyAge__c=2, Last_Case_Comment_Time__c=system.today());
        insert c;
        Test.startTest();
        UpdateCaseBatch batchObj = new UpdateCaseBatch();
        Database.executeBatch(batchObj);
        Test.stopTest();
    }
}