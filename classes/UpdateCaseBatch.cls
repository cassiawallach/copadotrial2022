global class UpdateCaseBatch implements Database.Batchable<sObject> {
    List<Case> caseList = New List<Case>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Last_Case_Comment_Time__c, NoReplyAge__c from Case WHERE Last_Case_Comment_Time__c != Null ORDER BY Id';
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope)
    {
        //public static BusinessHours AllBh;
        BusinessHours AllBh  = [Select Id From BusinessHours WHERE Name ='Weekday' AND isActive=True LIMIT 1];
        for(Case cse: scope)
        {
            Decimal result = BusinessHours.diff(AllBh.Id, cse.Last_Case_Comment_Time__c, system.Now());
            Decimal resultingHours = result/(60*60*1000);
            
            cse.NoReplyAge__c = resultingHours.round();
            
        }
        
        update scope;
        
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}