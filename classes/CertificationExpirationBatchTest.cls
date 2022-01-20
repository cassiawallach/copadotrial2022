@isTest
public class CertificationExpirationBatchTest {
    
    @testSetup
    public static void setupMethod(){
        Account accountObj = TestDataFactory.createAccount('TestGuestUser','EUR');
        INSERT accountObj;
        
        //Create contact
        Contact conObj = TestDataFactory.createContact(AccountObj.Id,'testContact');
        conObj.FirstName = 'Test';
        conObj.Email = System.now().millisecond() + 'test@test.com';
        Database.insert(conObj);
        system.assertNotEquals(null,conObj.Id, 'Contact can not created.');
        
        Product2 product = TestDataFactory.createProduct('Test Product', 'Membership fees', null);
        Product.ProductCode = 'TEST001';
        Product.IsActive = TRUE;
        Product.SBQQ__DefaultQuantity__c = 1000;
        INSERT Product;
        
        redwing__Training_Track__c trainingTrack = TestDataFactory.createTrainingTrack('Test Developer',product.Id);
        INSERT trainingTrack;
        
        redwing__Training_Track_Level__c trainingTrackLevel = TestDataFactory.createTrainingTrackLevel('Test Developer',trainingTrack.Id);
        INSERT trainingTrackLevel;
        
        redwing__Training_Plan__c trainingPlan = TestDataFactory.createTrainingPlan('Test Developer');
        INSERT trainingPlan;
        
        redwing__Training_Track_Assignment__c trainingTrackAssignment = TestDataFactory.createTrainingTrackAssignment(userinfo.getUserId(),conObj.Id,trainingTrack.Id);
        INSERT trainingTrackAssignment;
        
        redwing__Training_Plan_Assignment__c trainingPlanAssignment = TestDataFactory.createTrainingPlanAssignment(userinfo.getUserId(),conObj.Id,trainingPlan.Id);
        INSERT trainingPlanAssignment;
        
        redwing__Training_Track_Level_Item__c trainingTrackLevelItem = TestDataFactory.createTrainingTrackLevelItem(trainingTrackLevel.Id,trainingPlan.Id);
        INSERT trainingTrackLevelItem;
        
        redwing__Learning__c learning = TestDataFactory.createLearning('Test Learning');
        INSERT learning;
        
        redwing__Training_Plan_Section__c trainingPlanSection = TestDataFactory.createTrainigPlanSection('Test',trainingPlan.Id);
        INSERT trainingPlanSection;
        
        redwing__Training_Plan_Section_Assignment__c trainingPlanSectionAssignment = TestDataFactory.createTrainingPlanSectionAssignment(userinfo.getUserId(),trainingPlanSection.Id,trainingPlanAssignment.Id);
        INSERT trainingPlanSectionAssignment;
        
        redwing__Training_Plan_Section_Item__c trainingPlanSectionItem = TestDataFactory.createTrainingPlanSectionItem(learning.Id,trainingPlanSection.Id);
        INSERT trainingPlanSectionItem;
        
        redwing__Learning_Assignment__c learningAssignment = TestDataFactory.createLearningAssignment(conObj.Id,userinfo.getUserId(),trainingPlan.Id,learning.Id,trainingPlanSection.Id,trainingPlanSectionAssignment.Id,trainingPlanSectionItem.Id);
        INSERT learningAssignment;
        
        Academy_Certification_Program__c certificationProgram = TestDataFactory.createCertificationProgram();
        INSERT certificationProgram;
        
        redwing__Achievement__c achievement = TestDataFactory.createAchievement('Certifications',certificationProgram.Id);
        INSERT achievement;
        
        redwing__Training_Plan_Achievement__c trainingPlanAchievement = TestDataFactory.createTriningPlanAchievement(achievement.Id,trainingPlan.Id);
        INSERT trainingPlanAchievement;
        
        redwing__Achievement_Assignment__c achievementAssignment = TestDataFactory.createAchievementAssignment(conObj.Id,trainingPlanAchievement.Id,achievement.Id);
        INSERT achievementAssignment;
        
        Academy_Certification_Student__c  certificationStudent = TestDataFactory.createCertificationStudent(conObj);
        INSERT certificationStudent;
        
        Academy_Certification__c  certificate = TestDataFactory.createCertification(certificationStudent.Id,certificationProgram.Id);
        INSERT certificate;
        
        Academy_Certification_Examination__c  exam = TestDataFactory.createCertificationExam(certificationProgram.Id,certificate.Id, certificationStudent.Id);
        INSERT exam;
        
        certificate.Certification_Examination__c = exam.Id;
        update certificate;
    }
    @isTest
    public static void testCertificationExpirationBatch(){
        Test.startTest();
        CertificationExpirationSchedule ctrl = new CertificationExpirationSchedule();      
        String cronExp = '0 30 0 ? * * *';
        system.schedule('testCertificationExpirationBatch'+system.now(), cronExp, ctrl);
        Test.stopTest();
    }
}