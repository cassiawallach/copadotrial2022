@isTest
public class ReputationPointControllerTest {

     @testSetup
    public static void setupMethod(){
        Contact conObj = new Contact();
        conObj.FirstName ='test';
        conObj.LastName ='contact';
        INSERT conObj;
        
        Product2 Product = new Product2();
        Product.Name = 'Test Product';
        Product.ProductCode = 'TEST001';
        Product.IsActive = TRUE;
        Product.SBQQ__DefaultQuantity__c = 1000;
        INSERT Product;
        
        redwing__Training_Track__c Training_Track = new redwing__Training_Track__c();
        Training_Track.Name = 'Test Developer';
        Training_Track.redwing__Status__c ='Active';
        Training_Track.ltcomm__Product__c = Product.Id;
        Training_Track.redwing__Enable_all_internal_users__c = TRUE;
        Training_Track.redwing__Enable_all_external_accounts__c = TRUE;
        Training_Track.redwing__Language__c ='en_US';
        INSERT Training_Track;
        
        redwing__Training_Track_Level__c Training_Track_Level = NEW redwing__Training_Track_Level__c();
        Training_Track_Level.Name = 'Test Developer';
        Training_Track_Level.redwing__Training_Track__c = Training_Track.Id;
        INSERT Training_Track_Level;
        
        redwing__Training_Plan__c Training_Plan = new redwing__Training_Plan__c();
        Training_Plan.Name = 'Test TrainingPlan';
        Training_Plan.redwing__Status__c = 'Active';
        Training_Plan.Is_Certification_Plan__c = TRUE;
        INSERT Training_Plan;
        
        redwing__Training_Track_Assignment__c Training_Track_Assignment = NEW redwing__Training_Track_Assignment__c();
        Training_Track_Assignment.redwing__User__c = UserInfo.getUserId();
        Training_Track_Assignment.redwing__Contact__c = conObj.Id;
        Training_Track_Assignment.redwing__Status__c = 'In Progress';
        Training_Track_Assignment.redwing__Training_Track__c = Training_Track.Id;
        INSERT Training_Track_Assignment;
        
        
        redwing__Training_Plan_Assignment__c Training_Plan_Assignment = NEW redwing__Training_Plan_Assignment__c();
        Training_Plan_Assignment.redwing__User__c = UserInfo.getUserId();
        Training_Plan_Assignment.redwing__Contact__c = conObj.Id;
        Training_Plan_Assignment.redwing__Training_Plan__c = Training_Plan.Id;
        Training_Plan_Assignment.redwing__Status__c = 'In Progress';
        Training_Plan_Assignment.redwing__Progress_Percentage__c =  0.00;
        INSERT Training_Plan_Assignment;
        
        redwing__Training_Track_Level_Item__c Training_Track_Level_Item = NEW redwing__Training_Track_Level_Item__c();
        Training_Track_Level_Item.redwing__Training_Track_Level__c = Training_Track_Level.Id;
        Training_Track_Level_Item.redwing__Training_Plan__c = Training_Plan.Id;
        INSERT Training_Track_Level_Item;
        
        redwing__Learning__c Learning = new redwing__Learning__c();
        Learning.Name	= 'Quiz';
        Learning.redwing__Published__c = true;
        INSERT Learning;
        
        redwing__Training_Plan_Section__c Training_Plan_Section = NEW redwing__Training_Plan_Section__c();
        Training_Plan_Section.Name = 'Test';
        Training_Plan_Section.redwing__Training_Plan__c =Training_Plan.Id;
        INSERT Training_Plan_Section;
        
        redwing__Training_Plan_Section_Assignment__c Training_Plan_Section_Assignment = NEW redwing__Training_Plan_Section_Assignment__c();
        Training_Plan_Section_Assignment.redwing__User__c = UserInfo.getUserId();
        Training_Plan_Section_Assignment.redwing__Status__c = 'In Progress';
        Training_Plan_Section_Assignment.redwing__Training_Plan_Section__c = Training_Plan_Section.Id;
        Training_Plan_Section_Assignment.redwing__Training_Plan_Assignment__c= Training_Plan_Assignment.Id;
        INSERT Training_Plan_Section_Assignment;
        
        redwing__Training_Plan_Section_Item__c Training_Plan_Section_Item = NEW redwing__Training_Plan_Section_Item__c();
        Training_Plan_Section_Item.redwing__Learning__c = Learning.Id;
        Training_Plan_Section_Item.redwing__Training_Plan_Section__c = Training_Plan_Section.Id;
        INSERT Training_Plan_Section_Item;
        
        redwing__Learning_Assignment__c Learning_Assignment = NEW redwing__Learning_Assignment__c();
        Learning_Assignment.redwing__Contact__c = conObj.Id;
        Learning_Assignment.redwing__User__c = UserInfo.getUserId();
        Learning_Assignment.redwing__Progress__c = '';
        Learning_Assignment.redwing__Progress_Percentage__c = 0.00;
        Learning_Assignment.redwing__Evaluation_Times_Taken__c = 0;
        Learning_Assignment.redwing__Evaluation_Result__c = 'N/A';	
        Learning_Assignment.redwing__Progress__c = 'In Progress';
        Learning_Assignment.redwing__Training_Plan__c = Training_Plan.Id;
        Learning_Assignment.redwing__Learning__c = Learning.Id;
        Learning_Assignment.redwing__Training_Plan_Section__c = Training_Plan_Section.Id;
        Learning_Assignment.redwing__Training_Plan_Section_Assignment__c =Training_Plan_Section_Assignment.Id;
        Learning_Assignment.redwing__Training_Plan_Section_Item__c = Training_Plan_Section_Item.Id;
        Learning_Assignment.redwing__Times_Launched__c =1;
        Learning_Assignment.redwing__Evaluation_Score__c =1; 
        INSERT Learning_Assignment;
        
        Learning_Assignment.redwing__Evaluation_Times_Taken__c = 2;
        Learning_Assignment.redwing__Evaluation_Result__c = 'Failed';
        UPDATE Learning_Assignment;
        
        redwing__Achievement__c Achievement = new redwing__Achievement__c();
        Achievement.Name = 'Test Achievement';
        Achievement.ReputationPoints__c = 1000;
        Insert Achievement;
        
        redwing__Training_Plan_Achievement__c Training_Plan_Achievement = new redwing__Training_Plan_Achievement__c();
        Training_Plan_Achievement.redwing__Training_Plan__c = Training_Plan.Id;
        Training_Plan_Achievement.redwing__Achievement__c = Achievement.Id;
        Insert Training_Plan_Achievement;
        
        
        
    }
    @isTest
    public static void test1(){
        redwing__Training_Plan__c Training_Plan = [SELECT Id  FROM redwing__Training_Plan__c  LIMIT 1];
        ReputationPointController.getReputationPointByLearningPlanId(Training_Plan.Id);
        
    }
}