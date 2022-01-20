public class admin_utilities{
    public static String copadoURL = Copado_Settings__c.getValues('Default')!=null?Copado_Settings__c.getValues('Default').Server_url__c:'https://testMethod.com';
    public static String EUcopadoURL = Copado_Settings__c.getValues('Default')!=null?Copado_Settings__c.getValues('Default').EU_Server_url__c:'https://testMethod.com';
    public Opportunity opp {get;set;}
	
    public static Set<String> getServerUrls(){
        String mainurl = copadoURL;
        String euUrl = EUcopadoURL;
        Set<String> urls = new Set<String>();
        urls.add(mainurl);
        if(String.isNotBlank(euUrl) && !euUrl.equalsIgnoreCase(mainurl))urls.add(euUrl);
        AggregateResult[] servers = [SELECT Server_URL__c FROM Salesforce_Org__c WHERE Copado_Server__c = 'Other' GROUP BY Server_URL__c];
        for (AggregateResult server : servers)  {
            urls.add(String.valueOf(server.get('Server_URL__c')));
        }
        return urls;
    }
    
    @Future(Callout=true)
    public static void addTransaction(Id orgId, String apiMethod, Decimal value){
        Salesforce_Org__c org = [SELECT Id, Credits__c, Name, OrgId__c, Selenium_Minutes__c, Copado_Server__c FROM Salesforce_Org__c WHERE Id = :orgId LIMIT 1];
        addTransactionNow(org, apiMethod, value);
    }
    
    public static String getCopadoServer(String server, String orgId){
        String res = copadoURL;

        if(!String.isBlank(server) && server.equals('EU-West') && !String.isBlank(EUcopadoURL))res = EUcopadoURL;
        else if(!String.isBlank(server) && server.equals('Other')) {
            res = [SELECT Server_URL__c FROM Salesforce_Org__c WHERE Copado_Server__c = 'Other' AND Id = :orgId LIMIT 1].Server_URL__c;
        }
        System.debug('Server '+server+' returning ' + res);
        return res;
    }
    public static void addTransactionNow(Salesforce_Org__c org, String apiMethod, Decimal value){

        String url = getCopadoServer(org.Copado_Server__c, org.Id)+'/admin/'+apiMethod+'/'+org.OrgId__c+'/'+value+'?' +
        'pkey='+org.OrgId__c+getDateTimeTrimmed()+
        '&oppId='+org.OrgId__c+getDateTimeTrimmed();
        //'&amount='+opp.Amount+
        //'&currency=EUR'+
        //'&type='+EncodingUtil.urlEncode(opp.Type,'UTF-8')+
        //'&description='+EncodingUtil.urlEncode(opp.Description!=null?opp.Description:'Not Available','UTF-8');
        
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            setAuthHeadersADM(req, userInfo.getUserId(), userinfo.getOrganizationId(), userinfo.getSessionId());
            req.setEndpoint(url);
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            String r = res.getBody();
            HerokuResponse hr = new HerokuResponse(res);
            if(hr.success){
                System.debug('@@@@ OK' + hr.message);
            }
            else{
                System.debug('@@@@ ERROR ' + hr.message);
            }
        }
        catch(System.Exception ex){
            System.debug('@@@@ ERROR: ' + ex.getMessage());
        }
    }

    private static String getDateTimeTrimmed() {
        String s = String.valueOf(Datetime.now());
        s = s.replace(' ', '');
        s = s.replace('-', '');
        s = s.replace(':', '');
        s = s.substring(0, 12);

        return s;
    }
    
    public static string syncFeatures(){
        return syncFeatures(null);
    }
    public static string syncFeatures(String orgId){
        if(String.isNotBlank(orgId)){
            String server = [select Copado_Server__c from Salesforce_Org__c where Id=:orgId].Copado_Server__c;
            String durl = getCopadoServer(server, orgId);
            String url = durl +'/admin/syncFeatures?sid='+userinfo.getSessionId()+'&url='+[select API_url__c from user where id=:userinfo.getUserId()].API_url__c;
			url += '&orgId='+orgId;
            System.debug('@@@@ Calling Heroku: ' + url);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            setAuthHeadersADM(req, userInfo.getUserId(), userinfo.getOrganizationId(), userinfo.getSessionId());
            req.setEndpoint(url);
            req.setMethod('GET');
            HttpResponse res = new HttpResponse();
            if (!Test.isRunningTest()) {
                res = h.send(req);
            	HerokuResponse hr = new HerokuResponse(res);
            }
            return res.getBody();
        }
        else{
            Set<String> urls = getServerUrls();
            String ret = '';
            for(String durl:urls){
                String url = durl +'/admin/syncFeatures?sid='+userinfo.getSessionId()+'&url='+[select API_url__c from user where id=:userinfo.getUserId()].API_url__c;
                System.debug('@@@@ Calling Heroku: ' + url);
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                setAuthHeadersADM(req, userInfo.getUserId(), userinfo.getOrganizationId(), userinfo.getSessionId());
                req.setEndpoint(url);
                req.setMethod('GET');
                HttpResponse res = new HttpResponse();
                if (!Test.isRunningTest()) {
                    res = h.send(req);
                	HerokuResponse hr = new HerokuResponse(res);
                }
                ret += res.getBody();
            }
            return ret;
        }
    }
    @Future(Callout=true)
    public static void syncFeaturesAtFuture(){
        syncFeatures();
    }
    public static string syncTips(){
        Set<String> urls = getServerUrls();
        String ret = '';
        for(String durl:urls){
            String url = durl+'/admin/syncTips?sid='+userinfo.getSessionId()+'&url='+[select API_url__c from user where id=:userinfo.getUserId()].API_url__c;
            System.debug('@@@@ Calling Heroku: ' + url);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            setAuthHeadersADM(req, userInfo.getUserId(), userinfo.getOrganizationId(), userinfo.getSessionId());
            req.setEndpoint(url);
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            HerokuResponse hr = new HerokuResponse(res);
			ret += res.getBody();
        }
        return ret;
    }
    class ServerException extends Exception {}
    public class HerokuResponse{
        public boolean success{get;set;}
        public String message{get;set;}
        public HerokuResponse(HttpResponse res){
            if(res.getStatusCode()==200){
                System.debug('@@@ json = ' + res.getBody());
                Map<String, Object> fullMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                success = fullMap.get('error')==null;
                if(success){
                    message = (String)fullMap.get('ok');
                } 
                else{
                    message = (String)fullMap.get('error');
                }
            }
            else{
                success = false;
                message = res.getStatusCode()+ ' - ' + res.getStatus();
            }
            System.debug('@@@ success: ' + success + ' message: ' + message);
            if(!success)throw new ServerException(message);
        }
    }
    public static String getAuthToken(String orgId, String userId){
        String sid = '<sessionId might change>';//userinfo.getSessionId()!=null?userinfo.getSessionId():'';
        String cdate = Datetime.now().formatGMT('yyyy-MM-dd');
        String myData =  'Copado Deployer by Copado Ltd'+userId+orgId+sid+cdate;
        System.debug('key: ' + myData);
        Blob hash = Crypto.generateDigest('MD5',Blob.valueOf(myData));
        System.debug('auth: ' + EncodingUtil.convertToHex(hash));
        return EncodingUtil.convertToHex(hash);
    }
    public static void setAuthHeaders (HttpRequest req, String userId, String orgId, String sessionId){
        req.setHeader('userId', userId);
        req.setHeader('orgId', orgId);
        req.setHeader('sessionId', sessionId);
        req.setHeader('token', getAuthToken(orgId, userId));
    }
    public static String getAuthTokenADM(String orgId, String userId){
        String sid = '<sessionId might change>';//userinfo.getSessionId()!=null?userinfo.getSessionId():'';
        String cdate = Datetime.now().formatGMT('yyyy-MM-dd');
        String myData =  'Admin. Copado Deployer by Copado Ltd'+userId+orgId+sid+cdate;
        System.debug('key: ' + myData);
        Blob hash = Crypto.generateDigest('MD5',Blob.valueOf(myData));
        System.debug('auth: ' + EncodingUtil.convertToHex(hash));
        return EncodingUtil.convertToHex(hash);
    }
    public static void setAuthHeadersADM (HttpRequest req, String userId, String orgId, String sessionId){
        req.setHeader('userId', userId);
        req.setHeader('orgId', orgId);
        req.setHeader('sessionId', '');
        req.setHeader('token', getAuthTokenADM(orgId, userId));
        system.debug(userId+' '+orgId+' '+getAuthTokenADM(orgId, userId));
    }
}