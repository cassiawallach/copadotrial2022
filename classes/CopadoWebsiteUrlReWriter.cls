global class CopadoWebsiteUrlReWriter implements Site.UrlRewriter {

    global PageReference mapRequestUrl(PageReference myFriendlyUrl){
        String url = myFriendlyUrl.getUrl();
        url = (url.length()>1)?url.substring(1,url.length()):url;
        if(!url.startsWith('website'))return new PageReference('/website'+url);
        return myFriendlyUrl;
    }
    global List<PageReference> generateUrlFor(List<PageReference> myForcedotcomUrls){
        return myForcedotcomUrls;
    }   
}