({
    checkOrgType : function(component) {
		var action = component.get("c.checkOrgType");
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result) && result == true){
                    component.set("v.playgroundUrl", '/success/s/playground/Playground__c/Default');
                }
                else {
                    component.set("v.playgroundUrl", '/s/playground/Playground__c/Default');
                }
            } else if(state == "ERROR"){
                alert("Error in calling server side action");
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    }
})