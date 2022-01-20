({
	doInit : function(component, event, helper) {
        component.set('v.cometdSubscriptions', []);
        var moduleId = helper.getParameterFromUrl("ltui__urlRecordId");
        component.set("v.recordId", moduleId);
        helper.hasConfigStep(component, moduleId);

        window.addEventListener('unload', function(event) {
            helper.disconnectCometd(component);
        });

        helper.getSessionId(component, helper);
	},
   	closeModal: function(component, event, helper) {
        component.set("v.showResponse", false);
        component.set("v.response_message", "");
        component.set("v.isSeedBtnShow", false);
        component.set("v.isBtnRetryShow", false);
        component.set("v.isOpenPlaygroundBtnShow", false);
		component.set("v.isOpen", false);
    },
    setSelectedPlayground: function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var playground = params.playground;

            component.set("v.stepExecutions", null);
            component.set("v.selectedPlayground", playground.Id);
            component.set("v.selectedPlaygroundName", playground.Name);
            component.set("v.isOpen", true);
            helper.getStepExecution(component, false);
        }
    },
    runJob: function(component, event, helper) {
        component.set("v.showResponse", false);
        component.set("v.response_message", "");
        component.set("v.isSeedBtnShow", false);
        component.set("v.isBtnRetryShow", false);
        var action = component.get("c.runOrgConfigurationStep");

        action.setParams({
            "playgroundId": component.get("v.selectedPlayground"),
            "learningAssignmentId": component.get("v.recordId")
        });
        component.set("v.isSeedBtnShow", false);

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                helper.handleResponse(component, response.getReturnValue());
            	component.set("v.jobInProgress", true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showResponse", true);
            	component.set("v.jobInProgress", false);
                component.set("v.response_theme", "error");
                component.set("v.response_message", ((errors)?obj.error: "Unknown error"));
            }
        });
        //now create background action for credit assignment.
        var backgroundAction = component.get("c.assignCredits");
        backgroundAction.setBackground();
        backgroundAction.setParams({ "playgroundId": component.get("v.selectedPlayground") });
        backgroundAction.setCallback(this, function(response) {
            var state = response.getState();
        });
        $A.enqueueAction(backgroundAction);
        $A.enqueueAction(action);

    },
    openPlayground: function(component, event, helper){
        let orgId = component.get("v.selectedPlayground");
        helper.getFrontDoorUrl(component, orgId);
    },
    onCometdLoaded: function(component, event, helper) {
        const cometd = new org.cometd.CometD();
        component.set('v.cometd', cometd);
        
        helper.connectCometd(component);
    }
})