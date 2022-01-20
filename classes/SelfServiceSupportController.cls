public class SelfServiceSupportController {
    public String searchString {get;set;}
    public List<SolutionWrapper> solutions {get;set;}
    public Map<Id, SolutionWrapper> solutionMap {get;set;}
    public Map<Id, CategoryNode> solutionCategories {get;set;}
    public SolutionWrapper selectedSolution {get;set;}
    public Id selectedSolutionId {get;set;}
    public boolean isSolutionSelected {get;set;}
    public boolean isJSON {get;set;}
    
    
    public class SolutionWrapper{
        public Solution solution {get;set;}
        public String shortBody {get;set;}
        public List<CategoryNode> categories {get;set;}
        public SolutionWrapper(Solution s, List<CategoryNode> scs){
            this.solution = s;
            this.shortBody = (s.SolutionNote.length()>0 && s.SolutionNote.length()>150)?s.SolutionNote.subString(0,150):s.SolutionNote;            
            this.categories = scs;
        }
    }
    public SelfServiceSupportController(){
        isSolutionSelected = false;
        getSolutionCategories();
        searchString = ApexPages.currentPage().getParameters().get('q');

        isJSON = false;
        String t = ApexPages.currentPage().getParameters().get('format');
        if(String.isNotEmpty(t)&&t=='json')
	        isJSON = true;
        
        selectedSolutionId = (Id)ApexPages.currentPage().getParameters().get('solutionId');
        if(!String.isBlank(searchString) && searchString.length()>2){
            solutions = doSearch(searchString, null);
        }
        else if(selectedSolutionId!=null || selectedSolutionId!=''){
            solutions = doSearch(null, selectedSolutionId);
            if(solutions.size()>0){
                isSolutionSelected = true;
            	selectSolution();
        	}
        }
    }
    
    
    public PageReference selectSolution(){
        if(selectedSolutionId!=null && solutionMap.containsKey(selectedSolutionId)){
            selectedSolution = solutionMap.get(selectedSolutionId);
        	isSolutionSelected = true; 
        }
        return null;
    }
    public void backtoresults(){
        isSolutionSelected = false;
        selectedSolution = null;
        solutions = doSearch(searchString, selectedSolutionId);
    }
    public void getSolutionCategories(){
        solutionCategories = new Map<Id, CategoryNode>([SELECT Id, MasterLabel, ParentId, SortOrder, SortStyle FROM CategoryNode]);
    }
    public List<SolutionWrapper> doSearch(String q, Id selectedSolutionId){
        solutions = new List<SolutionWrapper>();
        solutionMap = new Map<Id, SolutionWrapper>();
        List<Solution> solutionRecords = new List<Solution>();
        
        if(selectedSolutionId!=null){
            solutionRecords = [select Id, SolutionName, Status, SolutionNote, Documentation_URL__c, IsReviewed, IsPublished, SolutionNumber, TimesUsed, CreatedDate, LastModifiedDate, IsHtml from Solution where IsPublished=true and Id=:selectedSolutionId];
        }
        else if(q!=null){
            String query = 'FIND \''+q+'\' IN ALL FIELDS RETURNING Solution(Id, SolutionName, Status, SolutionNote, Documentation_URL__c, IsReviewed, IsPublished, SolutionNumber, TimesUsed, CreatedDate, LastModifiedDate, IsHtml WHERE IsPublished=true)';
            List<List<sObject>> results = search.query(query);
            solutionRecords = ((List<Solution>)results[0]);
        }
        
        if(solutionRecords.size()>0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, solutionRecords.size()+' solutions found.'));
        	Set<Id> solutionIds = new Set<Id>();
            for(Solution s : solutionRecords){
                solutionIds.add(s.Id);
            }
            
            Map<Id, List<CategoryNode>> cdMap = createSolutionCategoryMap(solutionIds);
            
            for(Solution s : solutionRecords){
                solutions.add(new SolutionWrapper(s, cdMap.get(s.Id)));
                solutionMap.put(s.Id, new SolutionWrapper(s, cdMap.get(s.Id)));
            }
            return solutions;
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'No solutions found.'));
        }
        return solutions;       
    }
    public Map<Id, List<CategoryNode>> createSolutionCategoryMap(Set<Id> ids){
        Map<Id, List<CategoryNode>> scMap = new Map<Id, List<CategoryNode>>();
        
        for(CategoryData cd : [SELECT Id, CategoryNodeId, RelatedSobjectId FROM CategoryData where RelatedSobjectId IN :ids]){
            List<CategoryNode> tmp = new List<CategoryNode>();
            if(scMap.containsKey(cd.RelatedSobjectId))tmp = scMap.get(cd.RelatedSobjectId);
            tmp.add(solutionCategories.get(cd.CategoryNodeId));
            scMap.put(cd.RelatedSobjectId, tmp);
        }
        return scMap;
    }
    
    public String getJSONValue() {
        return JSON.serialize(solutions);
    }
}