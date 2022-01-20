({
	doInit : function(component, event, helper) {
		helper.checkUserCertification(component, event, helper);
	},
    doClick : function(component, event, helper) {
        var contentDocumentId=component.get("v.contentDocumentId");
        var contentDocumentURL = window.location.href;
        contentDocumentURL = contentDocumentURL.split('/s/')[0];
        contentDocumentURL += '/sfc/servlet.shepherd/document/download/'+contentDocumentId;
        contentDocumentURL += '?operationContext=S1';
        component.set("v.staticResourceUrl",contentDocumentURL);
        //component.set("v.staticResourceUrl",$A.get('$Resource.NoImageAvailable'));
        //alert($A.get('$Resource.DownloadCertifiedImage'));
	},
})