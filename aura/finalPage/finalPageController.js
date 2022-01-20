({
	gotoPlayground: function(component, event, helper) {
        var uri = "/playground/Playground__c/Default";
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url":uri, "isredirect":false });
        urlEvent.fire();
    }
})