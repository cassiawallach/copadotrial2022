({
	GetAllRelease : function(component, event, helper){
        var action = component.get("c.getAllReleaseRecords");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var APEX_Response = response.getReturnValue();
                var counter = 0;
                APEX_Response.forEach(function(record){
                    if(!record.hasOwnProperty("Documentation_Release_Notes__c")){
                        record.isDisabled = true;
                        record.Documentation_Release_Notes__c = 'comming soon';
                        record.Release_Note_text = 'Release Notes will be available soon';
                    }else{
                        record.isDisabled = false;
                        record.Release_Note_text =  'Release Notes';
                    }
                    if(counter==0 && record.copado__Status__c=='Released'){
                        component.set("v.LatestReleaseRecord",record);
                        ++counter;
                    }
                });
                component.set("v.TableData",APEX_Response);
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
    },
})