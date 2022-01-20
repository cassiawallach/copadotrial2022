@IsTest
private class TestCopadoUserStoryTrigger {
    
    @testSetup static void setupData() {
        
        Id subtaskRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Subtask').getRecordTypeId();
        Id userStoryRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        List<copado__User_Story__c> parentUserStoryList = new List<copado__User_Story__c>();
        List<copado__User_Story__c> childUserStoryList = new List<copado__User_Story__c>();
        
        for(Integer index = 0; index < 10; index++){
            copado__User_Story__c parentUs = new copado__User_Story__c();
            parentUs.copado__User_Story_Title__c = 'Parent US ' + index;
            parentUs.RecordTypeId = userStoryRT;
            parentUs.copado__Developer__c = UserInfo.getUserId();
            parentUserStoryList.add(parentUS);
        }
        
        insert parentUserStoryList;
        User loggedinUser = new user();
         loggedinUser.Id = userinfo.getUserId();
        loggedinUser.email = 'rwong@copa.do';
        update loggedinUser;
        copado__User_Story__c UpdateStatus = parentUserStoryList.get(0);
        UpdateStatus.Business_Owner__c = userInfo.getUserId();
        UpdateStatus.copado__Status__c = 'Ready for Testing';
        update UpdateStatus;
        for(Integer index = 0; index < 100; index++){
            copado__User_Story__c childUs = new copado__User_Story__c();
            childUs.copado__User_Story_Title__c = 'Child US ' + index;
            childUs.RecordTypeId = subtaskRT;
            childUs.Parent_User_Story__c = parentUserStoryList[Math.mod(index, 10)].Id;
            childUs.copado__Developer__c = UserInfo.getUserId();
            childUs.copado__Story_Points_Other__c = Integer.valueof((Math.random() * 10));
            childUs.copado__Story_Points_SFDC__c = Integer.valueof((Math.random() * 10));
            childUserStoryList.add(childUs);
        }
        
        insert childUserStoryList;
        
    }
    
    /*@IsTest static void testRollupPoints(){
        Id subtaskRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Subtask').getRecordTypeId();
        Id userStoryRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        Map<Id, copado__User_Story__c> parentStories = new Map<Id, copado__User_Story__c>([SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                                                           FROM copado__User_Story__c 
                                                                                           WHERE RecordTypeId = :userStoryRT]);
        List<copado__User_Story__c> childStories = [SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                    FROM copado__User_Story__c 
                                                    WHERE RecordTypeId = :subtaskRT];
        
        System.assertEquals(10, parentStories.values().size());
        System.assertEquals(100, childStories.size());
        
        List<AggregateResult> totalPoints = [SELECT Parent_User_Story__c parentId, SUM(copado__Story_Points_Other__c) totalOther, SUM(copado__Story_Points_SFDC__c) totalSFDC
                                             FROM copado__User_Story__c 
                                             WHERE RecordTypeId = :subtaskRT
                                             GROUP BY Parent_User_Story__c];
        
        For(AggregateResult ar : totalPoints){
            System.assertEquals((Decimal)ar.get('totalOther'), parentStories.get((Id)ar.get('parentId')).copado__Story_Points_Other__c);
            System.assertEquals((Decimal)ar.get('totalSFDC'), parentStories.get((Id)ar.get('parentId')).copado__Story_Points_SFDC__c);
        }
    }
    
    @IsTest static void testRollupPointsOnUpdate(){
        Id subtaskRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Subtask').getRecordTypeId();
        Id userStoryRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        
        List<copado__User_Story__c> childStories = [SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                    FROM copado__User_Story__c 
                                                    WHERE RecordTypeId = :subtaskRT];
                
        For(copado__User_Story__c cus : childStories){
            cus.copado__Story_Points_Other__c = 0;
            cus.copado__Story_Points_SFDC__c = 10;
        }
        
        update childStories;
        Map<Id, copado__User_Story__c> parentStories = new Map<Id, copado__User_Story__c>([SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                                                           FROM copado__User_Story__c 
                                                                                           WHERE RecordTypeId = :userStoryRT]);
        List<AggregateResult> totalPoints = [SELECT Parent_User_Story__c parentId, SUM(copado__Story_Points_Other__c) totalOther, SUM(copado__Story_Points_SFDC__c) totalSFDC
                                             FROM copado__User_Story__c 
                                             WHERE RecordTypeId = :subtaskRT
                                             GROUP BY Parent_User_Story__c];
        
        For(AggregateResult ar : totalPoints){
            System.assertEquals(0, parentStories.get((Id)ar.get('parentId')).copado__Story_Points_Other__c);
            System.assertEquals(100, parentStories.get((Id)ar.get('parentId')).copado__Story_Points_SFDC__c);
        }
        
    }
    
    @IsTest static void testRollupPointsOnDeleteAndUndelete(){
        Id subtaskRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Subtask').getRecordTypeId();
        Id userStoryRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        Map<Id, copado__User_Story__c> parentStories = new Map<Id, copado__User_Story__c>([SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                                                           FROM copado__User_Story__c 
                                                                                           WHERE RecordTypeId = :userStoryRT]);
        List<copado__User_Story__c> childStories = [SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                    FROM copado__User_Story__c 
                                                    WHERE RecordTypeId = :subtaskRT];
        
        System.assertEquals(10, parentStories.values().size());
        System.assertEquals(100, childStories.size());
        delete childStories;
        List<AggregateResult> totalPoints = [SELECT Parent_User_Story__c parentId, SUM(copado__Story_Points_Other__c) totalOther, SUM(copado__Story_Points_SFDC__c) totalSFDC
                                             FROM copado__User_Story__c 
                                             WHERE RecordTypeId = :subtaskRT
                                             GROUP BY Parent_User_Story__c];
        
        For(AggregateResult ar : totalPoints){
            System.assertEquals(0, parentStories.get((Id)ar.get('parentId')).copado__Story_Points_Other__c);
            System.assertEquals(0, parentStories.get((Id)ar.get('parentId')).copado__Story_Points_SFDC__c);
        }
        
        undelete childStories;
        
        totalPoints = [SELECT Parent_User_Story__c parentId, SUM(copado__Story_Points_Other__c) totalOther, SUM(copado__Story_Points_SFDC__c) totalSFDC
                                             FROM copado__User_Story__c 
                                             WHERE RecordTypeId = :subtaskRT
                                             GROUP BY Parent_User_Story__c];
        
        For(AggregateResult ar : totalPoints){
            System.assertEquals((Decimal)ar.get('totalOther'), parentStories.get((Id)ar.get('parentId')).copado__Story_Points_Other__c);
            System.assertEquals((Decimal)ar.get('totalSFDC'), parentStories.get((Id)ar.get('parentId')).copado__Story_Points_SFDC__c);
        } 
    */
    
    @IsTest static void testRollupPointsOnNullValues(){
        Id subtaskRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('Subtask').getRecordTypeId();
        Id userStoryRT = Schema.SObjectType.copado__User_Story__c.getRecordTypeInfosByName().get('User Story').getRecordTypeId();
        
        List<copado__User_Story__c> childStories = [SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                    FROM copado__User_Story__c 
                                                    WHERE RecordTypeId = :subtaskRT];
                
        For(copado__User_Story__c cus : childStories){
            cus.copado__Story_Points_Other__c = null;
            cus.copado__Story_Points_SFDC__c = null;
        }
        
        update childStories;
        Map<Id, copado__User_Story__c> parentStories = new Map<Id, copado__User_Story__c>([SELECT Id, copado__Story_Points_Other__c, copado__Story_Points_SFDC__c 
                                                                                           FROM copado__User_Story__c 
                                                                                           WHERE RecordTypeId = :userStoryRT]);
        List<AggregateResult> totalPoints = [SELECT Parent_User_Story__c parentId, SUM(copado__Story_Points_Other__c) totalOther, SUM(copado__Story_Points_SFDC__c) totalSFDC
                                             FROM copado__User_Story__c 
                                             WHERE RecordTypeId = :subtaskRT
                                             GROUP BY Parent_User_Story__c];
        
        For(AggregateResult ar : totalPoints){
            System.assertEquals(null, parentStories.get((Id)ar.get('parentId')).copado__Story_Points_Other__c);
            System.assertEquals(null, parentStories.get((Id)ar.get('parentId')).copado__Story_Points_SFDC__c);
        }
        
    }
    
    
}