({
  goToPlayground: function(component, event, helper) {
    const playgroundId = component.get("v.playgroundId");

    // change url to be relative to community root path
    $A.get("e.force:navigateToURL")
      .setParams({
        url: `/playground/${playgroundId}`
      })
      .fire();
  }
});