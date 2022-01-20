({
	checkResetBtnIsRequire : function(component, event, helper,LearningAssignmentId){
		var action = component.get("c.checkResetIsRequire");
        action.setParams({
            LearningAssignmentId : LearningAssignmentId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                console.log( response.getReturnValue());
                if(response.getReturnValue()){
                    component.set("v.isResetBtn",true);
                }
                component.set('v.loaded', false);
                
            }
            else{
                component.set('v.loaded', false);
                console.log('Apex error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
        
	},
    CertificationReset : function(component, event, helper, trainingPlanId){
		var action = component.get("c.UserCertificationRest");
		action.setParams({
			trainingPlanId : trainingPlanId
		});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.isResetBtn",false);
                var currentURL = window.location.href;
                window.location.href=currentURL.split('/s/')[0]+'/s/my-learning';
                component.set('v.loaded', false);
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
                component.set('v.loaded', false);
            }
        });       
        $A.enqueueAction(action);
	},
})