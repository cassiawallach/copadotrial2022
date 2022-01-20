({
  enqueueAction: function(component, actionName, params, onSuccess, onError) {
    const action = component.get(actionName);
    if (params) {
      action.setParams(params);
    }
    if (actionName === "c.CreateEnvironment") action.setBackground();
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
  nextStep: function() {
    const stepChangeEvent = $A.get("e.c:cps_wizard_stepChange");
    stepChangeEvent.setParams({ step: 2 });
    stepChangeEvent.fire();
  },
  savePlaygroundName: function(playgroundName, component) {
    const savePlaygroundNameAction = component.get("c.SavePlaygroundName");

    savePlaygroundNameAction.setParams({
      name: playgroundName
    });

    savePlaygroundNameAction.setCallback(this, function(response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        // Do something
      } else if (state === "INCOMPLETE") {
      } else if (state === "ERROR") {
      }
    });

    $A.enqueueAction(savePlaygroundNameAction);
  },
    
  playgroundConfig: function(component) {

  	var action = component.get("c.fetchPlaygroundSetting");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                var newItems=[];
                if(resultData.Full_Configuration_Scratch_Org_Enabled__c == true) {
                    newItems.push('Full Configuration - Scratch Orgs');
                }
                if(resultData.Light_Configuration_Enabled__c == true) {
                    newItems.push('Light Configuration');
                }
                if(resultData.Full_Configuration_Enabled__c == true) {
                    newItems.push('Full Configuration');
                }
                component.set("v.configOptions", newItems);
            }
        });
        $A.enqueueAction(action);
  },
});