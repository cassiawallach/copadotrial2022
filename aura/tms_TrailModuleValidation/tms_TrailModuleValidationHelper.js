({
    getSessionId : function(component, helper){
        const getSessionIdAction = component.get("c.getSessionId");
        getSessionIdAction.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === 'SUCCESS') {
                const sessionId = response.getReturnValue();
                component.set('v.sessionId', sessionId);
            	helper.connectCometd(component);
            } else{
                console.error(response);
            }
        });
        $A.enqueueAction(getSessionIdAction);
    },
    hasIMValidationConfigStep : function(component, moduleId) {
        var action = component.get("c.hasIMValidationConfigStep");
        action.setParams({ "moduleId":moduleId });
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(result==null) {
                	component.set("v.hasIMValidationConfigStep", false);
                } else {
                	component.set("v.hasIMValidationConfigStep", true);
                    component.set("v.learningAssignValidStatus", result);
                }
            } else if(state == "ERROR"){
                alert("Error in calling server side action");
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    handleResponse : function(component, response) {
        var THEME_BASE = "slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_";
        
        if(response.startsWith('<html')) {
            component.set("v.showResponse", true);
            component.set("v.response_message", "The service failed authorization. You can contact support by logging a case in our community.");
            component.set("v.response_theme", THEME_BASE+"error");
        } else if (response.startsWith('Validation Steps Execution Started')){
            component.set("v.showResponse", true);
            component.set("v.response_message", $A.get("$Label.c.TMS_IV_MSG_TRAILSETUP_STARTED"));
            component.set("v.response_theme", THEME_BASE+"info");
        }
        var obj = JSON.parse(response);
        if(obj==null)return;
        
        if (obj.isSuccess && obj.isSuccess==true && obj.isFinished==false) {
            component.set("v.showResponse", true);
            component.set("v.response_message", $A.get("$Label.c.TMS_IV_MSG_TRAILSETUP_STARTED"));
            component.set("v.response_theme", THEME_BASE+"info");
        }
        else if (obj.isSuccess && obj.isSuccess==false && obj.isFinished==true) {
            component.set("v.showResponse", true);
            component.set("v.response_theme", THEME_BASE+"error");
            if(obj.error)component.set("v.response_message", obj.error);
        }
	},
    getParameterFromUrl : function(paramName) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); // Get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split("&"); //Split by & so that we get the key value pairs separately in a list
        for (var i=0; i<sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split("="); //to split the key from the value.
            if (sParameterName[0] === paramName) {
                sParameterName[1] === undefined ? null : sParameterName[1];
                return sParameterName[1];
            }
        }
        console.log("No params were found, potentially due to a URL parsing issue.");
        return null;
    },
    connectCometd: function(component) {
        const helper = this;
        const cometd = component.get("v.cometd");
        const sessionId = component.get("v.sessionId");
        const cometdUrl = window.location.protocol + "//" + window.location.hostname + "/cometd/43.0/";
        
        if (sessionId == null || cometd == null) return;
        
        // Configure CometD
        cometd.configure({
            url: cometdUrl,
            requestHeaders: {
                Authorization: "OAuth " + sessionId
            },
            appendMessageTypeToURL: false
        });
        
        cometd.websocketEnabled = false;
        cometd.handshake(    
            $A.getCallback(function(handshakeReply) {
                if (handshakeReply.successful) {
                    // Subscribe to playground job event                    
                    const newSubscription = cometd.subscribe( "/event/Validation_Execution_Event__e",
                        $A.getCallback(function(response) {
                            const platformEvent = JSON.parse(JSON.stringify(response));
                            if(platformEvent.data.payload.Learning_Assignment_Id__c == component.get("v.recordId")){
                                let isExecutionFailed = (platformEvent.data.payload.isFinished__c == true && platformEvent.data.payload.Status__c == 'Failed');
                                helper.getInteractiveValidationStepExecution(component, isExecutionFailed);
                            }
                        })
                    );

                    // Save subscription for later
                    const subscriptions = component.get("v.cometdSubscriptions");
                    if (subscriptions) {
                        subscriptions.push(newSubscription);
                        component.set("v.cometdSubscriptions", subscriptions);
                    }
                } else {
                    console.error("CometD: Fail to connect");
                }
            })
        );
    },
    disconnectCometd: function(component) {
        var cometd = component.get("v.cometd");
        cometd.batch(function() {
            var subscriptions = component.get("v.cometdSubscriptions");
            subscriptions.forEach(function(subscription) {
                cometd.unsubscribe(subscription);
            });
        });
        
        component.set("v.cometdSubscriptions", []);
        cometd.disconnect();
    },
    getInteractiveValidationStepExecution : function(component, isVExecutionFailed){
        const helper = this;
        var THEME_BASE = "slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_";
        var selectedPlayground = component.get("v.selectedPlayground");
        if (selectedPlayground == null || selectedPlayground == '') {return;}

        var action = component.get("c.getInteractiveValidationStepExecution");

        action.setParams({
            "playgroundId": selectedPlayground,
            "learningAssignmentId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    component.set("v.IMValidationStepExecutions", result);

                    let successCount = 0, isProgressCount = 0;
                    let isFailed = false;
                    result.forEach(element => {
                        if (element.ExecutionStatus__c == 'In progress') {
                            isProgressCount++;
                        }
                        
                        if (element.Validation_Result__c == 'Success') {
                            successCount++;
                        }
                        if ((element.Validation_Execution__r.Status__c == 'Failed' || element.ExecutionStatus__c == 'Pending' || element.ExecutionStatus__c == 'Failed' || element.Validation_Result__c == 'Failed') && !isFailed) {
                            isFailed = true;
                        }
                    });
                    if (successCount == result.length && !isFailed) {
                        component.set("v.jobInProgress", false);
                        component.set("v.response_theme", THEME_BASE+"success");
                        component.set("v.response_message", $A.get("$Label.c.TMS_IV_MSG_TRAILSETUP_SUCCESS"));
                        component.set("v.isBtnProceedShow", false);
                        component.set("v.isBtnRetryShow", false);
                        let moduleId = component.get("v.recordId");
                        helper.hasIMValidationConfigStep(component, moduleId);
                        return;
                    }

                    if (isProgressCount > 0 && !isFailed) {
                        component.set("v.showResponse", true);
                        component.set("v.response_message", $A.get("$Label.c.TMS_IV_MSG_TRAILSETUP_STARTED"));
                        component.set("v.response_theme", THEME_BASE+"info");
                        component.set("v.isBtnProceedShow", false);
                        component.set("v.isBtnRetryShow", false);
                        return;
                    }
                    
                    if(isFailed){
                        component.set("v.jobInProgress", false);
                        component.set("v.response_theme", THEME_BASE+"error");
                        component.set("v.isBtnProceedShow", false);
                        component.set("v.isBtnRetryShow", true);

                        if(isVExecutionFailed == true){
                            component.set("v.response_message", "Error during validation. Please try again.");
                            return;
                        }
                        let moduleId = component.get("v.recordId");
                        helper.hasIMValidationConfigStep(component, moduleId);
                        component.set("v.response_message", $A.get("$Label.c.TMS_IV_MSG_TRAILSETUP_ERROR"));
                    }
                } else {
                    //helper.showButton(component, "btnSubmit");
                    component.set("v.isBtnProceedShow", true);
                    component.set("v.isBtnRetryShow", false);
                    component.set("v.IMValidationStepExecutions", null);
                }
            }
        });
        $A.enqueueAction(action);
    }
})