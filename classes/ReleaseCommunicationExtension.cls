public with sharing class ReleaseCommunicationExtension {
    private final Release_Communication__c release;
    private ApexPages.StandardController controller;
    public List<SelectOption> emailTemplates {get;set;}
    public String selectedEmailTemplateId {get;set;}
    
    public ReleaseCommunicationExtension(ApexPages.StandardController stdController) {
        controller = stdController;
        release = (Release_Communication__c)stdController.getRecord();
        EmailTemplate[] ets = [select Id,Name,isActive from EmailTemplate where isActive=true and name like '%Release Communication%'];
        system.debug('### Email Templates found: '+ets.size());
        emailTemplates = new List<SelectOption>();
        emailTemplates.add(new SelectOption('', '-- Select an email template --'));
        for(EmailTemplate e : ets){
            emailTemplates.add(new SelectOption(e.Id, e.Name));
        }
    }
    public pageReference sendEmails(){
        system.debug('### Email template Id and release Id. '+selectedEmailTemplateId+'--'+release.Id);
        Id jobId = Database.executeBatch(new ReleaseCommunicationBatch(selectedEmailTemplateId, release.Id),50);
        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM,'Email sending batch scheduled jobId='+jobId));
        return null;
    }
    public pageReference cancel(){
        return controller.cancel();
    }
}