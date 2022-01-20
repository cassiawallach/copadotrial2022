({
    doInit : function(component, event, helper) {
        var stepTwo = component.find("stepTwo");
        $A.util.addClass(stepTwo, 'slds-hide');
        component.set("v.progressIndicatorFlag", "step1");
        component.set("v.progressIndicatorIsError",false);
        helper.getData(component, event, helper)
    },
    goToStep1 : function(component, event, helper) {
        var stepTwo = component.find("stepTwo");
        $A.util.addClass(stepTwo, 'slds-hide');
        var stepOne = component.find("stepOne");
        $A.util.removeClass(stepOne, 'slds-hide');
        component.set("v.progressIndicatorFlag", "step1");
    },
    goToStep2 : function(component, event, helper) {
        component.set("v.IsErrorMessage","");
        component.find("stepOneError").getElement().focus();
        
        if(component.find("CustomerType").get("v.value") == '' || component.find("FirstName").get("v.value") == '' || component.find("LastName").get("v.value") == '' || component.find("Email").get("v.value") == '' || component.find("Job_Role").get("v.value") == '' || component.find("Country").get("v.value") == '' || component.find("State").get("v.value") == '' || (component.find("Job_Role").get("v.value") == 'Other' && component.find("Job_Role_Other").get("v.value") == '') ){
            helper.progressIndicatorShowErrorOnStep1(component, event, helper);
            document.getElementsByClassName('input-field-container')[0].className = " salesforceIdentitySelfRegister2 input-field-container";
            component.set("v.IsErrorMessage", "Please fill all the required fields.");
            return;
        }
        
        if(helper.validateEmailPersonal(component, event, helper)){
            helper.progressIndicatorShowErrorOnStep1(component, event, helper);
            document.getElementsByClassName('input-field-container')[0].className = " salesforceIdentitySelfRegister2 input-field-container";
            component.set("v.IsErrorMessage", "Please enter your valid personal email address.");
            return;
        }
        
        if(helper.checkCity(component, event, helper)){
            helper.progressIndicatorShowErrorOnStep1(component, event, helper);
            document.getElementsByClassName('input-field-container')[0].className = " salesforceIdentitySelfRegister2 input-field-container";
            component.set("v.IsErrorMessage", "Only Alphabets are allowed in city name");
            return;
        }
        
        var stepOne = component.find("stepOne");
        $A.util.addClass(stepOne, 'slds-hide');
        var stepTwo = component.find("stepTwo");
        $A.util.removeClass(stepTwo, 'slds-hide');
        component.set("v.progressIndicatorFlag", "step2");
        component.set("v.progressIndicatorIsError", false);
        component.set("v.IsErrorMessageStep2","");
    },
    doSignup : function(component, event, helper){
        component.set("v.IsErrorMessageStep2","");
        
        if(component.find("CustomerType").get("v.value") != 'Individual'){
            if(component.find("companyName").get("v.value") == '' || component.find("CorporateEmail").get("v.value") == '' ){
                helper.progressIndicatorShowErrorOnStep2(component, event, helper);
                document.getElementsByClassName('input-field-container')[0].className = " salesforceIdentitySelfRegister2 input-field-container";
                component.set("v.IsErrorMessageStep2", "Please fill all the required corporate fields.");
                component.set('v.loaded', false);
                return;
            }
        }
        
        if(helper.validateEmailCorporate(component, event, helper)){
            helper.progressIndicatorShowErrorOnStep2(component, event, helper);
            document.getElementsByClassName('input-field-container')[0].className = " salesforceIdentitySelfRegister2 input-field-container";
            component.set("v.IsErrorMessageStep2", "Please enter your valid corporate email adderess.");
            component.set('v.loaded', false);
            return;
        }
        
        var user ={customerType:'', firstName:'', lastName:'', email:'', jobRole:'', country:'', state:'', city:'', zipcode:'', companyName:'', corporateEmail:'', title:'', iAmExistingCustomer:false, iAmExistingPartner:false};
        component.set('v.loaded', true);
        user.customerType = component.find("CustomerType").get("v.value");
        user.firstName = component.find("FirstName").get("v.value");
        user.lastName = component.find("LastName").get("v.value");
        user.email = component.find("Email").get("v.value");
        user.jobRole = component.find("Job_Role").get("v.value");
        user.country = component.find("Country").get("v.value");
        user.state = component.find("State").get("v.value");
        user.city = component.find("City").get("v.value");
        user.zipcode = component.find("ZipCode").get("v.value");
        user.companyName = component.find("companyName").get("v.value");
        user.corporateEmail = component.find("CorporateEmail").get("v.value");
        user.title = component.find("Title").get("v.value");
        if(component.find("Job_Role").get("v.value") == 'Other'){
            user.jobRole = component.find("Job_Role_Other").get("v.value")
        }
        if(component.find("CustomerType").get("v.value") == 'Customer'){
            user.iAmExistingCustomer = true;
        }
        if(component.find("CustomerType").get("v.value") == 'Partner'){
            user.iAmExistingPartner = true;
        }
        
        helper.createUser(component, event, helper,user);
    },
    validateEmailPersonal : function(component, event, helper) {
        helper.validateEmailPersonal(component, event, helper)
    },validateEmailCorporate : function(component, event, helper) {
        helper.validateEmailCorporate(component, event, helper)
    },
    checkCity: function(component, event, helper){
        helper.checkCity(component, event, helper)
    },
    getStates: function(component, event, helper){
        component.set("v.stateData", null);
        component.find("State").set("v.value", '');
        var country = component.find("Country").get("v.value")
        var stateMap = component.get("v.stateDataMap");
        for (var singlekey in stateMap) {
            if(singlekey == country){
                component.set("v.stateData", stateMap[singlekey]);
            }
        }
    },
})