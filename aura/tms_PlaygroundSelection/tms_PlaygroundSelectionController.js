({
    doInit : function(component, event, helper) {
        helper.getPlaygrounds(component, helper);
    },
    changePlayground: function(component, event, helper){
        let selectedPlaygroundId = component.get("v.selectedPlaygroundValue");
        helper.getPlaygroundEnv(component, selectedPlaygroundId);
    },
    openEnvironment: function(component, event, helper){
        var orgId = event.currentTarget.getAttribute("data-peid");
        helper.getFrontDoorUrl(component, orgId);
    },
    startProcess : function(component, event, helper){
        let selectedPlaygroundId = component.get("v.selectedPlaygroundValue");
        let lstPlaygrounds = component.get("v.lstPlaygrounds");
        let playground = lstPlaygrounds.filter(pg => pg.Id == selectedPlaygroundId);

        if(playground.length > 0) {
            let parentComp = component.get("v.parent");
            parentComp.setSelectedPlayground(playground[0]);
        }
    }
})