({
	goToCreationPage: function(component, event, helper) {
        // change url to be relative to community root path
        $A.get("e.force:navigateToURL").setParams({ 
            "url": "/new-playground" 
        }).fire();
	}
})