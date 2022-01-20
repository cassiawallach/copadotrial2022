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
    enqueueAction: function(component, actionName, params, onSuccess, onError) {
      const action = component.get(actionName);

      if (params) action.setParams(params);
      action.setCallback(this, function(response) {
        switch (response.getState()) {
          case "SUCCESS":
            onSuccess && onSuccess(response.getReturnValue());
            break;
          case "INCOMPLETE":
            break;
          case "ERROR":
            const error = response.getError();
            console.error(error);
            onError && onError(error);
            break;
        }
      });

      $A.enqueueAction(action);
    },
    getJobActions: function() {
        return {
            CreateTrialOrg: "CreateTrialOrg"
        };
    },
    getJobStatus: function() {
        return {
            Pending: "Pending",
            InProgress: "In progress",
            Completed: "Completed",
            Failed: "Failed"
        };
    },
    getJobs: function(component, onSuccess) {
        const helper = this;
        const playground = component.get("v.playground");
        
        this.enqueueAction(component, 
                          "c.getPlaygroundJobs", 
                          { playgroundId: playground.Id }, 
                          function(jobs) {
                            const installJobs = [
                                helper.getJobActions().CreateTrialOrg
                            ];
        
                            const tasks = jobs.filter(j => installJobs.indexOf(j.Action__c) !== -1)
                            .map(j => ({ id:j.Id, action:j.Action__c, status:j.Status__c, label:j.Name, C1P_JobId:j.JobId__c, payload:j.Payload__c, displayOnUI:true }))
                            .sort((a, b) => installJobs.indexOf(a.action) - installJobs.indexOf(b.action));
                            onSuccess(tasks);
                          });
    },
    createSignupRequest: function(component, username, domain, country) {
		var playground = component.get("v.playground");        
        var action = component.get("c.createSignupRequest");
        action.setParams({ "username":username, "domain":domain, "country":country, "playgroundId":playground.Id });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state==="SUCCESS") {
                //Let's get the SR result and check if we have a good status...
                var res = response.getReturnValue();
                console.info(res);
                
                if (res.Id==null) return;

                if (res.Status__c=="New") {
                    var toastEvent = $A.get("e.force:showToast");
                    var staticLabel = $A.get("$Label.c.CPS_CREATEORG_STARTING");
                	toastEvent.setParams({ "mode":"sticky", "type":"success", "title":"Success", "message":staticLabel });
                    toastEvent.fire();
                }
            }
            else {
                let errors = response.getError();
                let message = "Unknown error";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = (errors[0].message=="")?message : errors[0].message;
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
    },
    parsePayload: function(msg) {
        if(!msg || msg=="") return [];
        var payload = [];
        try {
            payload = JSON.parse(msg);
        }
        catch(e) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Error!", "message":e });
            toastEvent.fire();
        }
        return payload;
    },
    setFailedStatusAndShowErrorToast: function (component, action, title, message) {
      const helper = this;
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({ "mode":"sticky", "type":"error", "title":title, "message":message });
      toastEvent.fire();
    }
});