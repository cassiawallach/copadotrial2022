@isTest
public class TestWebsiteUnsubscribeController {
    static testMethod void testUnsubscribe(){
        Lead l1 = new Lead(lastname='l1',email='l1@l1.com',Company='xyz');
        Lead l2 = new Lead(lastname='l2',email='l2@l2.com',Company='xyz');
        Contact c1 = new Contact(lastname='c1',email='l1@l1.com');
		Contact c2 = new Contact(lastname='c2',email='c2@c2.com');
        insert l1;
        insert l2;
        insert c1;
        insert c2;
        Test.setCurrentPage(Page.websiteUnsubscribe);
        
        WebsiteUnsubscribeController ctrl = new websiteUnsubscribeController();
        ctrl.unsubscribe();
        System.assert(!ctrl.unsubscribeOk);
        
        ApexPages.currentPage().getParameters().put('id',l1.id);
        ApexPages.currentPage().getParameters().put('email',l1.email);
        ctrl = new websiteUnsubscribeController();
        ctrl.unsubscribe();
        System.assert(ctrl.unsubscribeOk);
        System.assertEquals(1,[select count() from Lead where id=:l1.Id and HasOptedOutOfEmail=true]);
        System.assertEquals(1,[select count() from Lead where id=:l2.Id and HasOptedOutOfEmail=false]);
        System.assertEquals(1,[select count() from Contact where id=:c1.Id and HasOptedOutOfEmail=true]);
        System.assertEquals(1,[select count() from Contact where id=:c2.Id and HasOptedOutOfEmail=false]);
        
        ApexPages.currentPage().getParameters().put('id',c2.id);
        ApexPages.currentPage().getParameters().put('email',c2.email);
        ctrl = new websiteUnsubscribeController();
        ctrl.unsubscribe();
        System.assert(ctrl.unsubscribeOk);
        System.assertEquals(1,[select count() from Contact where id=:c2.Id and HasOptedOutOfEmail=true]);
        
        ApexPages.currentPage().getParameters().put('id','malformed Id : ! \n trying to hakc y@u');
        ApexPages.currentPage().getParameters().put('email',' or email !=null');
        ctrl = new websiteUnsubscribeController();
        ctrl.unsubscribe();
        System.assert(!ctrl.unsubscribeOk);
    }
}