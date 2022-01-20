({
  enqueueAction: function(component, actionName, params, onSuccess, onError) {
    const action = component.get(actionName);

    if (params) {
      action.setParams(params);
    }

    action.setCallback(this, function(response) {
      switch (response.getState()) {
        case "SUCCESS":
          onSuccess && onSuccess(response.getReturnValue());
          break;
        case "INCOMPLETE":
          break;
        case "ERROR":
          const error = response.getError();
          onError && onError(error);
          break;
      }
    });
    $A.enqueueAction(action);
  },
  getFrontDoorUrl : function(component) {
    var action = component.get("c.createFrontDoorRequest");
    action.setParams({"orgId":component.get("v.orgId")});

    action.setCallback(this,function(a){
      var state = a.getState();
      if(state == "SUCCESS"){
        var result = a.getReturnValue();
        if(result==null) {
          //handle exception.
        }
        else {
          try {
            var obj = JSON.parse(result);
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
          }
        }
      } else if(state == "ERROR"){
        alert("Error in calling server side action");
      }
    });
    //adds the server-side action to the queue
    $A.enqueueAction(action);
  }
});