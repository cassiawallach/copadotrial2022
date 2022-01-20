//Created by Englhard Consulting August 19th, 2019
@isTest
public class contentDocumentLinkHandlerTest {

    static testMethod void validateContentDocumentLinkHandler(){
        
        Account a = new Account();
        a.Name = 'Test';
        
        Insert a;
        
        Schema.DescribeFieldResult fieldResult = Agreement__c.Copado_Signer__c.getDescribe();
        LIST<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        Agreement__c c = new Agreement__c();
        
        c.Agreement_Name__c = 'Test';
        c.Account__c = a.Id;
        c.Copado_Signer__c = ple[0].value;
        
        insert c;
        
        ContentVersion file = new ContentVersion();
        file.VersionData = blob.valueOf('my attachment text');
        file.PathOnClient = 'textfile.txt';
        file.Title = 'textfile';
        file.IsMajorVersion = True;
        file.FirstPublishLocationId = c.Id;
        insert file;
        
    }
}