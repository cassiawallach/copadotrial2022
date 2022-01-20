({
    doInit : function( component, event, helper ){
        var currentUrl = window.location.href;
        if(currentUrl.includes('ltui__urlRecordId=')){
            currentUrl = currentUrl.split('&')[0];
            currentUrl = currentUrl.split('ltui__urlRecordId=')[1];
            helper.checkResetBtnIsRequire(component, event, helper,currentUrl);
        }
        console.log('finish::'+currentUrl);
    },
    
    doClick : function(component, event, helper) {
        var msg = component.get("v.ConfirmMessage");
        if(confirm(msg)){
			var currentUrl = window.location.href;
			if(currentUrl.includes('ltui__urlRecordId=')){
				var trainingPlanId = currentUrl.split('&')[0];
				trainingPlanId = trainingPlanId.split('ltui__urlRecordId=')[1];
				component.set('v.loaded', true);
				helper.CertificationReset(component, event, helper, trainingPlanId);
			}                       
        }
    }
})