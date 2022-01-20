public class CalculateCurrentARROnQuote implements Queueable {
    public void execute(QueueableContext context) {
        AggregateResult[] groupedResults = [SELECT SBQQ__Quote__c , SUM(ARR__c)arrSum FROM SBQQ__QuoteLine__c  WHERE Is_Current_ARR__c = True AND ARR__c !=Null group by SBQQ__Quote__c];
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        for (AggregateResult ar : groupedResults)  {
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj.Id = (Id)ar.get('SBQQ__Quote__c');
            quoteObj.Current_ARR__c = (Decimal)ar.get('arrSum');
            quoteList.add(quoteObj);
        }
        if(quoteList.size() > 0){
           Update quoteList; 
        }
    }
}