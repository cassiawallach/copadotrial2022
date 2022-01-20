public with sharing class PayByCard {
	public String quoteId{get;set;}
	public String accountId{get;set;}
	public String invoiceId{get;set;}
	public String name{get;set;}
	public String amount{get;set;}
	public String isoCode{get;set;}
	public String stripe_key{get;set;}
	public Boolean ok{get;set;}
	public Quote quote{get;set;}
	public Invoice__c invoice {get;set;}
	public String type {get;set;}
    public Boolean isCharge{get;set;}
    
    public String stripeToken {get;set;}
    public String stripeEmail {get;set;}

	public PayByCard() {
		ok = false;
        String mode = ApexPages.currentPage().getParameters().get('mode');
        isCharge = !String.isBlank(mode) && mode == 'charge';
		type = '';
		quoteId = ApexPages.currentPage().getParameters().get('quoteId');
		accountId = ApexPages.currentPage().getParameters().get('accountId');
		invoiceId = ApexPages.currentPage().getParameters().get('invoiceId');
		system.debug(quoteId+'  '+accountId+'  '+invoiceId);
		if((!String.isBlank(invoiceId) && !String.isBlank(quoteId) || 
			 String.isBlank(invoiceId) && String.isBlank(quoteId)) || String.isBlank(accountId)){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid parameters'));
			return;
		}
		quoteId = (!String.isBlank(quoteId))?EncodingUtil.urlEncode(quoteId, 'UTF-8'):null;
		accountId = (!String.isBlank(accountId))?EncodingUtil.urlEncode(accountId, 'UTF-8'):null;
		invoiceId = (!String.isBlank(invoiceId))?EncodingUtil.urlEncode(invoiceId, 'UTF-8'):null;

		List<Quote> quotes = new List<Quote>();
		if(!String.isBlank(quoteId)){
			type = 'Quote';
			quotes = [select Name, GrandTotal, QuoteNumber, CurrencyIsoCode from Quote where Id=:quoteId and Opportunity.AccountId=:accountId limit 1];
			if(quotes.size()!=1){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid quote'));
				return;	
			}
			name = quotes.get(0).QuoteNumber + ' - '+ quotes.get(0).Name;
			amount = quotes.get(0).GrandTotal.intValue() + '00';
			isoCode = quotes.get(0).CurrencyIsoCode;
			quote = quotes.get(0);
		}
		List<Invoice__c> invoices = new List<Invoice__c>();
		if(!String.isBlank(invoiceId)){
			type = 'Invoice';
			invoices = [select Id, Name, Total_Amount__c, CurrencyIsoCode from Invoice__c where Id=:invoiceId and Account__c=:accountId limit 1];
			if(invoices.size()!=1){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid invoice'));
				return;	
			}
			name = invoices.get(0).Name;
			amount = invoices.get(0).Total_Amount__c.intValue() + '00';
			isoCode = invoices.get(0).CurrencyIsoCode;
			invoice = invoices.get(0);
		}
		ok = true;
		stripe_key = Copado_Settings__c.getValues('Default').stripe_key__c;
	}
    public void init(){
        stripeToken = ApexPages.currentPage().getParameters().get('stripeToken');
        stripeEmail = ApexPages.currentPage().getParameters().get('stripeEmail');
    }
    public void charge(){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        String username = Copado_Settings__c.getValues('Default').stripe_secret__c;
        String password = '';
        
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' +
         EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
    
        req.setEndpoint('https://api.stripe.com/v1/charges');
        req.setMethod('POST');
        req.setBody('amount='+EncodingUtil.urlEncode(amount, 'UTF-8')+'&currency='+EncodingUtil.urlEncode(isoCode.toLowerCase(), 'UTF-8')+'&source='+EncodingUtil.urlEncode(stripeToken, 'UTF-8')+'&description='+EncodingUtil.urlEncode('Copado Solutions '+ type + ' ' + name, 'UTF-8'));
    
        try {
            res = http.send(req);
            Map<String, Object> fullMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            boolean success = fullMap.get('status')=='paid';
            if(success){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Payment successfull'));  
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Payment problem.  Response: ' + res.toString()));
            }
            
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Payment problem: ' + e.getMessage() + ' Response: ' + res.toString()));
        }
    }
}