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
  getMyPlaygrounds: function(component) {
    const helper = this;
    helper.enqueueAction(component, "c.GetMyPlaygrounds", null, playgrounds => {
      if (playgrounds.length === 0) {
        return;
      }

      let activePlaygrounds = 0;
      let inprogressPlaygrounds = 0;
      let failedPlaygrounds = 0;
      let expiredPlaygrounds = 0;

      playgrounds.forEach(p => {
        switch (p.Status__c) {
          case "Activated": {
            activePlaygrounds++;
            break;
          }
          case "In Progress": {
            inprogressPlaygrounds++;
            break;
          }
          case "Failed": {
            failedPlaygrounds++;
            break;
          }
          case "Expired": {
            expiredPlaygrounds++;
            break;
          }
          default: {
            break;
          }
        }
      });

      component.set("v.playgrounds", playgrounds);
      component.set("v.createdPlaygrounds", playgrounds.length);
      component.set("v.activePlaygrounds", activePlaygrounds);
      component.set("v.inprogressPlaygrounds", inprogressPlaygrounds);
      component.set("v.failedPlaygrounds", failedPlaygrounds);
      component.set("v.expiredPlaygrounds", expiredPlaygrounds);

      // Filter the playgrounds
      if (activePlaygrounds > 0) {
        helper.getFilteredPlaygrounds(component, "Activated");
      } else if (inprogressPlaygrounds > 0) {
        helper.getFilteredPlaygrounds(component, "In Progress");
      } else if (failedPlaygrounds > 0) {
        helper.getFilteredPlaygrounds(component, "Failed");
      } else if (expiredPlaygrounds > 0) {
        helper.getFilteredPlaygrounds(component, "Expired");
      }
    });
  },
  getFilteredPlaygrounds: function(component, filter) {
    // Display dashbords in current selected status only
    const playgroundList = component.get("v.playgrounds");

    component.set(
      "v.listedPlaygrounds",
      playgroundList.filter(playground => playground.Status__c === filter)
    );
  },

  getPlaygroundUnderMaintenance: function(component) {

    return new Promise(resolve => {
      this.enqueueAction(
        component,
        "c.getPlaygroundUnderMaintenance",
        { },
        resolve
      );
    });
  }
});