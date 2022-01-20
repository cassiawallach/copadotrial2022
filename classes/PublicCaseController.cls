public without sharing class PublicCaseController {

	public static String caseNumber {get;set;}
	public static String caseEmail {get;set;}
	public String closeCase {get;set;}

	public String caseSubject {get;set;}
	public String caseDescription {get;set;}
	public String caseType {get;set;}
	public String caseStatus {get;set;}
	public String caseOrigin {get;set;}

	public boolean renderStep1 {get;set;}
	public boolean renderStep2 {get;set;}
	public boolean renderCaseClosure {get;set;}

	public Case thisCase {get;set;}
	public List<CaseComment> comments {get;set;}
	public List<CaseSolution> solutions {get;set;}

	public Psydo_Case__c psydoCase {get;set;}

	public PublicCaseController(){
		thisCase = new Case();
		psydoCase = new Psydo_Case__c();
		renderStep1 = true;
		renderStep2 = false;
		renderCaseClosure = false;
		caseNumber = ApexPages.currentPage().getParameters().get('cn');
		caseEmail = ApexPages.currentPage().getParameters().get('ce');
		if(caseEmail!=null && caseNumber!=null){
			getCase();
		}
	}
	public void closeCase(){
		system.debug('#### This psydoCase: '+psydoCase);
		renderCaseClosure = true;
		renderStep1 = false;
		renderStep2 = false;
	}
	public void gotoStep2(){
		renderCaseClosure = false;
		renderStep1 = false;
		renderStep2 = true;
	}
	public void confirmCloseCase(){
		psydoCase.CaseComment__c = (psydoCase.CaseComment__c!=null && psydoCase.CaseComment__c!='')?'COMMENT BY CUSTOMER FOR CASE CLOSURE:\r\n'+psydoCase.CaseComment__c:null;
		psydoCase.Action__c='Update';
		psydoCase.Status__c='Closed';
		psydoCase.Record_Id__c=thisCase.Id;
		try{
			insert psydoCase;
			delete psydoCase;
			thisCase = [select Id, CaseNumber, Subject, Description, Contact.Email, Type, Status, Origin from Case where Id=:thisCase.Id];
			setCaseValues(thisCase);
			gotoStep2();
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your case has been closed.'));
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getMessage()));
		}
	}
	public void setCaseValues(Case c){
		caseNumber = c.CaseNumber;
		caseSubject = c.Subject;
		caseDescription = c.Description;
		caseType = c.Type;
		caseStatus = c.Status;
		caseOrigin = c.Origin;
	}
	public void getCase(){
		try{
			List<Case> tmp = [select Id, CaseNumber, Subject, Description, Contact.Email, Type, Status, Origin from Case where CaseNumber=:caseNumber and Contact.Email=:caseEmail];
			thisCase = (tmp!=null && tmp.size()>0)?tmp[0]:null;
			
			if(thisCase==null){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No case found'));
			}
			else{
				setCaseValues(thisCase);
				comments = new List<CaseComment>();
				solutions = new List<CaseSolution>();
				//comments = [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate, SystemModstamp, LastModifiedDate FROM CaseComment where ParentId=:thisCase.Id and IsPublished=true];
				//solutions = [SELECT Id, CaseId, SolutionId, Solution.SolutionName, Solution.SolutionNote, CreatedById, CreatedDate, SystemModstamp, IsDeleted FROM CaseSolution where CaseId=:thisCase.Id];
				renderStep1 = false;
				renderStep2 = true;
			}
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getMessage()));
		}
	}
}