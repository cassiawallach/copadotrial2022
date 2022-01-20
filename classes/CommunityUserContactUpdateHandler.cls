global class CommunityUserContactUpdateHandler implements Database.Batchable<sObject>{
    
    global DateTime lastBatchRun = system.now().addMinutes(-30);
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
            list<AsyncApexJob> AsyncApexJobsList = [SELECT Id, JobType, ApexClass.Name, Status, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset, CreatedBy.Name FROM AsyncApexJob WHERE apexclass.Name = 'CommunityUserContactUpdateHandler' AND Status= 'Completed' ORDER BY CompletedDate DESC LIMIT 1]; 
            if(AsyncApexJobsList.size()>0){
                lastBatchRun = AsyncApexJobsList.get(0).CompletedDate;
                lastBatchRun = lastBatchRun.addHours(-1);
            }
            
        }
        return Database.getQueryLocator([SELECT Id,Title, FirstName, LastName, Email, Street, City, State, PostalCode, Country,ContactId, Contact.Title, Contact.FirstName, Contact.LastName, Contact.Email, Contact.MailingStreet, Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode, Contact.MailingCountry FROM User WHERE ContactId!='' AND LastModifiedDate >=:lastBatchRun]);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope){
        if(scope.size()>0){
            List<contact> UpdateContactList = new List<Contact>();
            boolean isUpdate = false;
            for(User UserObj : scope){
                isUpdate = false;
                contact conObj = new contact();
                conObj.Id = UserObj.ContactId;
                if(UserObj.Title != UserObj.Contact.Title){
                    conObj.Title = UserObj.Title;
                    isUpdate = true;
                }
                if(UserObj.FirstName != UserObj.Contact.FirstName){
                    conObj.FirstName = UserObj.FirstName;
                    isUpdate = true;
                }
                if(UserObj.LastName != UserObj.Contact.LastName){
                    conObj.LastName = UserObj.LastName;
                    isUpdate = true;
                }
                if(UserObj.Email != UserObj.Contact.Email){
                    conObj.Email = UserObj.Email;
                    isUpdate = true;
                }
                if(UserObj.Street != UserObj.Contact.MailingStreet){
                    conObj.MailingStreet = UserObj.Street;
                    isUpdate = true;
                }
                if(UserObj.City != UserObj.Contact.MailingCity){
                    conObj.MailingCity = UserObj.City;
                    isUpdate = true;
                }
                if(UserObj.State != UserObj.Contact.MailingState){
                    conObj.MailingState = UserObj.State;
                    isUpdate = true;
                }
                if(UserObj.Country != UserObj.Contact.MailingCountry){
                    conObj.MailingCountry = UserObj.Country;
                    isUpdate = true;
                }
                if(UserObj.PostalCode != UserObj.Contact.MailingPostalCode){
                    conObj.MailingPostalCode = UserObj.PostalCode;
                    isUpdate = true;
                }
                if(isUpdate){
                    UpdateContactList.add(conObj);
                }
            }
            if(UpdateContactList.size()>0){
                UPDATE UpdateContactList;  
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
}