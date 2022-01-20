public with sharing class ContractLineItemTriggerHelper {
	public static Map<Id, QuoteLineItem> qliMap = new Map<Id, QuoteLineItem>();

	public static void prepareData(List<SObject> records){		
		Set<Id> qliIds = new Set<Id>();
		for(SObject so : records){
			Contract_Line_Item__c cli = (Contract_Line_Item__c)so;
			qliIds.add(cli.Quote_Line_Item__c);
		}
		qliMap = new Map<Id, QuoteLineItem>([select Id, Product2Id, Unit_Price__c, Quantity, Discount, CurrencyIsoCode, Total_Price__c from QuoteLineItem where Id IN :qliIds]);
	}
	public static void setProductLookup(Contract_Line_Item__c cli){
		if(cli.Quote_Line_Item__c==null)return;
		cli.Product__c = qliMap.get(cli.Quote_Line_Item__c).Product2Id;
		if(qliMap.containsKey(cli.Quote_Line_Item__c)){
			cli.Quantity__c = qliMap.get(cli.Quote_Line_Item__c).Quantity;
			cli.Total_Price__c = qliMap.get(cli.Quote_Line_Item__c).Total_Price__c;
			cli.Unit_Price__c = qliMap.get(cli.Quote_Line_Item__c).Unit_Price__c;
		}
	}
	public static void setCurrency(Contract_Line_Item__c cli){
		if(cli.Quote_Line_Item__c==null)return;
		cli.CurrencyIsoCode = qliMap.get(cli.Quote_Line_Item__c).CurrencyIsoCode;
	}
}