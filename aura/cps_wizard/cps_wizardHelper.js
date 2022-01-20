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
          console.error(error);
          onError && onError(error);
          break;
      }
    });
    $A.enqueueAction(action);
  },
  getPlaygroundDetails: function(component) {
    const playground = component.get("v.playground");

    return new Promise(resolve => {
      this.enqueueAction(
        component,
        "c.getPlaygroundDetails",
        { playgroundId: playground.Id },
        resolve
      );
    });
  }
});