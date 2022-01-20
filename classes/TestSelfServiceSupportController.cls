@isTest
public class TestSelfServiceSupportController {
		
    static testMethod void runFullTest(){
    
        Solution s1 = new Solution(SolutionName='test', SolutionNote='Copadoisthebest', Status='Reviewed', IsPublishedInPublicKb=true, IsPublished=true, Documentation_URL__c='');
        insert s1;
        system.debug('###0 '+s1);
        
        // Insert categories. Use try catch in case no nodes are available.
        try{
            CategoryNode cn = [SELECT Id FROM CategoryNode LIMIT 1];
            CategoryData cd = new CategoryData(CategoryNodeId=cn.Id, RelatedSobjectId=s1.Id);
            insert cd;
        }
        catch(Exception e){}
        
        SelfServiceSupportController con = new SelfServiceSupportController();
        con.searchString = '';        
        List<SelfServiceSupportController.SolutionWrapper> results = con.doSearch(con.searchString, null);
        system.assert(TestMethodUtilities.hasMessage('No solutions found.'));
        system.assertEquals(0, results.size());
        
        
        con.searchString = 'Min two chars';
        results = con.doSearch(con.searchString, null);
        system.assert(TestMethodUtilities.hasMessage('No solutions found.'));
        system.assertEquals(0, results.size());
        
        Test.setFixedSearchResults(new List<ID>{s1.id});
        
        con.searchString = 'Copadoisthebest';
        results = con.doSearch(con.searchString, null);
        
        system.assertEquals(1, results.size());
        system.assertEquals(1, con.solutions.size());
        List<SelfServiceSupportController.SolutionWrapper> result = con.doSearch(con.searchString, null);
        system.debug('###3a '+result);
        system.debug('###3b '+ApexPages.getMessages());
        system.assert(TestMethodUtilities.hasMessage('1 solutions found.'));
        
        //click
        con.selectedSolutionId = s1.Id;
        con.selectSolution();
        system.assertEquals(true, con.isSolutionSelected);
        
        con.backtoresults();
        system.assertEquals(false, con.isSolutionSelected);
        system.assertEquals(null, con.selectedSolution);
        
        Test.setCurrentPage(Page.WebsiteSelfServiceSupport);
		ApexPages.currentPage().getParameters().put('q', 'Copadoisthebest');
        con = new SelfServiceSupportController();
        system.assert(TestMethodUtilities.hasMessage('1 solutions found.'));
    }
    static testMethod void loadPageWithSolutionId(){
        Solution s1 = new Solution(SolutionName='test', SolutionNote='Copadoisthebest', Status='Reviewed', IsPublishedInPublicKb=true, IsPublished=true, Documentation_URL__c='');
        insert s1;
        
		Test.startTest();
    	PageReference pref = Page.WebsiteSelfServiceSupport;
	    pref.getParameters().put('solutionId',s1.Id);
	    Test.setCurrentPage(pref);

	    SelfServiceSupportController con = new SelfServiceSupportController();
	    Test.stopTest();
        system.assertEquals(true, con.isSolutionSelected);
        system.assertEquals(s1.SolutionName, con.selectedSolution.solution.SolutionName);
    }
}