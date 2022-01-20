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
    hasConfigStep : function(component, moduleId) {
        var action = component.get("c.hasConfigStep");
        action.setParams({ "moduleId":moduleId });
        action.setCallback(this,function(a){
            var state = a.getState();
            
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(result==null) {
                	component.set("v.hasConfigStep", false);
                }
                else {
                	component.set("v.hasConfigStep", true);
                }
            } else if(state == "ERROR"){
                console.error("Error in calling server side action");
            }
        });       
        $A.enqueueAction(action);
    },
    handleResponse : function(component, response) {
        var THEME_BASE = "slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_";
        
        if(response.startsWith('<html')) {
            component.set("v.showResponse", true);
            component.set("v.response_message", "The service failed authorization. You can contact support by logging a case in our community.");
            component.set("v.response_theme", THEME_BASE+"error");
        } else if (response.startsWith('Execution Started')){
            component.set("v.showResponse", true);
            component.set("v.response_message", $A.get("$Label.c.TMS_MSG_TRAILSETUP_STARTED"));
            component.set("v.response_theme", THEME_BASE+"info");
        }
	},
    getFrontDoorUrl : function(component, orgId) {
        var action = component.get("c.createFrontDoorRequest");
        action.setParams({
            "orgId": orgId
        });
        
        action.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                console.info("JSON Response object received: ", result);
                
                if(result!=null) {
                    try {
                        var obj = JSON.parse(result);
                        console.info("JSON obj: ", obj);
                        if(obj.isFinished==true && obj.isSuccess==true) {
                            if(!obj.frontDoor)console.error("We were unable to log you into your org.  Please do so manually.");
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                  "url": obj.frontDoor
                                });
                                urlEvent.fire();
                        }
                        if(obj.error) {
                            console.error("Error: "+obj.error);
                        }
                    } 
                    catch (e) {
                    	console.log("Error parsing response.", e);
                    }
                }
            } else if(state == "ERROR"){
                console.error("Error in calling server side action");
            }
        });       
        $A.enqueueAction(action);
    },
    getParameterFromUrl : function(paramName) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split("&");
        for (var i=0; i<sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split("=");
            if (sParameterName[0] === paramName) {
                sParameterName[1] === undefined ? null : sParameterName[1];
                return sParameterName[1];
            }
        }
        return null;
    },
    getStepExecution : function(component, isExecutionFailed){
        component.set("v.isOpenPlaygroundBtnShow", false);
        var action = component.get("c.getStepExecution");
        action.setParams({
            "playgroundId": component.get("v.selectedPlayground"),
            "learningAssignmentId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var THEME_BASE = "slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_";
            var state = response.getState();
            component.set("v.isBtnRetryShow", false);
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    component.set("v.isSeedBtnShow", false);
                    let completeCount = 0;
                    let isFailed = false;
                    result.forEach(element => {
                        if (element.Status__c == 'Completed') {
                            completeCount++;
                        }
                        if ((element.Configuration_Execution__r.Status__c == 'Failed' ||  element.Status__c == 'Failed') && !isFailed) {
                            isFailed = true;
                        }
                    });
                    component.set("v.stepExecutions", result);
                    if (completeCount == result.length && !isFailed) {
                        component.set("v.jobInProgress", false);
                        component.set("v.response_theme", THEME_BASE+"success");
                        component.set("v.response_message", $A.get("$Label.c.TMS_MSG_TRAILSETUP_SUCCESS"));
                        component.set("v.isOpenPlaygroundBtnShow", true);
                    }

                    if(isFailed){
                        component.set("v.jobInProgress", false);
                        component.set("v.response_theme", THEME_BASE+"error");
                        component.set("v.isBtnRetryShow", true);

                        if (isExecutionFailed) {
                            component.set("v.response_message", "Error during setup. Please try again.");
                            return;
                        }

                        component.set("v.response_message", $A.get("$Label.c.TMS_MSG_TRAILSETUP_ERROR"));
                    }
                } else {
                    component.set("v.stepExecutions", null);
                    component.set("v.isSeedBtnShow", true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    connectCometd: function(component) {
        const helper = this;
        const cometd = component.get("v.cometd");
        const sessionId = component.get("v.sessionId");
        const cometdUrl = window.location.protocol + "//" + window.location.hostname + "/cometd/43.0/";
        
        if (sessionId == null || cometd == null) return;
        
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
                    const newSubscription = cometd.subscribe( "/event/Step_Execution_Event__e",
                        $A.getCallback(function(response) {
                            const platformEvent = JSON.parse(JSON.stringify(response));
                            if(platformEvent.data.payload.Learning_Assignment_Id__c == component.get("v.recordId")){
                                let isExecutionFailed = (platformEvent.data.payload.isFinished__c == true && platformEvent.data.payload.Status__c == 'Failed');
                                helper.getStepExecution(component, isExecutionFailed);
                            }
                        })
                    );

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
    }
})