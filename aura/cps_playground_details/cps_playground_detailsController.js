({
  doInit: function(component, event, helper) {
    component.set("v.loadingRecord", true);
      helper.getPlaygroundDetails(component).then(
          $A.getCallback(r => {
              const showDetails = ["Activated", "Failed", "Expired"].indexOf(r.playground.Status__c) !== -1;
              let childOrgHeader = 'Sandboxes';
              component.set("v.showDetails", showDetails);
              component.set("v.playground", r.playground);
              component.set("v.git", r.git);
              component.set("v.production", r.environments.find(env => env.Type__c === "CoE_Org"));
              component.set("v.environments", r.environments.filter(env => env.Type__c !== "CoE_Org"));
              component.set("v.loadingRecord", false);
              if(r.playground.Playground_Configuration__c == 'Full Configuration - Scratch Orgs'){
                childOrgHeader = 'Scratch Orgs';
              }
              component.set("v.headings", ['Username', 'Status', 'Modified' ]);
              component.set("v.childOrgHeader", childOrgHeader);
          })
              );
  },
  navigateBack: function(component, event, helper) {
    // change url to be relative to community root path
    $A.get("e.force:navigateToURL")
      .setParams({
        url: "/"
      })
      .fire();
  },
  showDeleteDialog: function(component, event, helper) {
    component.set("v.displayDeletePlaygroundDialog", true);
  },
  hideDeleteDialog: function(component, event, helper) {
    component.set("v.displayDeletePlaygroundDialog", false);
  },
  deletePlayground: function(component, event, helper) {
    helper.deletePlayground(component);
  }
});