({
  enqueueAction: function(component, actionName, params, onSuccess, onError) {
    const action = component.get(actionName);

    if (params) {
      action.setParams(params);
    }

    action.setCallback(this, function(response) {
      switch (response.getState()) {
        case "SUCCESS":
          onSuccess && onSuccess(response.getReturnValue());
          break;
        case "INCOMPLETE":
          break;
        case "ERROR":
          const error = response.getError();
          console.error(JSON.stringify(error));
          onError && onError(error);
          break;
      }
    });

    $A.enqueueAction(action);
  },
  getActions: function() {
    /*return {
      AuthorizeSandbox: "AuthorizeSandbox",
      EnableUser: "EnableUser",
      GitSetupFinish: "GitSetupFinish",
      CreateGitSnapshot: "CreateGitSnapshot",
      CreateBranches: "CreateBranches",
      CreateBoilerplate: "CreateBoilerplate"
    };*/
    return {
      AuthorizeSandbox: "AuthorizeSandbox",
      AddingFinishingTouches: "AddingFinishingTouches"
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
  getPlayground: function(component, onSuccess) {
    const helper = this;
    const playground = component.get("v.playground");
    if(playground.All_Sandboxes_Authorized__c==true)return onSuccess(playground);

    helper.enqueueAction(component, "c.getPlaygroundDetails", { playgroundId:playground.Id}, 
    response => {
      component.set("v.playground", response.playground);
      onSuccess(response.playground);
    }, 
    error => {
      var toastEvent = $A.get("e.force:showToast");
      var beautifulError = helper.beautifyErrorResponse(component, helper.getActions().AuthorizeSandbox, error);
      toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Error getting Playground data", "message":beautifulError });
      toastEvent.fire();
    });
  },
  getJobs: function(component, onSuccess) {
    const helper = this;
    const playground = component.get("v.playground");

    helper.enqueueAction(
      component,
      "c.getPlaygroundJobs",
      { playgroundId: playground.Id },
      jobs => {
        /*const setupJobs = [
          helper.getActions().AuthorizeSandbox,
          helper.getActions().EnableUser,
          helper.getActions().GitSetupFinish,
          helper.getActions().CreateGitSnapshot,
          helper.getActions().CreateBranches,
          helper.getActions().CreateBoilerplate
        ];*/
        const setupJobs = [
          helper.getActions().AuthorizeSandbox,
          helper.getActions().AddingFinishingTouches
        ];

        const tasks = jobs
          .filter(j => setupJobs.indexOf(j.Action__c) !== -1)
          .map(j => ({
            id: j.Id,
            action: j.Action__c,
            status: j.Status__c,
            label: j.Name,
            environment_name: j.Sandbox_Name__c,
            displayOnUI: j.Action__c !== helper.getActions().AuthorizeSandbox,
            C1P_JobId: j.JobId__c,
            payload:j.Payload__c
          }))
          .sort((a, b) => setupJobs.indexOf(a.action) - setupJobs.indexOf(b.action));

        onSuccess(tasks);
      }
    );
  },
  updateJob: function(component, jobId, status) {
    return new Promise(resolve => {
      const playground = component.get("v.playground");

      this.enqueueAction(
        component,
        "c.updateJobStatus",
        { playgroundId: playground.Id, jobId, status },
        job => {
          const jobs = component.get("v.jobs");
          jobs.forEach(t => {
            if (t.id === job.Id) {
              t.status = job.Status__c;
            }
          });

          component.set("v.jobs", jobs);
          resolve();
        }
      );
    });
  },
  getUrlParameters: function(component) {
    const urlParamsStr = decodeURIComponent(window.location.href).substr(
      window.location.href.indexOf("?") + 1
    );
    const urlParams = urlParamsStr.split("&").reduce((acc, cur) => {
      const [key, value] = cur.split("=");
      acc[key] = value;
      return acc;
    }, {});

    return urlParams;
  },

  // Actions
  getAuthLinks: function(component, onSuccess) {
    const playground = component.get("v.playground");

    this.enqueueAction(
      component,
      "c.GetEnvironmentAuthorizationLinks",
      { playgroundId: playground.Id },
      onSuccess
    );
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
      if (eType=="EnableUser") {
        if (obj.message && obj.message.includes("The Copado license limit has been reached")) {
          return "The Copado license limit has been reached. Please contact support to increase the license limit.";
        }
      }

      if (eType=="GitSetupFinish") {
        if (obj.message && obj.message.includes("Validation Failed")) {
          if (obj.errors && obj.errors[0].message.includes("key is already in use")) {
            return "The authentication key we have created is already in use on your Github account.  Please delete unused keys.";
          }
        }
      }

      if (eType=="CreateGitSnapshot") {
        if (obj.message && obj.message.includes("Unauthorized")) {
          return "The Git Snapshot could not be completed due to an authorization issue. Please log a case with support.";
        }
        else if (obj.message && obj.message.length>0 && obj.message!=null && !obj.errors) {
          return obj.message;
        }
        else {
          return obj.message;
        }
      }

      if (eType=="CreateBranches") {
        if (obj.message && obj.message.includes("At least 40 characters are required; only 0 were supplied.")) {
          return "There was an error with creating the branches in Github. Please log a case with support.";
        }
        if (obj.message && obj.message.includes("Object does not exist")) {
          return "The branches could not be created without a parent commit Id. Please make sure the Repository has at least 1 commit and try again.";
        }
      }

      if (eType=="CreateBoilerplate") {
        if (obj.message && obj.message!=null) return obj.message;
        else return "The templated playground data could not be created.  Your playground will however still be functioning."
      }
      else if (obj.message && obj.message!=null) {
        return obj.message;
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
  checkIfAllJobsAreCompleted: function(component) {
    let helper = this;
    component.set("v.authorizationEnded", false);
    helper.getPlayground(component, playground => {
      component.set("v.authorizationEnded", playground.All_Sandboxes_Authorized__c);
    });
    
    let nonAuthJobs = () => component.get("v.jobs").filter(j => j.action !== helper.getActions().AuthorizeSandbox);
    const setupEnded = nonAuthJobs().filter(j => j.status !== helper.getJobStatus().Completed).length === 0;
    component.set("v.setupEnded", setupEnded);
  },
  setFailedStatusAndShowErrorToast: function (component, action, title, message) {
    const helper = this;
    helper.setComponentJobStatus(component, action, helper.getJobStatus().Failed);
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({ "mode":"sticky", "type":"error", "title":title, "message":message });
    toastEvent.fire();
  }
});