({
    connectCometd: function(component) {
        const helper = this;
        const cometd = component.get("v.cometd");
        const sessionId = component.get("v.sessionId");
        const ns = component.get("v.ns");
        const cometdUrl = window.location.protocol + "//" + window.location.hostname + "/cometd/43.0/";
        
        if (sessionId == null || cometd == null) return;
        
        // Configure CometD
        cometd.configure({
            url: cometdUrl,
            requestHeaders: {
                Authorization: "OAuth " + sessionId
            },
            appendMessageTypeToURL: false
        });
        
        cometd.websocketEnabled = false;
        cometd.handshake(    
            $A.getCallback(function(handshakeReply) {
                if (handshakeReply.successful) {
                    // Subscribe to playground job event                    
                    const newSubscription = cometd.subscribe( "/event/Playground_Job_Event__e",
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
                }
                else console.error("CometD: Fail to connect");
            })
        );
    },
    disconnectCometd: function(component) {
        var cometd = component.get("v.cometd");
        // Unsuscribe all CometD subscriptions
        cometd.batch(function() {
            var subscriptions = component.get("v.cometdSubscriptions");
            subscriptions.forEach(function(subscription) {
                cometd.unsubscribe(subscription);
            });
        });
        
        component.set("v.cometdSubscriptions", []);
        cometd.disconnect();
    },
    onReceiveNotification: function (helper, message) {
        console.info("Mesage received: ", message.data.payload);
        var appEvent = $A.get("e.c:cps_c1p_notifier");
        appEvent.setParams({
            "action" : message.data.payload.Action__c,
            "hasError" : (message.data.payload.isSuccess__c==false && message.data.payload.isFinished__c==true),
            "data" : message.data.payload,
            "raw" : message
        });
        appEvent.fire();
    }
})