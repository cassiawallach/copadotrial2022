var j$ = jQuery.noConflict();
var currentPopupId = '';
var nameSpaceVersion = core.Namespace();
var httpPath = core.ServiceUrl();

j$(document).ready(function () {    
    SetupClickEvents(); 
});

function ConvertMainLicenceObject()
{
    	if(licenceStatusObjectFull != null && typeof licenceStatusObjectFull != "undefined" && licenceStatusObjectFull != "REAUTH")
		{    
   			return JSON.parse(licenceStatusObjectFull);
		}
}

function RenderGetPreviewHeightSuccess(result)
{
	j$("#PreviewWindowHeight").val(result);
}

function RenderGetAdditionalSettingsSuccess(result)
{	
	if(typeof result != "undefined" && result != null)
	{
		var settingsObject = JSON.parse(result);
	
		j$("#PreviewWindowHeight").val(settingsObject.EmailPreviewHeight);
		j$("#HideDefaultFilters").prop("checked", settingsObject.HideDefaultFilters);		
	}
}

function ShowOauthSalesforceModel()
{
	var popUpObj = window.open(httpPath + "/OAuthSalesforceIdentityLogin?nv=" + nameSpaceVersion + "&sb=" + sandBoxStatus,
        "EbstaModalPopUp",
    "toolbar=no," +
    "scrollbars=no," +
    "location=no," +
    "statusbar=no," +
    "menubar=no," +
    "resizable=0," +
    "width=650," +
    "height=405," +
    "left = 490," +
    "top=300"
    );

    var timer = setInterval(checkChild, 500);

    function checkChild() {
        if (popUpObj.closed) {    
        
            ProcessAdminTabPostConnect();   

            clearInterval(timer);
        }
    }
}

function ProcessAdminTabPostConnect()
{
	j$(".ebsta-admin-connect").hide();	
	j$(".ebsta-authorized-display").show();	
	
	//log the post install event.
	LogEvent('AdminTabConnected', 'AdminTabConnected', 469);
	
	GetLicenceSettings();
	
	GoPageStart();
}

function SetupClickEvents()
{
	//connection screen.
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

	//tab navigation.
	j$("body").undelegate(".navLink", "click");
    j$("body").delegate(".navLink", "click", function () {

 			var addBackgroundColorToLink = true;
        	var tabName = j$(this).attr("navName");         
			 
				if(tabName === "ebsta-admin-reporting-area")
				{           
					j$(".ebsta-admin-control-area").hide();    
					j$(".ebsta-admin-ActiveUsers-area").hide();
					j$(".ebsta-admin-ReportingSettings-area").hide();   
					j$(".ebsta-admin-MiscSettings-area").hide();             
					j$(".ebsta-admin-reporting-area").show(); 
				}else if (tabName === "ebsta-admin-control-area"){
					j$(".ebsta-admin-reporting-area").hide();
					j$(".ebsta-admin-ActiveUsers-area").hide();
					j$(".ebsta-admin-ReportingSettings-area").hide();  
					j$(".ebsta-admin-MiscSettings-area").hide();    
					j$(".ebsta-admin-control-area").show();                
				}
				else if (tabName === "ebsta-admin-ActiveUsers-area"){
					j$(".ebsta-admin-control-area").hide();    
					j$(".ebsta-admin-reporting-area").hide();
					j$(".ebsta-admin-ReportingSettings-area").hide();  
					j$(".ebsta-admin-MiscSettings-area").hide();            
					j$(".ebsta-admin-ActiveUsers-area").show();
				}
				else if (tabName === "ebsta-admin-MiscSettings-area"){
					j$(".ebsta-admin-control-area").hide();    
					j$(".ebsta-admin-reporting-area").hide();
					j$(".ebsta-admin-ReportingSettings-area").hide();  
					j$(".ebsta-admin-MiscSettings-area").show();            
					j$(".ebsta-admin-ActiveUsers-area").hide();
				}
				else if (tabName === "ebsta-admin-ReportingAnalysis-area"){
					ShowPopUp('https://secure1.ebsta-webservices.com/Reporting/', 'EbstaReportingAndAnalysis');
					addBackgroundColorToLink = false;
				}
				else{
					j$(".ebsta-admin-control-area").hide();    
					j$(".ebsta-admin-reporting-area").hide();
					j$(".ebsta-admin-ActiveUsers-area").hide();  
					j$(".ebsta-admin-MiscSettings-area").hide();           
					j$(".ebsta-admin-ReportingSettings-area").show();
				}
		
		if(addBackgroundColorToLink) {
			j$(".ebstaNav").children().not("#ebsta-admin-gettingstartedguide").removeClass("active");
			j$(this).addClass("active");
		}
    });  
    
    function FindLeftWindowBoundry()
	{
		if (window.screenLeft)
		{
			return window.screenLeft;
		}
		
		if (window.screenX)
			return window.screenX;
			
		return 0;
	}
	
	function FindTopWindowBoundry()
	{
		if (window.screenTop)
		{
			return window.screenTop;
		}
		
		if (window.screenY)
			return window.screenY;
			
		return 0;
	} 
    
    //Creates a Pop Up screen
    function ShowPopUp(url, name){
    	
    	var w = 1366;
    	var h = 768;
    	
    	var x = screen.width/2 - w/2 + FindLeftWindowBoundry();
    	var y = screen.height/2 - h/2 + FindTopWindowBoundry();
    	
    	var popUpWin = window.open(url, name,'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,height='+h+',width='+w+',left='+x+',top='+y);
    	
    	popUpWin.focus();
    }
    
    //download report.
    j$("body").undelegate(".ebsta-admin-runreport-button", "click");
    j$("body").delegate(".ebsta-admin-runreport-button", "click", function (e) {
    
    	//hide the counters and show loaders.
    	j$(".ebsta-alert-counter").hide();
    	j$(".ebsta-alert-loader").show();
    	 
    	//put the counters back.
    	setTimeout(function () {
    		j$(".ebsta-alert-loader").hide();    	
        	j$(".ebsta-alert-counter").show();
        	
        	//change the numbers also
        	j$(".ebsta-missingRecords-counter").text('2,594');
        	j$(".ebsta-updatedContactData-counter").text('1,163');
        	j$(".ebsta-updatedLeadData-counter").text('793');
        	j$(".ebsta-outOfOffice-counter").text('306');
        	j$(".ebsta-hardBounce-counter").text('238');
        	
        	//update the date.
        	var lastReportDate = new Date();
        	
			var lastReportDateMessage = 'Last Report run at ' + formatAMPM(lastReportDate) + ' on ' + lastReportDate.toLocaleDateString(navigator.language, { month: 'long', weekday: 'long', day: '2-digit', year: 'numeric' });
						
			j$(".ebsta-last-report-text").text(lastReportDateMessage);
    	}, 1500);
	});
	
	//checkbox changed in team settings
	j$("body").undelegate(".ebsta-toggle-profile-checkboxes-toggleLink", "click");
    j$("body").delegate(".ebsta-toggle-profile-checkboxes-toggleLink", "click", function (e) {
    
    	if(j$(this).attr('allchecked') === '1')
    	{
    		j$(this).parent().parent().find(':checkbox').each(function(){
    				j$(this).prop('checked', false);
    		});
    		
    		j$(this).attr('allchecked', '0');
 		}else{
 			j$(this).parent().parent().find(':checkbox').each(function(){
    				j$(this).prop('checked', true);
    		});
    		
    		j$(this).attr('allchecked', '1');
 		}
	});
	
	//checkbox changed in team settings
	j$("body").undelegate(".user-control-event", "click");
    j$("body").delegate(".user-control-event", "click", function (e) {
    
    	var externalProfileId = j$(this).attr('externalid');
    	
    	var profileTeamId = j$(this).attr('profileteamid');
    	var securityId = 3; //user control change.
    	var teamRows = []; //don't need any for user change.
    	
    	var userControlValue = true;
    	
    	var userControlAttributeValue = j$(this).attr('usercontrolvalue');
    	
    	if(userControlAttributeValue === '1')
    	{
    		//it is turned on - switch it off.
    		userControlValue = false;
    	}else{
    		//it is turned off - switch it on.
    		userControlValue = true;
    	}
    	
    	//set the loading image while we wait for the request.
    	j$(this).addClass("ebsta-loader").removeClass("ebsta-usercontrol-granted").removeClass("ebsta-usercontrol-denied");
    	j$(this).attr('title', '');
    	
    	UpdateAdminTeam(profileTeamId, securityId, userControlValue, teamRows);    
	});
	
	//popup profile picker menu
	j$("body").undelegate(".ebsta-profile-picker", "click");
    j$("body").delegate(".ebsta-profile-picker", "click", function (e) {    
       
       	//j$('.ebsta-profile-menu-div').toggle();
       	
       	var popUpType = j$(this).attr('popUpType');
       	var externalRowId = j$(this).attr('externalRowId');
       	
       	j$('#ebsta-profile-menu-div-' + popUpType + '-' + externalRowId).toggle();
       	currentPopupId = '#ebsta-profile-menu-div-' + popUpType + '-' + externalRowId;
       
        var rect = this.getBoundingClientRect();
        
        j$('#ebsta-profile-menu-div-' + popUpType + '-' + externalRowId).css({
            	top: rect.top - 160,
            	left: rect.left + 15
        	});
	});
	
	//popup profile picker menu
	j$("body").undelegate(".ebsta-save-admin-controls", "click");
    j$("body").delegate(".ebsta-save-admin-controls", "click", function (e) {   

		j$(".ebsta-message-loader").html('Saving settings... <img src="https://secure1.ebsta-webservices.com/Images/loading.gif" />');
		
		setTimeout(function () {
    		j$(".ebsta-message-loader").html('Settings successfully saved.');
    	}, 1000);
	});
	//reporting onoff switch
	j$("body").undelegate("#myebsta-admin-reporting-onoffswitch", "change");
	j$("body").delegate("#myebsta-admin-reporting-onoffswitch", "change", function (e) {

		// remove any validation errors
		j$('#ebsta-admin-reporting-salesforceobjects-validation-message').removeClass('ebsta-admin-reporting-alert-error-show');
		j$('.reporting-setttings-update-feedback-text-error').remove();

		if(j$(this).is(':checked')){
		
			// user has switched on
		
			UpdateReportingSettingsFromPage(true);
			
			// show options
		
			setTimeout(function(){
				j$('#ebsta-admin-user-reporting-header').removeClass('ebsta-admin-reporting-greyout');
				j$('#ebsta-admin-reporting-userreporting').removeClass('ebsta-admin-reporting-greyout');
				j$('#ebsta-admin-object-reporting-method-header').removeClass('ebsta-admin-reporting-greyout');
				j$('#ebsta-admin-reporting-customfields').removeClass('ebsta-admin-reporting-greyout');
				j$('#ebsta-admin-reporting-customobjects').removeClass('ebsta-admin-reporting-greyout');
				j$('#reportingsettings-save-button-container').removeClass('ebsta-admin-reporting-greyout');
				
				if(j$("#customFieldsReporting-checkbox").is(':checked') || j$("#customobjectReporting-checkbox").is(':checked')){
					j$('#ebsta-admin-salesforceobject-selection-header').removeClass('ebsta-admin-reporting-greyout');
					j$('#ebsta-admin-reporting-salesforceobjects').removeClass('ebsta-admin-reporting-greyout');
				}
			}, 300)
		}
		else{
			// user has switched off
			 
			UpdateReportingSettingsFromPage(true);
			
			// grey out all other options
			setTimeout(function(){
				j$('.reportingsettings-option-containers').addClass('ebsta-admin-reporting-greyout');
				j$('.ebsta-admin-reporting-options-header').addClass('ebsta-admin-reporting-greyout');
			}, 300)
		}
	});
	
	// reporting custom fields reporting switch
	j$("body").undelegate("#customFieldsReporting-checkbox", "change");
	j$("body").delegate("#customFieldsReporting-checkbox", "change", function (e) {

		if(j$(this).is(':checked')){
			j$('#ebsta-admin-salesforceobject-selection-header').removeClass('ebsta-admin-reporting-greyout');
			j$('#ebsta-admin-reporting-salesforceobjects').removeClass('ebsta-admin-reporting-greyout');
		}
		else{
			if(!j$("#customobjectReporting-checkbox").is(':checked')){
				j$('#ebsta-admin-salesforceobject-selection-header').addClass('ebsta-admin-reporting-greyout');
				j$('#ebsta-admin-reporting-salesforceobjects').addClass('ebsta-admin-reporting-greyout');
			}
		}
	});
	
	// reporting custom objects reporting switch
	j$("body").undelegate("#customobjectReporting-checkbox", "change");
	j$("body").delegate("#customobjectReporting-checkbox", "change", function (e) {

		if(j$(this).is(':checked')){
			j$('#ebsta-admin-salesforceobject-selection-header').removeClass('ebsta-admin-reporting-greyout');
			j$('#ebsta-admin-reporting-salesforceobjects').removeClass('ebsta-admin-reporting-greyout');
		}
		else{
			if(!j$("#customFieldsReporting-checkbox").is(':checked')){
				j$('#ebsta-admin-salesforceobject-selection-header').addClass('ebsta-admin-reporting-greyout');
				j$('#ebsta-admin-reporting-salesforceobjects').addClass('ebsta-admin-reporting-greyout');
			}
		}
	});
	
	//reporting settings save button
	j$("body").undelegate(".reporting-settings-savebutton", "click");
	j$("body").delegate(".reporting-settings-savebutton", "click", function (e) {
		
		// remove any validation errors
		j$('#ebsta-admin-reporting-salesforceobjects-validation-message').removeClass('ebsta-admin-reporting-alert-error-show');
		j$('.reporting-setttings-update-feedback-text-error').remove();
		
		UpdateReportingSettingsFromPage(false);
		
	});
	
	//additional settings save button
	j$("body").undelegate(".additional-settings-savebutton", "click");
	j$("body").delegate(".additional-settings-savebutton", "click", function (e) {
		
		//email preview window height.
		var pixelValue = "" + j$("#PreviewWindowHeight").val();
		
		if(pixelValue.length > 0)
		{
			j$(".additional-setttings-update-feedback").text("Saving Settings...");
			
			//only save filter settings if we are displaying the extras.
			if(licenceObjectMain.loadActivityTypeFilters){
			
				//hide default filters.
				var hideDefaultFilters = "" + j$("#HideDefaultFilters").is(":checked");
			
				SaveAdditionalSettings(pixelValue, hideDefaultFilters);
			}else{
				SavePreviewHeight(pixelValue);
			}
		}else{
			j$(".additional-setttings-update-feedback").text("you must enter a value");
		}		
	});
}

function RenderSavePreviewHeightSuccess()
{
	j$(".additional-setttings-update-feedback").text("Settings Saved");
	
}

function RenderAdditionalSettingsError()
{

}

/*
reads reporting settings off page and saves
*/
function UpdateReportingSettingsFromPage(usedOnOffButton) {

	// get reporting settings from page
	var reportingSettings = GetSelectedReportingSettings();

	if(ValidateReportingSettings(reportingSettings, usedOnOffButton)){

		if(!usedOnOffButton){
			// loader
			j$('.reporting-setttings-update-feedback').html('');
			var loader = document.createElement('div');
			loader.setAttribute('id', 'reportingsettings-update-loader');
			loader.className = 'ebsta-loader ebsta-user-control-icon';
			j$('#ebsta-admin-reporting-settings-update-result').append(loader);
		}
		
		UpdateReportingSettings(reportingSettings, usedOnOffButton);
		
	}
}

/*
* if no salesforce objects are check by user to report on, alert them
*/
function ValidateReportingSettings(reportingSettings, usedOnOffButton){
	
	if(reportingSettings.reportingOn){
	
		// if one of the Sf objects settings is picked and no sf objects to report against, fail validation
		
		if(reportingSettings.updateCustomFields || reportingSettings.upsertCustomObjects){
		
			if(!reportingSettings.accountReporting
				&& !reportingSettings.contactReporting
				&& !reportingSettings.leadReporting
				&& !reportingSettings.opportunityReporting){
			
				j$('#ebsta-admin-reporting-salesforceobjects-validation-message').addClass('ebsta-admin-reporting-alert-error-show');
				return false;
			}
		}
		
		// if reporting on and all settings off, fail validation

		if(!reportingSettings.userReporting
			&& !reportingSettings.updateCustomFields
			&& !reportingSettings.upsertCustomObjects){
			
				var updateFeedback = document.createElement('div');
				updateFeedback.className = 'reporting-setttings-update-feedback-text reporting-setttings-update-feedback-text-error';
				updateFeedback.appendChild(document.createTextNode('Please select at least one Reporting settings or simply switch Reporting off.'));
				if(usedOnOffButton){
					j$('#ebsta-admin-reporting-settings-update-result-off').html(updateFeedback);
				}
				else{
					j$('#ebsta-admin-reporting-settings-update-result').html(updateFeedback);
				}
				
				return false;
		}
	} 
		
	
	return true;
}

function GetSelectedReportingSettings(){
 	
 	var reportingSettings = {};
 	
	reportingSettings.reportingOn = document.querySelector('#myebsta-admin-reporting-onoffswitch').checked;
	reportingSettings.userReporting = document.querySelector('#userreporting-checkbox').checked;
	reportingSettings.updateCustomFields = document.querySelector('#customFieldsReporting-checkbox').checked;
	reportingSettings.upsertCustomObjects = document.querySelector('#customobjectReporting-checkbox').checked;
	reportingSettings.accountReporting = document.querySelector('#accountreporting-checkbox').checked;
	reportingSettings.contactReporting = document.querySelector('#contactreporting-checkbox').checked;
	reportingSettings.leadReporting = document.querySelector('#leadreporting-checkbox').checked;
	reportingSettings.opportunityReporting = document.querySelector('#opportunityreporting-checkbox').checked;
	
	return reportingSettings;
}

function SetGlobalEvents()
{	
	j$(document).mouseup(function (e)
	{
    	var container = j$(".ebsta-profile-menu-div");

    	if (!container.is(e.target) // if the target of the click isn't the container...
        	&& container.has(e.target).length === 0) // ... nor a descendant of the container
    	{    	
    		if(currentPopupId.length > 0)
    		{
    			//run the update.  		
    			
    			container.hide();
    			
    			UpdatePermissionList();
    		}   	
    	}
	});
}

function UpdatePermissionList()
{
	var webuserTeamId = j$(currentPopupId).attr('webuserTeamId');
    var securityId = j$(currentPopupId).attr('securityid'); //user control change.
    var teamRows = [];
    var userControlValue = false;
    
    var newLinkText = '';
    var appendNewLinkText = true;
    var linkItemCounter = 0;
    
    var applyEmptySet = true; //let's see if everything is checked.
    var hasNoItemsChecked = true; //let's see if everything is unchecked.
    
    var isOnlyMeCheckBoxChecked = false;  

	j$(currentPopupId).find(':checkbox').each(function(){
    	
    	
    	var checkBoxTeamId = j$(this).attr('teamid');
    	var checkBoxProfileName = j$(this).attr('name');    		

			if(j$(this).is(':checked'))
			{
				var newPermission = new AdminTeamViewRowTeam('', checkBoxTeamId, securityId, 0);
				teamRows.push(newPermission);
			
				hasNoItemsChecked = false; //we found one that is checked.
			
				//add to the link.
						if(appendNewLinkText)
						{						
							if(newLinkText.length > 60)
							{
								newLinkText = newLinkText + '...';
								appendNewLinkText = false;
							}else{
								if(linkItemCounter > 0)
								{
									newLinkText = newLinkText + ',';
								}
					
								//add to the link.						
								newLinkText = newLinkText + checkBoxProfileName;
						
								linkItemCounter++;
							}	
						}
			
			}else{
				//we found one that isn't checked.
				applyEmptySet = false;		
			}
    });
    
    	if(applyEmptySet) //if all are checked just send up an empty list.
    	{    		
    		teamRows = [];
    		newLinkText = 'All';
    	
    		var newPermission = new AdminTeamViewRowTeam('', -1, securityId, 0);
			teamRows.push(newPermission);
    	}
    
    	if(hasNoItemsChecked)
    	{
    		teamRows = [];
    		newLinkText = 'None';
    	}
    
    //append the link text.
    
    j$('.ebsta-profile-link-' + securityId + '-' + webuserTeamId).text(newLinkText);
    
    UpdateAdminTeam(webuserTeamId, securityId, userControlValue, teamRows);
    
    currentPopupId = '';
}

function RenderTeamUpdateSuccess(dataObject, securityId, valueField, webUserTeamId)
{	
	var data = JSON.parse(dataObject);

	if(securityId === 3)
	{
		if(data.success) //if we were successful - update loaders with new values.
		{		
			if(valueField)
			{
				j$('.ebsta-user-control-profile-' + webUserTeamId).addClass("ebsta-usercontrol-granted").removeClass("ebsta-loader");
				j$('.ebsta-user-control-profile-' + webUserTeamId).attr('usercontrolvalue', '1');
				j$('.ebsta-user-control-profile-' + webUserTeamId).attr('title', 'On');
			}else{
				j$('.ebsta-user-control-profile-' + webUserTeamId).addClass("ebsta-usercontrol-denied").removeClass("ebsta-loader");
				j$('.ebsta-user-control-profile-' + webUserTeamId).attr('usercontrolvalue', '0');
				j$('.ebsta-user-control-profile-' + webUserTeamId).attr('title', 'Off');
			}
		}else{ //otherwise reset them to original values.
			if(valueField)
			{
				j$('.ebsta-user-control-profile-' + webUserTeamId).addClass("ebsta-usercontrol-denied").removeClass("ebsta-loader");
				j$(this).attr('usercontrolvalue', '0');
				j$('.ebsta-user-control-profile-' + webUserTeamId).attr('title', 'Off');
			}else{
				j$('.ebsta-user-control-profile-' + webUserTeamId).addClass("ebsta-usercontrol-granted").removeClass("ebsta-loader");
				j$(this).attr('usercontrolvalue', '1');
				j$('.ebsta-user-control-profile-' + webUserTeamId).attr('title', 'On');
			}
		}
	}
}

function InitiateFileDownload(dataObject)
{
	var data = JSON.parse(dataObject);
                         	
    if(data.fileFound + '' === 'true') 
    {         
    	//j$(".ebsta-last-report-text").text('');
    
    	if(data.fileUrl != null && data.fileUrl != '') 
    	{       
    		window.location.href = data.fileUrl;
    	}
    }else{    	
    	
    	j$(".ebsta-last-report-text").text('Unable to download this report - please try again later.');
    }
}


function RenderConnectedUsers(dataObject)
{
	if(dataObject){
	
		var data = JSON.parse(dataObject); 
		var monthNames = GenerateMonthNameArray();
		
		if(data){
			j$(".adminConnectedUsersTable").html('');
			
			for(var i = 0; i < data.length; i++)
			{
				// we'll alwasy add a row for users regardless of connected mailbox or no  
				var firstRow = true;
				
				var name = data[i].name;
				
				var team = data[i].team;
				
				//generate a new table row.
				var newRow = document.createElement('tr');
				
				//render the name cell.
				var nameCell = document.createElement('td');
				nameCell.appendChild(document.createTextNode(name || ''));
				
				//render the team name cell.
				var teamNameCell = document.createElement('td');
				teamNameCell.appendChild(document.createTextNode(team || ''));
				
				
				newRow.appendChild(nameCell);
				newRow.appendChild(teamNameCell);
				var weHaveMailboxes = false;
				
				if(data[i].connectedMailBoxes){
					
					if(data[i].connectedMailBoxes.length > 0){
						weHaveMailboxes = true;
						for(var m = 0; m < data[i].connectedMailBoxes.length; m++){
						
							addRowWithMailBoxInfo(firstRow, data[i].connectedMailBoxes[m], newRow, monthNames);
							
							firstRow = false;
						}
					}
				}
				
				// no mailboxes so we haven't added row yet
				if(!weHaveMailboxes){
					// no connected mailboxes 
					var mailBoxCell = document.createElement('td');
					mailBoxCell.setAttribute('colspan', '4')
					mailBoxCell.appendChild(document.createTextNode('-'));
					
					newRow.appendChild(mailBoxCell)
					
					//append the row to the table.		
					j$(".adminConnectedUsersTable").append(newRow);

				}	
			}
		}
		else{
			RenderConnectedUsersError();
		}
	}
	else{
		RenderConnectedUsersError();
	}
}

function RenderReportingSettings(dataObject, success)
{
	if(success){
		if(dataObject){
			//render object
			
			var data = JSON.parse(dataObject);
			
			if(data){
				
				if(data.success){
				
					RenderReportingSettingsOptions(data);
					
				}
				else{
					// render error
					
					j$('#ebsta-admin-ReportingSettings-Loader').hide();
		
					j$('.ebsta-admin-ReportingSettings-area').append(document.createTextNode('Failed to retrieve Reporting Settings!'));
				}
			}
			else{
				// render errror
				
				j$('#ebsta-admin-ReportingSettings-Loader').hide();
		
				j$('.ebsta-admin-ReportingSettings-area').append(document.createTextNode('Failed to retrieve Reporting Settings!'));
			}
		}
		else{
			// render errror
			
			j$('#ebsta-admin-ReportingSettings-Loader').hide();
		
			j$('.ebsta-admin-ReportingSettings-area').append(document.createTextNode('Failed to retrieve Reporting Settings!'));
		}
	}
	else{
		// render error
		
		j$('#ebsta-admin-ReportingSettings-Loader').hide();
		
		j$('.ebsta-admin-ReportingSettings-area').append(document.createTextNode('Failed to retrieve Reporting Settings!'));
	}
}

function RenderReportingSettingsOptions(data){
	
	// create reporting settings options
	var reportingOptions = j$('.ebsta-admin-reporting-options');
	
	if(reportingOptions.length > 0){
		
		// settings
		
		var line1 = document.createElement('hr');
		line1.className = 'ebsta-admin-reporting-options-hr-paddingtop';
		reportingOptions.append(line1);
	
		// user reporting
		
		var userReportingHeader = document.createElement('h1');
		userReportingHeader.className = 'ebsta-admin-reporting-options-header';
		userReportingHeader.setAttribute('id','ebsta-admin-user-reporting-header');
		userReportingHeader.appendChild(document.createTextNode('User Email Reporting Settings'));
		
		reportingOptions.append(userReportingHeader);
		
		var userReporting = document.createElement('div');
		userReporting.className = 'reportingsettings-option-containers';
		userReporting.setAttribute('id', 'ebsta-admin-reporting-userreporting');
		
		var userReportingCheckbox = document.createElement('input');
		userReportingCheckbox.setAttribute('type', 'checkbox');
		userReportingCheckbox.setAttribute('id', 'userreporting-checkbox');
		userReportingCheckbox.className = 'ebsta-admin-reporting-options-checkbox';
		
		if(data.userReporting){
			userReportingCheckbox.setAttribute('checked', 'checked');
		}
		
		var userReportingLabel = document.createElement('label');
		userReportingLabel.setAttribute('for', 'userreporting-checkbox');
		userReportingLabel.className = 'ebsta-admin-reporting-label';
		userReportingLabel.appendChild(document.createTextNode('User Email Activity'));
		
		var userReportingFootnote = document.createElement('div');
		userReportingFootnote.className = 'ebsta-admin-reporting-footnote';
		userReportingFootnote.appendChild(document.createTextNode('Create Custom User Email Reporting Objects to track the number of emails your Users send and receive on a daily basis.'));
		
		userReporting.appendChild(userReportingCheckbox);
		userReporting.appendChild(userReportingLabel);
		userReporting.appendChild(userReportingFootnote);
		
		reportingOptions.append(userReporting);
		
		var line2 = document.createElement('hr');
		line2.className = 'ebsta-admin-reporting-options-hr-paddingtop';
		reportingOptions.append(line2);
	
		// reporting on salesforce objects
		
		var objectReportingHeader = document.createElement('h1');
		objectReportingHeader.className = 'ebsta-admin-reporting-options-header';
		objectReportingHeader.setAttribute('id','ebsta-admin-object-reporting-method-header');
		objectReportingHeader.appendChild(document.createTextNode('Salesforce Object Reporting Settings'));
		
		reportingOptions.append(objectReportingHeader);
		
		// custom fields 
		
		var customFieldsReporting = document.createElement('div');
		customFieldsReporting.className = 'reportingsettings-option-containers';
		customFieldsReporting.setAttribute('id', 'ebsta-admin-reporting-customfields');
		
		var customFieldsReportingCheckbox = document.createElement('input');
		customFieldsReportingCheckbox.setAttribute('type', 'checkbox');
		customFieldsReportingCheckbox.setAttribute('id', 'customFieldsReporting-checkbox');
		customFieldsReportingCheckbox.className = 'ebsta-admin-reporting-options-checkbox';
		
		if(data.updateCustomFields){
			customFieldsReportingCheckbox.setAttribute('checked', 'checked');
		}
		
		var customFieldsReportingLabel = document.createElement('label');
		customFieldsReportingLabel.setAttribute('for', 'customFieldsReporting-checkbox');
		customFieldsReportingLabel.className = 'ebsta-admin-reporting-label';
		customFieldsReportingLabel.appendChild(document.createTextNode('Update Custom fields on Salesforce objects'));
		
		customFieldsReportingFootnote = document.createElement('div');
		customFieldsReportingFootnote.className = 'ebsta-admin-reporting-footnote';
		customFieldsReportingFootnote.appendChild(document.createTextNode("Ebsta will automatically update Ebsta's Custom Reporting Fields (including Ebsta Score, Emails Sent, Emails Received and Last Email Date) once every 24 hours."));
		
		
		customFieldsReportingFootnote2 = document.createElement('div');
		customFieldsReportingFootnote2.className = 'ebsta-admin-reporting-footnote';
		customFieldsReportingFootnote2.appendChild(document.createTextNode("Please note that this option will alter the Last Modified Date for the record whenever Ebsta updates a Custom Field."));
		
		customFieldsReporting.appendChild(customFieldsReportingCheckbox);
		customFieldsReporting.appendChild(customFieldsReportingLabel);
		customFieldsReporting.appendChild(customFieldsReportingFootnote);
		customFieldsReporting.appendChild(customFieldsReportingFootnote2);
		
		reportingOptions.append(customFieldsReporting);
		
		// create custom object reporting on off switch
		
		var customObjectReporting = document.createElement('div');
		customObjectReporting.className = 'reportingsettings-option-containers';
		customObjectReporting.setAttribute('id', 'ebsta-admin-reporting-customobjects');
		
		var customObjectReportingCheckbox = document.createElement('input');
		customObjectReportingCheckbox.setAttribute('type', 'checkbox');
		customObjectReportingCheckbox.setAttribute('id', 'customobjectReporting-checkbox');
		customObjectReportingCheckbox.className = 'ebsta-admin-reporting-options-checkbox';
		
		if(data.upsertCustomObjects){
			customObjectReportingCheckbox.setAttribute('checked', 'checked');
		}
		
		var customObjectReportingLabel = document.createElement('label');
		customObjectReportingLabel.setAttribute('for', 'customobjectReporting-checkbox');
		customObjectReportingLabel.className = 'ebsta-admin-reporting-label';
		customObjectReportingLabel.appendChild(document.createTextNode('Create and Update Custom Reporting Objects'));
		
		customObjectReportingFootnote = document.createElement('div');
		customObjectReportingFootnote.className = 'ebsta-admin-reporting-footnote';
		customObjectReportingFootnote.appendChild(document.createTextNode('Ebsta will create a Custom Reporting Object for each of your chosen Standard Objects and then update Custom Reporting Fields (including Ebsta Score, Email Sent, Emails Received and Last Email Date) once every 24 hours.'));
		
		
		customObjectReportingFootnote2 = document.createElement('div');
		customObjectReportingFootnote2.className = 'ebsta-admin-reporting-footnote';
		customObjectReportingFootnote2.appendChild(document.createTextNode('Please note that this option will impact on your data storage in Salesforce.'));
		
		customObjectReporting.appendChild(customObjectReportingCheckbox);
		customObjectReporting.appendChild(customObjectReportingLabel);
		customObjectReporting.appendChild(customObjectReportingFootnote);
		customObjectReporting.appendChild(customObjectReportingFootnote2);
		
		reportingOptions.append(customObjectReporting);
		
		// add an invisible line for spacing
		
		var invisibleLine = document.createElement('hr');
		invisibleLine.setAttribute('style', 'visibility: hidden;')
		
		reportingOptions.append(invisibleLine);
		
		// select which salesforce objects to report on
		
		
		
		var objectSelectionHeader = document.createElement('h1');
		objectSelectionHeader.setAttribute('id','ebsta-admin-salesforceobject-selection-header');
		objectSelectionHeader.appendChild(document.createTextNode('Please select the Salesforce Object(s) you wish to report against:'));
		objectSelectionHeader.className = 'ebsta-admin-reporting-options-header';
		
		reportingOptions.append(objectSelectionHeader);
		
		
		var salesforceObjects = document.createElement('div');
		salesforceObjects.className = 'reportingsettings-option-containers';
		salesforceObjects.setAttribute('id', 'ebsta-admin-reporting-salesforceobjects');
		
		// account object
		
		var accountReporting = document.createElement('div');
		
		var accountReportingCheckBox = document.createElement('input');
		accountReportingCheckBox.setAttribute('type', 'checkbox');
		accountReportingCheckBox.setAttribute('id', 'accountreporting-checkbox');
		accountReportingCheckBox.className = 'ebsta-admin-reporting-options-checkbox';
		
		if(data.accountReporting){
			accountReportingCheckBox.setAttribute('checked', 'checked');
		}
		
		var accountReportingLabel = document.createElement('label');
		accountReportingLabel.setAttribute('for', 'accountreporting-checkbox');
		accountReportingLabel.className = 'ebsta-admin-reporting-label';
		accountReportingLabel.appendChild(document.createTextNode('Account'));
		
		accountReporting.appendChild(accountReportingCheckBox);
		accountReporting.appendChild(accountReportingLabel);
		
		salesforceObjects.appendChild(accountReporting);
		
		// Contact
		
		var contactReporting = document.createElement('div');
		
		var contactReportingCheckBox = document.createElement('input');
		contactReportingCheckBox.setAttribute('type', 'checkbox');
		contactReportingCheckBox.setAttribute('id', 'contactreporting-checkbox');
		contactReportingCheckBox.className = 'ebsta-admin-reporting-options-checkbox';
		
		if(data.contactReporting){
			contactReportingCheckBox.setAttribute('checked', 'checked');
		}
		
		var contactReportingLabel = document.createElement('label');
		contactReportingLabel.setAttribute('for', 'contactreporting-checkbox');
		contactReportingLabel.className = 'ebsta-admin-reporting-label';
		contactReportingLabel.appendChild(document.createTextNode('Contact'));
		
		contactReporting.appendChild(contactReportingCheckBox);
		contactReporting.appendChild(contactReportingLabel);
		
		salesforceObjects.appendChild(contactReporting);
		
		// Lead
		
		var leadReporting = document.createElement('div');
		
		var leadReportingCheckBox = document.createElement('input');
		leadReportingCheckBox.setAttribute('type', 'checkbox');
		leadReportingCheckBox.setAttribute('id', 'leadreporting-checkbox');
		leadReportingCheckBox.className = 'ebsta-admin-reporting-options-checkbox';
		
		if(data.leadReporting){
			leadReportingCheckBox.setAttribute('checked', 'checked');
		}
		
		var leadReportingLabel = document.createElement('label');
		leadReportingLabel.setAttribute('for', 'leadreporting-checkbox');
		leadReportingLabel.className = 'ebsta-admin-reporting-label';
		leadReportingLabel.appendChild(document.createTextNode('Lead'));
		
		leadReporting.appendChild(leadReportingCheckBox);
		leadReporting.appendChild(leadReportingLabel);
		
		salesforceObjects.appendChild(leadReporting);
		
		// Opportunity
		
		var opportunityReporting = document.createElement('div');
		
		var opportunityReportingCheckBox = document.createElement('input');
		opportunityReportingCheckBox.setAttribute('type', 'checkbox');
		opportunityReportingCheckBox.setAttribute('id', 'opportunityreporting-checkbox');
		opportunityReportingCheckBox.className = 'ebsta-admin-reporting-options-checkbox';
		
		if(data.opportunityReporting){
			opportunityReportingCheckBox.setAttribute('checked', 'checked');
		}
		
		var opportunityReportingLabel = document.createElement('label');
		opportunityReportingLabel.setAttribute('for', 'opportunityreporting-checkbox');
		opportunityReportingLabel.className = 'ebsta-admin-reporting-label';
		opportunityReportingLabel.appendChild(document.createTextNode('Opportunity'));
		
		opportunityReporting.appendChild(opportunityReportingCheckBox);
		opportunityReporting.appendChild(opportunityReportingLabel);
		
		salesforceObjects.appendChild(opportunityReporting);
		
		var salesforceObjectsValidation = document.createElement('div');
		salesforceObjectsValidation.className = 'ebsta-admin-reporting-alert-error';
		salesforceObjectsValidation.setAttribute('id', 'ebsta-admin-reporting-salesforceobjects-validation-message');
		salesforceObjectsValidation.appendChild(document.createTextNode('Please select at least one Salesforce Object to report against.'))
		
		
		var salesforceObjectsContainer = document.createElement('div');
		salesforceObjectsContainer.setAttribute('id', 'ebsta-admin-reporting-salesforceobjects-header-container');
		
		salesforceObjectsContainer.appendChild(salesforceObjects);
		salesforceObjectsContainer.appendChild(salesforceObjectsValidation);
		
		reportingOptions.append(salesforceObjectsContainer);
	
		if(data.reportingOn){
		
			// reporting is on
			j$('#myebsta-admin-reporting-onoffswitch').attr('checked', 'checked');
						
		}
		else{
			j$('.reportingsettings-option-containers').addClass('ebsta-admin-reporting-greyout');
			j$('.ebsta-admin-reporting-options-header').addClass('ebsta-admin-reporting-greyout');
		}
	
		// hide loader and show switch
		j$('#ebsta-admin-ReportingSettings-Loader').hide();
		j$('#ebsta-admin-reportingsettings-content').show();
	}
	
	
}

function RenderReportingSettingsAfterUpdate(dataObject, success, usedOnOffSwitch){
	if(success){
	
		if(dataObject){
		
			//render object
			
			var data = JSON.parse(dataObject);
			
			if(data){
				
				if(data.success){
					// render success message
					
					PrintOutReportingSettingsUpdateResult(true, usedOnOffSwitch);
					
					// update any values that need updating on page
					
					// reporting on/off
					
					var onOffSwitch = document.querySelector('#myebsta-admin-reporting-onoffswitch');

					if(onOffSwitch.checked !== data.reportingOn){
						onOffSwitch.checked = data.reportingOn
					}
					
					// user reporting
					
					var userReportingSwitch = document.querySelector('#userreporting-checkbox');
					
					if(userReportingSwitch.checked !== data.userReporting){
						userReportingSwitch.checked = data.userReporting
					}
					
					// custom fields reporting
					
					var customFieldsSwitch = document.querySelector('#customFieldsReporting-checkbox');
					
					if(customFieldsSwitch.checked !== data.updateCustomFields){
						customFieldsSwitch.checked = data.updateCustomFields
					}
					
					// custom objects reporting
					
					var customObjectsSwitch = document.querySelector('#customobjectReporting-checkbox');
					
					if(customObjectsSwitch.checked !== data.upsertCustomObjects){
						customObjectsSwitch.checked = data.upsertCustomObjects
					}
					
					// account reporting
					
					var accountSwitch = document.querySelector('#accountreporting-checkbox');
					
					if(accountSwitch.checked !== data.accountReporting){
						accountSwitch.checked = data.accountReporting
					}
					
					// contact reporting
					
					var contactSwitch = document.querySelector('#contactreporting-checkbox');
					
					if(contactSwitch.checked !== data.contactReporting){
						contactSwitch.checked = data.contactReporting
					}
					
					// lead reporting
					
					var leadSwitch = document.querySelector('#leadreporting-checkbox');
					
					if(leadSwitch.checked !== data.leadReporting){
						leadSwitch.checked = data.leadReporting
					}
					
					// opportunity reporting
					
					var opportunitySwitch = document.querySelector('#opportunityreporting-checkbox');
					
					if(opportunitySwitch.checked !== data.opportunityReporting){
						opportunitySwitch.checked = data.opportunityReporting
					}
				}
				else{
					// render error
					
					PrintOutReportingSettingsUpdateResult(false, usedOnOffSwitch);
				}
			}
			else{
				// render errror
				
				PrintOutReportingSettingsUpdateResult(false, usedOnOffSwitch);
			}
		}
		else{
			// render errror
			
			PrintOutReportingSettingsUpdateResult(false, usedOnOffSwitch);
		}
	}
	else{
		// render error
		
		PrintOutReportingSettingsUpdateResult(false, usedOnOffSwitch);
	}
}

function PrintOutReportingSettingsUpdateResult(success, usedOnOffSwitch){

	var updateFeedback = document.createElement('div');
	updateFeedback.setAttribute('id', 'reporting-setttings-update-feedback');
	if(success){
		updateFeedback.className = 'reporting-setttings-update-feedback-text';
		updateFeedback.appendChild(document.createTextNode('Reporting Settings saved.'));
	}
	else{
		// update failed
		updateFeedback.className = 'reporting-setttings-update-feedback-text reporting-setttings-update-feedback-text-error';
		updateFeedback.appendChild(document.createTextNode('Update failed! please try again later.'));
	}
	
	// where to print result
	if(usedOnOffSwitch){
	// if user has turned reporting on or off, only display results if there was an error
		if(!success){
			j$('#ebsta-admin-reporting-settings-update-result-off').html(updateFeedback);
		}
	}
	else{
		j$('#ebsta-admin-reporting-settings-update-result').html(updateFeedback);
	}
	
					
	setTimeout(
			function(){
					j$('#reporting-setttings-update-feedback').fadeOut();
				}
			,5000);
			
}

function RenderConnectedUsersError()
{
	var newRow = document.createElement('tr');
				
	//render the error cell.
	var errorCell = document.createElement('td');
	errorCell.setAttribute('colspan', '5');
	errorCell.className = 'ebstaCenterAlign';
	errorCell.appendChild(document.createTextNode('Failed to retrieve user information!'));
	
	newRow.appendChild(errorCell);
	
	j$(".adminConnectedUsersTable").html('');
					
	//append the row to the table.		
	j$(".adminConnectedUsersTable").append(newRow);
}

function GenerateMonthNameArray(){
	var monthNames = [
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December"
	];
	return monthNames;
}

function addRowWithMailBoxInfo(firstRow, mailBox, newRow, monthNames){

	// if we have more than one mailbox per user, lets add another row
	if(!firstRow){
							
		newRow = document.createElement('tr');
							
		//render empty name cell.
		var nameCell = document.createElement('td');
		nameCell.className = 'ebsta-mailbox-row';
		nameCell.appendChild(document.createTextNode(''));
					
		//render empty team name cell.
		var teamNameCell = document.createElement('td');
		teamNameCell.className = 'ebsta-mailbox-row';
		teamNameCell.appendChild(document.createTextNode(''));
								
		newRow.appendChild(nameCell);
		newRow.appendChild(teamNameCell)
	}
				
	var username = mailBox.userName;
								
	var syncStartDate = mailBox.syncStartDate;
								
	var healthCheck = mailBox.healthCheck;
						
	var userFeedback = mailBox.userFeedback;
								
	var mailBoxCell = document.createElement('td');
	mailBoxCell.appendChild(document.createTextNode(username || ''));
							
	var syncStartDateValue = '';
	if(syncStartDate){
		syncStartDateDatePart = syncStartDate.substring(0, syncStartDate.indexOf('T'));
		var year = syncStartDateDatePart.substring(0, 4);
		var month = syncStartDateDatePart.substring(5, 7)
		var day = syncStartDateDatePart.substring(8, 10);
		syncStartDateValue = (day + ' ' + monthNames[month - 1] + ' ' + year);
	}
							
	var syncStartDateCell = document.createElement('td');
	syncStartDateCell.appendChild(document.createTextNode(syncStartDateValue));
						
	// do mailbox healthcheck stuff
	var healthCheckCell = document.createElement('td');
	healthCheckCell.setAttribute('title', (userFeedback || ''));
	healthCheckCell.className = 'ebstaCenterAlign';
							
	var healthCheckIcon = document.createElement('span');
						
	if(healthCheck){
		healthCheckIcon.className = 'ebsta-mailbox-healthy';
	}
	else{
		healthCheckIcon.className = 'ebsta-mailbox-unhealthy';
	}
								
	healthCheckCell.appendChild(healthCheckIcon);
	
	// do empty cell for spacing
	var emptyCell = document.createElement('td');
							
	if(!firstRow){
		mailBoxCell.className += ' ebsta-mailbox-row';
		syncStartDateCell.className += ' ebsta-mailbox-row';
		healthCheckCell.className += ' ebsta-mailbox-row';
		emptyCell.className += ' ebsta-mailbox-row';
	}
							
	newRow.appendChild(mailBoxCell);
	newRow.appendChild(syncStartDateCell);
	newRow.appendChild(healthCheckCell);
	newRow.appendChild(emptyCell);
							
	//append the row to the table.		
	j$(".adminConnectedUsersTable").append(newRow);
}

function RenderAdminTeamView(dataObject)
{
	var data = JSON.parse(dataObject); 
	
	var groupRows = data.rows;
	
	j$(".adminControlsTable").html('');
	
	if(groupRows.length > 0)
	{
	
	for(var i = 0; i < groupRows.length; i++)
	{
		var groupRow = groupRows[i];
		
		var teamName = groupRow.teamName;		

		var externalId = groupRow.externalId;		

		var userControl = groupRow.userControl;

		var webuserTeamId = groupRow.webuserTeamId;

		var activityView = groupRow.activityView;

		var contactView = groupRow.contactView;

		//generate a new table row.
		var newRow = document.createElement('tr');
		
		//render the group name cell.
		var groupNameCell = document.createElement('td');
		groupNameCell.appendChild(document.createTextNode(teamName));
		
		//render the activity view cell.
		var activityViewCell = document.createElement('td');	
		
		var activityViewLink = document.createElement('a');
		activityViewLink.className = 'ebstaLink ebsta-profile-picker ebsta-profile-picker-activity-view ebsta-profile-link-1-' + webuserTeamId;
		activityViewLink.setAttribute('popUpType', 'activity');
		activityViewLink.setAttribute('externalRowId', externalId);
		
		var profileCheckListDiv = document.createElement('div');
		profileCheckListDiv.className = 'ebsta-profile-menu-div';
		profileCheckListDiv.id = 'ebsta-profile-menu-div-activity-' + externalId;
		profileCheckListDiv.setAttribute('securityid', '1');	
		profileCheckListDiv.setAttribute('webuserTeamId', webuserTeamId);	
		
		var profileCheckListDiv2 = document.createElement('div');
		profileCheckListDiv2.className = 'ebsta-profile-menu-div';
		profileCheckListDiv2.id = 'ebsta-profile-menu-div-contact-' + externalId;
		profileCheckListDiv2.setAttribute('securityid', '2');
		profileCheckListDiv2.setAttribute('webuserTeamId', webuserTeamId);
		
		var popupHeaderSpan = document.createElement('span');
		popupHeaderSpan.className = 'ebstaBold';
		popupHeaderSpan.appendChild(document.createTextNode('Activity'));
		
		var toggleCheckBoxSpan = document.createElement('span');
		toggleCheckBoxSpan.className = 'ebsta-toggle-profile-checkboxes';
		
		var toggleCheckBoxLink = document.createElement('a');
		toggleCheckBoxLink.className = 'pointer ebsta-toggle-profile-checkboxes-toggleLink';
		toggleCheckBoxLink.appendChild(document.createTextNode('Select All'));
		toggleCheckBoxLink.setAttribute('allchecked', '0');
		
		toggleCheckBoxSpan.appendChild(toggleCheckBoxLink);
		
		var toggleCheckBoxSpan2 = document.createElement('span');
		toggleCheckBoxSpan2.className = 'ebsta-toggle-profile-checkboxes';
		
		var toggleCheckBoxLink2 = document.createElement('a');
		toggleCheckBoxLink2.className = 'pointer ebsta-toggle-profile-checkboxes-toggleLink';
		toggleCheckBoxLink2.appendChild(document.createTextNode('Select All'));
		toggleCheckBoxLink2.setAttribute('allchecked', '0');
		
		toggleCheckBoxSpan2.appendChild(toggleCheckBoxLink2);
		
		var popupHeaderSpan2 = document.createElement('span');
		popupHeaderSpan2.className = 'ebstaBold';
		popupHeaderSpan2.appendChild(document.createTextNode('Contact'));
		
		profileCheckListDiv.appendChild(popupHeaderSpan);
		profileCheckListDiv.appendChild(toggleCheckBoxSpan);
		
		profileCheckListDiv2.appendChild(popupHeaderSpan2);
		profileCheckListDiv2.appendChild(toggleCheckBoxSpan2);
		
		var listContainerSpan = document.createElement('span');
		listContainerSpan.className = 'ebsta-profile-list-style';
		
		var listContainerSpan2 = document.createElement('span');
		listContainerSpan2.className = 'ebsta-profile-list-style';
		
		var profileList = document.createElement('ul');
		var profileList2 = document.createElement('ul');
		
		var activityLinkText = '';
		var contactLinkText = '';	
		
		var activityLinkItemsAdded = 0;
				var renderActivityLink = true;
				
		var contactLinkItemsAdded = 0;
				var renderContactLink = true;
				
		var activityAllChecked = false;
		var activityNoneChecked = false;
		var activityOwnChecked = false;
		
		var contactAllChecked = false;
		var contactNoneChecked = false;
		var contactOwnChecked = false;
		
		//render own user checkbox for activity.
		var newCheckBoxListItemActivityOnlyMe = document.createElement('li');
		newCheckBoxListItemActivityOnlyMe.appendChild(document.createTextNode('Only User'));
			
		var checkBoxActivityOnlyMe = document.createElement('input');
		checkBoxActivityOnlyMe.setAttribute('name', 'Only User');
		checkBoxActivityOnlyMe.setAttribute('value', 'Only User');
		checkBoxActivityOnlyMe.setAttribute('type', 'checkbox');
		checkBoxActivityOnlyMe.setAttribute('teamid', '-2');	
		checkBoxActivityOnlyMe.setAttribute('externalid', externalId);		
		checkBoxActivityOnlyMe.setAttribute('securityid', '1');		
		checkBoxActivityOnlyMe.className = 'ebsta-profile-checkaccess ebsta-onlyme-checkbox';
		
		//for(var k = 0; k < activityView.length; k++)
		//{
		//	var activityViewItem = activityView[k];
					
		//	if(activityViewItem.webuserTeamSecurityId === -2)
		//	{
		//		checkBoxActivityOnlyMe.setAttribute('checked', 'checked');	
		//		activityOwnChecked = true;
		//		break;				
		//	}
		//}
		
		newCheckBoxListItemActivityOnlyMe.appendChild(checkBoxActivityOnlyMe);
		profileList.appendChild(newCheckBoxListItemActivityOnlyMe);
		
		//render own user checkbox for contacts.
		var newCheckBoxListItemContactOnlyMe = document.createElement('li');
		newCheckBoxListItemContactOnlyMe.appendChild(document.createTextNode('Only User'));
			
		var checkBoxContactOnlyMe = document.createElement('input');
		checkBoxContactOnlyMe.setAttribute('name', 'Only User');
		checkBoxContactOnlyMe.setAttribute('value', 'Only User');
		checkBoxContactOnlyMe.setAttribute('type', 'checkbox');
		checkBoxContactOnlyMe.setAttribute('teamid', '-2');	
		checkBoxContactOnlyMe.setAttribute('externalid', externalId);		
		checkBoxContactOnlyMe.setAttribute('securityid', '2');			
		checkBoxContactOnlyMe.className = 'ebsta-profile-checkaccess ebsta-onlyme-checkbox';
		
		//for(var l = 0; l < contactView.length; l++)
		//{
		//	var contactViewItem = contactView[l];
					
		//	if(contactViewItem.webuserTeamSecurityId === -2)
		//	{
		//		checkBoxContactOnlyMe.setAttribute('checked', 'checked');
		//		contactOwnChecked = true;	
		//		break;				
		//	}
		//}
		
		newCheckBoxListItemContactOnlyMe.appendChild(checkBoxContactOnlyMe);
		profileList2.appendChild(newCheckBoxListItemContactOnlyMe);
		
		for(var x = 0; x < groupRows.length; x++) //list all the groups for checkboxes in popup.
		{
			var profileRow = groupRows[x];		
		
			//render for activity view:
			
			var newCheckBoxListItem = document.createElement('li');
			newCheckBoxListItem.appendChild(document.createTextNode(profileRow.teamName));			
			
			var checkBox = document.createElement('input');
			checkBox.setAttribute('name', profileRow.teamName);
			checkBox.setAttribute('value', profileRow.teamName);
			checkBox.setAttribute('type', 'checkbox');
			checkBox.setAttribute('teamid', profileRow.webuserTeamId);	
			checkBox.setAttribute('externalid', externalId);				
			checkBox.className = 'ebsta-profile-checkaccess ebsta-standard-choicebox-1-' + externalId;	
			
			//if(activityOwnChecked)
			//{
			//	checkBox.setAttribute('disabled', 'disabled');
			//}
			
			if(activityView.length === 0)
			{
				//checkBox.setAttribute('checked', 'checked');
				
				activityLinkText = 'None';
				
			}else{
			
				for(var j = 0; j < activityView.length; j++)
				{
					var activityViewItem = activityView[j];
					
					if(activityViewItem.webuserTeamSecurityId === -1)
					{
						//checkBox2.setAttribute('checked', 'checked');
						activityLinkText = 'All';
						activityAllChecked = true;
					}
					
					if(activityViewItem.webuserTeamSecurityId === -2 && !activityOwnChecked)
					{
						checkBoxActivityOnlyMe.setAttribute('checked', 'checked');
						activityLinkText = 'Only User';
						activityOwnChecked = true;		
						activityLinkItemsAdded++;										
					}
					
					if(profileRow.webuserTeamId === activityViewItem.webuserTeamSecurityId)
					{
						checkBox.setAttribute('checked', 'checked');						
					
						//add to the link.
						if(renderActivityLink)
						{						
							if(activityLinkText.length > 60)
							{
								activityLinkText = activityLinkText + '...';
								renderActivityLink = false;
							}else{
								if(activityLinkItemsAdded > 0)
								{
									activityLinkText = activityLinkText + ',';
								}
								
									//add to the link.						
									activityLinkText = activityLinkText + activityViewItem.teamName;
						
								activityLinkItemsAdded++;
							}	
						}
						
						break;
					}				
				}
			}
			
			newCheckBoxListItem.appendChild(checkBox);
			profileList.appendChild(newCheckBoxListItem);
			
			//render for contact view: 
			
			var newCheckBoxListItem2 = document.createElement('li');
			newCheckBoxListItem2.appendChild(document.createTextNode(profileRow.teamName));
			newCheckBoxListItem2.className = 'ebsta-standard-choicebox';
			
			var checkBox2 = document.createElement('input');
			checkBox2.setAttribute('name', profileRow.teamName);
			checkBox2.setAttribute('value', profileRow.teamName);
			checkBox2.setAttribute('type', 'checkbox');
			checkBox2.setAttribute('teamid', profileRow.webuserTeamId);
			checkBox2.className = 'ebsta-profile-checkaccess ebsta-standard-choicebox-2-' + externalId;
			checkBox2.setAttribute('externalid', externalId);
			
			//if(contactOwnChecked)
			//{
			//	checkBox2.setAttribute('disabled', 'disabled');
			//}
			
			if(contactView.length === 0)
			{
				//checkBox2.setAttribute('checked', 'checked');
				 
				contactLinkText = 'None';
				
			}else{
			
				for(var k = 0; k < contactView.length; k++)
				{
					var contactViewItem = contactView[k];
					
					if(contactViewItem.webuserTeamSecurityId === -1)
					{
						//checkBox2.setAttribute('checked', 'checked');
						contactLinkText = 'All';
						contactAllChecked = true;						
					}
					
					if(contactViewItem.webuserTeamSecurityId === -2 && !contactOwnChecked)
					{
						checkBoxContactOnlyMe.setAttribute('checked', 'checked');
						contactLinkText = 'Only User';
						contactOwnChecked = true;
						contactLinkItemsAdded++;						
					}
			
					if(profileRow.webuserTeamId === contactViewItem.webuserTeamSecurityId)
					{
						checkBox2.setAttribute('checked', 'checked');						
						
						if(renderContactLink)
						{
							if(contactLinkText.length > 60)
							{
								contactLinkText = contactLinkText + '...';
								renderContactLink = false;
							}else{
								if(contactLinkItemsAdded > 0)
								{
									contactLinkText = contactLinkText + ',';
								}
					
								//add to the link.						
								contactLinkText = contactLinkText + contactViewItem.teamName;
						
								contactLinkItemsAdded++;
							}	
						}	
						
						break;				
					}
				}
			}
			
			newCheckBoxListItem2.appendChild(checkBox2);
			profileList2.appendChild(newCheckBoxListItem2);
			
			profileCheckListDiv.appendChild(profileList);
			profileCheckListDiv2.appendChild(profileList2);
			
		}
		
		listContainerSpan.appendChild(profileList);
		profileCheckListDiv.appendChild(listContainerSpan);	
		
		listContainerSpan2.appendChild(profileList2);
		profileCheckListDiv2.appendChild(listContainerSpan2);	
		
		activityViewLink.appendChild(document.createTextNode(activityLinkText));
		
		activityViewCell.appendChild(activityViewLink);
		activityViewCell.appendChild(profileCheckListDiv);
		activityViewCell.className = 'ebstaCenterAlign';
		
		//render the contact view cell.
		var contactViewCell = document.createElement('td');	
		
		var contactViewLink = document.createElement('a');
		contactViewLink.className = 'ebstaLink ebsta-profile-picker ebsta-profile-picker-activity-contact ebsta-profile-link-2-' + webuserTeamId;
		contactViewLink.setAttribute('popUpType', 'contact');
		contactViewLink.setAttribute('externalRowId', externalId);
		
		contactViewLink.appendChild(document.createTextNode(contactLinkText));		
		
		contactViewCell.appendChild(contactViewLink);
		contactViewCell.appendChild(profileCheckListDiv2);
		contactViewCell.className = 'ebstaCenterAlign';
		
		//render the user control cell.
		var userControlCell = document.createElement('td');
		userControlCell.className = 'ebstaCenterAlign';
		
		var userControlIconSpan = document.createElement('span');
		userControlIconSpan.className = 'ebstaPointer user-control-event ebsta-user-control-icon ebsta-user-control-profile-' + webuserTeamId;
		userControlIconSpan.setAttribute('externalId', externalId);
		userControlIconSpan.setAttribute('profileteamid', webuserTeamId);	
		
		var userControlImage = document.createElement('img');
		userControlImage.className = 'ebstaPointer ';
		userControlImage.setAttribute('externalId', externalId);
		userControlImage.setAttribute('profileteamid', webuserTeamId);		
		
		if(userControl)
		{
			userControlImage.setAttribute('src', 'https://secure1.ebsta-webservices.com/svg/FINALTICK.svg');
			userControlImage.setAttribute('usercontrolvalue', '1');
			userControlIconSpan.setAttribute('usercontrolvalue', '1');	
			userControlIconSpan.className = userControlIconSpan.className + ' ebsta-usercontrol-granted';	
			userControlIconSpan.title = 'On';	
			
		}else{
			userControlImage.setAttribute('src', 'https://secure1.ebsta-webservices.com/svg/FINALCROSS.svg');
			userControlImage.setAttribute('usercontrolvalue', '0');
			userControlIconSpan.setAttribute('usercontrolvalue', '0');
			userControlIconSpan.className = userControlIconSpan.className + ' ebsta-usercontrol-denied';	
			userControlIconSpan.title = 'Off';			
		}
		
		//userControlCell.appendChild(userControlImage);
		userControlCell.appendChild(userControlIconSpan); 
		
		newRow.appendChild(groupNameCell);
		newRow.appendChild(activityViewCell);
		newRow.appendChild(contactViewCell);
		newRow.appendChild(userControlCell);
		
		//append the row to the table.		
		j$(".adminControlsTable").append(newRow);
		
		//check all activity boxes if all is flagged. 
		 if(activityAllChecked && !activityOwnChecked)
		 {
		 	j$('#ebsta-profile-menu-div-activity-' + externalId).find(':checkbox').each(function(){
    	 			j$(this).prop('checked', true);
			});
		 } 
		 
		 //check all activity boxes if all is flagged.
		 if(contactAllChecked && !contactOwnChecked)
		 {
		 	j$('#ebsta-profile-menu-div-contact-' + externalId).find(':checkbox').each(function(){
    	 			j$(this).prop('checked', true);
			});
		 }
		}
	}else{
		DisplayNoResults(4, 'adminControlsTable', 'No profiles found.');
	}
}

function DisplayNoResults(columns, tableClass, message)
{
    j$("." + tableClass).html('');

    var newRow = document.createElement('tr');

    var newCell = document.createElement('td');
    newCell.setAttribute("colspan", "" + columns);
    newCell.setAttribute("style", "text-align:center;");
    newCell.appendChild(document.createTextNode(message));

    newRow.appendChild(newCell);

    j$("." + tableClass).append(newRow);
}

function RenderAlertReportNoAccess(hasAccess)
{
	if(hasAccess)
	{
		j$(".ebsta-last-report-text").text('Report pending - please check back later.');
	}else{
		j$(".ebsta-last-report-text").text('Access to Ebsta’s Data Alerts is a Premium Feature - please contact sales@ebsta.com for more information.');
		
		j$('input[type="button"]').prop('disabled', true);
        j$('.ebsta-export-report').addClass('ebsta-disabledButton');
        j$('.ebsta-csv-download').addClass('ebsta-disabledButton');
        j$('.ebsta-export-report').attr('title', 'Report download not available.');
        j$('.ebsta-csv-download').attr('title', 'Report download not available.');
	}
	
	j$(".ebsta-updatedContactData-counter").text('0');
	j$(".ebsta-hardBounce-counter").text('0');
	j$(".ebsta-updatedLeadData-counter").text('0');
	j$(".ebsta-missingRecords-counter").text('0');
	j$(".ebsta-missingLeadRecords-counter").text('0');
	j$(".ebsta-outOfOffice-counter").text('0');
	
	//show the counters.
	j$(".ebsta-alert-counter").show();
	j$(".ebsta-alert-loader").hide();
}

function RenderReportCounters(dataObject)
{

	//first check licence status: 
	
	if(licenceObjectMain.accessAlertsTab !== true)
    {
		//render something else?
		RenderAlertReportNoAccess(false);
	}else{
	
	var data = JSON.parse(dataObject); 
	
	if(data.reportFound + '' === 'false')
	{
		RenderAlertReportNoAccess(true);
	}else{
	
		if(data.contactDataCount != null)
		{
			j$(".ebsta-updatedContactData-counter").text(data.contactDataCount);
		}
	
		if(data.hardBounceCount != null)
		{
			j$(".ebsta-hardBounce-counter").text(data.hardBounceCount);
		}
	
		if(data.leadDataCount != null)
		{
			j$(".ebsta-updatedLeadData-counter").text(data.leadDataCount);
		}
	
		if(data.missingRecordsCount != null)
		{
			j$(".ebsta-missingRecords-counter").text(data.missingRecordsCount);
		}
		
		if(data.missingLeadsCount != null)
		{
			j$(".ebsta-missingLeadRecords-counter").text(data.missingLeadsCount);
		}
	
		if(data.outOfOfficeCount != null)
		{
			j$(".ebsta-outOfOffice-counter").text(data.outOfOfficeCount);
		}
		
		if(data.dateCreated != null)
		{
			var lastReportDate = new Date(data.dateCreated);
	
			var lastReportDateMessage = 'Last Report run at ' + formatAMPM(lastReportDate) + ' on ' + lastReportDate.toLocaleDateString(navigator.language, { month: 'long', weekday: 'long', day: '2-digit', year: 'numeric' });
			
			j$(".ebsta-last-report-text").text(lastReportDateMessage);
		}
	}
	
	//show the counters.
	j$(".ebsta-alert-counter").show();
	j$(".ebsta-alert-loader").hide();
	
	}
}

function formatAMPM(date) {
  var hours = date.getHours();
  var minutes = date.getMinutes();
  var ampm = hours >= 12 ? 'PM' : 'AM';
  hours = hours % 12;
  hours = hours ? hours : 12; // the hour '0' should be '12'
  minutes = minutes < 10 ? '0'+minutes : minutes;
  var strTime = hours + ':' + minutes + ' ' + ampm;
  return strTime;
}
