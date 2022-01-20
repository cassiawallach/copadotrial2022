public with sharing class ZealynxController {
  static final String PERCENT_OF_TOTAL = 'Percent Of Total';
  static final String EXCLUDED = 'Excluded';
  static final String ID_FIELD = 'Id';
  static final String ORDERNAME_FIELD = 'kugo2p__OrderName__c';
  static final String THEME4D = 'Theme4d';
  static final String THEME2 = 'Theme2';
  static final String THEME3 = 'Theme3';
  static final String RENEWAL = 'Renewal';
  static final String EXPANSION = 'Expansion';
  static final Id RENEWAL_RECORDTYPEID = Schema.SObjectType.kugo2p__SalesOrder__c.getRecordTypeInfosByName().get(RENEWAL).getRecordTypeId();
  static final Id EXPANSION_RECORDTYPEID = Schema.SObjectType.kugo2p__SalesOrder__c.getRecordTypeInfosByName().get(EXPANSION).getRecordTypeId();
  static final Map<String,Id> ORDER_RECORDTYPEMAP = new Map<String,Id>{
    RENEWAL=>RENEWAL_RECORDTYPEID,
    EXPANSION=>EXPANSION_RECORDTYPEID
  };

  public ApexPages.StandardController standardController;
  public ApexPages.StandardSetController standardSetController;
  public List<Result> results {get;set;}
  List<sObject> sobjects = new List<sObject>();

  public class ZealynxException extends Exception {}  

  public class Result {
    public Result(sObject s){
      quoteRecord = (SBQQ__Quote__c)s;
    }

    public SBQQ__Quote__c quoteRecord {get;set;}
    public kugo2p__SalesOrder__c orderRecord {get;set;}
    public String errors {get;set;}
  }
  
  public ZealynxController( ApexPages.StandardController c ) {
    standardController = c;
    sobjects.add( standardController.getRecord() );
  }
  
  public ZealynxController( ApexPages.StandardSetController c ) {
    standardSetController = c;
    sobjects.addAll(standardSetController.getSelected());
  }
  
  public PageReference syncQuotes(){
    List<Id> ids = new List<Id>();
    results = new List<Result>();
    for ( Integer i=0; i<sobjects.size(); i++ ){
      ids.add( sObjects[i].Id );
      results.add( new Result(sobjects[i]) );
    }
    try {
      List<Map<String,Object>> records = syncQuotesToOrders( ids );

      for ( Integer i=0; i<sobjects.size(); i++ ){
        system.debug( records[i] );
        if ( records[i].containsKey('Id') ){
          results[i].orderRecord = new kugo2p__SalesOrder__c();
          results[i].orderRecord.Id = (String)records[i].get('Id');
        }
        if ( records[i].containsKey(ORDERNAME_FIELD) ){
          results[i].orderRecord.kugo2p__OrderName__c = (String)records[i].get(ORDERNAME_FIELD);
        }
      }
    } catch ( Exception e ){
      ApexPages.addMessage(
        new ApexPages.Message( 
          ApexPages.Severity.Error, 
        'One or more fields required by Kugamon are not populated correctly on your '+e.getMessage())
      );
      return null;
    }
    if ( sobjects.size() == 1 && results[0].orderRecord.Id != null ){
      return redirectToOrder();
    }
    return null;
  }

  public static String compileQuoteQueryString(){
    String queryString = 'SELECT ';
    queryString += String.join(compileFields('SBQQ__Quote__c'),',');
    queryString += ',SBQQ__Opportunity2__r.RecordType.Name';
    queryString += ', (SELECT '+String.join(compileFields('SBQQ__QuoteLineGroup__c'),',')+' FROM SBQQ__LineItemGroups__r)';
    queryString += ', (SELECT SBQQ__Quote__r.SBQQ__EndDate__c,SBQQ__Product__r.SBQQ__SubscriptionType__c,'+String.join(compileFields('SBQQ__QuoteLine__c'),',')+' FROM SBQQ__LineItems__r ORDER BY Id)';
    queryString += ' FROM SBQQ__Quote__c WHERE Id IN :ids';
    return queryString;
  } 

  public static List<Map<String,Object>> syncQuotesToOrders(List<Id> ids){
    Schema.SObjectType sobjectType = ids[0].getSobjectType();
    // String kugoObjectName = 'kugo2p__SalesOrder__c';
    String queryString = compileQuoteQueryString();
    List<SBQQ__Quote__c> records = database.query(queryString);
    List<Map<String,Object>> results = new List<Map<String,Object>>();
    List<SBQQ__QuoteLineGroup__c> lineItemGroups = new List<SBQQ__QuoteLineGroup__c>();
    List<SBQQ__QuoteLine__c> lineItems = new List<SBQQ__QuoteLine__c>();
    Map<Id,kugo2p__AdditionalAccountDetail__c> accountDetailMap = new Map<Id,kugo2p__AdditionalAccountDetail__c>();
    List<kugo2p__OrderLineGroup__c> orderLineGroups = new List<kugo2p__OrderLineGroup__c>();
    List<kugo2p__SalesOrderProductLine__c> orderProductLines = new List<kugo2p__SalesOrderProductLine__c>();
    List<kugo2p__SalesOrderServiceLine__c> orderServiceLines = new List<kugo2p__SalesOrderServiceLine__c>();

    try {
      results = zealynxsf.Sync.handleTrigger( 
        records, 
        null, 
        null, 
        kugo2p__SalesOrder__c.getSobjectType(),
        kugo2p__SalesOrder__c.QuoteId__c      
      );
    } catch (Exception e){
      system.debug( e.getLineNumber() );
      system.debug( e.getMessage() );
      system.debug( e.getStackTraceString() );
      throw new ZealynxException('Orders', e);
    }

    for ( Integer i=0; i<records.size(); i++ ){
      if ( records[i].SBQQ__Account__c != null ){
        accountDetailMap.put( records[i].SBQQ__Account__c, null );
      }
      lineItemGroups.addAll( records[i].SBQQ__LineItemGroups__r );
      lineItems.addAll( records[i].SBQQ__LineItems__r );
    }
    accountDetailMap = queryAccountDetails(accountDetailMap.keySet());

    if ( lineItemGroups != null && lineItemGroups.size() > 0 ){
      try {
        List<Map<String,Object>> groupResults = zealynxsf.Sync.handleTrigger( 
          lineItemGroups, 
          null, 
          null,
          kugo2p__OrderLineGroup__c.getSobjectType(),
          kugo2p__OrderLineGroup__c.QuoteLineGroupId__c
        );
        for ( Map<String,Object> r : groupResults ){
          orderLineGroups.add( new kugo2p__OrderLineGroup__c(Id=(Id)r.get(ID_FIELD), QuoteLineGroupId__c=null ) );
        }
      } catch (Exception e){
        system.debug( e.getLineNumber() );
        system.debug( e.getMessage() );
        system.debug( e.getStackTraceString() );
        throw new ZealynxException('Line Item Groups');
      }
    }
    List<SBQQ__QuoteLine__c> productLineItems = new List<SBQQ__QuoteLine__c>();
    List<SBQQ__QuoteLine__c> serviceLineItems = new List<SBQQ__QuoteLine__c>();
    if ( lineItems != null && lineItems.size() > 0 ){
      for ( Integer i=0;i<lineItems.size();i++ ){
        lineItems[i].SBQQ__Number__c = i+1;
        if ( 
          String.isNotBlank(lineItems[i].SBQQ__SubscriptionType__c) && 
          lineItems[i].SBQQ__SubscriptionType__c.contains('Renewable') &&
          lineItems[i].SBQQ__EndDate__c == lineItems[i].SBQQ__Quote__r.SBQQ__EndDate__c
        ){
          lineItems[i].SBQQ__Renewal__c = true;
        }
        if ( 
          String.isNotBlank(lineItems[i].SBQQ__PricingMethod__c) &&
          lineItems[i].SBQQ__PricingMethod__c == PERCENT_OF_TOTAL 
        ){
          lineItems[i].SBQQ__PricingMethod__c = EXCLUDED;
        } else {
          lineItems[i].SBQQ__PricingMethod__c = null;
        }
        if ( String.isBlank(lineItems[i].SBQQ__Product__r.SBQQ__SubscriptionType__c) ){
          productLineItems.add(lineItems[i]);
        } else {
          serviceLineItems.add(lineItems[i]);
        }
      }
      try {
        List<Map<String,Object>> productLineResults = zealynxsf.Sync.handleTrigger( 
          productLineItems, 
          null, 
          null,
          kugo2p__SalesOrderProductLine__c.getSobjectType(),
          kugo2p__SalesOrderProductLine__c.QuoteLineId__c
        );
        for ( Map<String,Object> r : productLineResults ){
          orderProductLines.add( new kugo2p__SalesOrderProductLine__c(Id=(Id)r.get(ID_FIELD), QuoteLineId__c=null ) );
        }    
      } catch ( Exception e){
        system.debug( e.getLineNumber() );
        system.debug( e.getMessage() );
        system.debug( e.getStackTraceString() );
        throw new ZealynxException('Order Product Lines', e);
      }
      try {
        List<Map<String,Object>> serviceLineResults = zealynxsf.Sync.handleTrigger( 
          serviceLineItems, 
          null, 
          null,
          kugo2p__SalesOrderServiceLine__c.getSobjectType(),
          kugo2p__SalesOrderServiceLine__c.QuoteLineId__c
        );
        for ( Map<String,Object> r : serviceLineResults ){
          orderServiceLines.add( new kugo2p__SalesOrderServiceLine__c(Id=(Id)r.get(ID_FIELD), QuoteLineId__c=null ) );
        }
      } catch ( Exception e){
        system.debug( e.getLineNumber() );
        system.debug( e.getMessage() );
        system.debug( e.getStackTraceString() );
        throw new ZealynxException('Order Service Lines', e);
      }
    }
    if ( results.size() > 0 ){
      List<kugo2p__SalesOrder__c> toUpdate = new List<kugo2p__SalesOrder__c>();
      for ( Integer i=0;i<results.size();i++ ){
        Map<String,Object> newRecordMap = results[i];
        kugo2p__SalesOrder__c newRecord = new kugo2p__SalesOrder__c();
        if ( records[i].SBQQ__Account__c != null ){
          newRecord.kugo2p__Account__c = records[i].SBQQ__Account__c;
        }
        if ( newRecordMap.containsKey(ID_FIELD) ){
          newRecord.Id = (String)newRecordMap.get(ID_FIELD);
          populateOrderFromAccountDetail(newRecord, accountDetailMap);
          populateOrderRecordType(records[i], newRecord);
          newRecord.kugo2p__Opportunity__c = records[0].SBQQ__Opportunity2__c;
        }
        newRecord.QuoteId__c = null;
        toUpdate.add(newRecord);
      }
      update toUpdate;
      update orderLineGroups;
      update orderProductLines;
      update orderServiceLines;
    }
    return results;
  }

  public static void populateOrderRecordType(SBQQ__Quote__c quoteRecord, kugo2p__SalesOrder__c newRecord){
    if ( 
      quoteRecord.SBQQ__Opportunity2__r != null &&
      quoteRecord.SBQQ__Opportunity2__r.RecordType != null &&
      String.isNotBlank(quoteRecord.SBQQ__Opportunity2__r.RecordType.Name) &&
      ORDER_RECORDTYPEMAP.containsKey(quoteRecord.SBQQ__Opportunity2__r.RecordType.Name)
    ){
      newRecord.RecordTypeId = ORDER_RECORDTYPEMAP.get(quoteRecord.SBQQ__Opportunity2__r.RecordType.Name);
    }
  }

  public static void populateOrderFromAccountDetail(kugo2p__SalesOrder__c newRecord, Map<Id,kugo2p__AdditionalAccountDetail__c> accountDetailMap){
    kugo2p__AdditionalAccountDetail__c det;
    if ( 
      newRecord.kugo2p__Account__c != null && 
      accountDetailMap.containsKey( newRecord.kugo2p__Account__c ) &&
      accountDetailMap.get( newRecord.kugo2p__Account__c ) != null
    ){
      det = accountDetailMap.get(newRecord.kugo2p__Account__c);
    }
    if ( det != null && det.kugo2p__Warehouse__c != null ){
      newRecord.kugo2p__Warehouse__c = det.kugo2p__Warehouse__c;
    }
    if ( det != null && det.kugo2p__ContactShipping__c != null ){
      newRecord.kugo2p__ContactShipping__c = det.kugo2p__ContactShipping__c;
    }
    if ( det != null && det.kugo2p__ContactBilling__c != null ){
      newRecord.kugo2p__ContactBilling__c = det.kugo2p__ContactBilling__c;
    }
  }

  public PageReference redirectToOrder(){
    kugo2p__SalesOrder__c newOrder = new kugo2p__SalesOrder__c(Id=results[0].orderRecord.Id);
    PageReference p = new ApexPages.standardController(newOrder).view();
    String theme = UserInfo.getUiThemeDisplayed();

    if(theme==THEME4D){  // Lightning Theme Value
      p = new PageReference('/' + newOrder.Id);
      // System.Aura.redirect(p);
    }
    if(theme==THEME2 || theme==THEME3){  // Classic Theme Value
      p.setRedirect(true);
    }
    return p;
  }

  /**
   * @name compileFields 
   * @param {Schema.SObjectType} sobjectType
   * @description
   */
  public static List<String> compileFields(String sobjectType){
    SObjectType toCreate = ((SObject)(Type.forName('Schema.'+sobjectType).newInstance())).getSObjectType();
    Map<String, Schema.SObjectField> fieldMap = toCreate.getDescribe().fields.getMap();
    List<String> fields = new List<String>();
    for ( String f : fieldMap.keySet() ){
      fields.add(f);
    }
    if ( toCreate == new SBQQ__Quote__c().getSObjectType() ){
      fields.add('SBQQ__PriceBook__r.Name');
    }
    return fields;
  }

  /**
   * @name queryAccountDetails 
   * @param {Set<Id>} accountIds
   * @description
   */
  public static Map<Id,kugo2p__AdditionalAccountDetail__c> queryAccountDetails(Set<Id> accountIds){
    Map<Id,kugo2p__AdditionalAccountDetail__c> results = new Map<Id,kugo2p__AdditionalAccountDetail__c>();
    for ( kugo2p__AdditionalAccountDetail__c a : [
      SELECT Id, kugo2p__Account__c, 
        kugo2p__Warehouse__c, kugo2p__ContactShipping__c, 
        kugo2p__ContactBilling__c
      FROM kugo2p__AdditionalAccountDetail__c
      WHERE kugo2p__Account__c IN :accountIds
    ]){
      results.put(a.kugo2p__Account__c, a);
    }
    return results;
  }

}