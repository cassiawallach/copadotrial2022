({
    init : function(component, event, helper) {
        var action = component.get('c.getUserRecords'); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set('v.userCount', response.getReturnValue());
                component.set('v.isLoaded', true);
            }else{
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})