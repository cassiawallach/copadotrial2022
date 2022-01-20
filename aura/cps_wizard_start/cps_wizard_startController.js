({
  doInit: function(component, event, helper) {
    helper.enqueueAction(component, "c.canCreate", null, can => {
      if (!can) {
        // change url to be relative to community root path
        $A.get("e.force:navigateToURL")
          .setParams({
            url: "/"
          })
          .fire();
      }
    });	
	helper.playgroundConfig(component);      
  },   
  
      
  handleAgreeChange: function(component, event, helper) {
    const isChecked = event.target.checked;
    component.set("v.hasAgreed", isChecked);
  },
  handlePlaygroundNameChange: function(component, event, helper) {
    const playgroundName = event.getParam("value");
    const regex = new RegExp(/[a-zA-Z0-9_-]+/g);
    const matches = regex.exec(playgroundName);
    const validValue =
      playgroundName.length > 0 && matches.length > 0 && playgroundName === matches[0];

    component.set("v.invalidPlaygroundName", !validValue);

    try {
      const c = component.find("playgroundName").getElement();
    } catch (error) {
      console.error('Start.handlePlaygroundNameChange', error);
    }
  },
  handleAgreeClick: function(component, event, helper) {
    component.set("v.screen", 1);
  },
  handleContinueClick: function(component, event, helper) {
    const playgroundName = component.get("v.playgroundName");
    const playgroundConfiguration = component.get("v.playgroundConfiguration");
    component.set("v.verifyingPlaygroundName", true);

    const createPlaygroundAction = component.get("c.createPlayground");
    createPlaygroundAction.setParams({ playgroundName: playgroundName, playgroundConfiguration: playgroundConfiguration });
    createPlaygroundAction.setCallback(this, function(response) {
      switch (response.getState()) {
        case "SUCCESS":
          const playground = response.getReturnValue();

          // change url to be relative to community root path
          $A.get("e.force:navigateToURL")
            .setParams({ url:"/playground/"+playground.Id })
            .fire();

          break;
        case "ERROR":
          var errors = response.getError();
          let errMsg = "Unknown error during Playground creation.";
          if (errors && errors[0] && errors[0].message) errMsg = errors[0].message;
          console.error(errMsg);
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Error", "message":errMsg });
          toastEvent.fire();
          break;
      }
    });
    $A.enqueueAction(createPlaygroundAction);
  }
});