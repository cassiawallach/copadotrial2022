({
    getUserInfo: function(component) {
        var action = component.get("c.getUserInfo");
        action.setCallback(this, function(res){
            var state = res.getState();
            if (state==="SUCCESS") {
                var user = res.getReturnValue();
                console.info("Retrieved result: ", user);
                component.set("v.user", user);
                component.set("v.username", user.Email);
                return user;
            }
            else if (state==="ERROR") {
                let errors = res.getError();
                let message = 'Error retrieving User information.';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"", "message":message });
                toastEvent.fire();
                console.error(message);
                return null;
            }
        });
        $A.enqueueAction(action);
    },
    createSignupRequest: function(component, username, domain, country) {        
        var action = component.get("c.createSignupRequest");
        action.setParams({ "username":username, "domain":domain, "country":country });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state==="SUCCESS") {
                
                //Let's get the SR result and check if we have a good status...
                console.info(response.getReturnValue());
                
                var res = response.getReturnValue();
                console.info(res, res.Id);
                
                if (res.Id==null) return;

                console.log("Now checking to latest request status...");
                this.getSignupRequest(component, res.Id);
            }
            else {
                let errors = response.getError();
                let message = "Unknown error";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"", "message":message });
                toastEvent.fire();
                console.error(message);

                let button = component.find("nextBtn");
                button.set("v.disabled", false);
            }
        });
        $A.enqueueAction(action);
    },
    getSignupRequest: function(component, signupRequestId) {
        console.log("Start retrieving SignupRequest: "+signupRequestId);
        var getSignupAction = component.get("c.getSignupRequest");
        getSignupAction.setParams({ "recordId":signupRequestId });
        getSignupAction.setCallback(this, function(res){
            var state = res.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state==="SUCCESS") {
                var resObj = res.getReturnValue();
                console.info("Retrieved result: ", resObj);
                if (resObj.Status__c=="Error") {
                    let msg = this.getErrorDescriptionFromCode(resObj.Error_Code__c);
                    console.error(msg);
                    toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"", "message":msg });
                    toastEvent.fire();
                    let button = component.find("nextBtn");
                	button.set("v.disabled", false);
                    return;
                }
                else if (resObj.Status__c=="Success") {
                    console.log("Redirecting to page...");
                    var url = "/finalpage";
                    console.log("url is: " + url);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": url,
                        "isredirect": false
                    });
                    urlEvent.fire();
                }
                else if (resObj.Status__c=="New") {
                    var d = new Date();
                    toastEvent.setParams({ "mode":"sticky", "type":"success", "title":"Success", "message":"Copado trial org creation starting." });
                    toastEvent.fire();
                    window.setTimeout($A.getCallback(() => this.getSignupRequest(component, signupRequestId)), 2000);
                }
                else if (resObj.Status__c=="InProgress") {
                    var d = new Date();
                    toastEvent.setParams({ "mode":"sticky", "type":"success", "title":"Success", "message":"Copado trial org creation in progress." });
                    toastEvent.fire();
                    window.setTimeout($A.getCallback(() => this.getSignupRequest(component, signupRequestId)), 3000);
                }
            }
            else{
                let errors = res.getError();
                let message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Unknown Error", "message":message });
                toastEvent.fire();
                console.error(message);
                let button = component.find("nextBtn");
                button.set("v.disabled", false);
                return;
            }
        });
        $A.enqueueAction(getSignupAction);
    },
    getErrorDescriptionFromCode: function (errorCode) {
        if (errorCode=="C-1007")
            return "Duplicate username.";
        else if (errorCode=="C-1015")
            return "Error while establishing the new org’s My Domain (subdomain) settings. Contact Copado support for assistance.";
    	else if (errorCode=="C-1016")
            return "Error while configuring the OAuth connected app for Proxy Signup. Verify that your connected app has a valid consumer key, callback URL, and unexpired certificate (if applicable).";
        else if (errorCode=="C-1018")
            return "Invalid subdomain value provided during signup.";
        else if (errorCode=="C-1019")
            return "Subdomain in use. Choose a new subdomain value.";
        else if (errorCode=="C-1020")
            return "Template not found. Either the template doesn't exist (or it was deleted).";
        else if (errorCode=="C-1033")
            return "Template is the wrong version.";
        else if (errorCode=="C-9999")
            return "Generic fatal error. Contact Copado support for assistance.";
        else if (errorCode=="S-1006")
            return "Invalid email address (not in a proper email address format).";
        else if (errorCode=="S-1014")
            return "Invalid or missing parameters during signup process. Please refer to the SignupRequest API for Error Code: "+errorCode;
        else if (errorCode=="S-1017")
            return "Namespace isn’t registered with a release org associated with the Dev Hub.";
        else if (errorCode=="S-1018")
            return "Invalid My Domain (subdomain) name. Select a name that does not contain double hyphens, end in a hyphen, include restricted words or exceed 40 characters (33 for Developer Edition)";
        else if (errorCode=="S-1019")
            return "My Domain (subdomain) already in use.";
        else if (errorCode=="S-1026")
            return "Invalid namespace. Namespaces must begin with a letter, must not contain consecutive underscores, cannot be a restricted or reserved namespace, and must be 15 characters or fewer.";
        else if (errorCode=="S-2006")
            return "Invalid country.";
        else if (errorCode=="T-0001")
            return "Template ID not valid (not in the format 0TTxxxxxxxxxxxx).";
        else if (errorCode=="T-0002")
            return "Template not found. Either the template doesn't exist (or it was deleted).";
        else if (errorCode=="T-0003")
            return "Template not approved for use by Salesforce.";
        
        return "Error code ("+errorCode+") not found.  Please refer to the Salesforce SignupRequest API documentation.";
    }
});