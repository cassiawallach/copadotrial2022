({
    onInit : function(component, event, helper) {
        if(component.get("v.loading") && component.get("v.text") == 'Creating Sandbox Environments'){
            helper.checkCreatingSandboxEnvironmentsProcess(component, event, helper,component.get("v.jobId"));
        
        }
    },
	changePlaygroundStatus : function(component, event, helper) {
		var PlaygroundJobId = event.currentTarget.getAttribute("data-jobId");
        if(PlaygroundJobId != ''){            
            helper.restartJobProcess(component, event, helper, PlaygroundJobId);
            helper.checkCreatingSandboxEnvironmentsProcess(component, event, helper,PlaygroundJobId);
        	
        }
	}
})