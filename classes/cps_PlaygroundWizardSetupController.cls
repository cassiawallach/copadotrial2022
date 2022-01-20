public without sharing class cps_PlaygroundWizardSetupController {
  static final String BASE_COE_LOGIN_URL = 'https://login.salesforce.com';
  static final String BASE_SANDBOX_LOGIN_URL = 'https://test.salesforce.com';
  static final String SCRATCH_ORG_PLAYGROUND_TYPE = 'Full Configuration - Scratch Orgs';
  static final String COE_ORG_TYPE = 'CoE_Org';
  static final String SCRATCH_ORG_ORG_TYPE = 'Scratch_Org';

  @AuraEnabled
  public static Map<String, Object> getPlaygroundDetails(String playgroundId){
    return cps_PlaygroundWizardController.getPlaygroundDetails(playgroundId);
  }

  @AuraEnabled
  public static List<Playground_Job__c> getPlaygroundJobs(String playgroundId){
    return cps_PlaygroundWizardController.GetPlaygroundJobs(playgroundId);
  }

  @AuraEnabled
  public static Playground_Job__c updateJobStatus(String playgroundId, String jobId, String status) {
    return cps_PlaygroundWizardController.UpdateJobStatus(playgroundId, jobId, status);
  }

  @AuraEnabled
  public static Map<string, string> GetEnvironmentAuthorizationLinks(String playgroundId) {

    Playground__c playground = [SELECT Org_Credential__r.copado__Username__c, Custom_Signup_Request__r.Domain__c, Playground_Configuration__c FROM Playground__c WHERE Id = :playgroundId LIMIT 1];

    List<Playground_Enviroment__c> environments = [SELECT Name, Authorization_URL__c, Type__c,Access_Token__c ,InstanceUrl__c  FROM Playground_Enviroment__c WHERE Playground__c = :playgroundId LIMIT 9];
    Playground_Setting__mdt setting = [SELECT Copado_Client_Key__c, C1P_API_Key__c FROM Playground_Setting__mdt WHERE DeveloperName =: cps_Helper.SETTINGS_NAME LIMIT 1];

    Map<string, string> ret = new Map<string, string>();
    for (Playground_Enviroment__c e : environments) {
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(e.Authorization_URL__c);
      request.setMethod('GET');
      request.setHeader('X-Client-Key', setting.Copado_Client_Key__c);

      // Send request
      HttpResponse httpResponse = http.send(request);
      if (httpResponse.getStatusCode() == 302) {
        String authLink = httpResponse.getHeader('Location');
        String loginHint = '&login_hint=' + EncodingUtil.urlEncode(playground.Org_Credential__r.copado__Username__c + (e.Type__c == COE_ORG_TYPE ? '' : '.' + e.Name), 'UTF-8' ).toLowerCase();

        if(authLink.contains(BASE_COE_LOGIN_URL)){
          Http httpCoE_Org = new Http();
          HttpRequest requestCoE_Org = new HttpRequest();
          requestCoE_Org.setEndpoint('https://app-api.copado.com/json/v1/webhook/copadoSession/' + playground.Org_Credential__c + '?api_key=' + setting.C1P_API_Key__c);
          requestCoE_Org.setMethod('GET');
          requestCoE_Org.setHeader('X-Client-Key', setting.Copado_Client_Key__c);

          try{
            HttpResponse httpResponseCoE_Org = httpCoE_Org.send(requestCoE_Org);
            Map<String, Object> parsedResponse = parseJSON(httpResponseCoE_Org.getBody());
            String frontdoorUrl =  String.valueOf(parsedResponse.get('frontDoor'));

            String retUrl  = authlink.SubStringAfter(BASE_COE_LOGIN_URL);
            retUrl = retUrl.replace('prompt=login%20consent&', '');
            authlink = frontdoorUrl + '&retURL=' + EncodingUtil.urlEncode(retUrl, 'UTF-8');
          } catch(Exception excp) {
            throw excp;
          }
        } else if(authLink.contains(BASE_SANDBOX_LOGIN_URL)){
          if (SCRATCH_ORG_PLAYGROUND_TYPE == playground.Playground_Configuration__c && SCRATCH_ORG_ORG_TYPE == e.Type__c ) {
            String retUrl  = authlink.SubStringAfter(BASE_SANDBOX_LOGIN_URL);
            retUrl = retUrl.replace('prompt=login%20consent&', '');
            String frontdoorUrl = e.InstanceUrl__c + 'secur/frontdoor.jsp?sid=' + e.Access_Token__c;
            authlink = frontdoorUrl + '&retURL=' + EncodingUtil.urlEncode(retUrl, 'UTF-8');

          } else {
            authLink = authLink.replace(BASE_SANDBOX_LOGIN_URL, 'https://'+playground.Custom_Signup_Request__r.Domain__c+ (e.Type__c == COE_ORG_TYPE ? '' : '--' + e.Name).toLowerCase() + '.my.salesforce.com');
          }
        }
        ret.put(e.Name, authLink + loginHint);
      }
    }
    return ret;
  }

  private static Map<String, Object> parseJSON(String payloadString) {
    if(payloadString==null) return new Map<String, Object>();

    Map<String, Object> payloadObj = new Map<String, Object>();
    try{
      payloadObj = (Map<String, Object>) JSON.deserializeUntyped(payloadString);
    }
    catch(Exception e) {
      system.debug(payloadString);
      system.debug('@@@ Error parsing payloadString: '+e.getMessage());
    }
    return payloadObj;
  }
}