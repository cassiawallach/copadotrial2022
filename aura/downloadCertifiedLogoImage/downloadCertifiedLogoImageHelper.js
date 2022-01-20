({
    checkUserCertification : function(component, event, helper){
        var currentUrl = window.location.href;
        console.clear();
        currentUrl = currentUrl.split('/s/')[0];
        currentUrl += '/sfc/servlet.shepherd/document/download/';
		var action = component.get("c.checkUserIsCertified");
        action.setCallback(this, function(response){            
            var state = response.getState();
            if(state==='SUCCESS'){
                console.log( response.getReturnValue());
                var apexResponse = response.getReturnValue();
                if(!apexResponse.IsError){
                    component.set("v.isShow",!apexResponse.IsError);
                    var result = apexResponse.result;
                    var Certifications = [];
                    result.forEach(function(record){
                        var data={};
                        if(record.split("___")[1]!='No Preview'){
                            data.isDownloadIcon = true;
                            data.ContentDocumentDownloadUrl = currentUrl+record.split("___")[1]+'?operationContext=S1';
                        }
                        else{
                            data.ContentDocumentDownloadUrl = $A.get('$Resource.NoImageAvailable');
                        }        
                        data.CertificationName = record.split("___")[0];
                        Certifications.push(data);
                    });
                    component.set("v.Certifications",Certifications);
                }
                else{
                    component.set("v.isShow",!apexResponse.IsError);
                }
            }
            else{
                console.log('error::'+JSON.stringify(response.getError()));
            }         
        });       
        $A.enqueueAction(action);
        
	}
})