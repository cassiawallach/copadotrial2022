({
	doInit : function(component, event, helper){
        component.set('v.loaded', true);
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Campaign",
            "defaultFieldValues": {
                'ParentId' : component.get('v.recordId')
            }
        });
        createAcountContactEvent.fire();
    }
})