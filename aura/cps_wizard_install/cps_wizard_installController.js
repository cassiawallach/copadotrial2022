({
  doInit: function(component, event, helper) {
    const playground = component.get("v.playground");
    helper.getJobs(component, playground.Id, jobs => {
      component.set("v.jobs", jobs);
      for (let i=0; i<jobs.length; i++) {
        if (jobs[i].status==helper.getJobStatus().Failed) {
          var payload = helper.parsePayload(jobs[i].payload);
          var beautifulError = helper.beautifyErrorResponse(component, jobs[i].action, payload.data);
          helper.setFailedStatusAndShowErrorToast(component, jobs[i].action, helper.getJobStatus().Failed, beautifulError);
        }
      }

      helper.checkIfAllJobsAreCompleted(component, jobs);
    });
  },
  changeStep: function(component, event, helper) {
    const stepChangeEvent = $A.get("e.c:cps_wizard_stepChange");
    const playground = component.get("v.playground");
      const nextStep = playground.Playground_Configuration__c == 'Full Configuration' || playground.Playground_Configuration__c == 'Full Configuration - Scratch Orgs'  ? 5 : 6;
    stepChangeEvent.setParams({ step: nextStep });
    stepChangeEvent.fire();
  },
  handleC1PEvents: function(component, event, helper) {
    const playground = component.get("v.playground");
    const data = JSON.parse(JSON.stringify(event.getParam("data")));
    if(!data || !data.Playground_Id__c || data.Playground_Id__c!=playground.Id)return;
    //If we get here, we have a valid playground Id for the current playground.

    const action = event.getParam("action");
    const hasError = event.getParam("hasError");
    const raw = JSON.parse(JSON.stringify(event.getParam("raw")));
    const jobId = data.Copado_Job_Id__c;
	
    let jobs = component.get("v.jobs");
    let relatedJob = null;
    for (let i=0; i<jobs.length; i++) {
      //Make sure we have a jobId for all jobs.
      if (jobs[i].id==data.Record_Id__c && action==jobs[i].action) {
        jobs[i].C1P_JobId = jobId;
        relatedJob = jobs[i];
        break;
      }
    }

    if (!relatedJob) return;
    
    // if job is in progress
    if (relatedJob.C1P_JobId==jobId && data.isFinished__c==false && relatedJob.status!=helper.getJobStatus().InProgress) {
      helper.setComponentJobStatus(component, relatedJob.action, helper.getJobStatus().InProgress);
    }
    
    //Successfull jobs enter here.
    if (relatedJob.C1P_JobId==jobId && data.isFinished__c==true && data.isSuccess__c==true) {
      let hasEventMessage = helper.hasEventMessage(component, jobId);
      if (hasEventMessage) return;
      var payload = helper.parsePayload(data.Payload__c);

      helper.getJobs(component, playground.Id, jobs => {
        component.set("v.jobs", jobs);
        helper.checkIfAllJobsAreCompleted(component, jobs);
      });

      if (hasError) return;
    }

    //Exceptions will be handled within the elseIf statement.
    else if (relatedJob.C1P_JobId==jobId && data.isFinished__c==true && data.isSuccess__c==false) {
      var payload = helper.parsePayload(data.Payload__c);
      var toastEvent = $A.get("e.force:showToast");
      
      var beautifulError = helper.beautifyErrorResponse(component, action, payload.data);
	  toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Error", "message":beautifulError });
      toastEvent.fire();

      helper.getJobs(component, playground.Id, jobs => {
        component.set("v.jobs", jobs);
      });
      helper.setComponentJobStatus(component, relatedJob.action, helper.getJobStatus().Failed);
    }
  }
});