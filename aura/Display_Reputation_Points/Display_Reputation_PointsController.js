({
	doInit : function(component, event, helper){
        var currentUrl = window.location.href;
        if(currentUrl.includes('ltui__urlRecordId=')){
            currentUrl = currentUrl.split('&')[0];
            currentUrl = currentUrl.split('ltui__urlRecordId=')[1];
            helper.getReputationPoint(component, event, helper,currentUrl);
        }
		
        
	}
})