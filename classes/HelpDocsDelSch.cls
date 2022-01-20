global class HelpDocsDelSch implements Schedulable {
    //private final static String HELPDOCS_API_KEY = 'gnw7fp5vh4q5ssbciitn2xdzkgpiimm7pfdsphvp';
    private final static String HELPDOCS_API_KEY = 'ps6qjijp8bwu8zoym9fdxssgzpthtmufv0so5784';
    //private final static String CATEGORY_ID = '79oqbheifv';
    private final static String CATEGORY_ID = 'wpa2ilg2vc';

    global void execute(SchedulableContext sc) {

        deleteArticles();
    }

    @future(callout=true)
    public static void deleteArticles() {
        // Load all articles in HelpDocs and Salesforce to detect the deletions (not in __kav but still available in HelpDocs -> Delete from HelpDocs
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
        }

        // Now, we iterate over all HelpDocs and Salesforce articles to discover if any of them was unpublished, archived or deleted
        Map<String,Knowledge__kav> kavsMap = new Map<String,Knowledge__kav>();
        for (Knowledge__kav kav: [SELECT Body__c, Title, KnowledgeArticleId FROM Knowledge__kav WHERE IsVisibleInPkb = true]) {
            kavsMap.put(kav.Title, kav);
        }

        for (String articleTitle : articleIds.keySet()) {
            // If not in this map, it is not a Published Article any more, we delete it from HelpDocs
            if (!kavsMap.containsKey(articleTitle)) {
                HelpDocsSyncSch.deleteArticle(articleIds.get(articleTitle));
            }
        }
    }
}