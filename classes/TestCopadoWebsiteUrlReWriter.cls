@isTest
public class TestCopadoWebsiteUrlReWriter {
    static testMethod void testurlrewrites(){
        List<PageReference> prs = new List<PageReference>();
        PageReference pr = new Pagereference('/Pricing');
        prs.add(pr);
        CopadoWebsiteUrlReWriter fu = new CopadoWebsiteUrlReWriter();
        PageReference result = fu.mapRequestUrl(pr);
        system.assertEquals('/websitepricing', result.getUrl().toLowerCase());
        
        List<PageReference> result2 = fu.generateUrlFor(prs);
        for(PageReference p : result2){
            system.assertEquals('/pricing', p.getUrl().toLowerCase());
        }
    }
}