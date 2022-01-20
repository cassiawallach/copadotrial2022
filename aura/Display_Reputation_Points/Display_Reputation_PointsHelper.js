({
    getReputationPoint : function(component, event, helper,LearningPlanId){
        var action = component.get("c.getReputationPointByLearningPlanId");
        action.setParams({
            LearningPlanId : LearningPlanId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                console.log( response.getReturnValue());
                if(response.getReturnValue()!=''){
                    component.set("v.ReputationPoint",response.getReturnValue());
                    component.set('v.isShow', true);
                }
            }
            else{
                component.set('v.isShow', false);
                console.log('error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
    }
})