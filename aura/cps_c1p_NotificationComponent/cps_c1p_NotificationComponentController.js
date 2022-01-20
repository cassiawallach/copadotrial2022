({
    onCometdLoaded: function(component, event, helper) {
        const cometd = new org.cometd.CometD();
        component.set('v.cometd', cometd);
        
        helper.connectCometd(component);
    },
    onInit: function(component, event, helper) {
        component.set('v.cometdSubscriptions', []);
        component.set('v.notifications', []);
        
        // Disconnect CometD when leaving page
        window.addEventListener('unload', function(event) {
            helper.disconnectCometd(component);
        });
        
        // Retrieve sessionId
        const getSessionIdAction = component.get("c.getSessionId");
        getSessionIdAction.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === 'SUCCESS') {
                const sessionId = response.getReturnValue();
                component.set('v.sessionId', sessionId);
            	helper.connectCometd(component);
            } else{
                console.error(response);
            }
        });
        $A.enqueueAction(getSessionIdAction);
    }
})