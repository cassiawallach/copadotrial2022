({
  doInit: function(component, event, helper) {
    const playground = component.get("v.playground");
    component.set("v.loading", true);
    component.set("v.sandboxToAuthorize", { name: "", type: "", link: "" });

    helper.getJobs(component, jobs => {
      component.set("v.jobs", jobs);
      let authJobs = () => component.get("v.jobs").filter(j => j.action === helper.getActions().AuthorizeSandbox);
      
      for (let i=0; i<jobs.length; i++) {
        if (jobs[i].status==helper.getJobStatus().Failed) {
          var payload = helper.parsePayload(jobs[i].payload);
          var beautifulError = helper.beautifyErrorResponse(component, jobs[i].action, payload.data);
          helper.setFailedStatusAndShowErrorToast(component, jobs[i].action, helper.getJobStatus().Failed, beautifulError);
        }
      }

      helper.checkIfAllJobsAreCompleted(component);
      component.set(
        "v.authTasks",
        authJobs().map(j => ({
         id: j.Id,
          label: j.label,
          status: j.status,
          displayOnUI: true
        }))
      );
      if (playground.All_Sandboxes_Authorized__c==true) {
        component.set("v.view", 1);
        component.set("v.loading", false);
        return;
      }

      helper.getAuthLinks(component, authLinks => {
        const completeAuthJob = authorizationJob =>
          helper
            .updateJob(component, authorizationJob.id, helper.getJobStatus().Completed)
            .then(() => {
              component.set(
                "v.authTasks",
                authJobs().map(j => ({
          id: j.Id,
                  label: j.label,
                  status: j.status,
                  displayOnUI: true
                }))
              );
            });

        component.set("v.loading", false);
        component.set("v.view", 1);

        const getNextAuthLink = () => {
          const nextAuthJob = authJobs().find(j => j.status === helper.getJobStatus().Pending);
          if (!nextAuthJob) {
            return;
          }

          const environmentName = helper.getUrlParameters().name;

          // If current environment name is on the URL
          // It means the user has already authorized the sandbox
          // and we should marked as completed and provide the link to authorize the next environment
          if (nextAuthJob.environment_name === environmentName) {
            completeAuthJob(nextAuthJob).then(getNextAuthLink);
          } else {
            const isTrial = nextAuthJob.environment_name === "Copado";

            const sandboxToAuthorize = {
              name: isTrial ? "Trial" : nextAuthJob.environment_name,
              type: isTrial ? "Org" : "Sandbox",
              hint:
                "Username: " +
                playground.Org_Credential__r.copado__Username__c +
                (isTrial ? "" : "." + nextAuthJob.environment_name),
              link: authLinks[nextAuthJob.environment_name]
            };

            component.set("v.sandboxToAuthorize", sandboxToAuthorize);
          }
        };

        getNextAuthLink();
      });
    });
  },
  continue: function(component, event, helper) {
    component.set("v.view", 2);
  },
  changeStep: function(component, event, helper) {
    const stepChangeEvent = $A.get("e.c:cps_wizard_stepChange");
    stepChangeEvent.setParams({ step: 6 });
    stepChangeEvent.fire();
  },
  handleC1PEvents: function(component, event, helper) {
    const playground = component.get("v.playground");
    const data = JSON.parse(JSON.stringify(event.getParam("data")));
    if(!data || !data.Playground_Id__c || data.Playground_Id__c!=playground.Id)return;
    //If we get here, we have a valid playground Id for the current playground.
    
    const action = event.getParam("action");
    const hasError = event.getParam("hasError");
    //const raw = JSON.parse(JSON.stringify(event.getParam("raw")));
    const jobId = data.Copado_Job_Id__c;
    
    let jobs = component.get("v.jobs");
    let relatedJob = null;
    for (let i=0; i<jobs.length; i++) {
      //Make sure we have a jobId for all jobs.
      if (jobs[i].id==data.Record_Id__c && jobs[i].action==action) {
        jobs[i].C1P_JobId = jobId;
        relatedJob = jobs[i];
        console.debug("Related Job (SFDC Data):", relatedJob, "Data (Playground Job Event): ", data);
        relatedJob.status = data.Status__c;
        break;
      }
    }
    let hasEvtMessage = helper.hasEventMessage(component, relatedJob.C1P_JobId, false);
    if (!relatedJob || hasEvtMessage) return;
    
    // if job is in progress
    if (relatedJob.C1P_JobId==jobId && data.isFinished__c==false) {
      helper.setComponentJobStatus(component, relatedJob.action, helper.getJobStatus().InProgress);
    }
    
    //Successfull jobs enter here.
    if (relatedJob.C1P_JobId==jobId && data.isFinished__c==true && data.isSuccess__c==true) {
      let hasEvtMessage = helper.hasEventMessage(component, relatedJob.C1P_JobId, true);
      if (hasEvtMessage) return;
      var payload = helper.parsePayload(data.Payload__c);
      
      helper.getJobs(component, jobs => {
        component.set("v.jobs", jobs);
        helper.setComponentJobStatus(component, relatedJob.action, helper.getJobStatus().Completed);
        helper.checkIfAllJobsAreCompleted(component);
      });
    }

    //Exceptions will be handled within the elseIf statement.
    else if (relatedJob.C1P_JobId==jobId && data.isFinished__c==true && data.isSuccess__c==false) {
      var payload = helper.parsePayload(data.Payload__c);
      var beautifulError = helper.beautifyErrorResponse(component, action, payload.data);
      helper.setFailedStatusAndShowErrorToast(component, relatedJob.action, "Error", beautifulError);
      helper.setComponentJobStatus(component, relatedJob.action, helper.getJobStatus().Failed);
    }
  }
});