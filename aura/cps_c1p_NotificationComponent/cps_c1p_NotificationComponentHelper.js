({
  connectCometd: function(component) {
    const helper = this;
    const cometd = component.get("v.cometd");
    const sessionId = component.get("v.sessionId");
    const cometdUrl = window.location.protocol + "//" + window.location.hostname + "/cometd/43.0/";

    if (sessionId == null || cometd == null) {
      return;
    }

    // Configure CometD
    cometd.configure({
      url: cometdUrl,
      requestHeaders: {
        Authorization: "OAuth " + sessionId
      },
      appendMessageTypeToURL: false
    });
    cometd.websocketEnabled = false;

    // Establish CometD connection
    cometd.handshake(
      $A.getCallback(function(handshakeReply) {
        if (handshakeReply.successful) {

          // Subscribe to platform event
          const newSubscription = cometd.subscribe("/event/Playground_Job_Event__e",
            $A.getCallback(function(response) {
              const platformEvent = JSON.parse(JSON.stringify(response));
              helper.onReceiveNotification(helper, platformEvent);
            })
          );

          // Save subscription for later
          const subscriptions = component.get("v.cometdSubscriptions");
          if (subscriptions) {
            subscriptions.push(newSubscription);
            component.set("v.cometdSubscriptions", subscriptions);
          }
        } else console.error("CometD: Fail to connect");
      })
    );
  },
  disconnectCometd: function(component) {
    var cometd = component.get("v.cometd");

    cometd.batch(function() {
      var subscriptions = component.get("v.cometdSubscriptions");
      subscriptions.forEach(function(subscription) {
        cometd.unsubscribe(subscription);
      });
    });
    component.set("v.cometdSubscriptions", []);
    cometd.disconnect();
  },
  parseDescription: function(description) {
    const decodedDescription = decodeURIComponent(description);
    const isNumber = n => !isNaN(parseFloat(n)) && isFinite(n);

    if (decodedDescription === "" || isNumber(decodedDescription)) {
      throw new Error("Value received is not a json object");
    }

    return JSON.parse(decodedDescription);
  },
  onReceiveNotification: function(helper, rawPlatformEvent) {
      const hasError = (rawPlatformEvent.data.payload.isSuccess__c==false && rawPlatformEvent.data.payload.isFinished__c==true);
      
      console.info("Posting (cps_c1p_NotificationComponentHelper.js): ", rawPlatformEvent.data.payload);
      
        var appEvent = $A.get("e.c:cps_c1p_notifier");
        appEvent.setParams({
            "action" : rawPlatformEvent.data.payload.Action__c,
            "hasError" : hasError,
            "data" : rawPlatformEvent.data.payload,
            "raw" : rawPlatformEvent
        });
        appEvent.fire();
  }
});