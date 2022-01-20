@IsTest
private with sharing class TestExpirePlaygrounds {
    @TestSetup
    static void makeData() {
        Account account = new Account(Name = 'Test Account 1');
        insert account;

        Contact contactOne = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@copado.com', AccountId = account.Id);
        Contact contactTwo = new Contact(FirstName = 'Jen', LastName = 'Doe', Email = 'jen.doe@copado.com', AccountId = account.Id);
        Contact contactThree = new Contact(FirstName = 'Peter', LastName = 'Graph', Email = 'pete.graph@copado.com', AccountId = account.Id);

        insert new List<Contact>{ contactOne, contactTwo, contactThree };
    }

    @IsTest
    static void testPlaygroundExpirationBatch() {
        Id johnId;
        Id jenId;
        Id peteId;
        for (Contact contactItem : [SELECT Id, Email FROM Contact WHERE Account.Name = 'Test Account 1']) {
            switch on contactItem.Email {
                when 'john.doe@copado.com' {
                    johnId = contactItem.Id;
                }
                when 'jen.doe@copado.com' {
                    jenId = contactItem.Id;
                }
                when 'pete.graph@copado.com' {
                    peteId = contactItem.Id;
                }
            }
        }

        Signup_Request__c signupReqOne = new Signup_Request__c();
        signupReqOne.First_Name__c = 'John';
        signupReqOne.Last_Name__c = 'Doe';
        signupReqOne.Company__c = 'Copado, Inc.';
        signupReqOne.Country__c = 'US';
        signupReqOne.Email__c = 'john.doe@copado.com';
        signupReqOne.Username__c = 'jon.doe@copado.com.test';
        signupReqOne.Template__c = '0TT1i00000269iK';

        Signup_Request__c signupReqTwo = new Signup_Request__c();
        signupReqTwo.First_Name__c = 'Jen';
        signupReqTwo.Last_Name__c = 'Doe';
        signupReqTwo.Company__c = 'Copado, Inc.';
        signupReqTwo.Country__c = 'US';
        signupReqTwo.Email__c = 'jen.doe@copado.com';
        signupReqTwo.Username__c = 'jen.doe@copado.com.test';
        signupReqTwo.Template__c = '0TT1i00000269iK';

        Signup_Request__c signupReqThree = new Signup_Request__c();
        signupReqThree.First_Name__c = 'Peter';
        signupReqThree.Last_Name__c = 'Graph';
        signupReqThree.Company__c = 'Copado, Inc.';
        signupReqThree.Country__c = 'US';
        signupReqThree.Email__c = 'pete.gr@copado.com';
        signupReqThree.Username__c = 'pete.gr@copado.coom.test';
        signupReqThree.Template__c = '0TT1i00000269iK';

        insert new List<Signup_Request__c>{ signupReqOne, signupReqTwo, signupReqThree };

        Test.setCreatedDate(signupReqOne.Id, DateTime.newInstance(2018, 12, 12));
        Test.setCreatedDate(signupReqTwo.Id, DateTime.newInstance(2018, 12, 12));

        Playground__c playGroundOne = new Playground__c();
        playGroundOne.Name = 'John Playground';
        playGroundOne.Contact__c = johnId;
        playGroundOne.Custom_Signup_Request__c = signupReqOne.Id;

        Playground__c playGroundTwo = new Playground__c();
        playGroundTwo.Name = 'Jen Playground';
        playGroundTwo.Contact__c = jenId;
        playGroundTwo.Custom_Signup_Request__c = signupReqTwo.Id;

        Playground__c playGroundThree = new Playground__c();
        playGroundThree.Name = 'Pete Playground';
        playGroundThree.Contact__c = peteId;
        playGroundThree.Custom_Signup_Request__c = signupReqThree.Id;

        insert new List<Playground__c>{ playGroundOne, playGroundTwo, playGroundThree };

        Test.startTest();
        List<Playground__c> testPlaygrounds = [
            SELECT Id, Name, Status__c, Custom_Signup_Request__r.Is_Expired__c, Custom_Signup_Request__r.CreatedDate
            FROM Playground__c
        ];

        for (Playground__c playGroundItem : testPlaygrounds) {
            switch on playGroundItem.Name {
                when 'John Playground' {
                    System.assertNotEquals('Expired', playGroundItem.Status__c, 'Status must be different from "Expired"');
                    System.assertEquals(true, playGroundItem.Custom_Signup_Request__r.Is_Expired__c);
                }
                when 'Jen Playground' {
                    System.assertNotEquals('Expired', playGroundItem.Status__c, 'Status must be different from "Expired"');
                    System.assertEquals(true, playGroundItem.Custom_Signup_Request__r.Is_Expired__c);
                }
                when 'Pete Playground' {
                    System.assertNotEquals('Expired', playGroundItem.Status__c, 'Status must be different from "Expired"');
                    System.assertEquals(false, playGroundItem.Custom_Signup_Request__r.Is_Expired__c);
                }
            }
        }

        ExpiredPlaygroundsBatch expiredPlaygrounds = new ExpiredPlaygroundsBatch();
        database.executebatch(expiredPlaygrounds, 200);

        Test.stopTest();

        testPlaygrounds = [SELECT Id, Name, Status__c, Custom_Signup_Request__r.Is_Expired__c FROM Playground__c];
        for (Playground__c playGroundItem : testPlaygrounds) {
            switch on playGroundItem.Name {
                when 'John Playground' {
                    System.assertEquals('Expired', playGroundItem.Status__c, 'Status must be "Expired"');
                    System.assertEquals(true, playGroundItem.Custom_Signup_Request__r.Is_Expired__c);
                }
                when 'Jen Playground' {
                    System.assertEquals('Expired', playGroundItem.Status__c, 'Status must be "Expired"');
                    System.assertEquals(true, playGroundItem.Custom_Signup_Request__r.Is_Expired__c);
                }
                when 'Pete Playground' {
                    System.assertNotEquals('Expired', playGroundItem.Status__c, 'Status must be different from "Expired"');
                    System.assertEquals(false, playGroundItem.Custom_Signup_Request__r.Is_Expired__c);
                }
            }
        }
    }

    @IsTest
    static void testPlaygroundExpirationSchdulable() {
        Test.startTest();
        String strCrnExp = Datetime.now().addSeconds(5).format('s m H d M ? yyyy');
        String jobId = System.schedule('testScheduleExpiredPlaygrounds', strCrnExp, new ExpiredPlaygroundsSchedulable());
        Test.stopTest();
        CronTrigger cronTrigger = [SELECT Id FROM CronTrigger WHERE id = :jobId];
        System.assertNotEquals(null, cronTrigger, 'Cron is not created properly');
    }
}