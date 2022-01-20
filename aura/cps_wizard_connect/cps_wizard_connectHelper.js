({
    wizardNextStep: function() {
      const stepChangeEvent = $A.get("e.c:cps_wizard_stepChange");
      stepChangeEvent.setParams({ step: 4 });
      stepChangeEvent.fire();
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
            CoE_Authorization: "CoE_Authorization",
            GitSetup: "GitSetup",
            CreateCoeCredential: "CreateCoeCredential"
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
                                helper.getJobActions().CreateCoeCredential,
                                helper.getJobActions().CoE_Authorization,
                                helper.getJobActions().GitSetup
                            ];
        
                            const tasks = jobs.filter(j => installJobs.indexOf(j.Action__c) !== -1)
                            .map(j => ({ id:j.Id, action:j.Action__c, status:j.Status__c, label:j.Name, C1P_JobId:j.JobId__c, payload:j.Payload__c, displayOnUI:true }))
                            .sort((a, b) => installJobs.indexOf(a.action) - installJobs.indexOf(b.action));
                            onSuccess(tasks);
                          });
    },
    updateJob: function(component, playgroundJobId, theStatus) {
      return new Promise(resolve => {
        const playground = component.get("v.playground");
        
        this.enqueueAction(component, "c.updateJobStatus", { playgroundId:playground.Id, jobId:playgroundJobId, status:theStatus }, job => {
          const jobs = component.get("v.jobs");
          jobs.forEach(t => {
            if (t.action===job.Action__c) t.status = job.Status__c;
          });
          component.set("v.jobs", jobs);
          resolve();
        });
		  });
    },
    getSettings: function(component) {
    	return new Promise(resolve => {
        	this.enqueueAction(component, "c.getGithubSettings", null, resolve);
        });
    },
    getAuthLink: function(component, onSuccess) {            
    	const playground = component.get("v.playground");
      this.enqueueAction(
        component, 
        "c.getAuthLink", 
        { playgroundId:playground.Id, redirectUrl:encodeURIComponent(window.location.href) }, 
        onSuccess, 
        function(error){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Error", "message":"Error Setting Authorization URL" });
        toastEvent.fire();
      });
    },
    setupGit: function(component, gitAuthCode, onSuccess) {
      const playground = component.get("v.playground");
      const jobs = component.get("v.jobs");

      this.enqueueAction(component, "c.GitSetup", { playgroundId:playground.Id, gitAuthCode },
        gitSetupJob => {
          jobs.forEach(j => {
            if (j.action === gitSetupJob.Action__c) {
              j.status = gitSetupJob.Status__c;
              j.C1P_JobId = gitSetupJob.JobId__c;
            }
          });

          component.set("v.jobs", jobs);
          onSuccess && onSuccess();
        }
      );
    },
	handleGitSetupAction: function(component) {
      const helper = this;
      helper.setComponentJobStatus(component, helper.getJobActions().GitSetup, helper.getJobStatus().Completed);
      component.set("v.gitAccountConnected", true);
    },
	handleCredentialCreation: function(component) {
      const helper = this;
      
      helper.getAuthLink(component, ({ job, authorization_url }) => {
        const userHasLoggedInWithSF = job.Status__c === helper.getJobStatus().Completed;
        
        if (userHasLoggedInWithSF) {
          component.set("v.sfAccountConnected", true);
          helper.updateJob(component, job.Id, helper.getJobStatus().Completed);
        } else {
          component.set("v.copadoAuthLink", authorization_url);
        }

        component.set("v.view", 0);
        component.set("v.loading", false);
      });
  	},
    hasEventMessage: function(component, msg, isFinished) {
        var eventMessages = component.get("v.eventMessagesToIgnore");
        var yesIncludes = eventMessages.includes(msg);
        if (yesIncludes==false && isFinished==true) {
            eventMessages.push(msg);
            component.set("v.eventMessagesToIgnore", eventMessages);
        }
        return yesIncludes;
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
    beautifyErrorResponse: function (component, eType, obj) {
    	if (!obj) return "";
        try {
            if (eType=="GitSetup") {
                if (obj.message && obj.message.includes("Bad credentials")) {
                    return "There was an issue with the authorization of your GitHub account.  Please try again."
                }
                else if (obj.errors && obj.errors.length>0) {
                    const playground = component.get("v.playground");
                    if (obj.errors[0].message.includes("name already exists on this account")) {
                        var playgroundName = (playground && playground.Name && playground.Name!=null)? " 'copado-"+playground.Name+"' " : " ";
                        return "A Git Repository with the same name "+playgroundName+" already exists. Please delete this OR create a new Playground with a different name";
                    }
                }
                else if (obj.message && obj.message.length>0 && obj.message!=null && !obj.errors) {
                    return obj.message;
                }
                else {
                    return obj.message;
                }
            }
            else {
                if (obj.message) {
                    return obj.message;  
                }      
            }
        }
        catch (e) {
            console.error(e);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Error Response Beautification Error", "message":e });
            toastEvent.fire();
            return null;
        }
    },
    setComponentJobStatus: function (component, action, status) {
      var jobs = component.get("v.jobs");
      jobs.forEach(t => {
          if (t.action===action) t.status = status;
      });
      component.set("v.jobs", jobs);
    },
    setFailedStatusAndShowErrorToast: function (component, action, title, message) {
      const helper = this;
      helper.setComponentJobStatus(component, action, helper.getJobStatus().Failed);
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({ "mode":"sticky", "type":"error", "title":title, "message":message });
      toastEvent.fire();
    },
    retryGitSetup: function(component, jobId, uri) {
      this.updateJob(component, jobId, this.getJobStatus().Pending).then(result => {
        $A.get("e.force:navigateToURL")
          .setParams({ url: uri })
          .fire();
      });
    }
});