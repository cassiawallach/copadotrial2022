({
    restartJobProcess : function(component, event, helper, PlaygroundJobId) {
        var action = component.get("c.resetPlaygroundJobById");
        action.setParams({
            PlaygroundJobId : PlaygroundJobId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var res = response.getReturnValue();
            }
            else if (state === "ERROR") {
                console.log(json.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    checkCreatingSandboxEnvironmentsProcess:function(component, event, helper,jobId){
        var action = component.get("c.isPlaygroundJobRetriable");
        action.setParams({
            PlaygroundJobId : jobId,
            jobName : 'Creating Sandbox Environments' 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.isRetryBtnVisible", response.getReturnValue());
                /*window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.isRetryBtnVisible", true);
                    }), 180000
                );*/
            }
            else if (state === "ERROR") {
                console.log(json.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})