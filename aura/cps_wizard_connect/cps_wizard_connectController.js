({
    doInit: function(component, event, helper) {
        helper.getSettings(component).then(settings => {
            component.set("v.settings", settings);
            component.set("v.githubRedirectURI",
                settings.gitAuthUrl + settings.gitClientId + "&redirect_uri=" + window.location.href
            );
            helper.getJobs(component, jobs => {
                component.set("v.jobs", jobs);
                const createCoeCredential = jobs.find(j => j.action === helper.getJobActions().CreateCoeCredential);
                const authorizeSF = jobs.find(j => j.action === helper.getJobActions().CoE_Authorization);
                const gitSetup = jobs.find(j => j.action === helper.getJobActions().GitSetup);
                console.log(createCoeCredential, authorizeSF, gitSetup);
                /*for (let i=0; i<jobs.length; i++) {
                    if (jobs[i].status==helper.getJobStatus().Failed) {
                        var payload = helper.parsePayload(jobs[i].payload);
                        var beautifulError = helper.beautifyErrorResponse(component, jobs[i].action, payload.data);
                        helper.setFailedStatusAndShowErrorToast(component, jobs[i].action, "Error", beautifulError);
                    }
                }*/

                if (authorizeSF.status !== helper.getJobStatus().Completed) {
                    helper.getAuthLink(component, ({ job, authorization_url }) => {
                        const userHasLoggedInWithSF = job.Status__c === helper.getJobStatus().Completed;

                        if (userHasLoggedInWithSF) {
                            component.set("v.sfAccountConnected", true);
                            helper.updateJob(component, job.Id, helper.getJobStatus().Completed);
                        } else {
                            component.set("v.copadoAuthLink", authorization_url);
            				console.log('returned apex job', job);
            				if (job.Status__c==helper.getJobStatus().Failed) {
                                var payload = helper.parsePayload(job.Payload__c);
                                var beautifulError = helper.beautifyErrorResponse(component, job.Action__c, payload.data);
                        		helper.setFailedStatusAndShowErrorToast(component, job.Action__c, "Error", beautifulError);
                            }
                        }
                
                        component.set("v.view", 0);
                        component.set("v.loading", false);
            			return;
                    });
                }
            	else if (gitSetup.status!==helper.getJobStatus().Completed && gitSetup.status!==helper.getJobStatus().Failed) {
                    const urlParamsStr = window.location.href.substr(window.location.href.indexOf("?") + 1);
                    const urlParams = urlParamsStr.split("&").reduce((acc, cur) => {
                        const [key, value] = cur.split("=");
                        acc[key] = value;
                        return acc;
                    }, {});
                    
                    if (!!urlParams.code) {
                        helper.setComponentJobStatus(component, helper.getJobActions().GitSetup, helper.getJobStatus().InProgress);
                        helper.setupGit(component, urlParams.code, () => {});
                    }
                    
                    component.set("v.view", 1);
                    component.set("v.loading", false);
            		return;
                }
                else if (gitSetup.status==helper.getJobStatus().Failed) {
                    component.set("v.view", 1);
                    component.set("v.loading", false);
            		console.log('gitSetup', gitSetup);
                    for (let i=0; i<jobs.length; i++) {
                        if (jobs[i].status==helper.getJobStatus().Failed) {
                            var payload = helper.parsePayload(jobs[i].payload);
                            var beautifulError = helper.beautifyErrorResponse(component, jobs[i].action, payload.data);
                        	helper.setFailedStatusAndShowErrorToast(component, jobs[i].action, "Error", beautifulError);
                        }
                    }
            		return;
                }
                else {
                    helper.wizardNextStep();
                }
        	});
		});
	},
    connectToSalesforce: function(component, event, helper) {
        component.set("v.sfAccountConnected", true);
    },
    connectToGit: function(component, event, helper) {
        component.set("v.gitAccountConnected", true);
    },
    openGitAuth: function(component, event, helper) {
        const stepChangeEvent = $A.get("e.c:cps_wizard_stepChange");
        stepChangeEvent.setParams({ step: 4 });
        stepChangeEvent.fire();
    },
	handleContinueClick: function(component, event, helper) {
    	const currentView = component.get("v.view");

    	if (currentView === 0) {
      		component.set("v.view", 1);
    	}
        else if (currentView === 1) {
      		helper.wizardNextStep();
        }
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
          
        var jobs = component.get("v.jobs");
        let relatedJob = null;
        for (let i=0; i<jobs.length; i++) {
            //Make sure we have a jobId for all jobs.
            if (jobs[i].id==data.Record_Id__c && jobs[i].action==action) {
                jobs[i].C1P_JobId = jobId;
                relatedJob = jobs[i];
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
            if (hasError) return;
            
            if (relatedJob.action===helper.getJobActions().CreateCoeCredential) {
                helper.handleCredentialCreation(component);
            }
            else if (relatedJob.action===helper.getJobActions().GitSetup) {
                helper.handleGitSetupAction(component);
            }
        }
        
        //Exceptions will be handled within the elseIf statement.
        else if (relatedJob.C1P_JobId==jobId && data.isFinished__c==true && data.isSuccess__c==false) {
            var payload = helper.parsePayload(data.Payload__c);
            var beautifulError = helper.beautifyErrorResponse(component, relatedJob.action, payload.data);
            helper.setFailedStatusAndShowErrorToast(component, relatedJob.action, "Error", beautifulError);
            helper.setComponentJobStatus(component, relatedJob.action, helper.getJobStatus().Failed);
        }
    },
    retryGitAuthentication: function(component, event, helper) {
        const redirectUri = component.get("v.githubRedirectURI");
        const jobs = component.get("v.jobs");
        const gitSetup = jobs.find(j => j.action === helper.getJobActions().GitSetup);

        helper.retryGitSetup(component, gitSetup.id, redirectUri);        
    }
});