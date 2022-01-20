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
  formatDate: function(envDate) {
    const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return (
      days[envDate.getDay()] +
      ", " +
      months[envDate.getMonth()] +
      " " +
      envDate.getDate() +
      ", " +
      envDate.getFullYear()
    );
  },
  getPlaygroundDetails: function(component) {
    const helper = this;
    const playgroundId = component.get("v.recordId");

    return new Promise(resolve => {
      this.enqueueAction(component, "c.getPlaygroundDetails", { playgroundId }, res => {
        res.environments = res.environments.map(env => {
          const isCoe = env.Type__c === "CoE_Org";
          const Name = res.playground.Org_Credential__c
            ? res.playground.Org_Credential__r.copado__Username__c +
              (isCoe ? "" : "." + env.Name.toLowerCase())
            : env.Name;

          return Object.assign({}, env, {
            Name,
            LastModifiedDate: helper.formatDate(new Date(env.LastModifiedDate))
          });
        });

    	if(res.playground.Status__c=='Failed' && res.playground.Error_Message__c!=null) {
    		this.displayErrorMessage(res.playground.Error_Message__c);
		  }
        resolve(res);
      });
    });
  },
      displayErrorMessage: function(errorMessage) {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({ "mode":"sticky", "type":"error", "title":"Error", "message":errorMessage });
          toastEvent.fire();
      },
  deletePlayground: function(component) {
    const playground = component.get("v.playground");

    this.enqueueAction(component, "c.DeletePlayground", { playgroundId: playground.Id }, () => {
      component.set("v.displayDeletePlaygroundDialog", false);
      // change url to be relative to community root path
      $A.get("e.force:navigateToURL")
        .setParams({
          url: "/"
        })
        .fire();
    });
  }
});