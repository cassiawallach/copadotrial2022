@isTest
private class AchievementAssignmentHandlerTest {
    static testMethod void updateReputationPoints() { 
     //create a user
        User u = new User();
        u.LastName = 'achtest';
        u.Username = 'test@achievement-trigger-copadouser.com';
        u.Email = 'test@achievement-trigger-copadouser.com';
        u.Alias = 'testuser';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales User'].Id;
        u.TimeZoneSidKey = 'GMT';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        
    // create an achievement
    
        redwing__Achievement__c badge = new redwing__Achievement__c();
        badge.Name = 'test badge';
        badge.redwing__Type__c = 'Achievements';
        badge.ReputationPoints__c = 3;
        insert badge;

    //create an achievement assginment 
    
        redwing__Achievement_Assignment__c badgea = new redwing__Achievement_Assignment__c();
        badgea.redwing__User__c = u.Id;
        badgea.redwing__Achievement__c  = badge.Id;
        badgea.redwing__Status__c = 'Eligible';
        insert badgea;
        badgea.redwing__Status__c = 'Acquired';
        update badgea;
        
        NetworkMember nw = [SELECT Id, ReputationPoints FROM NetworkMember WHERE MemberId = :u.Id];
        System.assertEquals(4, nw.ReputationPoints);
    } 
    
    static testMethod void updateReputationPointsWhenItIsNull() { 
     //create a user
        User u = new User();
        u.LastName = 'achtest';
        u.Username = 'test@achievement-trigger-null-copadouser.com';
        u.Email = 'test@achievement-trigger-null-copadouser.com';
        u.Alias = 'testuser';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales User'].Id;
        u.TimeZoneSidKey = 'GMT';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        
    // create an achievement
    
        redwing__Achievement__c badge = new redwing__Achievement__c();
        badge.Name = 'test badge';
        badge.redwing__Type__c = 'Achievements';
        badge.ReputationPoints__c = null;
        insert badge;

    //create an achievement assginment 
    
        redwing__Achievement_Assignment__c badgea = new redwing__Achievement_Assignment__c();
        badgea.redwing__User__c = u.Id;
        badgea.redwing__Achievement__c  = badge.Id;
        badgea.redwing__Status__c = 'Eligible';
        insert badgea;
        badgea.redwing__Status__c = 'Acquired';
        update badgea;
        
        NetworkMember nw = [SELECT Id, ReputationPoints FROM NetworkMember WHERE MemberId = :u.Id];
        System.assertEquals(1, nw.ReputationPoints);
    } 
    
    static testMethod void updateAchivementStatusEligible() { 
     //create a user
        User u = new User();
        u.LastName = 'achtest';
        u.Username = 'test@achievement-trigger-copadouser.com';
        u.Email = 'test@achievement-trigger-copadouser.com';
        u.Alias = 'testuser';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales User'].Id;
        u.TimeZoneSidKey = 'GMT';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        insert u;
        
        Account testAccount = new Account(Name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(LastName='test', AccountId=testAccount.Id);
        insert testContact;
    // create an achievement
    
        redwing__Achievement__c badge = new redwing__Achievement__c();
        badge.Name = 'test badge';
        badge.redwing__Type__c = 'Achievements';
        badge.ReputationPoints__c = 3;
        insert badge;
        
        Interactive_Validation__c validation = new Interactive_Validation__c(Name='IV Config Step Deff', Status__c = 'Active');
        insert validation;
        
        List<Interactive_Validation_Step__c> configSteps = new List<Interactive_Validation_Step__c>();
        configSteps.add(new Interactive_Validation_Step__c(Interactive_Validation__c=validation.Id, Name='Step A', ExecutionOrder__c=1, Environment__c='Dev1', Type__c='Validate Data', ExecutionDetails__c='test'));
        configSteps.add(new Interactive_Validation_Step__c(Interactive_Validation__c=validation.Id, Name='Step B', ExecutionOrder__c=2, Environment__c='Dev1', Type__c='Validate Metadata', ExecutionDetails__c='test'));
        insert configSteps;
        
        redwing__Training_Plan__c trainingPlan = TestDataFactory.createTrainingPlan('Test Developer');
        INSERT trainingPlan;
        
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(u.Id,testContact.Id,trainingPlan.Id);
        INSERT trainingPlanAssignment;
        
        redwing__Learning__c learning = TestDataFactory.createLearning('Test Learning');
        learning.Interactive_Validation__c = validation.Id;
        learning.Is_Dynamic__c = true;
        INSERT learning;
        
        redwing__Training_Plan_Section__c trainingPlanSection = TestDataFactory.createTrainigPlanSection('Test',trainingPlan.Id);
        INSERT trainingPlanSection;
        
        redwing__Training_Plan_Section_Assignment__c trainingPlanSectionAssignment = TestDataFactory.createTrainingPlanSectionAssignment(u.Id,trainingPlanSection.Id,trainingPlanAssignment.Id);
        INSERT trainingPlanSectionAssignment;
        
        redwing__Training_Plan_Section_Item__c trainingPlanSectionItem = TestDataFactory.createTrainingPlanSectionItem(learning.Id,trainingPlanSection.Id);
        INSERT trainingPlanSectionItem;
        
        redwing__Learning_Assignment__c learningAssignment = TestDataFactory.createLearningAssignment(testContact.Id,u.Id,trainingPlan.Id,learning.Id,trainingPlanSection.Id,trainingPlanSectionAssignment.Id,trainingPlanSectionItem.Id);
        INSERT learningAssignment;
        
        redwing__Training_Plan_Achievement__c Training_Plan_Achievement = new redwing__Training_Plan_Achievement__c();
        Training_Plan_Achievement.redwing__Training_Plan__c = trainingPlan.Id;
        Training_Plan_Achievement.redwing__Achievement__c = badge.Id;
        Insert Training_Plan_Achievement;

    //create an achievement assginment 
    
        redwing__Achievement_Assignment__c badgea = new redwing__Achievement_Assignment__c();
        badgea.redwing__User__c = u.Id;
        badgea.redwing__Achievement__c  = badge.Id;
        badgea.redwing__Training_Plan_Achievement__c = Training_Plan_Achievement.Id;
        badgea.redwing__Status__c = 'Eligible';
        insert badgea;
        badgea.redwing__Status__c = 'Acquired';
        update badgea;
        
        NetworkMember nw = [SELECT Id, ReputationPoints FROM NetworkMember WHERE MemberId = :u.Id];
        System.assertEquals(1, nw.ReputationPoints);
    } 
}