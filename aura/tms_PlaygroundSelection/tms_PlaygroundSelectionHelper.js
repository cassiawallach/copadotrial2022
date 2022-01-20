({
	getPlaygrounds : function(component, helper) {
		var action = component.get("c.getPlaygroundRecords");
        action.setCallback(this,function(response){
            //get the response state
            var state = response.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    if (result.length > 0) {
                        component.set("v.selectedPSeededValue", result[0].Id);
                        helper.getPlaygroundEnv(component, result[0].Id);
                    }
                    component.set("v.lstPlaygrounds", result);
                    component.set("v.hasPlaygrounds", true);
                }
                else {
                    component.set("v.hasPlaygrounds", false);
                }
            } else if(state == "ERROR"){
                alert("Error in calling server side action");
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
	},
    getFrontDoorUrl : function(component, orgId) {
        var action = component.get("c.getFrontDoorUrl");
        action.setParams({
            "orgId": orgId
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                console.info("JSON Response object received: ", result);
                
                if(result==null) {
                    //handle exception.
                }
                else {
                    try {
                        var obj = JSON.parse(result);
                        console.info("JSON obj: ", obj);
                        if(obj.isFinished==true && obj.isSuccess==true) {
                            if(!obj.frontDoor)alert("We were unable to log you into your org.  Please do so manually.");
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                  "url": obj.frontDoor
                                });
                                urlEvent.fire();
                        }
                        if(obj.error) {
                            alert("Error: "+obj.error);
                        }
                    } 
                    catch (e) {
                        alert("Request to access org was not authorized.");
                    	console.log("Error parsing response.", e);
                    }
                }
            } else if(state == "ERROR"){
                alert("Error in calling server side action");
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    getPlaygroundEnv : function(component, playgroundId) {
        var action = component.get("c.getPlaygroundEnv");
        action.setParams({
            playgroundId : playgroundId
        });
        action.setCallback(this,function(response){
            var state = response.getState();

            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    component.set("v.lstPlaygroundsEnv", result);
                }
                else {
                    component.set("v.lstPlaygroundsEnv", null);
                }
            } else if(state == "ERROR"){
                alert("Error in calling server side action");
            }
        });
        $A.enqueueAction(action);
    }
})