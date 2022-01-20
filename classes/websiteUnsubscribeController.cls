public class websiteUnsubscribeController {
    public boolean unsubscribeOk {get;set;}
    public websiteUnsubscribeController(){
        unsubscribeOk = false;
    }
    public void unsubscribe(){
        try{
         	Id pId = (Id)EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('id'),'utf-8');
	        String email = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('email'),'utf-8');
            System.debug('unsubscribing ... id = ' + pId + ' email = ' + email);
			List<Contact> cons = [select id from Contact where Id = :pid and Email = :email];
            if(cons.size()==1){
                unsubscribeOk = true;
                System.debug('Contact found for ' + email);
            }
            List<Lead> leads = [select id from Lead where Id = :pid and Email = :email];
            if(leads.size()==1){
                unsubscribeOk = true;
                System.debug('Lead found for ' + email);
            }
            if(unsubscribeOk){
                List<Contact> updateConts = [select id from Contact where email = :email];
                for(Contact c:updateConts)c.HasOptedOutOfEmail = true;
                List<Lead> updateLeads = [select id from Lead where email = :email];
                for(Lead l:updateLeads)l.HasOptedOutOfEmail = true;
				Database.update(updateConts, false);
                Database.update(updateLeads, false);
                System.debug('Updated Contacts: ' + updateConts.size());
                System.debug('Updated Leads: ' + updateLeads.size());
            }
        }
        catch(Exception e){
            System.debug('Error while updating records: ' + e.getMessage());
            unsubscribeOk = false;
        }
    }
}