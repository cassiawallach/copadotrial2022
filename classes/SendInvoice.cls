public with sharing class SendInvoice {

    //public ApexPages.StandardController controller {get;set;}
    public Invoice__c inv{get;set;}
    public Contact con{get;set;}
    public String emailSubject {get;set;}

    public SendInvoice(ApexPages.StandardController stdController) {
        //controller = stdController;
        inv = [select id, name, account__r.billing_contact__c, account__r.Invoice_Email_Subject__c, Status__c, PO_number__c from Invoice__c where id=:stdController.getId()];
        List<Contact> t = [select id,name, email from contact where id = :inv.account__r.billing_contact__c];
        if(t.size()==1)con = t.get(0);
        emailSubject = getEmailSubject(inv.account__r.Invoice_Email_Subject__c, inv.PO_number__c);
    }

    public PageReference send(){
        if(inv.Status__c=='Draft' || inv.Status__c==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invoices cannot be sent as draft.'));
            return null;
        }
        
        // Reference the attachment page, pass in the account ID
        PageReference pdf = Page.invoicePDF;
        pdf.getParameters().put('id',(String)inv.id);
        pdf.setRedirect(true);

        // Take the PDF content
        Blob b = (Test.IsRunningTest())? Blob.valueOf('UNIT.TEST') : pdf.getContent();

		Attachment a = new Attachment(parentId = inv.id,body = b, name = inv.name+'.pdf');
        insert a;
        
        if(this.con !=null){
         	// Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(inv.name+'.pdf');
            efa.setBody(b);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            
    
            // Sets the paramaters of the email
            email.setTemplateId([select Id,Name, Body from EmailTemplate where Name='Invoice Email' limit 1].Id);
            String[] emailAddresses = new String[]{con.email};
            email.setToAddresses( emailAddresses );
            system.debug('#### EMAILS: ' + emailAddresses.size());
            email.setWhatId(inv.Id);
            email.setTargetObjectId(con.id);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
            if(r[0].isSuccess()){
                return new PageReference('/'+this.inv.id);   
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,r[0].geterrors()[0].getMessage()));
                return null;
            }   
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Invoice only Attached to the record. No email sent, no billing contact defined'));
            return new PageReference('/'+this.inv.id);
        }
    }
    public String getEmailSubject(String ems, String POnumber){
        if(POnumber==null)return ems;		
        return ems.replaceAll('(?i)__po_number__', POnumber);
    }
}