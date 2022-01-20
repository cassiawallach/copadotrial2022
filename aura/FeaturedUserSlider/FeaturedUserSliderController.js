({
	doInit : function(component, event, helper) {
        if(component.get("v.featuredUserId") != ''){
            helper.GetFeaturedUser(component, event, helper);
        }
        else{
            console.log('Feature user Id is missing.');
        }
	}
})