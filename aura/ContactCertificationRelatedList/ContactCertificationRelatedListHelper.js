({
    getAcademyCertificationStudent : function(component, event, helper) {
        var action = component.get("c.getContactRelatedCertification");
        action.setParams({
            "contactId": component.get("v.recordId")
        });
        console.log(component.get("v.recordId"));
        action.setCallback(this, function(a) {    
            component.set("v.AcademyCertification", a.getReturnValue());
        });
        $A.enqueueAction(action);
    }	

 })