public class OpportunitySetController {
	public List<Opportunity> records {get;set;}
    public ApexPages.StandardSetController con;

    public static final String[] FIELDS = new String[] {'Id','CloseDate'};
        
   	public OpportunitySetController(apexpages.StandardSetController std){
        con = std;
        if(!Test.isRunningTest())std.addFields(FIELDS);
        records = (List<Opportunity>)std.getSelected();
	}
    public PageReference moveToNextMonth(){
        String r = ApexPages.currentPage().getParameters().get('retURL');
        List<Opportunity> updates = new List<Opportunity>(); 
    	for (Opportunity o : records){
            Date d = o.CloseDate;
            Date n = d.toStartOfMonth().addMonths(2).addDays(-1);
        	o.CloseDate = n;
            updates.add(o);
        }
        update updates;
        
        return new PageReference((r!=null)?r:'/');
  	}
}