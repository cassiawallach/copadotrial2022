({
  doInit: function(component, event, helper) {
    helper.getPlaygroundUnderMaintenance(component).then(
      $A.getCallback(response => {
        component.set("v.arePlaygroundsUnderMaintenance", response.Are_Playgrounds_Under_Maintenance__c);
        component.set("v.isPlaygroundWizardUnderMaintenance", response.Is_Playground_Wizard_under_maintenance__c);
        if (response.Are_Playgrounds_Under_Maintenance__c === true) {
          return;
        }
      })
    );

    helper.enqueueAction(component, "c.GetAllowedPlaygrounds", null, allowedPlaygrounds => {
      component.set("v.allowedPlaygrounds", allowedPlaygrounds);
    });

    helper.getMyPlaygrounds(component);
  },
  goToCreationPage: function(component, event, helper) {
    // change url to be relative to community root path
    $A.get("e.force:navigateToURL")
      .setParams({
        url: "/new-playground"
      })
      .fire();
  },
  showDeleteDialog: function(component, event, helper) {
    const playgrounds = component.get("v.playgrounds");
    const playgroundToDelete = playgrounds.find(
      p => p.Id === event.currentTarget.dataset.playgroundid
    );

    component.set("v.playgroundIdToDelete", playgroundToDelete.Id);
    component.set("v.playgroundNameToDelete", playgroundToDelete.Name);
    component.set("v.displayDeletePlaygroundDialog", true);
  },
  hideDeleteDialog: function(component, event, helper) {
    component.set("v.displayDeletePlaygroundDialog", false);
  },
  deletePlayground: function(component, event, helper) {
    const playgroundId = component.get("v.playgroundIdToDelete");
    helper.enqueueAction(component, "c.DeletePlayground", { playgroundId }, () => {
      component.set("v.displayDeletePlaygroundDialog", false);
      helper.getMyPlaygrounds(component);
    });
  },
  filterList: function(component, event, helper) {
    const currentFilter = event.currentTarget.dataset.filter;
    helper.getFilteredPlaygrounds(component, currentFilter);
  }
});