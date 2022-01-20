({
	GetPlaygrounds : function(component, event, helper){
        var action = component.get("c.GetPlaygroundByContactId");
        action.setParams({
            recordId :  component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                //console.clear();
                var APEX_Response = response.getReturnValue();

                if (APEX_Response.length > 0) {
                    APEX_Response.forEach(function(item){
                        item.playgroundURL = '/'+item.Id;
                    });
                    component.set("v.TableData",APEX_Response);
                }
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
    },   
})