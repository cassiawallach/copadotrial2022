/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {
    global string baseUrl{get;set;}
    global String username{get;set;}
    global String password{get;set;}
    global string userLoginErrorMessage{get;set;}
    global CommunitiesLoginController(){
        userLoginErrorMessage = '';
        baseUrl = String.valueOf(ApexPages.currentPage().getHeaders().get('referer'));
    }
    // Code we will invoke on page load.
    /*global PageReference forwardToAuthPage() {
        return new PageReference('/Login');
    	String startUrl = System.currentPageReference().getParameters().get('startURL');
    	String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    } */
    global PageReference CommunityUserLogin() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        PageReference pageRef =  Site.login(username, password, startUrl);
        if(pageRef!=NULL){
            RETURN pageRef;
        }
        else{
            userLoginErrorMessage = 'User does not exist or password is incorrect.';
        }
        Return pageRef;
    }
}