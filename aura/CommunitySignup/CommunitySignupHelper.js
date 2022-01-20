({
    getData : function(component, event, helper){
        component.set('v.loaded', true);
        var action = component.get("c.fetchInitData");
        action.setCallback(this, function(response){
            console.log(response.getState());
            var state = response.getState();
            if(state==='SUCCESS'){
                var apexResponse = response.getReturnValue();
                component.set("v.jobRoleData", apexResponse.jobRoleList);
                component.set("v.countryData", apexResponse.countryList);
                component.set("v.stateDataMap", apexResponse.stateMap);
            }else{
                console.log( response.getError());
            }
            component.set('v.loaded', false);
        });
        $A.enqueueAction(action);
    },
    createUser : function(component, event, helper,user){
        component.set("v.IsErrorMessage","");
        component.set("v.IsErrorMessageStep2","");
        component.set("v.progressIndicatorIsError", false);
        
        var action = component.get("c.createCommunityUser");
        action.setParams({ 
            jsonUser : JSON.stringify(user)
        });
        action.setCallback(this, function(response){
            console.log(response.getState());
            var state = response.getState();
            if(state==='SUCCESS'){
                var apexResponse = response.getReturnValue();
                //component.set('v.loaded', false);
                var signupURL = window.location.href;
                if(!apexResponse.status){
                    window.location.href=signupURL.split("/s/")[0]+'/s/'+component.get("v.SuccessPageUrl");
                }
                else{
                    if(apexResponse.message =='duplicate email'){
                        this.progressIndicatorShowErrorOnStep1(component, event, helper);
                        var errorMessage = $A.get("$Label.c.Error_CommunityUser_Register_with_duplicate_email");
                        this.showToast(component, event,'Error', 'error', errorMessage);
                    }
                }
            }
            else{
                component.set('v.loaded', false);
                var error = response.getError();
                console.log(response.getError());
                console.log(error[0].message);
                console.log(error[0].pageErrors[0].message);
                
                if(error[0].fieldErrors.Username[0].statusCode == 'DUPLICATE_USERNAME'){
                    this.progressIndicatorShowErrorOnStep1(component, event, helper);
                    var errorMessage = $A.get("$Label.c.Error_CommunityUser_Register_with_duplicate_email");
                    this.showToast(component, event,'Error', 'error', errorMessage);
                }
            }
        });       
        $A.enqueueAction(action);
    },
    progressIndicatorShowErrorOnStep1 : function(component, event, helper){
        var stepTwo = component.find("stepTwo");
        $A.util.addClass(stepTwo, 'slds-hide');
        var stepOne = component.find("stepOne");
        $A.util.removeClass(stepOne, 'slds-hide');
        component.set("v.progressIndicatorFlag", "step1");
        component.set("v.progressIndicatorIsError",true);
    },
    progressIndicatorShowErrorOnStep2 : function(component, event, helper){
        var stepOne = component.find("stepOne");
        $A.util.addClass(stepOne, 'slds-hide');
        var stepTwo = component.find("stepTwo");
        $A.util.removeClass(stepTwo, 'slds-hide');
        component.set("v.progressIndicatorFlag", "step2");
        component.set("v.progressIndicatorIsError",true);
    },
    showToast : function(component, event,title, toastType, toastMsg){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: toastMsg,
            type : toastType
        });
        toastEvent.fire();
    },
    validateEmailPersonal : function(component, event, helper) {
        var isValidationError = false;
        var mailformat = /^\w+([\.+-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
        var EmailValue = component.find("Email").get("v.value");
        if(EmailValue!=''){
            if(!EmailValue.match(mailformat)){
                isValidationError = true;
            }
        }
        
        if(isValidationError){
            component.set('v.personalEmailValidationError', 'Invalid Email Format');
            return true;
        }else{
            component.set('v.personalEmailValidationError', '');
            return false;
        }
    },validateEmailCorporate : function(component, event, helper) {
        var isValidationError = false;
        var errMsg = '';
        var mailformat = /^\w+([\.+-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
        var CorporateEmailValue = component.find("CorporateEmail").get("v.value").toLowerCase();
        if(CorporateEmailValue!=''){
            if(!CorporateEmailValue.match(mailformat)){
                isValidationError = true;
                errMsg = 'Invalid Email Format';
            }else{
                var emailDomains = ["gmail","yahoo","hotmail","live","outlook","msn","inbox","rediff","aol","icloud"];
                var isValidEmail = true;
                emailDomains.forEach(function(domain){
                    if(CorporateEmailValue.includes(domain)){
                        isValidationError = true;
                        errMsg = 'Please enter your valid corporate email address';
                    }
                });
            }
        }
        
        if(isValidationError){
            component.set('v.corporateEmailValidationError', errMsg);
            return true;
        }else{
            component.set('v.corporateEmailValidationError', '');
            return false;
        }
    },
    checkCity: function(component, event, helper){
        var isValidationError = false;
        var cityFormat = /^[a-zA-Z ]+$/;
        var cityVal = component.find("City").get("v.value");
        if(cityVal!=''){
            if(!cityVal.match(cityFormat)){
                isValidationError = true;
            }
        }
        
        if(isValidationError){
            component.set('v.cityValidationError', 'Only Alphabets are allowed');
            return true;
        }else{
            component.set('v.cityValidationError', '');
            return false;
        }
    },
})