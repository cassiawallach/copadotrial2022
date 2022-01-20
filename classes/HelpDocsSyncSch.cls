global class HelpDocsSyncSch implements Schedulable,Database.AllowsCallouts {
    /*private final static String HELPDOCS_API_KEY = 'gnw7fp5vh4q5ssbciitn2xdzkgpiimm7pfdsphvp';
private final static String CATEGORY_ID = '79oqbheifv';*/
    
    //This is Production API key and Category Id
    private final static String HELPDOCS_API_KEY = 'ps6qjijp8bwu8zoym9fdxssgzpthtmufv0so5784';
    private final static String CATEGORY_ID = 'wpa2ilg2vc';
    
    //This is For Testing
    /*private final static String HELPDOCS_API_KEY = 'ymvaa6bonckm84lb75jukeagllk210jvm16vz2ic';
    private final static String CATEGORY_ID = '1l11dhtzej';*/
    
    global void execute(SchedulableContext sc) {
        // Migrate Articles changed in the last 10 minutes (scope of the schedule + 5 min in case the process gets delayed)
        List<String> kaIds = new List<String>();
        
        Datetime lastBatch = Datetime.now().addMinutes(-10);
        
        for(Knowledge__kav this_kav : [SELECT Id, Body__c, Title, KnowledgeArticleId FROM Knowledge__kav WHERE IsVisibleInPkb = true AND LastModifiedDate > :lastBatch]) {
            kaIds.add(this_kav.Id);
        }
        
        if (!kaIds.isEmpty()) {
            syncArticles(kaIds);
        }
    }
    
    @future(callout=true)
    public static void syncArticles(List<String> kaIds) {
        // Load all existing Articles from HelpDocs
        String url_read = 'https://api.helpdocs.io/v1/article?key=' + HELPDOCS_API_KEY + '&category_id=' + CATEGORY_ID; //Category = Knowledge Base
        Http h = new Http();
        HttpRequest getArticles = new HttpRequest();
        getArticles.setEndpoint(url_read);
        getArticles.setMethod('GET');
        getArticles.setHeader('Accept', 'application/json');
        getArticles.setHeader('Content-Type', 'application/json; charset=UTF-8');
        HttpResponse resArticles = h.send(getArticles);
        
        String body = resArticles.getBody().replace('\"_id\"', '\"id\"');
        Map<String, String> articleIds = new Map<String, String>();
        Map<String,Object> articles = (Map<String,Object>)JSON.deserializeUntyped(body);
        List<Object> articlesList = (List<Object>)articles.get('articles');
        for (Object art: articlesList) {
            Map<String,Object> mappedArticle = (Map<String,Object>)art;
            articleIds.put(mappedArticle.get('title').toString(), mappedArticle.get('article_id').toString());
            System.debug('articleIds = ' + articleIds);
            System.debug('Title@@@ = ' + mappedArticle.get('title').toString());
        }
        // Migrate Articles changed in the last 10 minutes (scope of the schedule + 5 min in case the process gets delayed)
        
        for(Knowledge__kav this_kav : [SELECT Body__c, Title, KnowledgeArticleId FROM Knowledge__kav WHERE IsVisibleInPkb = true AND Id IN :kaIds]) {
            // No previous HelpDocs article, creation mode
            if (!articleIds.containsKey(this_kav.Title)) {
                createArticle(this_kav.title, this_kav.Body__c.escapeJava(),articleIds.get(this_kav.title));
            }
            // We have previous HelpDocs article, update mode
            else {
                updateArticle(articleIds.get(this_kav.title),this_kav.title, this_kav.Body__c.escapeJava());
                //createArticle(this_kav.title, this_kav.Body__c.escapeJava());
            }
        }
    }
    
    @TestVisible
    private static void createArticle(String title, String body, String articleId) {
        System.debug('Creation mode on: ' + title);
        String url = 'https://api.helpdocs.io/v1/article?key=' + HELPDOCS_API_KEY;
        String jsonBody = '{"title": "' + title + '","category_id": "' + CATEGORY_ID + '","body": "' + body + '","is_private": false,"is_published": true}';
        //String replacement for testing the Sandbox. Environment Variables will assign the right values to be implemented in Production
        jsonBody = jsonBody.replace('https://copado--c.documentforce.com', 'http://copado.force.com');
        Http callCreate = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        req.setBody(jsonBody);
        HttpResponse res = callCreate.send(req);
        
        if (!res.getBody().contains('article') || Test.isRunningTest()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{'integration.user@copado.com'};
                mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName(UserInfo.getName());
            mail.setSubject('Knowledge Base Article failed to migrate to HelpDocs');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            String emailBody = 'Here is the details ' + res.getBody() + ', ';
            emailBody += 'With Article Id:<b> ' + articleId +' </b>';
            mail.setPlainTextBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        }
    }
    //By using this Method updating article in helpdoc
    global static void updateArticle(String articleId, String title, String body) {
        System.debug('Deletion mode on: ' + articleId);
        String url = 'https://api.helpdocs.io/v1/article/' + articleId + '?key=' + HELPDOCS_API_KEY;
        String jsonBody = '{"title": "' + title + '","category_id": "' + CATEGORY_ID + '","body": "' + body + '","is_private": false,"is_published": true}';
        //String replacement for testing the Sandbox. Environment Variables will assign the right values to be implemented in Production
        jsonBody = jsonBody.replace('https://copado--c.documentforce.com', 'http://copado.force.com');
        Http callUpdate = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('PATCH');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        req.setBody(jsonBody);
        HttpResponse res = callUpdate.send(req);
       System.debug('@@@@123 ' + res);
        if (!res.getBody().contains('article')) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{'integration.user@copado.com' };
                mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName(UserInfo.getName());
            mail.setSubject('Knowledge Base Article failed to migrate to HelpDocs');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            String emailBody = 'Here is the details ' + res.getBody() + ', ';
            emailBody += 'With Article Id:<b> ' + articleId +' </b>';
            mail.setPlainTextBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
    }
    //By using this method delete article from helpdoc
    global static void deleteArticle(String articleId) {
        System.debug('Deletion mode on: ' + articleId);
        String url = 'https://api.helpdocs.io/v1/article/' + articleId + '?key=' + HELPDOCS_API_KEY;
        Http callDelete = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('DELETE');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        HttpResponse res = callDelete.send(req);
        
        if (!res.getBody().contains('success')) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{'integration.user@copado.com'};
                mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName(UserInfo.getName());
            mail.setSubject('Knowledge Base Article failed to migrate to HelpDocs');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            String body = 'Here is the details ' + res.getBody() + ', ';
            body += 'With Article Id:<b> ' + articleId +' </b>';
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
    }
}