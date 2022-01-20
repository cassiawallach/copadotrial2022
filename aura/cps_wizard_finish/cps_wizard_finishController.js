({
  activatePlayground: function(component, event, helper) {
    const playground = component.get("v.playground");
    const activatePlaygroundAction = component.get("c.ActivatePlayground");

    activatePlaygroundAction.setParams({
      playgroundId: playground.Id
    });

    activatePlaygroundAction.setCallback(this, response => {
      if (response.getState() === "SUCCESS") {
        location.reload();
      } else {
        console.error(response);
      }
    });

    $A.enqueueAction(activatePlaygroundAction);
  }
});