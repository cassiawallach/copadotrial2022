({
    doInit : function(component, event, helper) {
        const playground = component.get("v.playground");
        helper.getUserInfo(component);
        helper.getJobs(component, jobs => {
            component.set("v.jobs", jobs);
            const createTrialOrg = jobs.find(j => j.action === helper.getJobActions().CreateTrialOrg);
            if (createTrialOrg.status == helper.getJobStatus().Completed) {
            	component.set("v.view", 1);
        	}
            else {
            	component.set("v.view", 0);
        	}
            component.set("v.loading", false);
        });
    },

    submitSignupRequest : function(component, event, helper) {
        
        var allValid = component.find("signupRequestForm").reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        
        if (!allValid) return;
                
        console.info("Checking username format validity...");
        var username = component.get("v.username");
        var patt = /^[a-zA-Z0-9.!#$%&’*+\/=?^_`{|}~-]+@([a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+)*$/g;
        var result = username.match(patt);
        var usernameValid = (username==result);
        console.info("Username ("+username+") validity is: "+ usernameValid);
        
        if(!usernameValid) {
            let errorMessage = "Please make sure your username is a Salesforce valid username (email format and may contain a suffix).";
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ "mode":"sticky", "type":"warning", "title":"", "message":errorMessage });
            toastEvent.fire();
            return;
        }
                                               
        //var domain = component.get("v.domain"); not implemented for now due to validation issues.
        var country = component.get("v.user.Country");
        
        let button = component.find("nextBtn");
        button.set("v.disabled", true);
		var countryCodes = ['MT', 'AU', 'GB', 'US']; 
        const randomCountry = countryCodes[Math.floor(Math.random() * countryCodes.length)];        
        helper.createSignupRequest(component, username, null, randomCountry);
    },
    changeStep: function(component, event, helper) {
        const stepChangeEvent = $A.get("e.c:cps_wizard_stepChange");
        stepChangeEvent.setParams({ step: 3 });
        stepChangeEvent.fire();
    },
  	handleC1PEvents: function(component, event, helper) {
        const playground = component.get("v.playground");
        const data = JSON.parse(JSON.stringify(event.getParam("data")));
        if(!data || !data.Playground_Id__c || data.Playground_Id__c!=playground.Id)return;
        //If we get here, we have a valid playground Id for the current playground.
        
        const action = event.getParam("action");
        const hasError = event.getParam("hasError");
        var jobs = component.get("v.jobs");
        let relatedJob = null;
        for (let i=0; i<jobs.length; i++) {
            //Make sure we have a jobId for all jobs.
            if (jobs[i].id==data.Record_Id__c && jobs[i].action==action) {
                relatedJob = jobs[i];
                relatedJob.status = data.Status__c;
                break;
            }
        }
        
        if (!relatedJob) return;
        
        //In Progress jobs enter here.
        if (relatedJob.id==data.Record_Id__c && data.Status__c==helper.getJobStatus().InProgress) {
            //var d = new Date();
            let button = component.find("nextBtn");
            button.set("v.disabled", true);
            var toastEvent = $A.get("e.force:showToast");
            var staticLabel = $A.get("$Label.c.CPS_CREATEORG_STARTING");
            toastEvent.setParams({ "mode":"sticky", "type":"success", "title":"Success", "message":staticLabel });
            toastEvent.fire();
            return;
        }
        
        //Successfull jobs enter here.
        else if (relatedJob.id==data.Record_Id__c && data.isFinished__c==true && data.isSuccess__c==true) {
            var payload = helper.parsePayload(data.Payload__c);
            if (hasError) return;
            component.set("v.view", 1);
            return;
        }
        
        //Exceptions will be handled within the elseIf statement.
        else if (relatedJob.id==data.Record_Id__c && data.isFinished__c==true && data.isSuccess__c==false) {
            var payload = helper.parsePayload(data.Payload__c);
            let beautifulError = "";
            if(payload.errorCode && payload.errorCode!=null){
                beautifulError = helper.getErrorDescriptionFromCode(payload.errorCode);
            }
            helper.setFailedStatusAndShowErrorToast(component, relatedJob.action, "Error", beautifulError);
            let button = component.find("nextBtn");
            button.set("v.disabled", false);
            return;
        }
    }
});