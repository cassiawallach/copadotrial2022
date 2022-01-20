({
  doInit: function(component, event, helper) {
    const playground = component.get("v.playground");
    if (playground) {
      component.set("v.currentStage", playground.Stage__c);
    } else {
      component.set("v.currentStage", "Start");
    }
  },
  handleStepChange: function(component, event, helper) {
    const stage = event.getParam("step");
    const validStages = ["", "Start", "CreateTrialOrg", "Connect", "PostInstallScript", "Setup", "Review", "Completed"];
    const nextStage = validStages[stage];

    component.set("v.currentStage", nextStage);

    const playground = component.get("v.playground");
    if (playground) {
      const updateStageAction = component.get("c.updatePlaygroundStage");

      updateStageAction.setParams({
        playgroundId: playground.Id,
        stage: nextStage
      });

      updateStageAction.setCallback(this, function(response) {
        switch (response.getState()) {
          case "SUCCESS":
            const playgroundUpdated = response.getReturnValue();
            component.set("v.playground", playgroundUpdated);
            break;
        }
      });

      $A.enqueueAction(updateStageAction);

      // Update playground
      helper.getPlaygroundDetails(component).then(
        $A.getCallback(response => {
          component.set("v.playground", response.playground);
        })
      );
    }
  }
});