
var j$ = jQuery.noConflict();
var nameSpaceVersion = core.Namespace();
    var httpPath = core.ServiceUrl();

j$(document).ready(function () {
    
    SetupClickEvents();
     
});

function SetupClickEvents()
{    
    j$("body").undelegate(".ebsta-termsCheckBox", "change");
        j$("body").delegate(".ebsta-termsCheckBox", "change", function () {
        	if(j$(this).is(":checked"))
        	{
        		j$('.ebsta-connect-button').removeClass('ebsta-disabledButton');
        		j$('.ebsta-connect-button').attr('title', '');
        		
        		//add the connect click event.
        		j$("body").undelegate(".ebsta-connect-button", "click");
        		j$("body").delegate(".ebsta-connect-button", "click", function () {
        		
        			ShowOauthSalesforceModel();
        		});
        	}else{
        		j$('.ebsta-connect-button').addClass('ebsta-disabledButton');
        		j$('.ebsta-connect-button').attr('title', 'You must agree to the Ebsta Terms and Conditions');
        		
        		//remove the connect click event.
        		j$("body").undelegate(".ebsta-connect-button", "click");
        	}
        });
}

function ShowOauthSalesforceModel()
{
	var popUpObj = window.open(httpPath + "/OAuthSalesforceIdentityLogin?nv=" + nameSpaceVersion + "&sb=" + sandBoxStatus,
        "EbstaModalPopUp",
    "toolbar=no," +
    "scrollbars=yes," +
    "location=no," +
    "statusbar=no," +
    "menubar=no," +
    "resizable=1," +
    "width=650," +
    "height=405," +
    "left = 490," +
    "top=300"
    );

    var timer = setInterval(checkChild, 500);

    function checkChild() {
        if (popUpObj.closed) {

            ProcessAdminPostConnect();   
            clearInterval(timer);
        }
    }
}

function ProcessAdminPostConnect()
{
	j$(".ebstaConnect").hide();
	
	j$(".ebstaPostAdminConnect").show();
	
	//log the post install event.
	LogEvent('PostInstallConnected', 'PostInstallConnected', 427);
	
	SetupTeamViews();
}

function ReauthProcess()
{
	j$(".ebstaConnect").hide();
	j$(".ebstaPostAdminConnect").hide();
	j$(".ebstaPostAdminError").show();
}

function ShowFailure()
{
	j$(".ebstaConnect").hide();
	j$(".ebstaPostAdminConnect").hide();
	j$(".ebstaPostAdminError").show();
}

function AdminTeamSetupSuccess(dataObject)
{
	var data = JSON.parse(dataObject); 
	
	if(data.success)
	{		
		window.top.location.href = "/apex/Ebsta_Reporting_Console"; 
	}else{
		ShowFailure();
	}
}

