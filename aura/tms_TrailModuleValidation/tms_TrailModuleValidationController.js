({
	doInit : function(component, event, helper) {
        component.set('v.cometdSubscriptions', []);

        var moduleId = helper.getParameterFromUrl("ltui__urlRecordId");
        component.set("v.recordId", moduleId);
        helper.hasIMValidationConfigStep(component, moduleId);

        window.addEventListener('unload', function(event) {
            helper.disconnectCometd(component);
        });

        helper.getSessionId(component, helper);
	},
   	closeModal: function(component, event, helper) {
        component.set("v.showResponse", false);
        component.set("v.response_message", "");
        component.set("v.isBtnProceedShow", false);
        component.set("v.isBtnRetryShow", false);
		component.set("v.isOpen", false);
    },
    setSelectedPlayground: function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var playground = params.playground;
            
            component.set("v.IMValidationStepExecutions", null);
            component.set("v.selectedPlayground", playground.Id);
            component.set("v.selectedPlaygroundName", playground.Name);
            component.set("v.isOpen", true);
            helper.getInteractiveValidationStepExecution(component, false);
        }
    },
    runJob: function(component, event, helper) {
        component.set("v.showResponse", false);
        component.set("v.response_message", "");
        component.set("v.response_theme", "");
        component.set("v.isBtnProceedShow", false);
        component.set("v.isBtnRetryShow", false);
        var action = component.get("c.runIVOrgConfigurationStep");

        action.setParams({
            "playgroundId": component.get("v.selectedPlayground"),
            "learningAssignmentId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            component.set("v.showResponse", true);
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                helper.handleResponse(component, response.getReturnValue());
            	component.set("v.jobInProgress", true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showResponse", true);
            	component.set("v.jobInProgress", false);
                component.set("v.response_theme", "slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error");
                component.set("v.response_message", ((errors)?obj.error: "Unknown error"));
            }
        });
        
        $A.enqueueAction(action);
    },
    onCometdLoaded: function(component, event, helper) {
        const cometd = new org.cometd.CometD();
        component.set('v.cometd', cometd);
        
        helper.connectCometd(component);
    }
})