@IsTest
private class TestUseCaseObject {
    @IsTest
    static void testValidationDate() {
        Use_Case__c myUseCase = new Use_Case__c();
        myUseCase.Name = 'New Use Case';
        myUseCase.Status__c = 'In Definition';
        insert myUseCase;

        myUseCase.Status__c = 'Automatically Tested';
        update myUseCase;

        Use_Case__c assertUseCase = [SELECT Id, Automated_Date__c FROM Use_Case__c WHERE Id = :myUseCase.Id];
        
        System.assertEquals(System.today(), assertUseCase.Automated_Date__c);

    }
}