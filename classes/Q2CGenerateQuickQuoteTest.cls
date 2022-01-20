@isTest
private class Q2CGenerateQuickQuoteTest {
   
    @isTest
    static void testQuickQuote(){
        Account acct = TestDataFactory.createAccount('test account', 'EUR');
        insert acct;        
     
        ApexPages.currentPage().getParameters().put('id',acct.id);        
        Q2CGenerateQuickQuote.genQuote();
    }

}