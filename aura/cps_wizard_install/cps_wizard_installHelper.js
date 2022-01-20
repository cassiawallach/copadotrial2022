({
    enqueueAction: function(component, actionName, params, onSuccess, onError) {
        const action = component.get(actionName);
        if (params) action.setParams(params);
        if (actionName === "c.CreateEnvironment") action.setBackground();
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
    getActions: function() {
        return {
            ExecutePostInstallScript: "ExecutePostInstallScript",
            ProvisionLicenses: "ProvisionLicenses",
            CreateEnvironment: "CreateEnvironment",
            AssignPermissionSet: "AssignPermissionSet",
            CreateOrgCredentials: "CreateOrgCredentials",
            CreateScratchOrgEnvironment : "CreateScratchOrgEnvironment"
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
    getJobs: function(component, playgroundId, onSuccess) {
        const helper = this;
        helper.enqueueAction(component, "c.getPlaygroundJobs", { playgroundId: playgroundId }, function(
            jobs
        ) {
            const installJobs = [
                helper.getActions().ExecutePostInstallScript,
                helper.getActions().ProvisionLicenses,
                helper.getActions().CreateEnvironment,
                helper.getActions().CreateScratchOrgEnvironment,
                helper.getActions().AssignPermissionSet,
                helper.getActions().CreateOrgCredentials
            ];
            const tasks = jobs
            .filter(j => installJobs.indexOf(j.Action__c) !== -1)
            .map(j => ({
                id: j.Id,
                action: j.Action__c,
                status: j.Status__c,
                label: j.Name,
                environment_name: j.Sandbox_Name__c,
                payload:j.Payload__c,
                displayOnUI: true,
                C1P_JobId: j.JobId__c
            }))
            .sort((a, b) => installJobs.indexOf(a.action) - installJobs.indexOf(b.action));
            onSuccess(tasks);
        });
    },
    
    hasEventMessage: function(component, msg) {
        var eventMessages = component.get("v.eventMessagesToIgnore");
        var yesIncludes = eventMessages.includes(msg);
        if (yesIncludes==false) {
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
            if (eType=="InstallCopado") {
                if (obj.message && obj.message.includes("Data Storage Limits Exceeded")) {
                    return "Data Storage Limits Exceeded: Please use a Copado Trial Org to setup your Playground.";
                }
                else if (obj.errors && obj.errors.message) {
                    if(obj.errors.message.includes("Data Storage Limits Exceeded")) {
                        return "Data Storage Limits Exceeded: Please use a Copado Trial Org to setup your Playground.";
                    }
                    else if(obj.errors.message.includes("A newer version of this package is currently installed")) {
                        return "A newer version of Copado is currently installed in the Playground.  Please contact Copado Support.";
                    }
                        else {
                            return obj.errors.message;
                        }
                }
                    else if (obj.message && obj.message.length>0 && obj.message!=null && !obj.errors) {
                        return obj.message;
                    }
                        else {
                            return obj.message;
                        }
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
    checkIfAllJobsAreCompleted: function(component, jobs) {
        let allStepsCompleted = true;
        for (let i=0; i<jobs.length; i++) {
            if (jobs[i].status!=this.getJobStatus().Completed) allStepsCompleted = false;
        }
        component.set("v.installationEnded", allStepsCompleted);
    },
    setFailedStatusAndShowErrorToast: function (component, action, title, message) {
        const helper = this;
        helper.setComponentJobStatus(component, action, helper.getJobStatus().Failed);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ "mode":"sticky", "type":"error", "title":title, "message":message });
        toastEvent.fire();
    }
});