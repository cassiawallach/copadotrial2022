var currentExpanded = '';
var previewFromClickEvent = false;

function ApplyLicenceSettings(licenceObjectMain) {
    //check for alert tab access:
    if (licenceObjectMain != null && typeof licenceObjectMain != "undefined") {
        if (licenceObjectMain.accessAlertsTab === false) {
            //hide the alerts tab.	
            j$(".ebsta-access-alertsTab").hide(); //maybe dispose of this?
        }
        //hide links to reporting.
        if (licenceObjectMain.accessAdminReportingConsole !== true) {
            //hide the reporting link.
            j$(".ebsta-reporting-li").hide(); //maybe dispose of this?
        }
        //display the search box for elastic search users.
        if (licenceObjectMain.searchIndexVersion > 0) {
            j$(".ebsta-email-search-spancontainer").show();
        }
    }
}

function ConvertMainLicenceObject(licenceStatusObjectFull) {
    //full company licence status - flags all permissions
    if (licenceStatusObjectFull === 'REAUTH') {
        ReauthProcess();
    } else {

        if (licenceStatusObjectFull != null && typeof licenceStatusObjectFull != "undefined") {
            return JSON.parse(licenceStatusObjectFull);
        }
    }
}

// descides if user has access to ebsta score or not, shows ebsta score container if they do
function UserHasAccessToEbstaScore(licenceObjectMain, mainObjectName) {

    if (licenceObjectMain !== null && typeof licenceObjectMain !== "undefined") {
        // show ebsta score if they have access
        if (licenceObjectMain.accessEbstaScore === false) {
            return false;
        } else {
            j$(".ebsta-score-container").css("display", "inline-block");
            return true;
        }
    }

    return false;
}



// renders score on page
function DisplayEbstaScore(result, mainSalesforceId) {

    if (result !== null && result.length > 0) {

        var jsonEbstaScore = JSON.parse(result);

        if (jsonEbstaScore !== null) {

            //render score

            var score = jsonEbstaScore['ebstaScore'];

            if (score !== null && !isNaN(score)) {

                ebstaScore = document.getElementsByClassName('ebsta-score-div');
                if (ebstaScore !== null && ebstaScore.length > 0) {
                    ebstaScore[0].innerHTML = score;
                }
            }

            //render score trend

            var sevenDayTrend = jsonEbstaScore['sevenDayTrend'];

            if (sevenDayTrend !== null && !isNaN(sevenDayTrend)) {

                if (sevenDayTrend !== 0) {

                    var ebstaScoreTrendVal = document.getElementById('ebsta-score-trend-value');

                    if (ebstaScoreTrendVal) {

                        ebstaScoreTrendVal.innerHTML = sevenDayTrend;
                    }

                    var ebstaScoreTrendArrow = document.getElementById('ebsta-score-trend-arrow');

                    if (ebstaScoreTrendArrow) {

                        if (sevenDayTrend > 0) {
                            // green up arrow
                            ebstaScoreTrendArrow.className = 'ebsta-score-arrow-up';
                        }

                        if (sevenDayTrend < 0) {
                            //red down arrow
                            ebstaScoreTrendArrow.className = 'ebsta-score-arrow-down';
                        }
                    }
                }
            }

            // set up click events to navigate to score admin page
            SetUpEbstaScoreClickEvents(mainSalesforceId);
        }
    }
}

// set up ebsta score click events
function SetUpEbstaScoreClickEvents(mainSalesforceId) {

    if (mainSalesforceId !== null && mainSalesforceId.length > 0) {

        j$("body").undelegate(".ebsta-score", "click");
        j$("body").delegate(".ebsta-score", "click", function (e) {
            var url = 'https://secure1.ebsta-webservices.com/ebstascore/index/' + mainSalesforceId;
            window.open(url, '_blank');
        });
    }
}

function HideAlertRow(alertId){

    // hide the alerts row.
    j$('#alertrowid-' + alertId).fadeOut(1000);

    // decrease the counter.
    totalAlertResults--;
    j$(".alertsCounter").text('(' + totalAlertResults + ')');

    if(totalAlertResults === 0){
        DisplayNoResults(6, 'alertsTable', 'alerts');
    }
}

function ApplyDisplayEvents() {

    j$('.blacklist').off("click");
    j$('.blacklist').on("click", function () {
        if (userHasPrivacyControl) {
            var emailAddress = j$(this).attr('emailaddress');

            BlackListEmailAddress(emailAddress);
        }
    });

    j$('.ebsta-blacklist-singleitem').off("click");
    j$('.ebsta-blacklist-singleitem').on("click", function () {

        if (userHasPrivacyControl) {
            var emailId = j$(this).attr('emailid');

            BlackListItem(emailId);
        }
    });

    j$('.ebsta-blacklist-allactivity').off("click");
    j$('.ebsta-blacklist-allactivity').on("click", function () {

        if (userHasPrivacyControl) {

            var emailAddress = j$(this).attr('emailaddress');

            BlackListAllActivity(emailAddress);
        }
    });

    j$('.ebsta-blacklist-allactivitycontact').off("click");
    j$('.ebsta-blacklist-allactivitycontact').on("click", function () {

        if (userHasPrivacyControl) {
            var emailAddress = j$(this).attr('emailaddress');

            BlackListAllActivityAndContact(emailAddress);
        }
    });

    j$('.ebsta-media-icon').off("click");
    j$('.ebsta-media-icon').on("click", function () {
        var linkUrl = j$(this).attr('linkUrl');

        //log the event.
        LogEvent('SocialMediaLinkClicked', 'LinkUrl: ' + linkUrl, 464);

        var win = window.open(linkUrl, '_blank');
        win.focus();
    });

    j$('.ebsta-hidden-menu, .ebsta-menu-ul').off("mouseleave");
    j$('.ebsta-hidden-menu, .ebsta-menu-ul').on("mouseleave", function (evt) {

        var emailId = j$(this).attr('emailId');

        //j$(this).parent().hide();    
        j$('.ebsta-menu-ul').hide();
    });

    j$('.ebsta-action-ignore').off("click");
    j$('.ebsta-action-ignore').on("click", function () {

        //TODO: loaders.
        j$(this).addClass("ebsta-loader").removeClass("ebsta-action-ignore");

        var alertId = j$(this).attr('esid');

        IgnoreAlertV2(alertId);

        // j$(this).closest("tr").fadeOut(500, function () { j$(this).remove(); });
    });

    j$('.action-update-record').off("click");
    j$('.action-update-record').on("click", function () {

        //TODO: loaders.
        j$(this).addClass("ebsta-loader").removeClass("action-update-record");

        var alertId = j$(this).attr('esid');
        var salesforceId = j$(this).attr('salesforceid');
        var updateField = j$(this).attr('updatefield');
        var updateValue = j$(this).attr('updatevalue');

        ActionAlert(salesforceId, updateField, alertId, updateValue);
    });

    j$('.ebsta-action-action').off("click");
    j$('.ebsta-action-action').on("click", function () {

        var alertType = j$(this).attr('alerttype');

        var strLocation = '';

        if (alertType + '' === '1') //this is a new contact alert.
        {
            strLocation = '/003/e?retURL=%2F' + accountId + '&accid=' + accountId;

            if (contactHasRecordTypes) {

                strLocation = '/setup/ui/recordtypeselect.jsp?ent=Contact';
                strLocation = strLocation + '&retURL=%2F003%2Fo&save_new_url=%2F003%2Fe%3FretURL%3D%252F003%252Fo';
            }

        } else {
            var salesforceId = j$(this).attr('salesforceid');

            var correction = j$(this).attr('correctionvalue');

            strLocation = '/' + salesforceId + '/e?retURL=%2F' + accountId;

            if (alertType + '' === '2' || alertType + '' === '3') //phone record.
            {
                strLocation = strLocation + '&con10=' + correction;
            }

            if (alertType + '' === '5') //new email.
            {
                strLocation = strLocation + '&con15=' + correction;
            }

            if (alertType + '' === '6' || alertType + '' === '7') //job title.
            {
                strLocation = strLocation + '&con5=' + correction;
            }
        }

        var win = window.open(strLocation, '_blank');
        win.focus();
    });

    j$('.blacklist-menu').off("click");
    j$('.blacklist-menu').on("click", function (evt) {

        var emailId = j$(this).attr('emailId');

        if (j$('.contact-menu-div-' + emailId).is(":visible")) {
            //j$('.ebsta-hidden-menu').parent().hide();
            j$('.ebsta-menu-ul').hide();
        } else {
            //j$('.ebsta-hidden-menu').parent().hide();
            j$('.ebsta-menu-ul').hide();
            j$('.contact-menu-div-' + emailId).show();
        }

        //j$('.contact-menu-div-' + emailId).toggle();

        var rect = this.getBoundingClientRect();

        j$('.contact-menu-div-' + emailId).css({
            //top: rect.top - 6,
            left: rect.left + 5
        });
    });

    j$('.ebsta-attachments-icon').off("mouseover");
    j$('.ebsta-attachments-icon').on("mouseover", function (evt) {

        previewFromClickEvent = true;

        var emailId = j$(this).attr('emailId');
        j$('.attachmentListDiv' + emailId).fadeIn('fast');

        if (j$('.attachmentListDiv' + emailId).text() == '') {
            j$('.attachmentListDiv' + emailId).text('Loading Attachments...');

            //LoadPreviewEmail('' + emailId);
            LoadAttachmentList('' + emailId);
        }
    });

    j$('.ebsta-attachments-icon').off("mouseleave");
    j$('.ebsta-attachments-icon').on("mouseleave", function (evt) {
        //Check if user has navigated away from the attachment list pop up, if so then hide the pop up
        if (evt.clientX != null && evt.clientY != null) {
            var mouseOnElement = document.elementFromPoint(evt.clientX, evt.clientY);

            if (mouseOnElement != null) {
                if (mouseOnElement.classList.contains("ebsta-attachmentlist-ul") || j$(mouseOnElement).closest(".ebsta-attachmentlist-ul").length > 0) {
                    return false;
                }
            }
        }

        j$('.ebsta-attachmentlist-ul').hide();
    });

    j$('.foundContact, .addEmailAdded, .activityTaskAdded, .foundLead').off("click");
    j$('.foundContact, .addEmailAdded, .activityTaskAdded, .foundLead').on("click", function () {
        var salesforceRecordId = j$(this).attr('sfId');

        var objectPrefix = salesforceRecordId.substring(0, 3);

        if (objectPrefix === '003') //contact
        {
            //log the event.
            LogEvent('ViewContactClicked', 'SalesforcedId: ' + salesforceRecordId, 448);
        }

        if (objectPrefix === '00Q') //lead
        {
            //log the event.
            LogEvent('ViewLeadClicked', 'SalesforcedId: ' + salesforceRecordId, 449);
        }

        if (objectPrefix === '00T') //task
        {
            //log the event.
            LogEvent('ViewEmailClicked', 'SalesforcedId: ' + salesforceRecordId, 447);
        }

        var win = window.open('/' + salesforceRecordId, '_blank');
        win.focus();
    });

    j$('.foundMultiplePeople').off("click");
    j$('.foundMultiplePeople').on("click", function () {
        var emailAddressString = j$(this).attr('emailaddress');

        var redirectSearchUrl = '/_ui/search/ui/UnifiedSearchResults?str=' + emailAddressString;

        var win = window.open(redirectSearchUrl, '_blank');
        win.focus();
    });

    //enter keypress from search box.
    j$("body").undelegate(".ebsta-email-search", "keypress");
    j$("body").delegate(".ebsta-email-search", "keypress", function (e) {

        var filterValue = j$(this).val();

        if (e.which == 13) { //we've hit return - add the filter.

            if (filterValue !== '') {
                if (filterValue.length > 2) {
                    CheckFilter('Search');

                    AddFilter('Search', filterValue, '', '');

                    //log the event.
                    LogEvent('FilterSubjectRun', 'FilterTerm: ' + filterValue, 463);

                    LoadActivity(50, 1, globalSearchTerm);
                }
            }
        }

    });

    j$("body").undelegate(".ebsta-search-button-icon", "click");
    j$("body").delegate(".ebsta-search-button-icon", "click", function (e) {
        var filterValue = j$(".ebsta-email-search").val();

        if (filterValue !== '') {
            if (filterValue.length > 2) {
                CheckFilter('Search');

                AddFilter('Search', filterValue, '', '');

                //log the event.
                LogEvent('Search', 'FilterTerm: ' + filterValue, 463);

                LoadActivity(50, 1, globalSearchTerm);
            }
        }

    });

    //filter user menu
    j$("body").undelegate(".ebsta-user-filter-checkbox", "change");
    j$("body").delegate(".ebsta-user-filter-checkbox", "change", function () {

        var checkboxChecked = j$(this).is(":checked");
        var filterValue = j$(this).val();

        if (checkboxChecked) //if the box has been check - add the filter.
        {
            CheckFilter('From');

            AddFilter('From', '' + filterValue, '', '');
        }

        //log the event.
        LogEvent('FilterUserClicked', 'FilterUserClicked', 453);

        LoadActivity(50, 1, globalSearchTerm);
    });

    //Filter Menu - Apply Button action
    j$("body").undelegate("#ebsta-apply-filtersection-link-activityview", "click");
    j$("body").delegate("#ebsta-apply-filtersection-link-activityview", "click", function () {

        j$('.ebsta-activity-filter-menu-div').slideUp();

        //Clear the array to start a fresh
        searchFilterList = [];

        j$("body").find(".ebsta-activity-filter-checkbox").each(function () {

            var checkboxChecked = j$(this).is(":checked");
            var filterValue = j$(this).val();
            var filterName = '';
            var filterValueContent = false;

            if (checkboxChecked) {
                if (filterValue === "sent") {
                    filterValueContent = true;
                    filterName = "Sent";
                }

                if (filterValue === "received") {
                    filterValueContent = false;
                    filterName = "Sent";
                }

                if (filterValue === "calls") {
                    filterValueContent = "";
                    filterName = "Calls";
                }

                if (filterValue === "meetings") {
                    filterValueContent = "";
                    filterName = "Meetings";
                }

                if (j$(this).hasClass("activityFilter")) {
                    filterName = "salesforceactivitytype";
                    filterValueContent = "" + filterValue;
                }

                if (!j$(this).hasClass("activityFilter")) {
                    AddFilter('' + filterName, '' + filterValueContent, '', '');
                }
            }

            if (j$(this).hasClass("activityFilter")) {
                filterName = "salesforceactivitytype";
                filterValueContent = "" + filterValue;
                AddActivityFilter('' + filterName, '' + filterValueContent, '', '', checkboxChecked);
            }
        });

        UpdateActivitySettingsView();

        //log the event.
        LogEvent('FilterActivityClicked', 'FilterActivityClicked', 450);

        LoadActivity(50, 1, globalSearchTerm);
    });

    //filter contact menu
    j$("body").undelegate(".ebsta-contact-filter-checkbox", "change");
    j$("body").delegate(".ebsta-contact-filter-checkbox", "change", function () {
        var checkboxChecked = j$(this).is(":checked");
        var filterValue = j$(this).val();

        if (checkboxChecked) //if the box has been check - add the filter.
        {
            CheckFilter('To');

            AddFilter('To', '' + filterValue, '', '');
        }

        //log the event.
        LogEvent('FilterContactClicked', 'FilterContactClicked', 451);

        LoadActivity(50, 1, globalSearchTerm);
    });

    j$('.showEmailPreview').off("mouseover");
    j$('.showEmailPreview').on("mouseover", function (evt) {

        previewFromClickEvent = true;

        var emailId = j$(this).attr('emailId');
        j$('.previewToolTip' + emailId).fadeIn('fast');

        if (j$('.previewToolTipTextContent' + emailId).text() == '') {
            j$('.previewToolTipTextContent' + emailId).text('Loading...');

            //j$('.previewToolTip' + emailId).css({
            //	top: evt.pageY,
            //	left: evt.pageX + 25
            //});

            LoadPreviewEmail('' + emailId);
        }
    });

    j$('.showEmailPreview').off("mouseleave");
    j$('.showEmailPreview').on("mouseleave", function (evt) {
        var emailId = j$(this).attr('emailId');
        j$('.previewToolTip' + emailId).fadeOut('fast');
    });

    j$('.emailNoExpand').off("click");
    j$('.emailNoExpand').on("click", function (evt) {

        evt.preventDefault();
    });

    j$('.emailExpand, .showEmailPreview').off("click");
    j$('.emailExpand, .showEmailPreview').on("click", function (evt) {
        var emailId = j$(this).attr('emailId');

        if (currentExpanded == emailId) {
            //j$('tr[emailActive="1"').remove();
            j$('.ebsta-tr-emailActive').remove();
            currentExpanded = '';
        }
        else {
            currentExpanded = emailId;
            //j$('tr[emailActive="1"').remove(); 
            j$('.ebsta-tr-emailActive').remove();
            j$("tr[emailId='" + emailId + "']").after('<tr emailActive="1" class="ebsta-tr-emailActive"><td colspan="8"><pre class="preEmail slds-text-body--small" bodyEmailId="' + emailId + '">Loading..</div></td><tr>');

            LoadEmailText('' + j$(this).attr('emailId'));
        }

        evt.preventDefault();
    });

    j$('.addEmail').off("click");
    j$('.addEmail').on("click", function () {  

        j$(this).addClass("ebsta-loader").removeClass("addEmail");
        //j$(this).removeClass("addEmail").html('<div class="slds-spinner--small"><img src="' + loadingImagePath2 + '" /></div>');

        //var addEmailLoadingGif = CreateSvgWithUseTag('', '#contact'); 

        //log the event.
        LogEvent('AddEmailClicked', 'EmailDocumentId: ' + j$(this).attr('emailId'), 444);

        AddEmailToSFV2(j$(this).attr('emailId'), j$(this).attr('contactId'), true);
    });

    j$('.addTask').off("click");
    j$('.addTask').on("click", function () {

        j$(this).addClass("ebsta-loader").removeClass("addTask");

        //log the event.
        LogEvent('AddEmailClicked', 'EmailDocumentId: ' + j$(this).attr('emailId'), 444);

        AddEmailToSFV2(j$(this).attr('emailId'), j$(this).attr('contactId'), false);
    });

    j$('.activityTable .addContactLead').off("click");
    j$('.activityTable .addContactLead').on("click", function () {

        var emailId = j$(this).attr('emailId');

        if (j$('.addcontactlead-menu-div-' + emailId).is(":visible")) {
            j$('.ebsta-menu-ul').hide();
        } else {
            j$('.ebsta-menu-ul').hide();
            j$('.addcontactlead-menu-div-' + emailId).show();
        }

        var rect = this.getBoundingClientRect();

        j$('.addcontactlead-menu-div-' + emailId).css({
            //top: rect.top - 6,
            left: rect.left + 5
        });
    });

    j$('.relationshipsTable .addContactLead').off("click");
    j$('.relationshipsTable .addContactLead').on("click", function () {

        var emailId = j$(this).attr('emailId');

        if (j$('.addcontactlead-menu-div-' + emailId).is(":visible")) {
            j$('.ebsta-menu-ul').hide();
        } else {
            j$('.ebsta-menu-ul').hide();
            j$('.addcontactlead-menu-div-' + emailId).show();

            var rect = this.getBoundingClientRect();

            j$('.addcontactlead-menu-div-' + emailId).css({
                //top: rect.top - 30,
                left: rect.left - 95
            });
        }

    });

    j$('.addContact').off("click");
    j$('.addContact').on("click", function () {

        //if we are in lightning mode we need to load the contact form differently through an event.
        if (lightningMode) {
            AddContactLightningView(this);
        } else {
            AddContactClassicView(this, true);
        }
    });

    j$('.addContactAlert').off("click");
    j$('.addContactAlert').on("click", function () {

        //if we are in lightning mode we need to load the contact form differently through an event.
        if (lightningMode) {
            AddContactLightningView(this);
        } else {
            AddContactClassicView(this, false);
        }
    });

    j$('.addLead').off("click");
    j$('.addLead').on("click", function () {

        //if we are in lightning mode we need to load the contact form differently through an event.
        if (lightningMode) {
            AddLeadLightningView(this);
        } else {
            AddLeadClassicView(this);
        }
    });
}

//handles redirect to add contact page in salesforce classic view.
function AddContactClassicView(currentElement, openInNewWindow) {
    var emailId = j$(currentElement).attr('emailId');

    //log the event.
    LogEvent('AddContactClicked', 'EmailDocumentId: ' + emailId, 445);

    var itemCount, item;
    var sentItem = false;

    if (emailId) {
        if (emailId.indexOf('S-') != -1) {

            itemCount = parseInt(emailId.replace('S-', ''));
            item = resultsListSent[itemCount];
            sentItem = true;
        }
        else {
            itemCount = parseInt();
            item = resultsListRec[itemCount];
        }
    }

    var fullname = '';
    var emailAddress = '';

    if (item != null) {
        if (!sentItem) {
            if (item.from != null) {

                if (item.from.name != null) {
                    fullname = item.from.name.split(' ');
                }
                if (item.from.address != null) {
                    emailAddress = item.from.address;
                }
            }
        }
        else {
            if (item.to != null) {

                if (item.to.name != null) {
                    fullname = item.to.name.split(' ');
                }
                if (item.to.address != null) {
                    emailAddress = item.to.address;
                }
            }
        }
    }

    var onLeadRecord = false;
    var onContactRecord = false;
    var onOpportunityRecord = false;
    var onAccountRecord = false;

    if (mainSalesforceId != null) {
        if (mainSalesforceId.length > 2) {
            var objectPrefix = mainSalesforceId.substring(0, 3);

            if (objectPrefix === '00Q') //lead
            {
                onLeadRecord = true;
            }

            if (objectPrefix === '003') //contact
            {
                onContactRecord = true;
            }

            if (objectPrefix === '006') //opportunity
            {
                onOpportunityRecord = true;
            }

            if (objectPrefix === '001') //account
            {
                onAccountRecord = true;
            }
        }
    }

    var firstname = j$(currentElement).attr('firstname');
    var lastname = j$(currentElement).attr('lastname');
    var emailAddress = j$(currentElement).attr('emailAddress');
    var phone = j$(currentElement).attr('phonenumber');
    var mobile = j$(currentElement).attr('mobilenumber');
    var jobtitle = j$(currentElement).attr('jobtitle');

    var strLocation = '/003/e?retURL=%2F' + mainSalesforceId;

    //if we are generating a lead there will be no associated account.
    if (!onLeadRecord) {
        //if we're on a contact record, set the related account id. 
        if (onContactRecord) {
            if (relatedAccountId != '' && relatedAccountId != null) {
                strLocation = strLocation + '&accid=' + relatedAccountId;
            }
        }

        //if we're on an opportunity record, set the related account id. 
        if (onOpportunityRecord) {
            if (relatedAccountId != '' && relatedAccountId != null) {
                strLocation = strLocation + '&accid=' + relatedAccountId;
            }
        }

        //if we're on an account record, set the account id from the main object id. 
        if (onAccountRecord) {
            strLocation = strLocation + '&accid=' + mainSalesforceId;
        }

        //otherwise we are on another object type which will have custom setup - let's not set a related account id.
    }

    strLocation = strLocation + '&name_firstcon2=' + firstname;
    strLocation = strLocation + '&name_lastcon2=' + lastname;
    strLocation = strLocation + '&con15=' + emailAddress;
    if (typeof phone != "undefined" && phone != "null") {
        strLocation = strLocation + '&con10=' + phone;
    }

    if (typeof mobile != "undefined" && mobile != "null") {
        strLocation = strLocation + '&con12=' + mobile;
    }

    if (typeof jobtitle != "undefined" && jobtitle != "null") {
        strLocation = strLocation + '&con5=' + jobtitle;
    }

    if (contactHasRecordTypes) {

        var strLocation = '/setup/ui/recordtypeselect.jsp?ent=Contact';
        strLocation = strLocation + '&retURL=%2F' + mainSalesforceId;
        strLocation = strLocation + '&save_new_url=%2F003%2Fe%3FretURL%3D%252F' + mainSalesforceId;
        strLocation = strLocation + '&name_firstcon2=' + firstname;
        strLocation = strLocation + '&name_lastcon2=' + lastname;
        strLocation = strLocation + '&con15=' + emailAddress;

        if (!onLeadRecord) {
            //if we're on a contact record, set the related account id. 
            if (onContactRecord) {
                if (relatedAccountId != '' && relatedAccountId != null) {
                    strLocation = strLocation + '&accid=' + relatedAccountId;
                }
            }

            //if we're on an opportunity record, set the related account id. 
            if (onOpportunityRecord) {
                if (relatedAccountId != '' && relatedAccountId != null) {
                    strLocation = strLocation + '&accid=' + relatedAccountId;
                }
            }

            //if we're on an account record, set the account id from the main object id. 
            if (onAccountRecord) {
                strLocation = strLocation + '&accid=' + mainSalesforceId;
            }

            //otherwise we are on another object type which will have custom setup - let's not set a related account id.
        }

        if (typeof phone != "undefined" && phone != "null") {
            strLocation = strLocation + '&con10=' + phone;
        }

        if (typeof mobile != "undefined" && mobile != "null") {
            strLocation = strLocation + '&con12=' + mobile;
        }

        if (typeof jobtitle != "undefined" && jobtitle != "null") {
            strLocation = strLocation + '&con5=' + jobtitle;
        }
    }

    //parent.window.location = strLocation;

    // open the add contact uri in new window.
    if(openInNewWindow){
        var win = window.open(strLocation, '_blank');
        win.focus();
    }else{ // or just direct there in the current window.
        parent.window.location = strLocation;
    }    
}

//handles redirect to add lead page in salesforce classic view.
function AddLeadClassicView(currentElement) {
    var emailId = j$(currentElement).attr('emailId');

    //log the event.
    LogEvent('AddLeadClicked', 'EmailDocumentId: ' + emailId, 446);

    var itemCount, item;
    var sentItem = false;

    if (emailId) {
        if (emailId.indexOf('S-') != -1) {

            itemCount = parseInt(emailId.replace('S-', ''));
            item = resultsListSent[itemCount];
            sentItem = true;
        }
        else {
            itemCount = parseInt();
            item = resultsListRec[itemCount];
        }
    }

    var fullname = '';
    var emailAddress = '';

    if (item != null) {
        if (!sentItem) {
            if (item.from != null) {

                if (item.from.name != null) {
                    fullname = item.from.name.split(' ');
                }
                if (item.from.address != null) {
                    emailAddress = item.from.address;
                }
            }
        }
        else {
            if (item.to != null) {

                if (item.to.name != null) {
                    fullname = item.to.name.split(' ');
                }
                if (item.to.address != null) {
                    emailAddress = item.to.address;
                }
            }
        }
    }

    var firstname = j$(currentElement).attr('firstname');
    var lastname = j$(currentElement).attr('lastname');
    var emailAddress = j$(currentElement).attr('emailAddress');
    var phone = j$(currentElement).attr('phonenumber');
    var mobile = j$(currentElement).attr('mobilenumber');
    var jobtitle = j$(currentElement).attr('jobtitle');

    var strLocation = '/00Q/e?retURL=%2F' + mainSalesforceId;
    strLocation = strLocation + '&name_firstlea2=' + firstname;
    strLocation = strLocation + '&name_lastlea2=' + lastname;
    strLocation = strLocation + '&lea11=' + emailAddress;
    strLocation = strLocation + '&lea3=' + currentObjectCompanyName;
    if (typeof phone != "undefined") {
        strLocation = strLocation + '&lea8=' + phone;
    }

    if (typeof mobile != "undefined") {
        strLocation = strLocation + '&lea9=' + mobile;
    }

    if (typeof jobtitle != "undefined") {
        strLocation = strLocation + '&lea4=' + jobtitle;
    }

    if (leadHasRecordTypes) {

        var strLocation = '/setup/ui/recordtypeselect.jsp?ent=Lead';
        strLocation = strLocation + '&retURL=%2F00Q%2Fo&save_new_url=%2F00Q%2Fe%3FretURL%3D%252F00Q%252Fo';
        strLocation = strLocation + '&name_firstlea2=' + firstname;
        strLocation = strLocation + '&name_lastlea2=' + lastname;
        strLocation = strLocation + '&lea11=' + emailAddress;
        strLocation = strLocation + '&lea3=' + currentObjectCompanyName;

        if (typeof phone != "undefined") {
            strLocation = strLocation + '&lea8=' + phone;
        }

        if (typeof mobile != "undefined") {
            strLocation = strLocation + '&lea9=' + mobile;
        }

        if (typeof jobtitle != "undefined") {
            strLocation = strLocation + '&lea4=' + jobtitle;
        }
    }

    //parent.window.location = strLocation;
    var win = window.open(strLocation, '_blank');
    win.focus();
}

//fires the add contact form event in salesforce lightning view.
function AddContactLightningView(currentElement) {
    var onLeadRecord = false;
    var onContactRecord = false;
    var onOpportunityRecord = false;
    var onAccountRecord = false;

    if (mainSalesforceId != null) {
        if (mainSalesforceId.length > 2) {
            var objectPrefix = mainSalesforceId.substring(0, 3);

            if (objectPrefix === '00Q') //lead
            {
                onLeadRecord = true;
            }

            if (objectPrefix === '003') //contact
            {
                onContactRecord = true;
            }

            if (objectPrefix === '006') //opportunity
            {
                onOpportunityRecord = true;
            }

            if (objectPrefix === '001') //account
            {
                onAccountRecord = true;
            }
        }
    }

    var relatedAccountIdParam = '';

    //if we are generating a lead there will be no associated account.
    if (!onLeadRecord) {
        //if we're on a contact record, set the related account id. 
        if (onContactRecord) {
            if (relatedAccountId != '' && relatedAccountId != null) {
                relatedAccountIdParam = relatedAccountId;
            }
        }

        //if we're on an opportunity record, set the related account id. 
        if (onOpportunityRecord) {
            if (relatedAccountId != '' && relatedAccountId != null) {
                relatedAccountIdParam = relatedAccountId;
            }
        }

        //if we're on an account record, set the account id from the main object id. 
        if (onAccountRecord) {
            relatedAccountIdParam = mainSalesforceId;
        }

        //otherwise we are on another object type which will have custom setup - let's not set a related account id.
    }

    var firstname = j$(currentElement).attr('firstname');
    var lastname = j$(currentElement).attr('lastname');
    var emailAddress = j$(currentElement).attr('emailAddress');
    var phone = j$(currentElement).attr('phonenumber');
    var mobile = j$(currentElement).attr('mobilenumber');
    var jobtitle = j$(currentElement).attr('jobtitle');

    if (typeof phone == "undefined" || phone == "null") {
        phone = '';
    }

    if (typeof mobile == "undefined" || mobile == "null") {
        mobile = '';
    }

    if (typeof jobtitle == "undefined" || jobtitle == "null") {
        jobtitle = '';
    }

    var defaultFieldValues = {
        'FirstName': '' + firstname,
        'LastName': '' + lastname,
        'Email': '' + emailAddress,
        'Phone': '' + phone,
        'MobilePhone': '' + mobile,
        'Title': '' + jobtitle,
        'AccountId': '' + relatedAccountIdParam
    };

    if (contactHasRecordTypes) {
        LoadRecordTypePicker('Contact', defaultFieldValues);
    } else {

        SfdcApp.projectOneNavigator.fireContainerEvent("force:createRecord",
            {
                entityApiName: "Contact",
                recordTypeId: null,
                defaultFieldValues: defaultFieldValues
            });
    }
}

//fires the add lead form event in salesforce lightning view.
function AddLeadLightningView(currentElement) {
    var emailId = j$(currentElement).attr('emailId');

    //log the event.
    LogEvent('AddLeadClicked', 'EmailDocumentId: ' + emailId, 446);

    //get the values to pass top the form.
    var firstname = j$(currentElement).attr('firstname');
    var lastname = j$(currentElement).attr('lastname');
    var emailAddress = j$(currentElement).attr('emailAddress');
    var phone = j$(currentElement).attr('phonenumber');
    var mobile = j$(currentElement).attr('mobilenumber');
    var jobtitle = j$(currentElement).attr('jobtitle');

    if (typeof phone == "undefined") {
        phone = '';
    }

    if (typeof mobile == "undefined") {
        mobile = '';
    }

    if (typeof jobtitle == "undefined") {
        jobtitle = '';
    }

    var defaultFieldValues = {
        'FirstName': '' + firstname,
        'LastName': '' + lastname,
        'Email': '' + emailAddress,
        'Phone': '' + phone,
        'MobilePhone': '' + mobile,
        'Title': '' + jobtitle,
        'Company': '' + currentObjectCompanyName
    };

    //if we have lead record types - go display the record type picker.
    if (leadHasRecordTypes) {
        LoadRecordTypePicker('Lead', defaultFieldValues);
    } else { //otherwise load the form.
        //fire the create record event.
        SfdcApp.projectOneNavigator.fireContainerEvent("force:createRecord",
            {
                entityApiName: "Lead",
                recordTypeId: null,
                defaultFieldValues: defaultFieldValues
            });
    }
}

function LoadRecordTypePicker(objectName, defaultFieldValues) {
    //show the modal and the overlay.
    j$("#chooseRecordTypeModal, .ebsta-modal-bodyoverlay").show();
    j$("#chooseRecordTypeModal").addClass("ebsta-display-table");

    //set the object header text.
    j$(".ebsta-objectname-header").text(objectName);

    //render the record types.
    var recordTypeList;

    //check which record type list we need. default to contact.
    if (objectName == "Lead") {
        recordTypeList = leadRecordTypeList;
    } else {
        recordTypeList = contactRecordTypeList;
    }

    //clear existing html first.
    j$("#recordTypeList").html("");

    var validRecordTypeCounter = 0;
    var primaryRecordTypeId = "012000000000000AAA"; //master record type by default.

    //loop through the record types.
    for (var key in recordTypeList) {
        //increment the counter.
        validRecordTypeCounter++;

        var obj = recordTypeList[key];

        var paragraphHolder = document.createElement("p");

        var button = document.createElement("button");
        button.type = "button";
        button.className = "btn btn-primary ebsta-recordtype-item btn-lg ebsta-mailpicker-button ebsta-main-modal-button slds-button slds-button--neutral slds-button--brand";
        button.setAttribute("data-toggle", "modal");
        button.setAttribute("data-target", "#myModal");
        button.setAttribute("statevalue", "101");
        button.setAttribute("statevalue", "101");
        button.setAttribute("recordtypeid", "" + key);
        button.appendChild(document.createTextNode("" + obj));

        primaryRecordTypeId = "" + key;

        paragraphHolder.append(button);

        j$("#recordTypeList").append(paragraphHolder);
    }

    //if we only have 1 record type, redirect automatically.
    if (validRecordTypeCounter < 2) {

        //fire the create record event.
        SfdcApp.projectOneNavigator.fireContainerEvent("force:createRecord",
            {
                entityApiName: "" + objectName,
                recordTypeId: primaryRecordTypeId,
                defaultFieldValues: defaultFieldValues
            });

        //hide the picker modals.
        j$("#chooseRecordTypeModal, .ebsta-modal-bodyoverlay").hide();
        j$("#chooseRecordTypeModal").removeClass("ebsta-display-table");
    } else { //otherwise set the events for the picker menu.

        //cancel hides the modal and overlay.
        j$("body").undelegate(".ebsta-recordtype-cancel", "click");
        j$("body").delegate(".ebsta-recordtype-cancel", "click", function (evt) {
            j$("#chooseRecordTypeModal, .ebsta-modal-bodyoverlay").hide();
            j$("#chooseRecordTypeModal").removeClass("ebsta-display-table");
            evt.preventDefault();
        });

        //selected record type hides the modal and overlay, then fires off the create record form request.
        j$("body").undelegate(".ebsta-recordtype-item", "click");
        j$("body").delegate(".ebsta-recordtype-item", "click", function (evt) {

            var recordTypeId = j$(this).attr("recordtypeid");

            //fire the create record event.
            SfdcApp.projectOneNavigator.fireContainerEvent("force:createRecord",
                {
                    entityApiName: "" + objectName,
                    recordTypeId: recordTypeId,
                    defaultFieldValues: defaultFieldValues
                });

            j$("#chooseRecordTypeModal, .ebsta-modal-bodyoverlay").hide();
            j$("#chooseRecordTypeModal").removeClass("ebsta-display-table");
            evt.preventDefault();
        });
    }
}

// redirect to download link for s3 object
function InitiateAttachmentDownload(dataObject, attachmentDownloandLoaderObject) {
    var data = JSON.parse(dataObject);

    if (data) {

        if (data.fileFound) {
            if (data.fileUrl && data.fileUrl.length > 0) {
                window.location.href = data.fileUrl;
            }
            else {
                var errorMessage = data.errorMessage || "Error in downloading file!";
                attachmentDownloandLoaderObject.displayError(errorMessage);
            }
        } else {
            var errorMessage = data.errorMessage || "Error in downloading file!";
            attachmentDownloandLoaderObject.displayError(errorMessage);
        }
    }
    else {
        var errorMessage = data.errorMessage || "Error in downloading file!";
        attachmentDownloandLoaderObject.displayError(errorMessage);
    }

}

// return object for managing loader and result for downloading attachment
function GetAttachmentDownloandLoaderObject(emailId) {
    var element = j$('#attachmentDownloadLoaderDiv' + emailId);
    var timeout;
    return {
        displayError: function (errorMessage) {
            if (timeout !== null) {
                clearTimeout(timeout);
                timeout = null;
            }
            element.html(document.createTextNode(errorMessage)).fadeIn();
            timeout = setTimeout(function () {
                element.fadeOut();
            }, 3000)
        }
    }
}

// return event handler to fire email attachment download from s3
function GetAttachmentDownloadEventHandler(attachmentId, attachmentDownloandLoaderObject) {
    return function () {
        GetEmailAttachmentDownloadLink(attachmentId, attachmentDownloandLoaderObject);
    }
}

function RenderAttachmentList(emailId, attachmentResult) {
    if (emailId > 0) {
        if (attachmentResult != null && typeof attachmentResult != "undefined") {
            j$(".attachmentListDiv" + emailId).text('No Attachments Found.');

            if (attachmentResult.length > 0) {
                var attachmentPopupList = document.createElement('ul');
                attachmentPopupList.setAttribute('class', 'slds-popover__content');


                //create object for managing attachment loader and result container
                var attachmentDownloandLoaderObject = GetAttachmentDownloandLoaderObject(emailId);

                for (var i = 0; i < attachmentResult.length; i++) {
                    var attachmentObject = attachmentResult[i];

                    var attachmentItemIcon = document.createElement('span');

                    //if we have added this to salesforce already indicate this with a green icon.
                    if (attachmentObject.addedToSalesforce) {
                        attachmentItemIcon.className = 'ebsta-attachments-icon-small ebsta-attachment-icon-green';
                    } else {
                        attachmentItemIcon.className = 'ebsta-attachments-icon-small';
                    }

                    var attachmentId = attachmentObject.emailAttachmentId;

                    if (attachmentId != null) {
                        AttachListenerToAttachmentIcon(attachmentItemIcon, attachmentId, attachmentObject.attachmentName);
                        attachmentItemIcon.setAttribute('attachmentId', attachmentId);
                    }

                    var attachmentItem = document.createElement('li');
                    attachmentItem.setAttribute('class', 'ebsta-attachment-singleitem pointer truncate');
                    attachmentItem.appendChild(attachmentItemIcon);

                    var anchorHolder = document.createElement('a');
                    anchorHolder.title = "Click to download";
                    anchorHolder.className = "attachment-link-download";
                    anchorHolder.appendChild(document.createTextNode(attachmentObject.attachmentName));

                    //add listener on attachment link to fire download from s3
                    anchorHolder.addEventListener('click', GetAttachmentDownloadEventHandler(attachmentId, attachmentDownloandLoaderObject));

                    attachmentItem.appendChild(anchorHolder);

                    attachmentPopupList.appendChild(attachmentItem);
                }

                j$(".attachmentListDiv" + emailId).html(attachmentPopupList);
            } else {
                //render nothing.
                j$(".attachmentListDiv" + emailId).text('No Attachments Found.');
            }
        } else {
            //render nothing.
            j$(".attachmentListDiv" + emailId).text('No Attachments Found.');
        }
    } else {
        //render nothing.
        j$(".attachmentListDiv" + emailId).text('No Attachments Found.');
    }
}

function CheckFilter(filterName) {
    for (var i = 0; i < searchFilterList.length; i++) {
        var filterItem = searchFilterList[i];

        if (filterItem.FieldName === filterName) {
            //we found the object in the list - remove it.
            searchFilterList.splice(i, 1);
        }
    }
}

function LoadTable(tabName) {
    //display the correct table.
    j$(".activeTable").removeClass("activeTable").addClass("ebstaHidden");
    j$(".sec-" + tabName).addClass("activeTable").removeClass("ebstaHidden");

    //display the correct tab selection.
    j$(".ebstaNav .active").removeClass("active");
    j$(".tab-" + tabName).addClass("active");

    ga('send', 'event', 'TableLoad', '' + tabName);
}

//display the status of mailbox connections.
function RenderMailboxStatus(mailboxSummaryObject) {
    var badMailboxes = 0;

    var totalMailboxes = mailboxSummaryObject.totalConnectedMailboxes;

    if (totalMailboxes > 0) {
        j$(".ebsta-connect-invisible").hide();

        //remove the existing menu items.
        j$(".ebsta-mailbox-row-dynamic").remove();

        var completedMailboxes = mailboxSummaryObject.mailboxesCompleted;

        if (totalMailboxes > completedMailboxes) //we are still syncing mailboxes
        {
            //display sync messaging.
            j$(".ebsta-notificationLabel").removeClass('ebsta-notificationLabel-hidden');
        } else {
            j$(".ebsta-notificationLabel").addClass('ebsta-notificationLabel-hidden');
        }

        var showReconnectScreen = false;
        var mailboxesForReconnect = [];
        var mailboxList = mailboxSummaryObject.mailboxList;

        var failedMailboxListTemp = localStorage.FailedMailboxes; //get the failed mailboxes we have already stored.

        var failedMailboxList = [];

        if (failedMailboxListTemp != null && typeof failedMailboxListTemp != "undefined") {
            //var existingList = JSON.parse(failedMailboxListTemp);

            failedMailboxList = j$.parseJSON(failedMailboxListTemp);

        }

        for (var i = 0; i < mailboxList.length; i++) {
            var mailboxObject = mailboxList[i];
            var mailboxName = mailboxObject.mailboxUsername;

            //render it in the menu.

            //create the list item.
            var mailboxMenuItem = document.createElement('li');
            mailboxMenuItem.className = 'ebsta-mailbox-row-dynamic';

            //create the link.
            var mailboxMenuItemLink = document.createElement('a');
            mailboxMenuItemLink.setAttribute('href', '#');
            mailboxMenuItemLink.appendChild(document.createTextNode(mailboxName));

            //create the icon.
            var mailboxMenuItemIcon = document.createElement('span');
            mailboxMenuItemIcon.className = 'ebsta-mailbox-menu-icon menu-icon-email pointer';

            if (mailboxObject.requiresReconnect === true) {
                mailboxMenuItemIcon.className = 'ebsta-mailbox-menu-icon menu-icon-warning pointer';
                mailboxMenuItem.className = "menu-mailbox-error ebsta-mailbox-row-dynamic";
                mailboxMenuItem.setAttribute('mailbox', mailboxName);
            } else {
                mailboxMenuItemIcon.className = 'ebsta-mailbox-menu-icon menu-icon-none no-pointer';
                mailboxMenuItemLink.className = 'no-pointer';
            }

            //add the icon to the list item.
            mailboxMenuItem.appendChild(mailboxMenuItemIcon);

            //add the link to the list item.
            mailboxMenuItem.appendChild(mailboxMenuItemLink);

            //add the list item to the menu.
            j$(".AddEmailAuth").after(mailboxMenuItem);

            //if we need to reconnect - show the popup
            if (mailboxObject.requiresReconnect === true) {
                badMailboxes++;

                showReconnectScreen = true;

                mailboxesForReconnect = FailedMailboxPromptExists(failedMailboxList, mailboxObject, mailboxesForReconnect);

            } else {
                //if this mailbox is good, clear it from the local storage list.    				

                RemoveLocalElement(mailboxObject);
            }
        }

        if (showReconnectScreen === true) {
            j$(".ebsta-mailbox-warning").show();

            localStorage.FailedMailboxes = JSON.stringify(mailboxesForReconnect);

            CheckForMailboxPrompts(false);
        } else {
            j$(".ebsta-options-menu-list").addClass('ebsta-thin-icon');
            j$(".ebsta-mailbox-warning").hide();
        }

    } else {
        //display not syncing message.

        j$(".ebsta-connect-invisible").show();
        j$(".ebsta-options-menu-list").addClass('ebsta-thin-icon');
    }

    //set the click event.
    j$("body").undelegate(".ebsta-options-menu-link", "click");
    j$("body").delegate(".ebsta-options-menu-link", "click", function () {

        j$(".ebsta-options-menu-list").slideToggle("fast");
    });

    j$("body").undelegate(".ebsta-options-menu-list", "mouseleave");
    j$("body").delegate(".ebsta-options-menu-list", "mouseleave", function () {

        j$(".ebsta-options-menu-list").hide();
    });

    j$("body").undelegate(".ebsta-attachmentlist-ul", "mouseleave");
    j$("body").delegate(".ebsta-attachmentlist-ul", "mouseleave", function () {

        j$(".ebsta-attachmentlist-ul").hide();
    });

    j$("body").undelegate(".menu-mailbox-error", "click");
    j$("body").delegate(".menu-mailbox-error", "click", function () {

        var mailbox = j$(this).attr('mailbox');

        RenderReconnectPrompt(mailbox, badMailboxes);
    });

    j$("body").undelegate(".ebsta-mailbox-warning", "click");
    j$("body").delegate(".ebsta-mailbox-warning", "click", function () {

        CheckForMailboxPrompts(true);
    });
}

function SetGlobalEvents() {

    //mouse click events.
    j$(document).mouseup(function (e) {
        var container = j$(".ebsta-filter-menu, .ebsta-date-filter-menu-div, #ui-datepicker-div, .ebsta-menu-ul");

        if (!container.is(e.target) // if the target of the click isn't the container...
            && container.has(e.target).length === 0) // ... nor a descendant of the container
        {
            container.hide();
        }
    });

    //mailboxconnection status check.
    //display status of mailbox connections.

    if (mailboxConnectionStatus != null) {
        if (mailboxConnectionStatus != 'REAUTH') {
            var mailboxSummaryObject = JSON.parse(mailboxConnectionStatus);
            RenderMailboxStatus(mailboxSummaryObject);
        }
    }
}

//check if there are failed mailboxes in local storage to prompt the user.
function CheckForMailboxPrompts(chooseAny) {
    var failedMailboxList = localStorage.FailedMailboxes;

    if (failedMailboxList != null && failedMailboxList != '') {
        var objectList = JSON.parse(failedMailboxList);
        var objectListFull = j$.parseJSON(failedMailboxList);

        for (var i = 0; i < objectListFull.length; i++) {
            var mailbox = objectListFull[i];

            if (chooseAny) {
                RenderReconnectPrompt(mailbox.mailboxUsername, objectList.length);

                break;
            } else {
                if (mailbox.promptShown !== true) //if we have not shown a prompt for this mailbox - show it now.
                {
                    objectListFull[i].promptShown = true;


                    localStorage.FailedMailboxes = JSON.stringify(objectListFull);

                    RenderReconnectPrompt(mailbox.mailboxUsername, objectList.length);

                    break;
                }
            }
        }
    }
}

function RenderReconnectPrompt(mailboxName, badMailboxTotal) {
    var additionalMailboxTextHint = '';

    if (badMailboxTotal > 1) {
        additionalMailboxTextHint = ' (1 of ' + badMailboxTotal + ')';
    }

    j$(".connectedMailboxFailures").html('');
    j$(".connectedMailboxFailures").append(document.createTextNode(mailboxName + additionalMailboxTextHint));

    j$("#reconnectEmailModal, .ebsta-modal-bodyoverlay").show(); //show the div and the overlay.
    j$("#connectEmailModal, #connectModal").hide(); //hide any exisiting popups.
}

function RemoveLocalElement(mailboxName) {
    var failedMailboxList = localStorage.FailedMailboxes;

    if (failedMailboxList != null && typeof failedMailboxList != "undefined") {
        var jsonList = j$.parseJSON(failedMailboxList);

        for (var i = 0; i < jsonList.length; i++) {
            var mailbox = jsonList[i];

            if (mailbox.mailboxConnectionId === mailboxName.mailboxConnectionId) //we found the item in the list; remove it.
            {
                var index = jsonList.indexOf(mailbox);

                if (index > -1) {
                    jsonList.splice(index, 1);
                }

                localStorage.FailedMailboxes = JSON.stringify(jsonList);
                break;
            }
        }
    }
}

function FailedMailboxPromptExists(failedMailboxesLocal, mailboxName, mailboxesForReconnect) {
    var foundMatch = false;

    if (failedMailboxesLocal != null) {
        for (var i = 0; i < failedMailboxesLocal.length; i++) {
            var mailbox = failedMailboxesLocal[i];

            if (mailbox.mailboxConnectionId === mailboxName.mailboxConnectionId) {
                mailboxesForReconnect.push(mailbox);
                foundMatch = true;

                break;
            }
        }
    }

    if (!foundMatch) {
        mailboxesForReconnect.push(mailboxName);
    }

    return mailboxesForReconnect;
}

function HandleEventError(event, method) {
    var renderErrorMessage = true;

    if (event.message != null) {
        if (event.message.indexOf('Error parsing json response') != -1) {
            if (event.message.indexOf('Unexpected token <') != -1) {
                renderErrorMessage = false;
            }
        }
    }

    if (renderErrorMessage) {
        if (event.type === 'exception') {
            document.getElementById("responseErrors").innerText = event.message;
        } else {
            document.getElementById("responseErrors").innerText = event.message;
        }
    }
}

function SetUpFilters() {
    //render the icons.

    //set up click events.

    //order by date
    j$("body").undelegate(".ebsta-date-orderby", "click");
    j$("body").delegate(".ebsta-date-orderby", "click", function () {
        var lastOrderBy = j$(this).attr('lastorderby');

        if (lastOrderBy === 'RecTimeAsc') {
            orderBy = 'RecTime'; //set the order by.
            j$(this).attr('RecTime', orderBy);
        } else {
            orderBy = 'RecTimeAsc';
            j$(this).attr('lastorderby', orderBy);
        }

        //log the event.
        LogEvent('SortDateClicked', 'OrderBy: ' + orderBy, 457);

        //LoadRecievedEmailsWithFilters(50, 1, globalSearchTerm); //load the data set back in.

        LoadActivity(50, 1, globalSearchTerm);
    });

    //order by user
    j$("body").undelegate(".ebsta-user-orderby", "click");
    j$("body").delegate(".ebsta-user-orderby", "click", function () {
        var lastOrderBy = j$(this).attr('lastorderby');

        if (lastOrderBy === 'FromEmailAddressAsc') {
            orderBy = 'FromEmailAddress'; //set the order by.
            j$(this).attr('lastorderby', orderBy);
        } else {
            orderBy = 'FromEmailAddressAsc';
            j$(this).attr('lastorderby', orderBy);
        }

        //log the event.
        LogEvent('SortUserClicked', 'OrderBy: ' + orderBy, 467);

        //LoadRecievedEmailsWithFilters(50, 1, globalSearchTerm); //load the data set back in.

        LoadActivity(50, 1, globalSearchTerm);
    });

    //order by contact
    j$("body").undelegate(".ebsta-contact-orderby", "click");
    j$("body").delegate(".ebsta-contact-orderby", "click", function () {
        var lastOrderBy = j$(this).attr('lastorderby');

        if (lastOrderBy === 'ToEmailAddressAsc') {
            orderBy = 'ToEmailAddress'; //set the order by.
            j$(this).attr('lastorderby', orderBy);
        } else {
            orderBy = 'ToEmailAddressAsc';
            j$(this).attr('lastorderby', orderBy);
        }

        //log the event.
        LogEvent('SortContactClicked', 'OrderBy: ' + orderBy, 456);

        //LoadRecievedEmailsWithFilters(50, 1, globalSearchTerm); //load the data set back in.

        LoadActivity(50, 1, globalSearchTerm);
    });

    //order by subject
    j$("body").undelegate(".ebsta-subject-orderby", "click");
    j$("body").delegate(".ebsta-subject-orderby", "click", function () {

        var lastOrderBy = j$(this).attr('lastorderby');

        if (lastOrderBy === 'SubjectAsc') {
            orderBy = 'Subject'; //set the order by.
            j$(this).attr('lastorderby', orderBy);
        } else {
            orderBy = 'SubjectAsc';
            j$(this).attr('lastorderby', orderBy);
        }

        //log the event.
        LogEvent('SortSubjectClicked', 'OrderBy: ' + orderBy, 458);

        //LoadRecievedEmailsWithFilters(50, 1, globalSearchTerm); //load the data set back in.

        LoadActivity(50, 1, globalSearchTerm);
    });

    //filter activity menu
    j$("body").undelegate(".ebsta-activity-filter", "click");
    j$("body").delegate(".ebsta-activity-filter", "click", function () {

        //log the event.
        LogEvent('ShowFilterActivityMenuClicked', 'ShowFilterActivityMenuClicked', 459);

        j$(".ebsta-activity-filter-menu-div").slideDown();
    });

    //filter contact menu
    j$("body").undelegate(".ebsta-contact-filter", "click");
    j$("body").delegate(".ebsta-contact-filter", "click", function () {

        //log the event.
        LogEvent('ShowFilterContactMenuClicked', 'ShowFilterContactMenuClicked', 460);

        j$(".ebsta-contact-filter-menu-div").toggle();
    });

    //filter date menu
    j$("body").undelegate(".ebsta-date-filter", "click");
    j$("body").delegate(".ebsta-date-filter", "click", function () {

        //log the event.
        LogEvent('ShowFilterDateMenuClicked', 'ShowFilterDateMenuClicked', 461);

        j$(".ebsta-date-filter-menu-div").toggle();
    });

    //filter user menu
    j$("body").undelegate(".ebsta-user-filter", "click");
    j$("body").delegate(".ebsta-user-filter", "click", function () {

        //log the event.
        LogEvent('ShowFilterUserMenuClicked', 'ShowFilterUserMenuClicked', 462);

        j$(".ebsta-user-filter-menu-div").toggle();
    });

    //clear all filters
    j$("body").undelegate(".ebsta-clear-filters", "click");
    j$("body").delegate(".ebsta-clear-filters", "click", function () {

        //log the event.
        LogEvent('ClearFiltersClicked', 'ClearFiltersClicked', 454);

        j$(".ebsta-email-search").val(''); //clear the search box.
        j$('.ebsta-activity-filter-radio, .ebsta-contact-filter-checkbox, .ebsta-user-filter-checkbox').prop('checked', false); //clear the radio selectors.
        orderBy = ''; //reset the order by.

        //clear the datefilters
        j$(".ebsta-filter-fromdate").val('');
        j$(".ebsta-filter-todate").val('');

        ApplyDefaultActivityViewSettings(false);
    });

    //hide the filter menus on mouseleave event.
    j$("body").undelegate(".ebsta-filter-menu", "mouseleave");
    j$("body").delegate(".ebsta-filter-menu", "mouseleave", function (e) {

        j$('.ebsta-filter-menu').slideUp();
    });

    //clear individual filters.
    j$("body").undelegate(".ebsta-clear-filtersection-contact", "click");
    j$("body").delegate(".ebsta-clear-filtersection-contact", "click", function () {

        RemoveFilterByType('To');
        j$(".ebsta-contact-filter-checkbox").prop('checked', false);
        j$(".ebsta-contact-filter-menu-div").hide();

        LoadActivity(50, 1, globalSearchTerm);
    });

    //clear individual filters.
    j$("body").undelegate(".ebsta-clear-filtersection-date", "click");
    j$("body").delegate(".ebsta-clear-filtersection-date", "click", function () {

        RemoveFilterByType('RecievedFrom');
        RemoveFilterByType('RecievedFromTo');

        //clear the datefilters
        j$(".ebsta-filter-fromdate").val('');
        j$(".ebsta-filter-todate").val('');

        j$(".ebsta-date-filter-menu-div").hide();

        //LoadRecievedEmailsWithFilters(50, 1, globalSearchTerm); //load the original set back in.

        LoadActivity(50, 1, globalSearchTerm);
    });

    //clear individual filters.
    j$("body").undelegate(".ebsta-clear-filtersection-user", "click");
    j$("body").delegate(".ebsta-clear-filtersection-user", "click", function () {

        RemoveFilterByType('From');
        j$(".ebsta-user-filter-checkbox").prop('checked', false);

        j$(".ebsta-user-filter-menu-div").hide();

        LoadActivity(50, 1, globalSearchTerm);
    });
}
var resultsListRec;

function RunDateSearch() {

    var fromDate = j$(".ebsta-filter-fromdate").val();
    var toDate = j$(".ebsta-filter-todate").val();

    if (fromDate !== null && fromDate !== '') //we need at least a from date.
    {
        j$(".ebsta-filter-fromdate").css("border-color", ""); //remove previous validation styles.

        if (toDate !== null && toDate !== '') //if we have a to date let's search with both.
        {
            j$(".ebsta-filter-todate").css("border-color", "");

            CheckFilter('RecievedFrom');
            CheckFilter('RecievedFromTo');
            AddFilter('RecievedFromTo', '', new Date(fromDate), new Date(toDate));

            //log the event.
            LogEvent('FilterDateClicked', 'FilterDates: ' + fromDate + ' - ' + toDate, 452);

            //LoadRecievedEmailsWithFilters(50, 1, globalSearchTerm);

            LoadActivity(50, 1, globalSearchTerm);

            j$(".ebsta-date-filter-menu-div").hide();
        } else {
            j$(".ebsta-filter-tpdate").css("border-color", "red");
        }
        //else{ //otherwise just run the from date.
        //	CheckFilter('RecievedFrom');		
        //	AddFilter('RecievedFrom', '', new Date(fromDate), '');
        //}


    } else { //validation messaging/highlighting.
        j$(".ebsta-filter-fromdate").css("border-color", "red");
    }
}

function AddActivityFilter(name, value, dateFrom, dateTo, selected) {

    //if selected, add to the standard selected filter list.
    if (selected) {
        AddFilter(name, value, dateFrom, dateTo);
    }

    //add to the additional filter list so we can store state.
    AddFilterDynamic(name, value, dateFrom, dateTo, selected);
}

function AddFilterDynamic(name, value, dateFrom, dateTo, selected) {
    var newDateFrom;
    var newDateTo;

    if (dateFrom !== '' && dateFrom !== null) {
        newDateFrom = dateFrom
    } else {
        newDateFrom = new Date();
        //newDateFrom = dtexample;
    }

    if (dateTo !== '' && dateTo !== null) {
        newDateTo = dateTo
    } else {
        newDateTo = new Date();
        //newDateTo = dtexample;
    }

    //1000(1s) x 60(1m) x 60(1h) x 24(1d) = 86400000 (1d)
    var diffMilliseconds = 86400000 - 1000; //1d - 1s 

    //make the todate dd/mm/yy 23:59:59
    var appendedDateTo = new Date(newDateTo.getTime() + diffMilliseconds);

    var newFilter = new FilterObjectWithState(name, value, newDateFrom.toUTCString(), appendedDateTo.toUTCString(), selected);

    additionalSearchFilterList.push(newFilter);

    j$(".ebsta-clear-filters-span").show();
}

function AddFilter(name, value, dateFrom, dateTo) {
    var newDateFrom;
    var newDateTo;

    if (dateFrom !== '' && dateFrom !== null) {
        newDateFrom = dateFrom
    } else {
        newDateFrom = new Date();
        //newDateFrom = dtexample;
    }

    if (dateTo !== '' && dateTo !== null) {
        newDateTo = dateTo
    } else {
        newDateTo = new Date();
        //newDateTo = dtexample;
    }

    //1000(1s) x 60(1m) x 60(1h) x 24(1d) = 86400000 (1d)
    var diffMilliseconds = 86400000 - 1000; //1d - 1s 

    //make the todate dd/mm/yy 23:59:59
    var appendedDateTo = new Date(newDateTo.getTime() + diffMilliseconds);

    var newFilter = new FilterObject(name, value, newDateFrom.toUTCString(), appendedDateTo.toUTCString());

    searchFilterList.push(newFilter);

    j$(".ebsta-clear-filters-span").show();
}

function toSFDate(dateObj) {

    // string format is YYYY-MM-DDThh:mm:ssZ           
    var dateStr = dateObj.getFullYear() + '-' + pad2(dateObj.getMonth() + 1) + '-' + pad2(dateObj.getDate()) + 'T' + pad2(dateObj.getHours()) + ':' + pad2(dateObj.getMinutes()) + ':' + pad2(dateObj.getSeconds()) + 'Z';
    return dateStr;
}

function pad2(number) {
    return (number < 10 ? '0' : '') + number
}

function RemoveFilterByType(name) {

    for (var i = 0; i < searchFilterList.length; i++) {
        var filterItem = searchFilterList[i];


        if (filterItem.FieldName === name) {

            //we found the object in the list - remove it.
            searchFilterList.splice(i, 1);
        }
    }
}

function RemoveFilter(name, value, dateFrom, dateTo) {

    for (var i = 0; i < searchFilterList.length; i++) {
        var filterItem = searchFilterList[i];

        if (filterItem.FieldName === name && filterItem.FieldValue === value) {
            //we found the object in the list - remove it.
            searchFilterList.splice(i, 1);
        }
    }
}

function AddMarkerToEmail(result, emailId) {

    j$("span[markemailId='" + emailId + "']").removeClass('addEmail');
    j$("span[markemailId='" + emailId + "']").removeClass("ebsta-loader").addClass("addEmailAdded");
    j$("span[markemailId='" + emailId + "']").attr('sfid', '' + result);
    j$("span[markemailId='" + emailId + "']").attr('title', 'View Email');

    var addEmailSuccessGif = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--small slds-m-right--small ebsta-green-text', '#email');

    j$("span[markemailId='" + emailId + "']").html(addEmailSuccessGif);

    j$("span[markemailId='" + emailId + "']").on("click", function () {
        var salesforceRecordId = j$(this).attr('sfId');
        //parent.window.location = '/' + salesforceRecordId;  

        var win = window.open('/' + salesforceRecordId, '_blank');
        win.focus();
    });
}

function ResetAddEmailIcon(emailId){
    j$("span[markemailId='" + emailId + "']").removeClass("ebsta-loader").addClass("addEmail").attr('title', 'Add Email to Salesforce');
}

function AddMarkerToEmailV2(result, emailId, isEmail) {

    if (isEmail) //if the activity is an email, render the correct email icon.
    {
        j$("span[markemailId='" + emailId + "']").removeClass('addEmail');
        j$("span[markemailId='" + emailId + "']").removeClass("ebsta-loader").addClass("addEmailAdded");
        j$("span[markemailId='" + emailId + "']").attr('sfid', '' + result);
        j$("span[markemailId='" + emailId + "']").attr('title', 'View Email');
    } else { //otherwise render the activity icon.
        j$("span[markemailId='" + emailId + "']").removeClass('addTask');
        j$("span[markemailId='" + emailId + "']").removeClass("ebsta-loader").addClass("activityTaskAdded");
        j$("span[markemailId='" + emailId + "']").attr('sfid', '' + result);
        j$("span[markemailId='" + emailId + "']").attr('title', 'View Task');
    }

    //var addEmailSuccessGif = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--small slds-m-right--small ebsta-green-text', '#email');

    //j$("span[markemailId='" + emailId + "']").html(addEmailSuccessGif);

    j$("span[markemailId='" + emailId + "']").off("click"); // remove click event before resetting it, otherwise we dupe the task.
    j$("span[markemailId='" + emailId + "']").on("click", function () {
        var salesforceRecordId = j$(this).attr('sfId');
        //parent.window.location = '/' + salesforceRecordId;  

        var win = window.open('/' + salesforceRecordId, '_blank');
        win.focus();
    });

}

//var globalAlertsCounter = 0;
function DisplayAlertResults(jsontxt, pageNumber) {
    var data1 = JSON.parse(jsontxt);

    var resultsAlerts = data1.Results;

    var totalPages = data1.TotalPages;
    var searchTerm = data1.SearchTerm;
    var totalResults1 = data1.TotalRecords;

    // update global counter.
    totalAlertResults = totalResults1;

    if (resultsAlerts.length == 0) {
        j$('.alertsCounter').text('(0)');
        DisplayNoResults(6, 'alertsTable', 'alerts');
    } else {
        j$('.alertsCounter').text('(' + totalResults1 + ')');

        j$(".alertsTable").html('');

        for (var i = 0; i < resultsAlerts.length; i++) {

            var dataItem = resultsAlerts[i];

            var newRow = document.createElement('tr');
            newRow.setAttribute('emailId', '' + dataItem.AlertsId);
            newRow.setAttribute('class', 'emailRow ebsta-row');
            newRow.setAttribute('title', '');
            newRow.id = 'alertrowid-' + dataItem.ElasticsearchId;

            var newCell1 = document.createElement('td');
            var spanTracking1 = document.createElement('span');

            if (dataItem.Processed != null) {
								spanTracking1.appendChild(document.createTextNode(FormatDateWithDayName(dataItem.CreatedDate)));
            }

            newCell1.appendChild(spanTracking1);

            var newCell2 = document.createElement('td');
            var spanTracking2 = document.createElement('span');
            spanTracking2.setAttribute('class', 'name-cell');

            // new contact alert.
            if (dataItem.AlertType + '' === '1')
            {
                spanTracking2.classList.add("contact-icon-missing");
            }else{
                if (dataItem.RecordType === "Contact") {
                    spanTracking2.classList.add("contact-icon");
                } else if (dataItem.RecordType === "Lead") {
                    spanTracking2.classList.add("lead-icon");
                }
            }            

            if (dataItem.Name != null) {

                if(dataItem.SalesforceId !== undefined && dataItem.SalesforceId !== null && dataItem.SalesforceId.length > 0 
                    && (dataItem.SalesforceId.indexOf('003') === 0 || dataItem.SalesforceId.indexOf('00Q') === 0)){

                    var nameAnchor = document.createElement('a');
                    nameAnchor.href = '/' + dataItem.SalesforceId;
                    nameAnchor.target = '_blank';
                    nameAnchor.innerText = dataItem.Name;

                    spanTracking2.appendChild(nameAnchor);
                }else{
                    spanTracking2.appendChild(document.createTextNode(dataItem.Name));
                }                
            }

            newCell2.appendChild(spanTracking2);


            var newCell3 = document.createElement('td');
            var spanTracking3 = document.createElement('span');

            if (dataItem.Message != null) {
                spanTracking3.appendChild(document.createTextNode(dataItem.Message));
            }

            newCell3.appendChild(spanTracking3);


            var newCell4 = document.createElement('td');
            var spanTracking4 = document.createElement('span');

            if (dataItem.UnFormattedCorrection != null) {
                var correctionValue = '' + dataItem.UnFormattedCorrection;

                if (dataItem.AlertType + '' === '8') {
                    if (dataItem.Correction + '' === 'true' || dataItem.Correction + '' === 'True') {
                        correctionValue = '';
                    }
                }

                spanTracking4.appendChild(document.createTextNode(correctionValue));
            }

            // action icon table
            var actionsTable = document.createElement('table');
            actionsTable.setAttribute('class', 'new-values-column-table');

            // remove/ignore alert icon.
            var ignoreLink = document.createElement('a');
            //ignoreLink.appendChild(document.createTextNode("Ignore"));
            ignoreLink.setAttribute('actionId', '' + dataItem.ActionId);
            ignoreLink.setAttribute('alertId', '' + dataItem.AlertsId);
            ignoreLink.className = 'ebsta-action-ignore';
            ignoreLink.title = 'Remove';    
            ignoreLink.setAttribute('esid', '' + dataItem.ElasticsearchId);
            ignoreLink.id = 'alerticonignore-' + dataItem.ElasticsearchId;

            // sub table for listing record fields.
            var newValuesColumn = document.createElement('table');
            newValuesColumn.setAttribute('class', 'new-values-column-table');

            // select the list of fields for potential updates if any.
            var updateFields = dataItem.SalesforceUpdateFields;

            // for phone fields - if we have multiple fields we can updarte, render them all.
            if (updateFields != undefined && updateFields != null && updateFields.length > 0) {
                newCell4.appendChild(newValuesColumn);

                // loop the additional fields.
                for(var k = 0; k < updateFields.length; k++){
                    // existing field object.
                    var updateField = updateFields[k];

                    // create the row/cell for displaying the field data.
                    var fieldRow = document.createElement('tr');
                    var fieldCell = document.createElement('td');

                    // div for the field label.
                    var divExistingValueLabel = document.createElement('div');
                    divExistingValueLabel.setAttribute('class', 'new-value-name');
                    divExistingValueLabel.appendChild(document.createTextNode(updateField.FriendlyName));
                    fieldCell.appendChild(divExistingValueLabel);

                    // div for the field value.
                    var divExistingValue = document.createElement('div');
                    divExistingValue.setAttribute('class', 'new-value');

                    if(updateField.FieldValue !== undefined && updateField.FieldValue !== null && updateField.FieldValue.length > 0){
                        divExistingValue.appendChild(document.createTextNode(updateField.FieldValue));
                    }else{
                        divExistingValue.setAttribute('class', 'new-value new-value-name');
                        divExistingValue.appendChild(document.createTextNode('No value'));
                    }
                                        
                    fieldCell.appendChild(divExistingValue);

                    // add the cell to the row.
                    fieldRow.appendChild(fieldCell);

                    // create the row/cell for displaying the action icon.
                    var actionRow = document.createElement('tr');                    

                    // add properties for hidden / view more fields.
                    if(k > 1){
                        // field data row.
                        fieldRow.setAttribute('class', 'cat' + i);
                        fieldRow.setAttribute('style', 'display:none');

                        // action table row.
                        actionRow.setAttribute('class', 'cat' + i);
                        actionRow.setAttribute('style', 'display:none');
                    }

                    actionRow.classList.add("fieldaction");

                    // add new row to the inner table for rendering field data.
                    newValuesColumn.appendChild(fieldRow);

                    var actionCell = document.createElement('td');
                    var ignoreCell = document.createElement('td');                    

                    // only render ignore icon in the first row.
                    if(k == 0){
                        ignoreCell.appendChild(ignoreLink);
                    }

                    // render the icon action.
                    var actionLink = document.createElement('a');
                    actionLink.setAttribute('actionId', '' + dataItem.ActionId);
                    actionLink.setAttribute('alertId', '' + dataItem.AlertsId);
                    actionLink.className = 'action-update-record';
                    actionLink.title = 'Update';
                    actionLink.setAttribute('esid', '' + dataItem.ElasticsearchId);
                    actionLink.id = 'alerticonaction-' + dataItem.ElasticsearchId;

                    // field data.
                    actionLink.setAttribute('updatefield', '' + updateField.ApiName);
                    actionLink.setAttribute('updatevalue', '' + dataItem.UnFormattedCorrection);
                    actionLink.setAttribute('salesforceid', '' + dataItem.SalesforceId);

                    actionCell.appendChild(actionLink);

                    actionRow.appendChild(actionCell);
                    actionRow.appendChild(ignoreCell);

                    // add new row to the inner table for rendering action icons.
                    actionsTable.appendChild(actionRow);
                }

                // if we have more than  2 fields render 'show more' expander.
                if(updateFields.length > 1){
                    var showMoreButton = document.createElement('div');
                    showMoreButton.setAttribute('class', 'show-more-button toggler');
                    showMoreButton.setAttribute('data-prod-cat', i);
                    showMoreButton.appendChild(document.createTextNode('Show more'));
                    newValuesColumn.appendChild(showMoreButton);
                }
            }else{ // standard action cell (none-phone number)
                // create the row/cell for displaying the action icon.
                var actionRowStandard = document.createElement('tr');   

                // create table cells.
                var actionCellStandard = document.createElement('td');
                var ignoreCellStandard = document.createElement('td');  

                // render the icon action.
                var actionLinkStandard = document.createElement('a');
                actionLinkStandard.setAttribute('actionId', '' + dataItem.ActionId);
                actionLinkStandard.setAttribute('alertId', '' + dataItem.AlertsId);
                actionLinkStandard.className = 'action-update-record';
                actionLinkStandard.title = 'Update';
                actionLinkStandard.setAttribute('esid', '' + dataItem.ElasticsearchId);
                actionLinkStandard.id = 'alerticonaction-' + dataItem.ElasticsearchId;

                // field data - if not a phone number it's job title by default as we're not handling other types.
                // TODO: expand this dynamically for different types in future.
                actionLinkStandard.setAttribute('updatefield', 'Title');
                actionLinkStandard.setAttribute('updatevalue', '' + dataItem.UnFormattedCorrection);
                actionLinkStandard.setAttribute('salesforceid', '' + dataItem.SalesforceId);

                // add icons to the table cells.
                actionCellStandard.appendChild(actionLinkStandard);
                ignoreCellStandard.appendChild(ignoreLink);

                // add cells to the table row.
                actionRowStandard.appendChild(actionCellStandard);
                actionRowStandard.appendChild(ignoreCellStandard);

                // add new row to the inner table for rendering action icons.
                actionsTable.appendChild(actionRowStandard);

                // existing value.

                //TODO: render the original value.

                newCell4.appendChild(document.createTextNode(dataItem.OriginalValue));
            }

            // cell for the action/ignore icons.
            var newCell5 = document.createElement('td');
            newCell5.setAttribute('class', 'action-row');                    

            // if this is a new contact alert render a different icon and popup menu.
            if (dataItem.AlertType + '' === '1')
            {
                var firstName = '';
                var lastName = '';
                var emailAddress = '';
                var phoneNumber = '';
                var jobTitle = '';

                var mobileNumber = '';

                if (dataItem.Detail != null) {
                    var newRecordDetails = JSON.parse(dataItem.Detail);

                    var fullName = '' + newRecordDetails.ContactName;

                    var nameSplitter = fullName.split(' ');

                    firstName = nameSplitter[0];

                    if (nameSplitter.length > 1) {
                        lastName = nameSplitter[1];
                    }

                    emailAddress = newRecordDetails.EmailAddress;
                    phoneNumber = newRecordDetails.Phone;
                    jobTitle = newRecordDetails.JobTitle;
                    mobileNumber = newRecordDetails.Mobile;
                }

                var addNewObjectSpan = document.createElement('span');
                addNewObjectSpan.setAttribute('firstname', '' + firstName);
                addNewObjectSpan.setAttribute('lastname', '' + lastName);
                addNewObjectSpan.setAttribute('emailaddress', '' + emailAddress);
                addNewObjectSpan.setAttribute('emailId', '' + dataItem.AlertsId);
                addNewObjectSpan.setAttribute('phonenumber', '' + phoneNumber);
                addNewObjectSpan.setAttribute('jobTitle', '' + jobTitle);
                addNewObjectSpan.setAttribute('mobilenumber', '' + mobileNumber);
                addNewObjectSpan.title = 'Create New Record';
                addNewObjectSpan.className = 'addContactAlert slds-icon__container pointer ';

                var menuHolderDiv = document.createElement('div');
                menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left addcontactlead-menu-div-' + dataItem.alertsId;
                menuHolderDiv.setAttribute('role', 'dialog');

                var contactPopupMenu = document.createElement('ul');
                contactPopupMenu.setAttribute('class', 'slds-popover__content');

                var menuItem1 = document.createElement('li');
                menuItem1.setAttribute('class', 'addContactAlert pointer');
                menuItem1.setAttribute('firstname', '' + firstName);
                menuItem1.setAttribute('lastname', '' + lastName);
                menuItem1.setAttribute('emailaddress', '' + emailAddress);
                menuItem1.setAttribute('emailId', '' + dataItem.AlertsId);
                menuItem1.setAttribute('phonenumber', '' + phoneNumber);
                menuItem1.setAttribute('jobTitle', '' + jobTitle);
                menuItem1.setAttribute('mobileNumber', '' + mobileNumber);

                var menuItem2 = document.createElement('li');
                menuItem2.setAttribute('class', 'addLead pointer');
                menuItem2.setAttribute('firstname', '' + firstName);
                menuItem2.setAttribute('lastname', '' + lastName);
                menuItem2.setAttribute('emailaddress', '' + emailAddress);
                menuItem2.setAttribute('emailId', '' + dataItem.AlertsId);
                menuItem2.setAttribute('phonenumber', '' + phoneNumber);
                menuItem2.setAttribute('jobTitle', '' + jobTitle);
                menuItem2.setAttribute('mobileNumber', '' + mobileNumber);

                var menuLink = document.createElement('a');
                menuLink.appendChild(document.createTextNode('Create New Contact Record'));

                menuItem1.appendChild(menuLink);

                var menuLink2 = document.createElement('a');
                menuLink2.appendChild(document.createTextNode('Create New Lead Record'));

                menuItem2.appendChild(menuLink2);

                if (userHasContactAccess == "true") {
                    contactPopupMenu.appendChild(menuItem1);
                }

                if (userHasLeadAccess == "true") {
                    contactPopupMenu.appendChild(menuItem2);
                }

                menuHolderDiv.appendChild(contactPopupMenu);

                //Add contact/lead button - uncomment to hide in lightning mode.
                //if(!lightningMode)
                //{
                ////newCell5.appendChild(addNewObjectSpan);
                ////newCell5.appendChild(menuHolderDiv);

                // action icon table
                var actionsTableNew = document.createElement('table');
                actionsTableNew.setAttribute('class', 'new-values-column-table actionsnewcontact');

                // create the row/cell for displaying the action icon.
                var actionRowNew = document.createElement('tr');  

                // create table cells.
                var actionCellNew = document.createElement('td');
                var ignoreCellNew = document.createElement('td');  

                actionCellNew.appendChild(addNewObjectSpan);
                actionCellNew.appendChild(menuHolderDiv);
                ignoreCellNew.appendChild(ignoreLink);

                // add cells to the table row.
                actionRowNew.appendChild(actionCellNew);
                actionRowNew.appendChild(ignoreCellNew);

                // add new row to the inner table for rendering action icons.
                actionsTableNew.appendChild(actionRowNew);

                newCell5.appendChild(actionsTableNew);
                //}
            } else if (dataItem.AlertType + '' !== '1') { // render the action links by default for all other alert types.
                newCell5.appendChild(actionsTable);
            }       	

            ////newCell5.appendChild(ignoreLink);

            var newCell6 = document.createElement('td');
            var spanTracking6 = document.createElement('span');
            if (dataItem.UnFormattedCorrection != null) {
                spanTracking6.appendChild(document.createTextNode(dataItem.UnFormattedCorrection));
            }
            newCell6.appendChild(spanTracking6);

            newCell1.classList.add('alertcell');
            newCell2.classList.add('alertcell');
            newCell3.classList.add('alertcell');
            newCell4.classList.add('alertcell');
            newCell5.classList.add('alertcell');
            newCell6.classList.add('alertcell');

            newRow.appendChild(newCell1); //date
            newRow.appendChild(newCell3); //type
            newRow.appendChild(newCell2); //name
            newRow.appendChild(newCell6); //new value
            newRow.appendChild(newCell4); //existing value / values
            newRow.appendChild(newCell5); //action/ignore                

            j$(".alertsTable").append(newRow);
        }



    }
    toggleShowMore();
    ApplyDisplayEvents();
}

function TruncateEmailAddress(inputString, trimIndex) {
    if (inputString != null) {
        if (inputString.length > trimIndex) {
            inputString = inputString.substring(0, trimIndex) + '...';

            return inputString;
        } else {
            return inputString;
        }
    }

    return inputString;
}

function DisplayResultsActivity(jsontxt, pageNumber, searchObject) {
    var data1 = JSON.parse(jsontxt);

    resultsListRec = data1.SearchResultsItems;
    var totalPages = data1.TotalPages;
    var searchTerm = searchObject;
    var totalResults1 = data1.TotalRecords;
    LogThis(data1);
    if (resultsListRec.length == 0) {
        j$('.activityCounter').text('(0)');
        DisplayNoResults(8, 'activityTable', 'activities');
    } else {

        var additionalRecordText = '';

        if (totalPages > 1) {
            additionalRecordText = '+';
        }

        j$('.activityCounter').text('(' + totalResults1 + ')');

        j$(".activityTable").html('');

        for (var i = 0; i < resultsListRec.length; i++) {

            var dataItem = resultsListRec[i];

            var emailType = dataItem.EmailType;

            var newRow = document.createElement('tr');
            newRow.setAttribute('emailId', '' + dataItem.EmailDocumentId);

            newRow.setAttribute('title', '');

            var newCell1 = document.createElement('td');
            var spanTracking1 = document.createElement('span');

            var sentInternal = dataItem.SentInternal;

            var mailDirectionIcon = document.createElementNS("http://www.w3.org/2000/svg", "svg");
            mailDirectionIcon.setAttribute('aria-hidden', 'true');
            mailDirectionIcon.setAttribute('class', 'slds-icon-replacement-class lds-icon-text-default slds-icon--small');

            var forwardLink = document.createElementNS("http://www.w3.org/2000/svg", "use");

            //forwardLink.appendChild(document.createTextNode(''));  

            var svgLink = '';
            var svgTitle = '';

            var isSalesforceTask = false;

            var newIconSpan = document.createElement('span');
            var emailTypeSpan = document.createElement('span');
            emailTypeSpan.setAttribute('class', 'ebsta-ooo-activity ebsta-display-svg-medium ebsta-fill-red');

            //render inbound/outbound icons for email objects.
            if (dataItem.IndexType == 1 || dataItem.IndexType == 5 || dataItem.IndexType == 20) {
                if (sentInternal) {
                    spanTracking1.setAttribute('class', 'activityEmailOutbound');
                    spanTracking1.setAttribute('title', 'Email Sent');
                    newIconSpan.className = 'slds-icon__container activityEmailOutbound';

                    svgLink = '#back';
                    svgTitle = 'Email Sent';

                } else {
                    spanTracking1.setAttribute('class', 'activityEmailInbound');
                    spanTracking1.setAttribute('title', 'Email Received');
                    newIconSpan.className = 'slds-icon__container activityEmailInbound';

                    svgLink = '#forward';
                    svgTitle = 'Email Received';
                }
            } else { //render icons for other activities and phone calls.

                var activityTypeFound = false;

                //CallOutBound.
                if (emailType == 10) {
                    activityTypeFound = true;
                    isSalesforceTask = true;

                    if (sentInternal) {
                        spanTracking1.setAttribute('class', 'activityCallOutbound');
                        spanTracking1.setAttribute('title', 'Outbound Call');
                        newIconSpan.className = 'slds-icon__container activityCallOutbound';
                        newIconSpan.title = 'Outbound Call';
                        svgTitle = 'Outbound Call';
                    } else {
                        spanTracking1.setAttribute('class', 'activityCallInbound');
                        spanTracking1.setAttribute('title', 'Inbound Call');
                        newIconSpan.className = 'slds-icon__container activityCallInbound';
                        newIconSpan.title = 'Inbound Call';
                        svgTitle = 'Inbound Call';
                    }
                }

                //CallOutBound.
                if (emailType == 11) {
                    activityTypeFound = true;
                    isSalesforceTask = true;

                    spanTracking1.setAttribute('class', 'activityCallOutbound');
                    spanTracking1.setAttribute('title', 'Outbound Call');
                    newIconSpan.className = 'slds-icon__container activityCallOutbound';
                    svgTitle = 'Outbound Call';
                }

                //CallInBound.
                if (emailType == 12) {
                    isSalesforceTask = true;

                    activityTypeFound = true;
                    spanTracking1.setAttribute('class', 'activityCallInbound');
                    spanTracking1.setAttribute('title', 'Inbound Call');
                    newIconSpan.className = 'slds-icon__container activityCallInbound';
                    svgTitle = 'Inbound Call';
                }

                //emails sent. (from activity)
                if (emailType == 13) {
                    isSalesforceTask = true;

                    activityTypeFound = true;
                    spanTracking1.setAttribute('class', 'activityEmailOutbound');
                    spanTracking1.setAttribute('title', 'Email Sent');
                    newIconSpan.className = 'slds-icon__container activityEmailOutbound';
                    svgTitle = 'Email Sent';
                }

                //emails recieved. (from activity)
                if (emailType == 14) {
                    isSalesforceTask = true;

                    activityTypeFound = true;
                    spanTracking1.setAttribute('class', 'activityEmailInbound');
                    spanTracking1.setAttribute('title', 'Email Received');
                    newIconSpan.className = 'slds-icon__container activityEmailInbound';
                    svgTitle = 'Email Received';
                }

                //meeting. (from activity)
                if (emailType == 15) {
                    activityTypeFound = true;
                    spanTracking1.setAttribute('class', 'activityMeeting');
                    spanTracking1.setAttribute('title', 'Meeting');
                    newIconSpan.className = 'slds-icon__container activityMeeting';
                    svgTitle = 'Meeting';
                }

                //generic task.
                if (emailType == 16) {
                    isSalesforceTask = true;
                    activityTypeFound = true;
                    spanTracking1.setAttribute('class', 'activityTaskDefault');
                    spanTracking1.setAttribute('title', 'Task');
                    newIconSpan.className = 'slds-icon__container activityTaskDefault';
                    newIconSpan.title = 'Task';
                    svgTitle = 'Task';
                }

                //generic event.
                if (emailType == 17) {
                    activityTypeFound = true;
                    spanTracking1.setAttribute('class', 'activityTaskDefault');
                    spanTracking1.setAttribute('title', 'Event');
                    newIconSpan.className = 'slds-icon__container activityTaskDefault';
                    newIconSpan.title = 'Event';
                    svgTitle = 'Event';
                }

                //if we don't have a specified activity type - set the default task symbol.
                if (!activityTypeFound) {
                    spanTracking1.setAttribute('class', 'activityTaskDefault');
                    spanTracking1.setAttribute('title', 'Task');
                    newIconSpan.className = 'slds-icon__container activityTaskDefault';
                    newIconSpan.title = 'Task';
                    svgTitle = 'Task';
                }
            }

            var mailDirectionIcon = CreateSvgWithUseTag('slds-icon-replacement-class slds-icon-text-default slds-icon--tiny', svgLink);

            newIconSpan.appendChild(mailDirectionIcon);
						newIconSpan.setAttribute('title', svgTitle);

            var emailType = '' + dataItem.EmailType;

            var rowClassString = 'emailRow ebsta-row';

            if (emailType === "2") {
                //grey out the row.                        	
                //rowClassString = 'emailRow ebsta-row ebsta-outofoffice-tr';

                //add out of office icon.                        	
                //var oOOIcon = CreateSvgWithUseTag('', '#warning');                         
                //emailTypeSpan.appendChild(oOOIcon);
                emailTypeSpan.setAttribute('title', 'Out of Office');
                emailTypeSpan.className = emailTypeSpan.className + ' ebsta-outofoffice-icon';
                emailTypeSpan.title = 'Out of office';

                spanTracking1.className = spanTracking1.className + ' ebsta-outofoffice-icon-overide';

                newCell1.appendChild(emailTypeSpan);
            }

            newRow.setAttribute('class', rowClassString);

            newCell1.appendChild(newIconSpan);

            var newCell3 = document.createElement('td');

            var subjectLink = document.createElement('a');
            subjectLink.href = '#';
            subjectLink.appendChild(document.createTextNode(dataItem.Subject));

            newCell3.appendChild(subjectLink);


            if (dataItem.IndexType == 10 || dataItem.HasNoDescription) {
                newCell3.setAttribute('class', 'emailNoExpand');
            } else {
                newCell3.setAttribute('class', 'emailExpand');
            }

            newCell3.setAttribute('emailId', '' + dataItem.EmailDocumentId);

						var newCell4 = document.createElement('td');
						newCell4.setAttribute('class', 'date-in-activities');

            //if this is a salesforce task.
            if (isSalesforceTask) {
                //in salesforce activities we may have no date - do not try to format/render empty or min date value.
                if (dataItem.ReceivedTime + "" !== "0001-01-01T00:00:00") {
										//format the rec time as a date without time - do not apply locale offset.
										newCell4.appendChild(document.createTextNode(FormatDate(dataItem.ReceivedTime, true)));
                } else {
                    newCell4.appendChild(document.createTextNode(""));
                }
            } else {
                //in salesforce activities we may have no date - do not try to format/render empty or min date value.
                if (dataItem.ReceivedTime + "" !== "0001-01-01T00:00:00") {
										//otherwise render the rec datetime in the users' locale.
										newCell4.appendChild(document.createTextNode(FormatDateTime(dataItem.ReceivedTime)));
                } else {
                    newCell4.appendChild(document.createTextNode(""));
                }
            }

            var newCell7 = document.createElement('td');

            var addContact1 = document.createElement('span');
            var addLead1 = document.createElement('span');

            var contactIconRef = '';

            var renderLeadIcon = false;
            var renderContactIcon = false;
            var renderAddRecordIcon = false;

            if (dataItem.RelatedId != '' && dataItem.RelatedId != null) {

                renderContactIcon = true;
                addContact1.setAttribute('class', 'foundContact slds-icon__container pointer');

                //standard email objects.
                if (dataItem.IndexType == 1 || dataItem.IndexType == 5 || dataItem.IndexType == 20) {
                    addContact1.setAttribute('sfId', '' + dataItem.RelatedId);
                } else { //other activity types.
                    if (dataItem.To.Address != null && typeof dataItem.To.Address != 'undefined' && dataItem.To.Address != '') {

                        // if related item on a task/event is a lead switch the icon flags to render correct icon.
                        if(dataItem.To.Address.indexOf('00Q') === 0){
                            addContact1.setAttribute('class', 'foundLead slds-icon__container pointer');
                            renderContactIcon = false;
                            renderLeadIcon = true;
                        }

                        addContact1.setAttribute('sfId', '' + dataItem.To.Address);                        
                    } else {
                        addContact1.setAttribute('class', '');
                    }
                }

                addContact1.setAttribute('title', 'View Contact Record');
                addContact1.setAttribute('style', 'margin-right: 10px;');
                contactIconRef = '#user';
            }
            else {
                addContact1.setAttribute('class', 'addContact slds-icon__container pointer');
                addContact1.setAttribute('title', 'Create New Contact Record');
                contactIconRef = '#adduser';

                renderAddRecordIcon = true;
            }

            var relatedLeadId = '';

            var relatedObjectList = dataItem.RelatedObjects;

            for (var j = 0; j < relatedObjectList.length; j++) {
                var relatedSfObject = relatedObjectList[j];

                if (relatedSfObject.ObjectName == 'Lead') //check the lead object.
                {
                    if (relatedSfObject.RelatedId + '' !== '' && relatedSfObject.RelatedId !== null && relatedSfObject.RelatedId !== 'null')  {

                        renderLeadIcon = true;

                        addLead1.setAttribute('class', 'foundLead slds-icon__container pointer');
                        addLead1.setAttribute('sfId', '' + relatedSfObject.RelatedId);
                        addLead1.setAttribute('title', 'View Lead Record');
                        addLead1.setAttribute('style', 'margin-right: 12px;margin-left: -2px;');

                        relatedLeadId = relatedSfObject.RelatedId;

                    } else {
                        addLead1.setAttribute('class', 'addLead slds-icon__container pointer');
                        addLead1.setAttribute('title', 'Create New Lead Record');

                        renderAddRecordIcon = true;
                    }
                }
            }

            if (renderContactIcon && renderLeadIcon) {
                addContact1.setAttribute('class', 'foundMultiplePeople slds-icon__container pointer');
                addContact1.setAttribute('title', 'View Multiple Records');
                renderLeadIcon = false; //don't render the lead only item if we have multiple.
            }

            addContact1.setAttribute('emailId', '' + i);
            addLead1.setAttribute('emailId', '' + i);

            var foundContactSvgDisplay = 'slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small';
            var newContactIconRender = CreateSvgWithUseTag(foundContactSvgDisplay, contactIconRef);

            addContact1.appendChild(newContactIconRender);

            var contactObject;

            if (sentInternal) {
                contactObject = dataItem.To;
            } else {

                if (dataItem.From != null && typeof dataItem.From != "undefined") {
                    contactObject = dataItem.From;
                }
                else if (dataItem.FromAddress != null && typeof dataItem.FromAddress != "undefined") {
                    contactObject = dataItem.FromAddress;
                }
            }

            var toEmailAddress = '';
            var toFirstName = '';
            var toLastName = '';

            if (contactObject != null && typeof contactObject != "undefined") {
                toEmailAddress = contactObject.Address;
                var toName = contactObject.Name;

                if (toName != null && typeof toName != "undefined") {
                    var nameArray = toName.split(' ');

                    if (nameArray) {
                        if (nameArray.length > 0) {
                            toFirstName = nameArray[0];
                        }

                        if (nameArray.length > 1) {
                            toLastName = nameArray[1];
                        }
                    }
                }
            }

            addContact1.setAttribute('firstname', '' + toFirstName);
            addContact1.setAttribute('lastname', '' + toLastName);
            addContact1.setAttribute('emailaddress', '' + toEmailAddress);

            addLead1.setAttribute('firstname', '' + toFirstName);
            addLead1.setAttribute('lastname', '' + toLastName);
            addLead1.setAttribute('emailaddress', '' + toEmailAddress);

            var addemail1 = document.createElement('span');

            var emailSvgDisplayClass = '';

            if (dataItem.SFAddedId != '') {

                //standard email objects.
                if (dataItem.IndexType == 1 || dataItem.IndexType == 5 || dataItem.IndexType == 20) {
                    addemail1.setAttribute('class', 'addEmailAdded slds-icon__container pointer');
                    addemail1.setAttribute('sfId', '' + dataItem.SFAddedId);
                    addemail1.setAttribute('title', 'View Email');
                } else { //other activity types.

                    if (dataItem.IndexType == 4) {
                        if (emailType == 13 || emailType == 14) {
                            addemail1.setAttribute('class', 'addEmailAdded slds-icon__container pointer');
                            addemail1.setAttribute('sfId', '' + dataItem.SFAddedId);
                            addemail1.setAttribute('title', 'View Email');
                        } else {
                            addemail1.setAttribute('class', 'activityTaskAdded slds-icon__container pointer');
                            addemail1.setAttribute('sfId', '' + dataItem.SFAddedId);
                            addemail1.setAttribute('title', 'View Task');
                        }
                    } else {
                        addemail1.setAttribute('class', 'activityTaskAdded slds-icon__container pointer');
                        addemail1.setAttribute('sfId', '' + dataItem.SFAddedId);
                        addemail1.setAttribute('title', 'View Task');
                    }
                }

                emailSvgDisplayClass = 'slds-icon-replacement-class lds-icon-text-default slds-icon--small slds-m-right--small ebsta-green-text';
            }
            else {

                //standard email objects.
                if (dataItem.IndexType == 1 || dataItem.IndexType == 5 || dataItem.IndexType == 20) {
                    addemail1.setAttribute('class', 'addEmail slds-icon__container pointer');
                    addemail1.setAttribute('title', 'Add Email to Salesforce');
                } else {

                    if (emailType === 13 || emailType === 14) {
                        addemail1.setAttribute('class', 'addEmail slds-icon__container pointer');
                        addemail1.setAttribute('title', 'Add Email to Salesforce');
                    } else {
                        addemail1.setAttribute('class', 'addTask slds-icon__container pointer');
                        addemail1.setAttribute('title', 'Add Task to Salesforce');
                    }
                }

                if (dataItem.RelatedId != null && dataItem.RelatedId != '' && dataItem.RelatedId != 'null') {
                    addemail1.setAttribute('contactId', '' + dataItem.RelatedId);
                } else if (relatedLeadId != '') {

                    //find the related lead id.

                    addemail1.setAttribute('contactId', '' + relatedLeadId);
                } else {

                    addemail1.setAttribute('contactId', '');
                }

                emailSvgDisplayClass = 'slds-icon-replacement-class lds-icon-text-default slds-icon--small slds-m-right--small';
            }

            addemail1.setAttribute('emailId', '' + dataItem.EmailDocumentId);
            addemail1.setAttribute('markemailId', '' + dataItem.EmailDocumentId);

            addEmailIconSvg = CreateSvgWithUseTag(emailSvgDisplayClass, '#email');

            addemail1.appendChild(addEmailIconSvg);

            if (dataItem.IndexType != 0) {
                if (dataItem.IndexType != 10) {
                    newCell7.appendChild(addemail1);
                }
            } else {
                addemail1.setAttribute('sfId', '' + dataItem.SalesforceId);
                newCell7.appendChild(addemail1);
            }

            //do we have access to attachments.
            if (licenceObjectMain.accessAttachments) {
                //if we have some attachments for this email, render the icon.
                if (dataItem.AttachmentCount > 0) {
                    //create the element.
                    var attachmentIcon = document.createElement('span');
                    attachmentIcon.className = 'ebsta-attachments-icon ebsta-icon-grey';
                    attachmentIcon.title = 'Attachments';
                    attachmentIcon.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    //add the icon element to the cell.
                    newCell7.appendChild(attachmentIcon);

                    //build loader and result container for attachment download event handler
                    var attachmentDownloadLoadingContainer = document.createElement('div');
                    attachmentDownloadLoadingContainer.className = 'attachmentdownloadloadercontainer attachmentdownloadError';
                    attachmentDownloadLoadingContainer.id = 'attachmentDownloadLoaderDiv' + dataItem.EmailDocumentId;
                    newCell7.appendChild(attachmentDownloadLoadingContainer);

                    //build the popup container.
                    var attachmentPopupContent = document.createElement('div');
                    attachmentPopupContent.className = 'slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left ebsta-attachmentlist-ul attachmentListDiv' + dataItem.EmailDocumentId;

                    //add the attachment holding div to the cell.
                    newCell7.appendChild(attachmentPopupContent);
                }
            }

            if (dataItem.directLink != null) {
                var addemail1 = document.createElement('span');
                addemail1.setAttribute('class', 'directLink');
                addemail1.setAttribute('linkPath', '' + dataItem.DirectLink);
            }

            var newCell2 = document.createElement('td');

            var newCell6 = document.createElement('td');

            var magnifyCell = document.createElement('td');
            magnifyCell.className = 'magnifyTableCell';

            var magnifySpan = document.createElement('span');
            magnifySpan.setAttribute('class', 'magnify showEmailPreview slds-icon__container pointer');
            magnifySpan.setAttribute('emailId', dataItem.EmailDocumentId);

            var magnifyIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small', '#search');


            magnifySpan.appendChild(magnifyIconSvg);


            var previewDivPopup = document.createElement('div');
            previewDivPopup.setAttribute('class', 'slds-popover slds-nubbin--left ebsta-hidden-tooltip previewToolTip' + dataItem.EmailDocumentId);
            previewDivPopup.setAttribute('role', 'dialog');

            var popOverContentDiv = document.createElement('div');
            popOverContentDiv.className = 'slds-popover__content';
            popOverContentDiv.setAttribute('role', 'document');

            var popOverContentHeader = document.createElement('div');
            popOverContentHeader.className = 'slds-popover__header';

            var popOverContentBody = document.createElement('div');
            popOverContentBody.className = 'slds-popover__body previewToolTipTextContent' + dataItem.EmailDocumentId;

            //popOverContentDiv.appendChild(popOverContentHeader);
            popOverContentDiv.appendChild(popOverContentBody);

            previewDivPopup.appendChild(popOverContentDiv);

            //'.previewToolTip' + emailId				

            if (dataItem.IndexType != 10 && !dataItem.HasNoDescription) //don't display magnify glass for call data.
            {
                magnifyCell.appendChild(magnifySpan);
                magnifyCell.appendChild(previewDivPopup);
            }

            if (sentInternal) {
                if (renderContactIcon) {
                    newCell6.appendChild(addContact1);
                }

                if (renderLeadIcon) {
                    newCell6.appendChild(addLead1);
                }

                if (!renderContactIcon && !renderLeadIcon) {
                    var addNewObjectSpan = document.createElement('span');
                    addNewObjectSpan.setAttribute('firstname', '' + toFirstName);
                    addNewObjectSpan.setAttribute('lastname', '' + toLastName);
                    addNewObjectSpan.setAttribute('emailaddress', '' + toEmailAddress);
                    addNewObjectSpan.setAttribute('emailId', '' + dataItem.EmailDocumentId);
                    addNewObjectSpan.title = 'Create New Record';
                    addNewObjectSpan.className = 'addContactLead slds-icon__container pointer';

                    var menuHolderDiv = document.createElement('div');
                    menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left addcontactlead-menu-div-' + dataItem.EmailDocumentId;
                    menuHolderDiv.setAttribute('role', 'dialog');

                    var contactPopupMenu = document.createElement('ul');
                    contactPopupMenu.setAttribute('class', 'slds-popover__content');

                    var menuItem1 = document.createElement('li');
                    menuItem1.setAttribute('class', 'addContact pointer');
                    menuItem1.setAttribute('firstname', '' + toFirstName);
                    menuItem1.setAttribute('lastname', '' + toLastName);
                    menuItem1.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem1.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuItem2 = document.createElement('li');
                    menuItem2.setAttribute('class', 'addLead pointer');
                    menuItem2.setAttribute('firstname', '' + toFirstName);
                    menuItem2.setAttribute('lastname', '' + toLastName);
                    menuItem2.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem2.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuLink = document.createElement('a');
                    menuLink.appendChild(document.createTextNode('Create New Contact Record'));

                    menuItem1.appendChild(menuLink);

                    var menuLink2 = document.createElement('a');
                    menuLink2.appendChild(document.createTextNode('Create New Lead Record'));

                    menuItem2.appendChild(menuLink2);

                    if (userHasContactAccess == "true") {
                        contactPopupMenu.appendChild(menuItem1);
                    }

                    if (userHasLeadAccess == "true") {
                        contactPopupMenu.appendChild(menuItem2);
                    }

                    menuHolderDiv.appendChild(contactPopupMenu);

                    //don't show add record icon in lightning view, does not navigate well.
                    if (dataItem.IndexType != 10) {
                        newCell6.appendChild(addNewObjectSpan);
                        newCell6.appendChild(menuHolderDiv);
                    } else {
                        //render blank block to keep shape.

                        var addNewObjectSpan = document.createElement('span');
                        addNewObjectSpan.className = 'ebsta-icon-block-empty slds-icon__container';

                        newCell6.appendChild(addNewObjectSpan);
                    }
                }

                var emailMailtoLink1SpanContainer = document.createElement('span');
                emailMailtoLink1SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink1 = document.createElement('a');
                emailMailtoLink1.className = 'pointer activity-email-link';

                if (dataItem.IndexType == 10) {
                    //emailMailtoLink1.href = 'mailto:' + dataItem.To.Name;

                    if (dataItem.To.Name != '' && dataItem.To.Name != null) {
                        if (lightningMode) {
                            emailMailtoLink1.appendChild(document.createTextNode(TruncateEmailAddress(dataItem.To.Name, 25)));
                        } else {
                            emailMailtoLink1.appendChild(document.createTextNode(dataItem.To.Name));
                        }

                    } else {
                        if (lightningMode) {
                            emailMailtoLink1.appendChild(document.createTextNode(TruncateEmailAddress(dataItem.To.Address, 25)));
                        } else {
                            emailMailtoLink1.appendChild(document.createTextNode(dataItem.To.Address));
                        }
                    }
                } else {
                    emailMailtoLink1.href = 'mailto:' + dataItem.To.Address;
                    emailMailtoLink1.target = '_top';

                    if (lightningMode) {
                        emailMailtoLink1.appendChild(document.createTextNode(TruncateEmailAddress(dataItem.To.Address, 25)));
                    } else {
                        emailMailtoLink1.appendChild(document.createTextNode(dataItem.To.Address));
                    }
                }

                emailMailtoLink1SpanContainer.appendChild(emailMailtoLink1);
                newCell6.appendChild(emailMailtoLink1SpanContainer);

                if (lightningMode) {
                    newCell6.className = 'contactCellPadding contactCellPadding-lightning';
                } else {
                    newCell6.className = 'contactCellPadding';
                }

                var blackListCell = document.createElement('span');
                blackListCell.appendChild(document.createTextNode(' '));

                //standard email objects.
                if (dataItem.IndexType == 1 || dataItem.IndexType == 5 || dataItem.IndexType == 20) {
                    blackListCell.setAttribute('emailAddress', dataItem.To.Address);
                    blackListCell.setAttribute('emailId', dataItem.EmailDocumentId);
                    blackListCell.setAttribute('class', 'blacklist-menu slds-icon__container pointer');
                    blackListCell.title = 'Privacy';
                }

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small', '#down');

                blackListCell.appendChild(arrowMenuIconSvg);

                var menuHolderDiv = document.createElement('div');
                menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left contact-menu-div-' + dataItem.EmailDocumentId;
                menuHolderDiv.setAttribute('role', 'dialog');

                var contactPopupMenu = document.createElement('ul');
                contactPopupMenu.setAttribute('class', 'slds-popover__content');
                //contactPopupMenu.setAttribute('style', 'display: none;');

                var menuItem1 = document.createElement('li');
                menuItem1.setAttribute('class', 'ebsta-blacklist-singleitem pointer');
                menuItem1.setAttribute('emailAddress', dataItem.To.Address);
                menuItem1.setAttribute('emailId', dataItem.EmailDocumentId);

                var menuLink = document.createElement('a');

                var blockIconSpan = document.createElement('span');
                blockIconSpan.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan.appendChild(arrowMenuIconSvg);

                menuLink.appendChild(blockIconSpan);
                menuLink.appendChild(document.createTextNode('Hide Email'));

                menuItem1.appendChild(menuLink);


                var menuItem2 = document.createElement('li');
                menuItem2.setAttribute('class', 'pointer ebsta-blacklist-allactivity');
                menuItem2.setAttribute('emailAddress', dataItem.To.Address);

                var menuLink2 = document.createElement('a');

                var blockIconSpan2 = document.createElement('span');
                blockIconSpan2.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg2 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan2.appendChild(arrowMenuIconSvg2);

                menuLink2.appendChild(blockIconSpan2);
                menuLink2.appendChild(document.createTextNode('Hide All Emails'));

                menuItem2.appendChild(menuLink2);


                var menuItem3 = document.createElement('li');
                menuItem3.setAttribute('class', 'pointer ebsta-blacklist-allactivitycontact');
                menuItem3.setAttribute('emailAddress', dataItem.To.Address);

                var menuLink3 = document.createElement('a');

                var blockIconSpan3 = document.createElement('span');
                blockIconSpan3.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg3 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan3.appendChild(arrowMenuIconSvg3);

                menuLink3.appendChild(blockIconSpan3);
                menuLink3.appendChild(document.createTextNode('Hide All Emails & Contact'));

                menuItem3.appendChild(menuLink3);

                if (!userHasPrivacyControl) {
                    menuLink.setAttribute('class', 'ebsta-disabledLink');
                    menuLink2.setAttribute('class', 'ebsta-disabledLink');
                    menuLink3.setAttribute('class', 'ebsta-disabledLink');
                }

                contactPopupMenu.appendChild(menuItem1);
                contactPopupMenu.appendChild(menuItem2);
                contactPopupMenu.appendChild(menuItem3);

                menuHolderDiv.appendChild(contactPopupMenu);

                if (userHasPrivacyControl) {
                    newCell6.appendChild(blackListCell);
                    newCell6.appendChild(menuHolderDiv);
                }

                //var emailMailtoLink4SpanContainer = document.createElement('span');
                //emailMailtoLink4SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink4 = document.createElement('a');

                emailMailtoLink4.className = 'pointer activity-email-link';

                //emailMailtoLink4SpanContainer.appendChild(emailMailtoLink4);

                newCell2.appendChild(emailMailtoLink4);

                //phone data objects.
                if (dataItem.IndexType == 10) {
                    //emailMailtoLink4.href = dataItem.FromAddress.Address;

                    if (dataItem.FromAddress.Name != '' && dataItem.FromAddress.Name != null) {
                        emailMailtoLink4.appendChild(document.createTextNode(dataItem.FromAddress.Name));
                    } else {
                        emailMailtoLink4.appendChild(document.createTextNode(dataItem.FromAddress.Address));
                    }
                } else {
                    emailMailtoLink4.href = 'mailto:' + dataItem.FromAddress.Address;
                    emailMailtoLink4.target = '_top';
                    emailMailtoLink4.appendChild(document.createTextNode(dataItem.FromAddress.Address));
                }

                newRow.appendChild(newCell1);

                newRow.appendChild(newCell6);

                newRow.appendChild(magnifyCell);
                newRow.appendChild(newCell3);
                newRow.appendChild(newCell4);
                newRow.appendChild(newCell2);
                newRow.appendChild(newCell7);
            } else {

                if (renderContactIcon) {
                    newCell2.appendChild(addContact1);
                }

                if (renderLeadIcon) {
                    newCell2.appendChild(addLead1);
                }

                if (!renderContactIcon && !renderLeadIcon) {
                    var addNewObjectSpan = document.createElement('span');
                    addNewObjectSpan.setAttribute('firstname', '' + toFirstName);
                    addNewObjectSpan.setAttribute('lastname', '' + toLastName);
                    addNewObjectSpan.setAttribute('emailaddress', '' + toEmailAddress);
                    addNewObjectSpan.setAttribute('emailId', '' + dataItem.EmailDocumentId);
                    addNewObjectSpan.title = 'Create New Record';
                    addNewObjectSpan.className = 'addContactLead slds-icon__container pointer';

                    var menuHolderDiv = document.createElement('div');
                    menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left addcontactlead-menu-div-' + dataItem.EmailDocumentId;
                    menuHolderDiv.setAttribute('role', 'dialog');

                    var contactPopupMenu = document.createElement('ul');
                    contactPopupMenu.setAttribute('class', 'slds-popover__content');

                    var menuItem1 = document.createElement('li');
                    menuItem1.setAttribute('class', 'addContact pointer');
                    menuItem1.setAttribute('firstname', '' + toFirstName);
                    menuItem1.setAttribute('lastname', '' + toLastName);
                    menuItem1.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem1.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuItem2 = document.createElement('li');
                    menuItem2.setAttribute('class', 'addLead pointer');
                    menuItem2.setAttribute('firstname', '' + toFirstName);
                    menuItem2.setAttribute('lastname', '' + toLastName);
                    menuItem2.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem2.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuLink = document.createElement('a');
                    menuLink.appendChild(document.createTextNode('Create New Contact Record'));

                    menuItem1.appendChild(menuLink);

                    var menuLink2 = document.createElement('a');
                    menuLink2.appendChild(document.createTextNode('Create New Lead Record'));

                    menuItem2.appendChild(menuLink2);

                    if (userHasContactAccess == "true") {
                        contactPopupMenu.appendChild(menuItem1);
                    }

                    if (userHasLeadAccess == "true") {
                        contactPopupMenu.appendChild(menuItem2);
                    }

                    menuHolderDiv.appendChild(contactPopupMenu);


                    if (dataItem.IndexType != 10) {
                        newCell2.appendChild(addNewObjectSpan);
                        newCell2.appendChild(menuHolderDiv);
                    } else {
                        //render blank block to keep shape.

                        var addNewObjectSpan = document.createElement('span');
                        addNewObjectSpan.className = 'ebsta-icon-block-empty slds-icon__container';

                        newCell2.appendChild(addNewObjectSpan);
                    }
                }

                if (lightningMode) {
                    newCell2.className = 'contactCellPadding contactCellPadding-lightning';
                } else {
                    newCell2.className = 'contactCellPadding';
                }

                var emailMailtoLink2SpanContainer = document.createElement('span');
                emailMailtoLink2SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink2 = document.createElement('a');
                //emailMailtoLink2.href = 'mailto:' + dataItem.FromAddress.Address;
                //emailMailtoLink2.appendChild(document.createTextNode(dataItem.FromAddress.Address));
                emailMailtoLink2.className = 'pointer activity-email-link';

                //var emailMailtoLink3SpanContainer = document.createElement('span');
                //emailMailtoLink3SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink3 = document.createElement('a');
                //emailMailtoLink3.href = 'mailto:' + dataItem.To.Address;
                //emailMailtoLink3.appendChild(document.createTextNode(dataItem.To.Address));
                emailMailtoLink3.className = 'pointer activity-email-link';

                //emailMailtoLink3SpanContainer.appendChild(emailMailtoLink3);

                var blackListCell = document.createElement('span');
                blackListCell.appendChild(document.createTextNode(' '));

                //email objects.
                if (dataItem.IndexType == 1 || dataItem.IndexType == 5 || dataItem.IndexType == 20) {
                    emailMailtoLink3.href = 'mailto:' + dataItem.To.Address;
                    emailMailtoLink3.target = '_top';

                    emailMailtoLink2.href = 'mailto:' + dataItem.FromAddress.Address;
                    emailMailtoLink2.target = '_top';

                    if (lightningMode) {
                        emailMailtoLink3.appendChild(document.createTextNode(TruncateEmailAddress(dataItem.To.Address, 25)));
                        emailMailtoLink2.appendChild(document.createTextNode(TruncateEmailAddress(dataItem.FromAddress.Address, 25)));
                    } else {
                        emailMailtoLink3.appendChild(document.createTextNode(dataItem.To.Address));
                        emailMailtoLink2.appendChild(document.createTextNode(dataItem.FromAddress.Address));
                    }

                    emailMailtoLink2SpanContainer.appendChild(emailMailtoLink2);

                    newCell2.appendChild(emailMailtoLink2SpanContainer);
                    newCell6.appendChild(emailMailtoLink3);

                    blackListCell.setAttribute('emailAddress', dataItem.FromAddress.Address);
                    blackListCell.setAttribute('emailId', dataItem.EmailDocumentId);
                    blackListCell.setAttribute('class', 'blacklist-menu pointer');
                    blackListCell.title = 'Privacy';

                } else { //other activities.
                    emailMailtoLink3.href = 'mailto:' + dataItem.To.Name;
                    emailMailtoLink3.target = '_top';

                    emailMailtoLink2.href = 'mailto:' + dataItem.FromAddress.Name;
                    emailMailtoLink2.target = '_top';

                    if (lightningMode) {
                        emailMailtoLink3.appendChild(document.createTextNode(TruncateEmailAddress(dataItem.To.Name, 25)));
                        emailMailtoLink2.appendChild(document.createTextNode(TruncateEmailAddress(dataItem.FromAddress.Name, 25)));
                    } else {
                        emailMailtoLink3.appendChild(document.createTextNode(dataItem.To.Name));
                        emailMailtoLink2.appendChild(document.createTextNode(dataItem.FromAddress.Name));
                    }

                    emailMailtoLink2SpanContainer.appendChild(emailMailtoLink3);

                    newCell2.appendChild(emailMailtoLink2SpanContainer);
                    newCell6.appendChild(emailMailtoLink2);
                }

                //newCell6.appendChild(emailMailtoLink3);                

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small', '#down');

                blackListCell.appendChild(arrowMenuIconSvg);

                var menuHolderDiv = document.createElement('div');
                menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left contact-menu-div-' + dataItem.EmailDocumentId;
                menuHolderDiv.setAttribute('role', 'dialog');

                var contactPopupMenu = document.createElement('ul');
                contactPopupMenu.setAttribute('class', '');
                //contactPopupMenu.setAttribute('style', 'display: none;');

                var menuItem1 = document.createElement('li');
                menuItem1.setAttribute('class', 'ebsta-blacklist-singleitem pointer');
                menuItem1.setAttribute('emailAddress', dataItem.FromAddress.Address);
                menuItem1.setAttribute('emailId', dataItem.EmailDocumentId);

                var menuLink = document.createElement('a');

                var blockIconSpan = document.createElement('span');
                blockIconSpan.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan.appendChild(arrowMenuIconSvg);

                menuLink.appendChild(blockIconSpan);
                menuLink.appendChild(document.createTextNode('Hide Email'));

                menuItem1.appendChild(menuLink);

                var menuItem2 = document.createElement('li');
                menuItem2.setAttribute('class', 'pointer ebsta-blacklist-allactivity');
                menuItem2.setAttribute('emailAddress', dataItem.FromAddress.Address);

                var menuLink2 = document.createElement('a');

                var blockIconSpan2 = document.createElement('span');
                blockIconSpan2.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg2 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan2.appendChild(arrowMenuIconSvg2);

                menuLink2.appendChild(blockIconSpan2);
                menuLink2.appendChild(document.createTextNode('Hide All Emails'));

                menuItem2.appendChild(menuLink2);


                var menuItem3 = document.createElement('li');
                menuItem3.setAttribute('class', 'pointer ebsta-blacklist-allactivitycontact');
                menuItem3.setAttribute('emailAddress', dataItem.FromAddress.Address);

                var menuLink3 = document.createElement('a');

                var blockIconSpan3 = document.createElement('span');
                blockIconSpan3.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg3 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan3.appendChild(arrowMenuIconSvg3);

                menuLink3.appendChild(blockIconSpan3);
                menuLink3.appendChild(document.createTextNode('Hide All Emails & Contact'));

                menuItem3.appendChild(menuLink3);

                if (!userHasPrivacyControl) {
                    menuLink.setAttribute('class', 'ebsta-disabledLink');
                    menuLink2.setAttribute('class', 'ebsta-disabledLink');
                    menuLink3.setAttribute('class', 'ebsta-disabledLink');
                }

                contactPopupMenu.appendChild(menuItem1);
                contactPopupMenu.appendChild(menuItem2);
                contactPopupMenu.appendChild(menuItem3);

                menuHolderDiv.appendChild(contactPopupMenu);

                if (userHasPrivacyControl) {
                    newCell2.appendChild(blackListCell);
                    newCell2.appendChild(menuHolderDiv);
                }

                newRow.appendChild(newCell1);


                newRow.appendChild(newCell2);
                newRow.appendChild(magnifyCell);
                newRow.appendChild(newCell3);
                newRow.appendChild(newCell4);
                newRow.appendChild(newCell6);

                newRow.appendChild(newCell7);
            }

            j$(".activityTable").append(newRow);
        }
    }

    ApplyDisplayEvents();

    j$(".slds-icon").focus();

    //set up paging.
    SetupPaging('ebsta-activity-pagination', totalPages, pageNumber, searchTerm);
}

function DisplayResults(jsontxt, pageNumber, searchObject) {


    var data1 = JSON.parse(jsontxt);


    resultsListRec = data1.SearchResultsItems;
    var totalPages = data1.TotalPages;
    var searchTerm = searchObject;
    var totalResults1 = data1.TotalRecords;
    LogThis(data1);
    if (resultsListRec.length == 0) {
        j$('.emailsRecievedCounter').text('(0)');
        DisplayNoResults(8, 'emailsRecievedTable', 'emails');
    } else {

        var additionalRecordText = '';

        if (totalPages > 1) {
            additionalRecordText = '+';
        }

        j$('.emailsRecievedCounter').text('(' + totalResults1 + ')');

        j$(".emailsRecievedTable").html('');

        for (var i = 0; i < resultsListRec.length; i++) {

            var dataItem = resultsListRec[i];

            var newRow = document.createElement('tr');
            newRow.setAttribute('emailId', '' + dataItem.EmailDocumentId);

            newRow.setAttribute('title', '');

            var newCell1 = document.createElement('td');
            var spanTracking1 = document.createElement('span');

            var sentInternal = dataItem.SentInternal;

            var mailDirectionIcon = document.createElementNS("http://www.w3.org/2000/svg", "svg");
            mailDirectionIcon.setAttribute('aria-hidden', 'true');
            mailDirectionIcon.setAttribute('class', 'slds-icon-replacement-class slds-icon-text-default slds-icon--small');

            var forwardLink = document.createElementNS("http://www.w3.org/2000/svg", "use");

            //forwardLink.appendChild(document.createTextNode(''));  

            var svgLink = '';
            var svgTitle = '';

            var newIconSpan = document.createElement('span');
            var emailTypeSpan = document.createElement('span');
            emailTypeSpan.setAttribute('class', 'ebsta-ooo-activity ebsta-display-svg-medium ebsta-fill-red');

            if (sentInternal) {
                spanTracking1.setAttribute('class', 'activityEmailOutbound');
                spanTracking1.setAttribute('title', 'Email Sent');
                newIconSpan.className = 'slds-icon__container activityEmailOutbound';

                svgLink = '#back';
                svgTitle = 'Email Sent';

            } else {
                spanTracking1.setAttribute('class', 'activityEmailInbound');
                spanTracking1.setAttribute('title', 'Email Received');
                newIconSpan.className = 'slds-icon__container activityEmailInbound';

                svgLink = '#forward';
                svgTitle = 'Email Received';
            }

            var mailDirectionIcon = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', svgLink);

            newIconSpan.appendChild(mailDirectionIcon);
            newIconSpan.setAttribute('title', svgTitle);

            var emailType = '' + dataItem.EmailType;

            var rowClassString = 'emailRow ebsta-row';

            if (emailType === "2") {
                //grey out the row.                        	
                //rowClassString = 'emailRow ebsta-row ebsta-outofoffice-tr';

                //add out of office icon.                        	
                //var oOOIcon = CreateSvgWithUseTag('', '#warning');                         
                //emailTypeSpan.appendChild(oOOIcon);
                emailTypeSpan.setAttribute('title', 'Out of Office');
                emailTypeSpan.className = emailTypeSpan.className + ' ebsta-outofoffice-icon';
                emailTypeSpan.title = 'Out of office';

                spanTracking1.className = spanTracking1.className + ' ebsta-outofoffice-icon-overide';
            }

            newRow.setAttribute('class', rowClassString);

            newCell1.appendChild(newIconSpan);
            newCell1.appendChild(emailTypeSpan);

            var newCell3 = document.createElement('td');

            var subjectLink = document.createElement('a');
            subjectLink.href = '#';
            subjectLink.appendChild(document.createTextNode(dataItem.Subject));

            newCell3.appendChild(subjectLink);
            newCell3.setAttribute('class', 'emailExpand');
            newCell3.setAttribute('emailId', '' + dataItem.EmailDocumentId);

            var newCell4 = document.createElement('td');
            newCell4.appendChild(document.createTextNode(FormatDateTime(dataItem.ReceivedTime)));

            var newCell7 = document.createElement('td');

            var addContact1 = document.createElement('span');
            var addLead1 = document.createElement('span');

            var contactIconRef = '';

            var renderLeadIcon = false;
            var renderContactIcon = false;
            var renderAddRecordIcon = false;

            if (dataItem.RelatedId != '' && dataItem.RelatedId != null) {

                renderContactIcon = true;

                addContact1.setAttribute('class', 'foundContact slds-icon__container pointer');
                addContact1.setAttribute('sfId', '' + dataItem.RelatedId);
                addContact1.setAttribute('title', 'View Contact Record');
                addContact1.setAttribute('style', 'margin-right: 10px;');
                contactIconRef = '#user';
            }
            else {
                addContact1.setAttribute('class', 'addContact slds-icon__container pointer');
                addContact1.setAttribute('title', 'Create New Contact Record');
                contactIconRef = '#adduser';

                renderAddRecordIcon = true;
            }

            var relatedLeadId = '';

            var relatedObjectList = dataItem.RelatedObjects;

            for (var j = 0; j < relatedObjectList.length; j++) {
                var relatedSfObject = relatedObjectList[j];

                if (relatedSfObject.ObjectName == 'Lead') //check the lead object.
                {
                    if (relatedSfObject.RelatedId + '' !== '' && relatedSfObject.RelatedId !== null && relatedSfObject.RelatedId !== 'null') {

                        renderLeadIcon = true;

                        addLead1.setAttribute('class', 'foundLead slds-icon__container pointer');
                        addLead1.setAttribute('sfId', '' + relatedSfObject.RelatedId);
                        addLead1.setAttribute('title', 'View Lead Record');
                        addLead1.setAttribute('style', 'margin-right: 12px;margin-left: -2px;');

                        relatedLeadId = relatedSfObject.RelatedId;

                    } else {
                        addLead1.setAttribute('class', 'addLead slds-icon__container pointer');
                        addLead1.setAttribute('title', 'Create New Lead Record');

                        renderAddRecordIcon = true;
                    }
                }
            }

            if (renderContactIcon && renderLeadIcon) {
                addContact1.setAttribute('class', 'foundMultiplePeople slds-icon__container pointer');
                addContact1.setAttribute('title', 'View Multiple Records');
                renderLeadIcon = false; //don't render the lead only item if we have multiple.
            }

            addContact1.setAttribute('emailId', '' + i);
            addLead1.setAttribute('emailId', '' + i);

            var foundContactSvgDisplay = 'slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small';
            var newContactIconRender = CreateSvgWithUseTag(foundContactSvgDisplay, contactIconRef);

            addContact1.appendChild(newContactIconRender);

            var contactObject;

            if (sentInternal) {
                contactObject = dataItem.To;
            } else {

                if (dataItem.From != null && typeof dataItem.From != "undefined") {
                    contactObject = dataItem.From;
                }
                else if (dataItem.FromAddress != null && typeof dataItem.FromAddress != "undefined") {
                    contactObject = dataItem.FromAddress;
                }
            }

            var toEmailAddress = '';
            var toFirstName = '';
            var toLastName = '';

            if (contactObject != null && typeof contactObject != "undefined") {
                toEmailAddress = contactObject.Address;
                var toName = contactObject.Name;

                if (toName != null && typeof toName != "undefined") {
                    var nameArray = toName.split(' ');

                    if (nameArray) {
                        if (nameArray.length > 0) {
                            toFirstName = nameArray[0];
                        }

                        if (nameArray.length > 1) {
                            toLastName = nameArray[1];
                        }
                    }
                }
            }

            addContact1.setAttribute('firstname', '' + toFirstName);
            addContact1.setAttribute('lastname', '' + toLastName);
            addContact1.setAttribute('emailaddress', '' + toEmailAddress);

            addLead1.setAttribute('firstname', '' + toFirstName);
            addLead1.setAttribute('lastname', '' + toLastName);
            addLead1.setAttribute('emailaddress', '' + toEmailAddress);

            var addemail1 = document.createElement('span');

            var emailSvgDisplayClass = '';

            if (dataItem.SFAddedId != '') {
                addemail1.setAttribute('class', 'addEmailAdded slds-icon__container pointer');
                addemail1.setAttribute('sfId', '' + dataItem.SFAddedId);
                addemail1.setAttribute('title', 'View Email');

                emailSvgDisplayClass = 'slds-icon-replacement-class lds-icon-text-default slds-icon--small slds-m-right--small ebsta-green-text';
            }
            else {
                addemail1.setAttribute('class', 'addEmail slds-icon__container pointer');
                addemail1.setAttribute('title', 'Add Email to Salesforce');

                if (dataItem.RelatedId != null && dataItem.RelatedId != '' && dataItem.RelatedId != 'null') {
                    addemail1.setAttribute('contactId', '' + dataItem.RelatedId);
                } else if (relatedLeadId != '') {

                    //find the related lead id.

                    addemail1.setAttribute('contactId', '' + relatedLeadId);
                } else {

                    addemail1.setAttribute('contactId', '');
                }

                emailSvgDisplayClass = 'slds-icon-replacement-class lds-icon-text-default slds-icon--small slds-m-right--small';
            }

            addemail1.setAttribute('emailId', '' + dataItem.EmailDocumentId);
            addemail1.setAttribute('markemailId', '' + dataItem.EmailDocumentId);

            addEmailIconSvg = CreateSvgWithUseTag(emailSvgDisplayClass, '#email');

            addemail1.appendChild(addEmailIconSvg);

            newCell7.appendChild(addemail1);

            if (dataItem.directLink != null) {
                var addemail1 = document.createElement('span')
                addemail1.setAttribute('class', 'directLink');
                addemail1.setAttribute('linkPath', '' + dataItem.DirectLink);
            }

            var newCell2 = document.createElement('td');

            var newCell6 = document.createElement('td');

            var magnifyCell = document.createElement('td');

            var magnifySpan = document.createElement('span');
            magnifySpan.setAttribute('class', 'magnify showEmailPreview slds-icon__container pointer');
            magnifySpan.setAttribute('emailId', dataItem.EmailDocumentId);

            var magnifyIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small', '#search');

            magnifySpan.appendChild(magnifyIconSvg);

            var previewDivPopup = document.createElement('div');
            previewDivPopup.setAttribute('class', 'slds-popover slds-nubbin--left ebsta-hidden-tooltip previewToolTip' + dataItem.EmailDocumentId);
            previewDivPopup.setAttribute('role', 'dialog');

            var popOverContentDiv = document.createElement('div');
            popOverContentDiv.className = 'slds-popover__content';
            popOverContentDiv.setAttribute('role', 'document');

            var popOverContentHeader = document.createElement('div');
            popOverContentHeader.className = 'slds-popover__header';

            var popOverContentBody = document.createElement('div');
            popOverContentBody.className = 'slds-popover__body previewToolTipTextContent' + dataItem.EmailDocumentId;

            //popOverContentDiv.appendChild(popOverContentHeader);
            popOverContentDiv.appendChild(popOverContentBody);

            previewDivPopup.appendChild(popOverContentDiv);

            //'.previewToolTip' + emailId				

            magnifyCell.appendChild(magnifySpan);
            magnifyCell.appendChild(previewDivPopup);

            if (sentInternal) {
                if (renderContactIcon) {
                    newCell6.appendChild(addContact1);
                }

                if (renderLeadIcon) {
                    newCell6.appendChild(addLead1);
                }

                if (!renderContactIcon && !renderLeadIcon) {
                    var addNewObjectSpan = document.createElement('span');
                    addNewObjectSpan.setAttribute('firstname', '' + toFirstName);
                    addNewObjectSpan.setAttribute('lastname', '' + toLastName);
                    addNewObjectSpan.setAttribute('emailaddress', '' + toEmailAddress);
                    addNewObjectSpan.setAttribute('emailId', '' + dataItem.EmailDocumentId);
                    addNewObjectSpan.title = 'Create New Record';
                    addNewObjectSpan.className = 'addContactLead slds-icon__container pointer';

                    var menuHolderDiv = document.createElement('div');
                    menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left addcontactlead-menu-div-' + dataItem.EmailDocumentId;
                    menuHolderDiv.setAttribute('role', 'dialog');

                    var contactPopupMenu = document.createElement('ul');
                    contactPopupMenu.setAttribute('class', 'slds-popover__content');

                    var menuItem1 = document.createElement('li');
                    menuItem1.setAttribute('class', 'addContact pointer');
                    menuItem1.setAttribute('firstname', '' + toFirstName);
                    menuItem1.setAttribute('lastname', '' + toLastName);
                    menuItem1.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem1.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuItem2 = document.createElement('li');
                    menuItem2.setAttribute('class', 'addLead pointer');
                    menuItem2.setAttribute('firstname', '' + toFirstName);
                    menuItem2.setAttribute('lastname', '' + toLastName);
                    menuItem2.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem2.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuLink = document.createElement('a');
                    menuLink.appendChild(document.createTextNode('Create New Contact Record'));

                    menuItem1.appendChild(menuLink);

                    var menuLink2 = document.createElement('a');
                    menuLink2.appendChild(document.createTextNode('Create New Lead Record'));

                    menuItem2.appendChild(menuLink2);

                    if (userHasContactAccess == "true") {
                        contactPopupMenu.appendChild(menuItem1);
                    }

                    if (userHasLeadAccess == "true") {
                        contactPopupMenu.appendChild(menuItem2);
                    }

                    menuHolderDiv.appendChild(contactPopupMenu);

                    newCell6.appendChild(addNewObjectSpan);
                    newCell6.appendChild(menuHolderDiv);
                }

                var emailMailtoLink1SpanContainer = document.createElement('span');
                emailMailtoLink1SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink1 = document.createElement('a');
                emailMailtoLink1.href = 'mailto:' + dataItem.To.Address;
                emailMailtoLink1.target = '_top';
                emailMailtoLink1.appendChild(document.createTextNode(dataItem.To.Address));
                emailMailtoLink1.className = 'pointer activity-email-link';

                emailMailtoLink1SpanContainer.appendChild(emailMailtoLink1);

                newCell6.appendChild(emailMailtoLink1SpanContainer);

                if (lightningMode) {
                    newCell6.className = 'contactCellPadding contactCellPadding-lightning';
                } else {
                    newCell6.className = 'contactCellPadding';
                }

                var blackListCell = document.createElement('span');
                blackListCell.appendChild(document.createTextNode(' '));
                blackListCell.setAttribute('emailAddress', dataItem.To.Address);
                blackListCell.setAttribute('emailId', dataItem.EmailDocumentId);
                blackListCell.setAttribute('class', 'blacklist-menu slds-icon__container pointer');
                blackListCell.title = 'Privacy';

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small', '#down');

                blackListCell.appendChild(arrowMenuIconSvg);

                var menuHolderDiv = document.createElement('div');
                menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left contact-menu-div-' + dataItem.EmailDocumentId;
                menuHolderDiv.setAttribute('role', 'dialog');

                var contactPopupMenu = document.createElement('ul');
                contactPopupMenu.setAttribute('class', 'slds-popover__content');
                //contactPopupMenu.setAttribute('style', 'display: none;');

                var menuItem1 = document.createElement('li');
                menuItem1.setAttribute('class', 'ebsta-blacklist-singleitem pointer');
                menuItem1.setAttribute('emailAddress', dataItem.To.Address);
                menuItem1.setAttribute('emailId', dataItem.EmailDocumentId);

                var menuLink = document.createElement('a');

                var blockIconSpan = document.createElement('span');
                blockIconSpan.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan.appendChild(arrowMenuIconSvg);

                menuLink.appendChild(blockIconSpan);
                menuLink.appendChild(document.createTextNode('Hide Email'));

                menuItem1.appendChild(menuLink);


                var menuItem2 = document.createElement('li');
                menuItem2.setAttribute('class', 'pointer ebsta-blacklist-allactivity');
                menuItem2.setAttribute('emailAddress', dataItem.To.Address);

                var menuLink2 = document.createElement('a');

                var blockIconSpan2 = document.createElement('span');
                blockIconSpan2.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg2 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan2.appendChild(arrowMenuIconSvg2);

                menuLink2.appendChild(blockIconSpan2);
                menuLink2.appendChild(document.createTextNode('Hide All Emails'));

                menuItem2.appendChild(menuLink2);


                var menuItem3 = document.createElement('li');
                menuItem3.setAttribute('class', 'pointer ebsta-blacklist-allactivitycontact');
                menuItem3.setAttribute('emailAddress', dataItem.To.Address);

                var menuLink3 = document.createElement('a');

                var blockIconSpan3 = document.createElement('span');
                blockIconSpan3.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg3 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan3.appendChild(arrowMenuIconSvg3);

                menuLink3.appendChild(blockIconSpan3);
                menuLink3.appendChild(document.createTextNode('Hide All Emails & Contact'));

                menuItem3.appendChild(menuLink3);

                if (!userHasPrivacyControl) {
                    menuLink.setAttribute('class', 'ebsta-disabledLink');
                    menuLink2.setAttribute('class', 'ebsta-disabledLink');
                    menuLink3.setAttribute('class', 'ebsta-disabledLink');
                }

                contactPopupMenu.appendChild(menuItem1);
                contactPopupMenu.appendChild(menuItem2);
                contactPopupMenu.appendChild(menuItem3);

                menuHolderDiv.appendChild(contactPopupMenu);

                if (userHasPrivacyControl) {
                    newCell6.appendChild(blackListCell);
                    newCell6.appendChild(menuHolderDiv);
                }

                //var emailMailtoLink4SpanContainer = document.createElement('span');
                //emailMailtoLink4SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink4 = document.createElement('a');
                emailMailtoLink4.href = 'mailto:' + dataItem.FromAddress.Address;
                emailMailtoLink4.target = '_top';
                emailMailtoLink4.appendChild(document.createTextNode(dataItem.FromAddress.Address));
                emailMailtoLink4.className = 'pointer activity-email-link';

                //emailMailtoLink4SpanContainer.appendChild(emailMailtoLink4);

                newCell2.appendChild(emailMailtoLink4);

                newRow.appendChild(newCell1);
                newRow.appendChild(newCell6);

                newRow.appendChild(magnifyCell);
                newRow.appendChild(newCell3);
                newRow.appendChild(newCell4);
                newRow.appendChild(newCell2);
                newRow.appendChild(newCell7);
            } else {

                if (renderContactIcon) {
                    newCell2.appendChild(addContact1);
                }

                if (renderLeadIcon) {
                    newCell2.appendChild(addLead1);
                }

                if (!renderContactIcon && !renderLeadIcon) {
                    var addNewObjectSpan = document.createElement('span');
                    addNewObjectSpan.setAttribute('firstname', '' + toFirstName);
                    addNewObjectSpan.setAttribute('lastname', '' + toLastName);
                    addNewObjectSpan.setAttribute('emailaddress', '' + toEmailAddress);
                    addNewObjectSpan.setAttribute('emailId', '' + dataItem.EmailDocumentId);
                    addNewObjectSpan.title = 'Create New Record';
                    addNewObjectSpan.className = 'addContactLead slds-icon__container pointer';

                    var menuHolderDiv = document.createElement('div');
                    menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left addcontactlead-menu-div-' + dataItem.EmailDocumentId;
                    menuHolderDiv.setAttribute('role', 'dialog');

                    var contactPopupMenu = document.createElement('ul');
                    contactPopupMenu.setAttribute('class', 'slds-popover__content');

                    var menuItem1 = document.createElement('li');
                    menuItem1.setAttribute('class', 'addContact pointer');
                    menuItem1.setAttribute('firstname', '' + toFirstName);
                    menuItem1.setAttribute('lastname', '' + toLastName);
                    menuItem1.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem1.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuItem2 = document.createElement('li');
                    menuItem2.setAttribute('class', 'addLead pointer');
                    menuItem2.setAttribute('firstname', '' + toFirstName);
                    menuItem2.setAttribute('lastname', '' + toLastName);
                    menuItem2.setAttribute('emailaddress', '' + toEmailAddress);
                    menuItem2.setAttribute('emailId', '' + dataItem.EmailDocumentId);

                    var menuLink = document.createElement('a');
                    menuLink.appendChild(document.createTextNode('Create New Contact Record'));

                    menuItem1.appendChild(menuLink);

                    var menuLink2 = document.createElement('a');
                    menuLink2.appendChild(document.createTextNode('Create New Lead Record'));

                    menuItem2.appendChild(menuLink2);

                    if (userHasContactAccess == "true") {
                        contactPopupMenu.appendChild(menuItem1);
                    }

                    if (userHasLeadAccess == "true") {
                        contactPopupMenu.appendChild(menuItem2);
                    }

                    menuHolderDiv.appendChild(contactPopupMenu);

                    newCell2.appendChild(addNewObjectSpan);
                    newCell2.appendChild(menuHolderDiv);
                }

                if (lightningMode) {
                    newCell2.className = 'contactCellPadding contactCellPadding-lightning';
                } else {
                    newCell2.className = 'contactCellPadding';
                }

                var emailMailtoLink2SpanContainer = document.createElement('span');
                emailMailtoLink2SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink2 = document.createElement('a');
                emailMailtoLink2.href = 'mailto:' + dataItem.FromAddress.Address;
                emailMailtoLink2.target = '_top';
                emailMailtoLink2.appendChild(document.createTextNode(dataItem.FromAddress.Address));
                emailMailtoLink2.className = 'pointer activity-email-link';

                emailMailtoLink2SpanContainer.appendChild(emailMailtoLink2);

                newCell2.appendChild(emailMailtoLink2SpanContainer);

                //var emailMailtoLink3SpanContainer = document.createElement('span');
                //emailMailtoLink3SpanContainer.className = 'ebsta-emailAddressContainer';

                var emailMailtoLink3 = document.createElement('a');
                emailMailtoLink3.href = 'mailto:' + dataItem.To.Address;
                emailMailtoLink3.target = '_top';
                emailMailtoLink3.appendChild(document.createTextNode(dataItem.To.Address));
                emailMailtoLink3.className = 'pointer activity-email-link';

                //emailMailtoLink3SpanContainer.appendChild(emailMailtoLink3);

                newCell6.appendChild(emailMailtoLink3);

                var blackListCell = document.createElement('span');
                blackListCell.appendChild(document.createTextNode(' '));
                blackListCell.setAttribute('emailAddress', dataItem.FromAddress.Address);
                blackListCell.setAttribute('emailId', dataItem.EmailDocumentId);
                blackListCell.setAttribute('class', 'blacklist-menu pointer');
                blackListCell.title = 'Privacy';

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny slds-m-right--small', '#down');

                blackListCell.appendChild(arrowMenuIconSvg);

                var menuHolderDiv = document.createElement('div');
                menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left contact-menu-div-' + dataItem.EmailDocumentId;
                menuHolderDiv.setAttribute('role', 'dialog');

                var contactPopupMenu = document.createElement('ul');
                contactPopupMenu.setAttribute('class', '');
                //contactPopupMenu.setAttribute('style', 'display: none;');

                var menuItem1 = document.createElement('li');
                menuItem1.setAttribute('class', 'ebsta-blacklist-singleitem pointer');
                menuItem1.setAttribute('emailAddress', dataItem.FromAddress.Address);
                menuItem1.setAttribute('emailId', dataItem.EmailDocumentId);

                var menuLink = document.createElement('a');

                var blockIconSpan = document.createElement('span');
                blockIconSpan.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan.appendChild(arrowMenuIconSvg);

                menuLink.appendChild(blockIconSpan);
                menuLink.appendChild(document.createTextNode('Hide Email'));

                menuItem1.appendChild(menuLink);

                var menuItem2 = document.createElement('li');
                menuItem2.setAttribute('class', 'pointer ebsta-blacklist-allactivity');
                menuItem2.setAttribute('emailAddress', dataItem.FromAddress.Address);

                var menuLink2 = document.createElement('a');

                var blockIconSpan2 = document.createElement('span');
                blockIconSpan2.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg2 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan2.appendChild(arrowMenuIconSvg2);

                menuLink2.appendChild(blockIconSpan2);
                menuLink2.appendChild(document.createTextNode('Hide All Emails'));

                menuItem2.appendChild(menuLink2);


                var menuItem3 = document.createElement('li');
                menuItem3.setAttribute('class', 'pointer ebsta-blacklist-allactivitycontact');
                menuItem3.setAttribute('emailAddress', dataItem.FromAddress.Address);

                var menuLink3 = document.createElement('a');

                var blockIconSpan3 = document.createElement('span');
                blockIconSpan3.setAttribute('class', 'ebsta-block-icon slds-icon__container');

                var arrowMenuIconSvg3 = CreateSvgWithUseTag('slds-icon-replacement-class lds-icon-text-default slds-icon--tiny', '#ban');

                blockIconSpan3.appendChild(arrowMenuIconSvg3);

                menuLink3.appendChild(blockIconSpan3);
                menuLink3.appendChild(document.createTextNode('Hide All Emails & Contact'));

                menuItem3.appendChild(menuLink3);

                if (!userHasPrivacyControl) {
                    menuLink.setAttribute('class', 'ebsta-disabledLink');
                    menuLink2.setAttribute('class', 'ebsta-disabledLink');
                    menuLink3.setAttribute('class', 'ebsta-disabledLink');
                }

                contactPopupMenu.appendChild(menuItem1);
                contactPopupMenu.appendChild(menuItem2);
                contactPopupMenu.appendChild(menuItem3);

                menuHolderDiv.appendChild(contactPopupMenu);

                if (userHasPrivacyControl) {
                    newCell2.appendChild(blackListCell);
                    newCell2.appendChild(menuHolderDiv);
                }                

                newRow.appendChild(newCell1);
                newRow.appendChild(newCell2);
                newRow.appendChild(magnifyCell);
                newRow.appendChild(newCell3);
                newRow.appendChild(newCell4);
                newRow.appendChild(newCell6);
                newRow.appendChild(newCell7);
            }

            j$(".emailsRecievedTable").append(newRow);
        }
    }

    ApplyDisplayEvents();

    j$(".slds-icon").focus();

    //set up paging.
    SetupPaging('ebsta-received-pagination', totalPages, pageNumber, searchTerm);
}

function CreateSvgWithUseTag(className, svgLink) {
    var mainSvg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    mainSvg.setAttribute('aria-hidden', 'true');
     mainSvg.setAttribute('class', '' + className);

    var useTag = document.createElementNS("http://www.w3.org/2000/svg", "use");
    useTag.setAttributeNS('http://www.w3.org/1999/xlink', 'href', '' + svgLink);

    mainSvg.appendChild(useTag);

    return mainSvg;
}

var resultsListSent;

function DisplayResultsSent(jsontxt, pageNumber) {
    var data1 = JSON.parse(jsontxt);
    resultsListSent = data1.searchResultsItems;

    var totalPages = data1.totalPages;
    var searchTerm = data1.searchTerm;
    var totalResults = data1.totalRecords;

    if (resultsListSent.length == 0) {
        j$('.emailsSendCounter').text('(0)');
        DisplayNoResults(7, 'emailsSentTable', 'emails');
    } else {

        var additionalRecordText = '';

        if (totalPages > 1) {
            additionalRecordText = '+';
        }

        j$('.emailsSendCounter').text('(' + totalResults + ')');

        j$(".emailsSentTable").html('');

        for (var i = 0; i < resultsListSent.length; i++) {
            var dataItem = resultsListSent[i];

            var newRow = document.createElement('tr');
            newRow.setAttribute('emailId', '' + dataItem.emailDocumentId);
            newRow.setAttribute('class', 'emailRow ebsta-row');
            newRow.setAttribute('title', 'Loading');

            var newCell1 = document.createElement('td');
            var spanTracking1 = document.createElement('span')
            spanTracking1.setAttribute('class', 'trackingrecipientspan');

            newCell1.appendChild(spanTracking1);

            var newCell2 = document.createElement('td');
            newCell2.appendChild(document.createTextNode(dataItem.FromAddress.address));

            var newCell3 = document.createElement('td');

            var subjectLink = document.createElement('a');
            subjectLink.href = '#';
            subjectLink.appendChild(document.createTextNode(dataItem.subject));

            newCell3.appendChild(subjectLink);
            newCell3.setAttribute('class', 'emailExpand');
            newCell3.setAttribute('emailId', '' + dataItem.emailDocumentId);

            var newCell4 = document.createElement('td');
            newCell4.appendChild(document.createTextNode(FormatDateTime(dataItem.receivedTime)));

            //var newCell5 = document.createElement('td');
            //newCell5.appendChild(document.createTextNode(FormatDateTime(dataItem.SentTime)));

            var newCell6 = document.createElement('td');
            newCell6.appendChild(document.createTextNode(dataItem.to.address));

            var newCell7 = document.createElement('td');
            var addContact1 = document.createElement('span')
            addContact1.setAttribute('class', 'addContact');
            addContact1.setAttribute('emailId', 'S-' + i)


            var to = dataItem.to;
            var toEmailAddress = '';
            var toFirstName = '';
            var toLastName = '';

            if (to != null && typeof to != "undefined") {
                toEmailAddress = to.address;
                var toName = to.name;

                if (toName != null && typeof toName != "undefined") {
                    var nameArray = toName.split(' ');

                    if (nameArray) {
                        if (nameArray.length > 0) {
                            toFirstName = nameArray[0];
                        }

                        if (nameArray.length > 1) {
                            toLastName = nameArray[1];
                        }
                    }
                }
            }

            addContact1.setAttribute('firstname', '' + toFirstName);
            addContact1.setAttribute('lastname', '' + toLastName);
            addContact1.setAttribute('emailaddress', '' + toEmailAddress);

            var addemail1 = document.createElement('span');

            var emailIsAdded = dataItem.sfAddedId;
            var addIconClass = '';

            if (emailIsAdded === "") {
                addIconClass = 'addEmail';
            } else {
                addIconClass = 'addEmailAdded';
                addemail1.setAttribute("salesforceId", "" + emailIsAdded);
            }

            addemail1.setAttribute('class', '' + addIconClass);
            addemail1.setAttribute('emailId', '' + dataItem.emailDocumentId);
            addemail1.setAttribute("markemailid", '' + dataItem.emailDocumentId);

            newCell7.appendChild(addContact1);
            newCell7.appendChild(addemail1);

            newRow.appendChild(newCell1);
            newRow.appendChild(newCell2);
            newRow.appendChild(newCell3);
            newRow.appendChild(newCell4);
            //    newRow.appendChild(newCell5);
            newRow.appendChild(newCell6);
            newRow.appendChild(newCell7);

            j$(".emailsSentTable").append(newRow);
        }
    }
    ApplyDisplayEvents();

    //set up paging.
    SetupPaging('ebsta-sent-pagination', totalPages, pageNumber, searchTerm);
}

function DisplayResultsRelationships(jsontxt, pageNumber, searchObject) {

    var data1 = JSON.parse(jsontxt);

    resultsListRec = data1.SearchResultsItems;
    var totalPages = data1.TotalPages;
    var searchTerm = searchObject;
    var totalResults1 = data1.Counter;

    var resultsList = data1.SearchResultsItems;
    var searchTerm = data1.SearchTerm;
    var contactListForFilters = [];

    if (resultsList.length == 0) {
        j$('.relationshipCounter').text('(0)');
        DisplayNoResults(7, 'relationshipsTable', 'contacts');
    } else {
        j$('.relationshipCounter').text('(' + totalResults1 + ')');

        j$(".relationshipsTable").html('');

        var totalResults2 = totalResults1;

        for (var i = 0; i < resultsList.length; i++) {
            var dataItem = resultsList[i];


            var newRow = document.createElement('tr');
            newRow.className = 'ebsta-row';

            var newCell1 = document.createElement('td');
            newCell1.appendChild(document.createTextNode(''));

            var newCell2 = document.createElement('td');

            var newProgress = document.createElement('div');
            newProgress.setAttribute('class', 'progress ebsta-progress');

            var velocityPercentage = 0;

            if (dataItem.Velocity && dataItem.Velocity != "") {
                velocityPercentage = dataItem.Velocity / 10
            }

            var leftBusiness = '' + dataItem.LeftBusiness;
            var emailTypeIcon = document.createElement('span');
            emailTypeIcon.className = 'ebsta-display-svg-medium ebsta-fill-red ebsta-media-icon-style';

            if (leftBusiness === "true") {
                //grey out the row.                        	
                newRow.className = 'ebsta-row ebsta-leftbusiness-tr';

                emailTypeIcon.className = emailTypeIcon.className + ' ebsta-leftbusiness-icon';

                //add left business icon.                        	
                emailTypeIcon.title = 'Left business';
            } else { //they have not left the business - check the out of office situation.
                var returnDate = dataItem.ReturnDate;

                if (returnDate !== null && returnDate !== '') {
                    var dateSplitter = returnDate.split('/');
                    if (dateSplitter.length === 3) {
                        var yearFigure = dateSplitter[2];
                        var monthFigure = dateSplitter[1];
                        var dayFigure = dateSplitter[0];

                        var returnDateFormat = new Date(yearFigure, monthFigure, dayFigure);
                        var currentDate = new Date();

                        if (returnDateFormat > currentDate) {
                            //add out of office icon.                        	
                            emailTypeIcon.setAttribute('title', 'Out of office - ' + returnDateFormat);
                            emailTypeIcon.className = emailTypeIcon.className + ' ebsta-outofoffice-icon';
                        }
                    }
                }
            }

            var newProgressBar = document.createElement('div');
            newProgressBar.setAttribute('class', 'progress-bar');
            newProgressBar.setAttribute('role', 'progressbar');
            newProgressBar.setAttribute('aria-valuenow', '' + velocityPercentage);
            newProgressBar.setAttribute('aria-valuemin', '0');
            newProgressBar.setAttribute('aria-valuemax', '1000');
            newProgressBar.setAttribute('style', 'width: ' + velocityPercentage + '%;');

            newProgress.appendChild(newProgressBar);

            var spanComment = document.createElement('span')
            spanComment.setAttribute('class', 'sr-only');
            spanComment.appendChild(document.createTextNode('' + velocityPercentage + ' Score'));

            newProgressBar.appendChild(spanComment);


            newCell2.appendChild(newProgress);

            var newCell3 = document.createElement('td');

            var renderContact = true;

            if (dataItem.ContactName === '' || dataItem.ContactName === null) {
                if (dataItem.EmailAddress != null) {
                    if (dataItem.EmailAddress.indexOf("005") != -1) {
                        renderContact = false;
                    } else {
                        newCell3.appendChild(document.createTextNode(dataItem.EmailAddress));
                    }
                }
            } else {
                if (dataItem.EmailAddress.indexOf("005") != -1) {
                    renderContact = false;
                } else {
                    newCell3.appendChild(document.createTextNode(dataItem.ContactName));
                }
            }

            contactListForFilters.push(dataItem.EmailAddress);

            var newCell3a = document.createElement('td');

            if (dataItem.JobTitle != null) {
                newCell3a.appendChild(document.createTextNode(dataItem.JobTitle));
            }

            var newCell3b = document.createElement('td');

            if (dataItem.Phone != null) {
                newCell3b.appendChild(document.createTextNode(dataItem.Phone));
            }

            var newCell4 = document.createElement('td');

            if (dataItem.EmailAddress != null) {
                var emailMailtoLink = document.createElement('a');
                emailMailtoLink.href = 'mailto:' + dataItem.EmailAddress;
                emailMailtoLink.target = '_top';
                emailMailtoLink.appendChild(document.createTextNode(dataItem.EmailAddress));
                emailMailtoLink.className = 'pointer contact-email-link';

                newCell4.appendChild(emailMailtoLink);
            }

            var blackListCell = document.createElement('span');
            blackListCell.appendChild(document.createTextNode(' '));
            blackListCell.setAttribute('emailAddress', dataItem.EmailAddress);
            blackListCell.setAttribute('class', 'blacklist-menu slds-icon__container pointer');
            blackListCell.setAttribute('emailId', i);
            blackListCell.title = 'Privacy';

            if (userHasPrivacyControl) {
                newCell4.appendChild(blackListCell);
            }

            var menuHolderDiv = document.createElement('div');
            menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left contact-menu-div-' + i;
            menuHolderDiv.setAttribute('role', 'dialog');

            var blockIconSpan = document.createElement('span');
            blockIconSpan.setAttribute('class', 'ebsta-block-icon slds-icon__container');

            var blockIconSpan2 = document.createElement('span');
            blockIconSpan2.setAttribute('class', 'ebsta-block-icon slds-icon__container');

            var contactPopupMenu = document.createElement('ul');
            contactPopupMenu.setAttribute('class', 'slds-popover__content');
            //contactPopupMenu.setAttribute('style', 'display: none;');

            var menuItem1 = document.createElement('li');
            menuItem1.setAttribute('class', 'ebsta-blacklist-allactivity pointer');
            menuItem1.setAttribute('emailAddress', dataItem.EmailAddress);

            var menuLink = document.createElement('a');
            menuLink.appendChild(blockIconSpan);
            menuLink.appendChild(document.createTextNode('Hide All Emails'));

            var menuItem2 = document.createElement('li');
            menuItem2.setAttribute('class', 'ebsta-blacklist-allactivitycontact pointer');
            menuItem2.setAttribute('emailAddress', dataItem.EmailAddress);

            var menuLink2 = document.createElement('a');
            menuLink2.appendChild(blockIconSpan2);
            menuLink2.appendChild(document.createTextNode('Hide All Emails & Contact'));

            menuItem1.appendChild(menuLink);
            menuItem2.appendChild(menuLink2);

            if (!userHasPrivacyControl) {
                menuLink.setAttribute('class', 'ebsta-disabledLink');
                menuLink2.setAttribute('class', 'ebsta-disabledLink');
            }

            contactPopupMenu.appendChild(menuItem1);
            contactPopupMenu.appendChild(menuItem2);
            menuHolderDiv.appendChild(contactPopupMenu);

            newCell4.appendChild(menuHolderDiv);

            //connected colleagues.
            var connectedColleagues = dataItem.Connected;

            var newCell5 = document.createElement('td');

            if (connectedColleagues) {
                if (connectedColleagues.length > 0) {
                    var firstConnectionName = connectedColleagues[0].Fullname;

                    var connectedColleagueSpan = document.createElement('span');
                    connectedColleagueSpan.className = 'ebsta-link-text ebsta-connected-colleagues-link';

                    var additionalConnections = '';

                    if (connectedColleagues.length > 1) {
                        additionalConnections = ' +' + (connectedColleagues.length - 1);
                    }

                    var nameDisplay = '';
                    var title = '';

                    for (var j = 0; j < connectedColleagues.length; j++) {
                        var colleague = connectedColleagues[j];

                        if (j > 0) {
                            title = title + '\n'; //add a line break.
                        }

                        if (colleague.fullname && colleague.fullname != "") {
                            title = title + colleague.Fullname;
                        } else {
                            title = title + colleague.EmailAddress;
                        }
                    }

                    if (firstConnectionName && firstConnectionName != "") {
                        nameDisplay = firstConnectionName + additionalConnections;
                    } else {
                        nameDisplay = connectedColleagues[0].EmailAddress + additionalConnections;
                    }

                    connectedColleagueSpan.appendChild(document.createTextNode(nameDisplay));
                    connectedColleagueSpan.title = title;

                    newCell5.appendChild(connectedColleagueSpan);
                }
            }

						var newCell6 = document.createElement('td');
						newCell6.setAttribute('class', 'last-interaction-date');
            // check if last interaction date exists and it's not starting with zero 
            if (dataItem.LastInteraction != null && dataItem.LastInteraction.indexOf('0') !== 0) {
								newCell6.appendChild(document.createTextNode(FormatDateTime(dataItem.LastInteraction)));
            }	else {
							newCell6.appendChild(document.createTextNode(""));
						}

            var newCell7 = document.createElement('td');
            var addContactRelationship = document.createElement('span');
            var addLeadRelationship = document.createElement('span');

            var foundContactSvgDisplay = '';
            var contactIcon = '';

            var renderLeadIcon = false;
            var renderContactIcon = false;
            var renderAddRecordIcon = false;

            if (dataItem.SalesforceId != '' && dataItem.SalesforceId != null) {

                renderContactIcon = true;

                addContactRelationship.setAttribute('class', 'foundContact pointer');
                addContactRelationship.setAttribute('sfId', '' + dataItem.SalesforceId);
                addContactRelationship.setAttribute('title', 'View Contact Record');
                foundContactSvgDisplay = 'slds-icon-replacement-class slds-icon-standard-contact slds-icon--small slds-m-right--small';
                contactIcon = "contact";
            }
            else {
                addContactRelationship.setAttribute('class', 'addContact pointer');
                addContactRelationship.setAttribute('title', 'Create New Contact Record');
                foundContactSvgDisplay = 'slds-icon-replacement-class slds-icon-text-default slds-icon--tiny slds-m-right--small';
                contactIcon = "new";

                renderAddRecordIcon = true;
            }

            var relatedObjectList = dataItem.RelatedObjects;

            for (var j = 0; j < relatedObjectList.length; j++) {
                var relatedSfObject = relatedObjectList[j];

                if (relatedSfObject.ObjectName == 'Lead') //check the lead object.
                {
                    if (relatedSfObject.RelatedId + '' !== '' && relatedSfObject.RelatedId !== null) {

                        renderLeadIcon = true;

                        addLeadRelationship.setAttribute('class', 'foundLead pointer');
                        addLeadRelationship.setAttribute('sfId', '' + relatedSfObject.RelatedId);
                        addLeadRelationship.setAttribute('title', 'View Lead Record');
                    } else {
                        addLeadRelationship.setAttribute('class', 'addLead pointer');
                        addLeadRelationship.setAttribute('title', 'Create New Lead Record');

                        renderAddRecordIcon = true;
                    }
                }
            }

            if (renderContactIcon && renderLeadIcon) {
                addContactRelationship.setAttribute('class', 'foundMultiplePeople pointer');
                addContactRelationship.setAttribute('title', 'View Multiple Records');
                renderLeadIcon = false; //don't render the lead only item if we have multiple.
            }

            var to = dataItem.to;
            var emailAddress = '';
            var firstName = '';
            var lastName = '';

            emailAddress = dataItem.EmailAddress;
            var toName = dataItem.ContactName;

            if (toName != null && typeof toName != "undefined") {
                var nameArray = toName.split(' ');

                if (nameArray) {
                    if (nameArray.length > 0) {
                        firstName = nameArray[0];
                    }

                    if (nameArray.length > 1) {
                        lastName = nameArray[1];
                    }
                }
            }

            addContactRelationship.setAttribute('firstname', '' + firstName);
            addContactRelationship.setAttribute('lastname', '' + lastName);
            addContactRelationship.setAttribute('emailaddress', '' + emailAddress);

            addLeadRelationship.setAttribute('firstname', '' + firstName);
            addLeadRelationship.setAttribute('lastname', '' + lastName);
            addLeadRelationship.setAttribute('emailaddress', '' + emailAddress);

            //var newContactIconRender = CreateSvgWithUseTag(foundContactSvgDisplay, '#' + contactIcon);

            //addContactRelationship.appendChild(newContactIconRender);

            if (!renderContactIcon && !renderLeadIcon) {
                var addNewObjectSpan = document.createElement('span');
                addNewObjectSpan.setAttribute('firstname', '' + firstName);
                addNewObjectSpan.setAttribute('lastname', '' + lastName);
                addNewObjectSpan.setAttribute('emailaddress', '' + emailAddress);
                addNewObjectSpan.setAttribute('phonenumber', '' + dataItem.Phone);
                addNewObjectSpan.setAttribute('jobtitle', '' + dataItem.JobTitle);

                addNewObjectSpan.setAttribute('emailId', i);
                addNewObjectSpan.title = 'Create New Record';
                addNewObjectSpan.className = 'addContactLead slds-icon__container pointer';

                var menuHolderDiv = document.createElement('div');
                menuHolderDiv.className = 'ebsta-menu-ul slds-popover slds-popover__content--small ebsta-hidden-tooltip slds-nubbin--left addcontactlead-menu-div-' + i;
                menuHolderDiv.setAttribute('role', 'dialog');

                var contactPopupMenu = document.createElement('ul');
                contactPopupMenu.setAttribute('class', 'slds-popover__content');

                var menuItem1 = document.createElement('li');
                menuItem1.setAttribute('class', 'addContact addContactContactsTab pointer');
                menuItem1.setAttribute('firstname', '' + firstName);
                menuItem1.setAttribute('lastname', '' + lastName);
                menuItem1.setAttribute('emailaddress', '' + emailAddress);
                menuItem1.setAttribute('phonenumber', '' + dataItem.Phone);
                menuItem1.setAttribute('jobtitle', '' + dataItem.JobTitle);

                var menuItem2 = document.createElement('li');
                menuItem2.setAttribute('class', 'addLead addLeadContactsTab pointer');
                menuItem2.setAttribute('firstname', '' + firstName);
                menuItem2.setAttribute('lastname', '' + lastName);
                menuItem2.setAttribute('emailaddress', '' + emailAddress);
                menuItem2.setAttribute('phonenumber', '' + dataItem.Phone);
                menuItem2.setAttribute('jobtitle', '' + dataItem.JobTitle);

                var menuLink = document.createElement('a');
                menuLink.appendChild(document.createTextNode('Create New Contact Record'));

                menuItem1.appendChild(menuLink);

                var menuLink2 = document.createElement('a');
                menuLink2.appendChild(document.createTextNode('Create New Lead Record'));

                menuItem2.appendChild(menuLink2);

                if (userHasContactAccess == "true") {
                    contactPopupMenu.appendChild(menuItem1);
                }

                if (userHasLeadAccess == "true") {
                    contactPopupMenu.appendChild(menuItem2);
                }

                menuHolderDiv.appendChild(contactPopupMenu);

                //Add contact/lead button - uncomment to hide in lightning mode.
                //if(!lightningMode)
                //{
                newCell7.appendChild(addNewObjectSpan);
                newCell7.appendChild(menuHolderDiv);
                //}
            }

            if (renderContactIcon) {
                newCell7.appendChild(addContactRelationship);
            }

            if (renderLeadIcon) {
                newCell7.appendChild(addLeadRelationship);
            }

            //linkedin
            if (dataItem.Linkedin != null && typeof dataItem.Linkedin != "undefined") {
                var linkedinIcon = document.createElement('span');
                linkedinIcon.setAttribute('class', 'ebsta-media-icon ebsta-linkedin-icon pointer');
                linkedinIcon.setAttribute('linkUrl', '' + dataItem.Linkedin);
                linkedinIcon.setAttribute('title', 'View LinkedIn');

                newCell7.appendChild(linkedinIcon);
            }

            //twitter
            if (dataItem.Twitter != null && typeof dataItem.Twitter != "undefined") {
                var twitterIcon = document.createElement('span');
                twitterIcon.setAttribute('class', 'ebsta-media-icon ebsta-twitter-icon pointer');
                twitterIcon.setAttribute('linkUrl', '' + dataItem.Twitter);
                twitterIcon.setAttribute('title', 'View Twitter');

                newCell7.appendChild(twitterIcon);
            }


            //facebook
            if (dataItem.Facebook != null && typeof dataItem.Facebook != "undefined") {
                var facebookIcon = document.createElement('span');
                facebookIcon.setAttribute('class', 'ebsta-media-icon ebsta-facebook-icon pointer');
                facebookIcon.setAttribute('linkUrl', '' + dataItem.Facebook);
                facebookIcon.setAttribute('title', 'View Facebook');

                newCell7.appendChild(facebookIcon);
            }

            //youtube
            if (dataItem.Youtube != null && typeof dataItem.Youtube != "undefined") {
                var youtubeIcon = document.createElement('span');
                youtubeIcon.setAttribute('class', 'ebsta-media-icon ebsta-youtube-icon pointer');
                youtubeIcon.setAttribute('linkUrl', '' + dataItem.Youtube);
                youtubeIcon.setAttribute('title', 'View Youtube');

                newCell7.appendChild(youtubeIcon);
            }

            //google+
            if (dataItem.Googleplus != null && typeof dataItem.Googleplus != "undefined") {
                var googleplusIcon = document.createElement('span');
                googleplusIcon.setAttribute('class', 'ebsta-media-icon ebsta-googleplus-icon pointer');
                googleplusIcon.setAttribute('linkUrl', '' + dataItem.Googleplus);
                googleplusIcon.setAttribute('title', 'View Google+');

                newCell7.appendChild(googleplusIcon);
            }

            //add the email type icon.
            newCell7.appendChild(emailTypeIcon);

            //newRow.appendChild(newCell1);
            newRow.appendChild(newCell2); //velocity.
            newRow.appendChild(newCell3); //contact name.
            newRow.appendChild(newCell3a); //contact name.
            newRow.appendChild(newCell3b); //contact name.
            newRow.appendChild(newCell4); //email address.
            //    newRow.appendChild(newCell5);
            newRow.appendChild(newCell6); //last interaction.

            newRow.appendChild(newCell5); //connected colleagues.

            newRow.appendChild(newCell7); //add/found contact.

            //only render the coontact if we have good data.
            if (renderContact) {
                j$(".relationshipsTable").append(newRow);
            } else {
                totalResults2--;
            }
        }

        //render the new count.
        if (totalResults2 <= 0) {
            DisplayNoResults(7, 'relationshipsTable', 'contacts');
        }

        j$('.relationshipCounter').text('(' + totalResults2 + ')');
    }

    //populate the contact filter list.
    for (var c = 0; c < contactListForFilters.length; c++) {
        var inputElement = document.createElement('input');
        //inputElement.setAttribute('checked', 'checked');
        //inputElement.setAttribute('type', 'checkbox');
        inputElement.setAttribute('type', 'radio');
        inputElement.setAttribute('name', 'contactfilters');
        inputElement.setAttribute('value', '' + contactListForFilters[c]);
        inputElement.setAttribute('contactStringValue', '' + contactListForFilters[c]);
        inputElement.setAttribute('class', 'ebsta-contact-filter-checkbox');

        var newListItem = document.createElement('li');
        newListItem.appendChild(document.createTextNode(contactListForFilters[c]));
        newListItem.appendChild(inputElement);

        j$(".ebsta-contact-filter-list").append(newListItem);

        //add to the filter.
        //AddFilter('To', '' + contactListForFilters[c], '', '');
    }

    //populate the user filter list.
    for (var d = 0; d < data1.UserList.length; d++) {
        var inputElement = document.createElement('input');
        //inputElement.setAttribute('checked', 'checked');
        //inputElement.setAttribute('type', 'checkbox');
        inputElement.setAttribute('type', 'radio');
        inputElement.setAttribute('name', 'userfilters');
        inputElement.setAttribute('value', '' + data1.UserList[d]);
        inputElement.setAttribute('contactStringValue', '' + data1.UserList[d]);
        inputElement.setAttribute('class', 'ebsta-user-filter-checkbox');

        var newListItem = document.createElement('li');
        newListItem.appendChild(document.createTextNode(data1.UserList[d]));
        newListItem.appendChild(inputElement);

        j$(".ebsta-user-filter-list").append(newListItem);

        //add to the filter.
        //AddFilter('From', '' + data1.UserList[d], '', '');
    }

    ApplyDisplayEvents();
    SetupPaging('ebsta-relationships-pagination', totalPages, pageNumber, searchObject);
}

function ConvertDateToUtc(date) {

    //take the current date value, add both the calendar and the user offsets.
    var convertedDateTime = new Date(date.getTime() + userLocaleOffset);

    //return the new date.
    return convertedDateTime;
}

function FormatDateTime(dateString) {

    var dateConversionString = '';

    //ensure the incoming date is in RFC2822/ISO 8601 format to ensure correct locale timezone conversion.
    if (dateString.indexOf('.000Z') == -1) {
        dateConversionString = dateString + '.000Z';
    } else {
        dateConversionString = dateString;
    }

    //parse datestring into a date object.
    var date = new Date(dateConversionString);

    //format the date accoring to the browser locale.
    var formattedDateString = date.toLocaleDateString() + ' ' + date.toLocaleTimeString(navigator.language, { hour: '2-digit', minute: '2-digit' });

    return formattedDateString;
}

function FormatDate(dateString, renderAsUtc) {

    var dateConversionString = '';

    //ensure the incoming date is in RFC2822/ISO 8601 format to ensure correct locale timezone conversion.
    if (dateString.indexOf('.000Z') == -1) {
        dateConversionString = dateString + '.000Z';
    } else {
        dateConversionString = dateString;
    }

    //parse datestring into a date object.
    var date = new Date(dateConversionString);

    //timezone offset is applied automatically by the browser - convert back to utc using the offset.
    if (renderAsUtc) {
        date = ConvertDateToUtc(date);
    }

    //format the date accoring to the browser locale.
    var formattedDateString = date.toLocaleDateString();

    return formattedDateString;
}

function FormatDateWithDayName(dateString) {

    var formattedDateString = new Date(dateString).toLocaleString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' });

    return formattedDateString;
}

function DisplayUnauthorizedRow(columns, tableClass) {
    j$("." + tableClass).html('');

    var newRow = document.createElement('tr');

    var searchTermLabel = 'You are not authorized to access this data - please connect an email account to Ebsta!';

    var newCell = document.createElement('td');
    newCell.setAttribute("colspan", "" + columns);
    newCell.setAttribute("style", "text-align:center;");
    newCell.appendChild(document.createTextNode(searchTermLabel));

    newRow.appendChild(newCell);

    j$("." + tableClass).append(newRow);
}

function DisplayCustomMessageRow(columns, tableClass, messageLabel) {
    j$("." + tableClass).html('');

    var newRow = document.createElement('tr');

    var newCell = document.createElement('td');
    newCell.setAttribute("colspan", "" + columns);
    newCell.setAttribute("style", "text-align:center;");
    newCell.appendChild(document.createTextNode(messageLabel));

    newRow.appendChild(newCell);

    j$("." + tableClass).append(newRow);
}


function DisplayNoResults(columns, tableClass, mainSearchTerm) {
    j$("." + tableClass).html('');

    var newRow = document.createElement('tr');

    var searchTermLabel = 'No ' + mainSearchTerm + ' found.';

    if (mainSearchTerm !== 'alerts' && mainSearchTerm !== 'contacts' && searchFilterList.length > 0) {
        searchTermLabel = searchTermLabel + '\n Filters: ';

        var filtersDisplayed = 0;

        for (var i = 0; i < searchFilterList.length; i++) {
            var filterItem = searchFilterList[i];
            if (filterItem.FieldName != null && filterItem.FieldValue != null) {

                if (filtersDisplayed > 0) {
                    searchTermLabel = searchTermLabel + ', ';
                }

                var clearFilterLabel = false;

                var filterValue = '';

                if (filterItem.FieldName.toLowerCase() == "sent" && filterItem.FieldValue == "true") {

                    filterValue = 'Sent';

                    if (hideDefaultFilters + "" === "true") {
                        clearFilterLabel = true;
                    }
                }

                if (filterItem.FieldName.toLowerCase() == "sent" && filterItem.FieldValue == "false") {
                    filterValue = 'Received';

                    if (hideDefaultFilters + "" === "true") {
                        clearFilterLabel = true;
                    }
                }

                if (filterItem.FieldName.toLowerCase() == "calls") {
                    filterValue = 'Calls';

                    if (hideDefaultFilters + "" === "true") {
                        clearFilterLabel = true;
                    }
                }

                if (filterItem.FieldName.toLowerCase() == "meetings") {
                    filterValue = 'Meetings';

                    if (hideDefaultFilters + "" === "true") {
                        clearFilterLabel = true;
                    }
                }

                if (filterItem.FieldName === 'RecievedFromTo') {
                    filterValue = 'Date (' + filterItem.FromDate + ' - ' + filterItem.ToDate + ')';
                }

                if (filterItem.FieldName.toLowerCase() == "salesforceactivitytype") {
                    filterValue = '' + filterItem.FieldValue + ' (type)';
                }

                if (!clearFilterLabel) {
                    filtersDisplayed++;
                    searchTermLabel = searchTermLabel + filterValue;
                }
            }
        }

        searchTermLabel = searchTermLabel + '.';
    }

    var newCell = document.createElement('td');
    newCell.setAttribute("colspan", "" + columns);
    newCell.setAttribute("style", "text-align:center; white-space: pre;");
    newCell.appendChild(document.createTextNode(searchTermLabel));

    newRow.appendChild(newCell);

    j$("." + tableClass).append(newRow);
}

function SetupPaging(paginationClass, totalPages, pageNumber, searchString) {

    j$("." + paginationClass + " .ebsta-page-number-tab").remove(); //remove the exisiting page number tabs.

    //next page click event.
    j$("body").undelegate("." + paginationClass + " .ebsta-page-next", "click");
    j$("body").delegate("." + paginationClass + " .ebsta-page-next", "click", function () {

        var currentPageSelection = j$("." + paginationClass + " .ebsta-selected-page").attr("page-number");

        var nextPageToLoad = 1;

        if (pageNumber != null && typeof pageNumber != "undefined") {
            nextPageToLoad = parseInt(currentPageSelection) + 1;
        }

        if (nextPageToLoad <= totalPages) {

            //log the event.
            LogEvent('PagingNextClicked', 'LoadPage: ' + nextPageToLoad, 438);

            if (paginationClass == "ebsta-activity-pagination") {
                LoadActivity(50, nextPageToLoad, searchString);
            }

            if (paginationClass == "ebsta-received-pagination") {
                LoadRecievedEmailsWithFilters(50, nextPageToLoad, searchString);
            }

            if (paginationClass == "ebsta-sent-pagination") {
                LoadRecievedEmailsWithFilters(50, nextPageToLoad, searchString);
            }

            if (paginationClass == "ebsta-relationships-pagination") {
                LoadRelationships(10, nextPageToLoad, searchString);
            }
        }
    });

    //previous page click event.
    j$("body").undelegate("." + paginationClass + " .ebsta-page-previous", "click");
    j$("body").delegate("." + paginationClass + " .ebsta-page-previous", "click", function () {
        var currentPageSelection = j$("." + paginationClass + " .ebsta-selected-page").attr("page-number");


        var nextPageToLoad = 1;

        if (pageNumber != null && typeof pageNumber != "undefined") {
            nextPageToLoad = parseInt(currentPageSelection) - 1;
        }

        if (nextPageToLoad > 0) {

            //log the event.
            LogEvent('PagingPreviousClicked', 'LoadPage: ' + nextPageToLoad, 439);

            if (paginationClass == "ebsta-activity-pagination") {
                LoadActivity(50, nextPageToLoad, searchString);
            }

            if (paginationClass == "ebsta-received-pagination") {
                LoadRecievedEmailsWithFilters(50, nextPageToLoad, searchString);
            }

            if (paginationClass == "ebsta-sent-pagination") {
                LoadRecievedEmailsWithFilters(50, nextPageToLoad, searchString);
            }

            if (paginationClass == "ebsta-relationships-pagination") {
                LoadRelationships(10, nextPageToLoad, searchString);
            }
        }
    });

    //click events are set up - render the selected tabs properly.
    if (totalPages > 5) //set the middle tab as selected and adjust next/prev 2 page numbers accordingly.
    {
        if (pageNumber > 2) {

            if (pageNumber > (totalPages - 2)) {
                var tab1 = CreatePagingTab(totalPages - 5);
                var tab2 = CreatePagingTab(totalPages - 4);
                var tab3 = CreatePagingTab(totalPages - 3);
                var tab4 = CreatePagingTab(totalPages - 2);
                var tab5 = CreatePagingTab(totalPages - 1);

                if (pageNumber == (totalPages - 4)) {
                    tab1.className = tab1.className + ' ebsta-selected-page';
                }

                if (pageNumber == (totalPages - 3)) {
                    tab2.className = tab2.className + ' ebsta-selected-page';
                }

                if (pageNumber == (totalPages - 2)) {
                    tab3.className = tab3.className + ' ebsta-selected-page';
                }

                if (pageNumber == (totalPages - 1)) {
                    tab4.className = tab4.className + ' ebsta-selected-page';
                }

                if (pageNumber == totalPages) {
                    tab5.className = tab5.className + ' ebsta-selected-page';
                }

                j$("." + paginationClass + " .ebsta-page-previous").after(tab5);
                j$("." + paginationClass + " .ebsta-page-previous").after(tab4);
                j$("." + paginationClass + " .ebsta-page-previous").after(tab3);
                j$("." + paginationClass + " .ebsta-page-previous").after(tab2);
                j$("." + paginationClass + " .ebsta-page-previous").after(tab1);
            } else {
                var currentPageTab = CreatePagingTab(pageNumber - 1);
                currentPageTab.className = currentPageTab.className + ' ebsta-selected-page';

                var previous1 = CreatePagingTab(pageNumber - 2);
                var previous2 = CreatePagingTab(pageNumber - 3);
                var next1 = CreatePagingTab(pageNumber);
                var next2 = CreatePagingTab(pageNumber + 1);

                j$("." + paginationClass + " .ebsta-page-previous").after(next2);
                j$("." + paginationClass + " .ebsta-page-previous").after(next1);
                j$("." + paginationClass + " .ebsta-page-previous").after(currentPageTab);
                j$("." + paginationClass + " .ebsta-page-previous").after(previous1);
                j$("." + paginationClass + " .ebsta-page-previous").after(previous2);
            }
        } else {
            var tab1 = CreatePagingTab(0);
            var tab2 = CreatePagingTab(1);
            var tab3 = CreatePagingTab(2);
            var tab4 = CreatePagingTab(3);
            var tab5 = CreatePagingTab(4);

            if (pageNumber == 1) {
                tab1.className = tab1.className + ' ebsta-selected-page';
            }

            if (pageNumber == 2) {
                tab2.className = tab2.className + ' ebsta-selected-page';
            }

            j$("." + paginationClass + " .ebsta-page-previous").after(tab5);
            j$("." + paginationClass + " .ebsta-page-previous").after(tab4);
            j$("." + paginationClass + " .ebsta-page-previous").after(tab3);
            j$("." + paginationClass + " .ebsta-page-previous").after(tab2);
            j$("." + paginationClass + " .ebsta-page-previous").after(tab1);
        }

    } else { //otherwise just render all of them.
        for (var i = totalPages; i > 0; i--) {
            var newPagingTab = CreatePagingTab(i - 1);

            if (i == pageNumber) {
                newPagingTab.className = newPagingTab.className + ' ebsta-selected-page';
            }

            j$("." + paginationClass + " .ebsta-page-previous").after(newPagingTab);
        }
    }

    //set the click events for the tabs.
    j$("body").undelegate("." + paginationClass + " .ebsta-page-number-tab", "click");
    j$("body").delegate("." + paginationClass + " .ebsta-page-number-tab", "click", function () {
        var newPageNumberRaw = j$(this).attr("page-number");


        var newPageNumber = 1;

        if (newPageNumberRaw != null && typeof newPageNumberRaw != "undefined") {
            newPageNumber = parseInt(newPageNumberRaw);
        }

        if (newPageNumber != pageNumber) { //no point reloading the same page.

            //log the event.
            LogEvent('PagingPageClicked', 'LoadPage: ' + newPageNumber, 440);

            if (paginationClass == "ebsta-activity-pagination") {
                LoadActivity(50, newPageNumber, searchString);
            }

            if (paginationClass == "ebsta-received-pagination") {
                LoadRecievedEmailsWithFilters(50, newPageNumber, searchString);
            }

            if (paginationClass == "ebsta-sent-pagination") {
                LoadRecievedEmailsWithFilters(50, newPageNumber, searchString);
            }

            if (paginationClass == "ebsta-relationships-pagination") {
                LoadRelationships(10, newPageNumber, searchString);
            }
        }
    });
}

function CreatePagingTab(pageNumber) {
    var pageNumberDisplay = pageNumber + 1;

    var pageTab = document.createElement('button');
    pageTab.appendChild(document.createTextNode(pageNumberDisplay));
    pageTab.className = 'slds-button slds-button--neutral ebsta-page-number-tab';
    pageTab.setAttribute('page-number', '' + pageNumberDisplay);

    return pageTab;
}// JavaScript source code

// Show or hide more records in New Value column
function toggleShowMore() {
    j$(".toggler").click(function () {
        j$('.cat' + j$(this).attr('data-prod-cat')).toggle();

        if (j$(this).text() == "Show more") {
            j$(this).text("Show less");
        } else {
            j$(this).text("Show more");
        };

    });
}
