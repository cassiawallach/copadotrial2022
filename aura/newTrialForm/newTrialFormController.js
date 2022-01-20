({
    doInit : function(component, event, helper) {        
        helper.getUserInfo(component);
    },

    submitSignupRequest : function(component, event, helper) {
        
        var allValid = component.find("signupRequestForm").reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        
        if (!allValid) return;
                
        console.info("Checking username format validity...");
        var username = component.get("v.username");
        var patt = "^[a-zA-Z0-9.!#$%&’*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
        var result = username.match(patt);
        var usernameValid = (username==result);
        console.info("Username ("+username+") validity is: "+ usernameValid);
        
        if(!usernameValid) {
            let errorMessage = "Please make sure your username is a Salesforce valid username (email format and may contain a suffix).";
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({ "mode":"sticky", "type":"warning", "title":"", "message":errorMessage });
            toastEvent.fire();
            return;
        }
                                               
        //var domain = component.get("v.domain"); not implemented for now due to validation issues.
        var country = component.get("v.user.Country");
        
        let button = component.find("nextBtn");
        button.set("v.disabled", true);

        helper.createSignupRequest(component, username, null, "US");
    }
});