@isTest
private class TestReleaseTrigger {
     static testMethod void TestAfterUpdate(){
        copado__Release__c firstRelease = TestDataFactory.createCopadoRelease('firstRelease'); //new copado__Release__c(Name='firstRelease');
        copado__Release__c secondRelease = TestDataFactory.createCopadoRelease('secondRelease'); // new copado__Release__c(Name='secondRelease');
        copado__Environment__c BPEnvironment = TestDataFactory.createEnvironment('BP'); //new copado__Environment__c(Name='BP');
        copado__Environment__c NotBPEnvironment = TestDataFactory.createEnvironment('Production'); //new copado__Environment__c(Name='Production');
        copado__User_Story__c firstReleaseUS1 = new copado__User_Story__c();
        copado__User_Story__c firstReleaseUS2 = new copado__User_Story__c();
        copado__User_Story__c secondReleaseUS1 = new copado__User_Story__c();
        copado__User_Story__c secondReleaseUS2 = new copado__User_Story__c();
        copado__Release__c[] releases = new List<copado__Release__c>{firstRelease,secondRelease};
        copado__User_Story__c[] userStories = new List<copado__User_Story__c>{firstReleaseUS1,firstReleaseUS2,secondReleaseUS1,secondReleaseUS2};
        insert releases;
        insert BPEnvironment;
        insert NotBPEnvironment;

        firstReleaseUS1.copado__Release__c = firstRelease.id;
        firstReleaseUS1.copado__Environment__c = BPEnvironment.id;
        firstReleaseUS1.copado__Status__c ='Ready for testing';
        secondReleaseUS1.copado__Status__c ='Cancelled';
        secondReleaseUS1.copado__Cancellation_Reason__c='Bad Commited';

        firstReleaseUS2.copado__Release__c = firstRelease.id;
        firstReleaseUS2.copado__Environment__c = BPEnvironment.id;
        secondReleaseUS1.copado__Release__c = firstRelease.id;
        secondReleaseUS1.copado__Environment__c = BPEnvironment.id;
        secondReleaseUS2.copado__Release__c = secondRelease.id;
        secondReleaseUS2.copado__Environment__c = NotBPEnvironment.id;
        insert userStories;

        firstRelease.copado__Status__c = 'Released';
        secondRelease.copado__Status__c = 'Released';
        update releases;

        //
        firstReleaseUS1.copado__Status__c = [select copado__Status__c from copado__User_Story__c where  id = :firstReleaseUS1.id limit 1].copado__Status__c;
        firstReleaseUS2.copado__Status__c = [select copado__Status__c from copado__User_Story__c where  id = :firstReleaseUS2.id limit 1].copado__Status__c;
        secondReleaseUS1.copado__Status__c = [select copado__Status__c from copado__User_Story__c where  id = :secondReleaseUS1.id limit 1].copado__Status__c;
        secondReleaseUS2.copado__Status__c = [select copado__Status__c from copado__User_Story__c where  id = :secondReleaseUS2.id limit 1].copado__Status__c;
    
    
        System.assertEquals(firstRelease.copado__Status__c,'Released');
        System.assertEquals(secondRelease.copado__Status__c,'Released');

        System.assertEquals('Released',firstReleaseUS1.copado__Status__c);
        System.assertEquals('Released',firstReleaseUS2.copado__Status__c);
        System.assertNotEquals('Released',secondReleaseUS1.copado__Status__c);
        System.assertEquals('Released',secondReleaseUS2.copado__Status__c);

        //For Test Coverage, Remove if Delete or Undelete is tested in another Method. 
        User adminUser = [SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND isActive=true AND UserRole.Name ='System Administrator' LIMIT 1];
        System.runAs(adminUser) {
            delete releases;
        }
        undelete releases;

     }
    
}