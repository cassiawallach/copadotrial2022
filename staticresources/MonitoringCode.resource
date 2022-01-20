// refresh the url, replacing a parameter (to have unique urls per subtab-detail)
function updateNavigation(param, paramVal) {
    var newURL = updateURLParameter(window.location.href, param, encodeURIComponent(paramVal));
    window.history.replaceState('', '', newURL);
}

/**
 * updates an url parameter ?xxx=yyy&zzz=000
 * http://stackoverflow.com/a/10997390/11236
 */
function updateURLParameter(url, param, paramVal, allowEmpty) {
    var newAdditionalURL = "";
    var tempArray = url.split("?");
    var baseURL = tempArray[0];
    var additionalURL = tempArray[1];
    var temp = "";
    if (additionalURL) {
        tempArray = additionalURL.split("&");
        for (var i = 0; i < tempArray.length; i++) {
            if (tempArray[i].split('=')[0] != param) {
                newAdditionalURL += temp + tempArray[i];
                temp = "&";
            }
        }
    }
    var rows_txt = ((allowEmpty || paramVal) ? (temp + "" + param + "=" + paramVal) : "");
    return baseURL + "?" + newAdditionalURL + rows_txt;
}

function callServiceAPI(endpoint, params, postData, methodName, callbackSuccess) {
    var formatParams = function (params) {
        return "?" + Object
            .keys(params)
            .map(function (key) {
                return key + "=" + encodeURIComponent(params[key]);
            })
            .join("&");
    };

    var errorHandler = function (err, msg, data) {
        console.error(err, data);
        alert('There was an error contacting the API.\n\nThe error was: ' + msg + '.\n\nDetails: ' + err);
        throw err;
    };

    var paramString = (Object.keys(params).length > 0) ? formatParams(params) : '';
    console.info('callServiceAPI() server', window.COPADO_ENDPOINT, endpoint, params, paramString, postData);
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        console.log('onreadystatechange called with readyState: ' + this.readyState + ' status: ' + this.status + '  ' + new Date());
        if (this.readyState == 4) {
            if (this.status >= 200 && this.status < 400) {
                console.info('callServiceAPI() response', this.status);
                console.log(this);
                try {
                    var jsonData = {};
                    if (this.responseText != null && this.responseText != '') {
                        jsonData = JSON.parse(this.responseText);
                    }
                    callbackSuccess(jsonData);
                } catch (excp) {
                    errorHandler(excp, 'Could not parse JSON data', this.responseText);
                }
            } else {
                var err = new Error('Status: ' + this.status + ' ' + this.responseText);
                errorHandler(err, 'HTTP error');
            }
        }
    };

    postData = postData !== null ? JSON.stringify(postData) : null;
    xhttp.open(methodName, window.COPADO_ENDPOINT + endpoint + paramString, true);
    xhttp.setRequestHeader('Content-type', 'application/json');
    // window.copadoRefreshToken is dynamically generated and changes periodically
    xhttp.setRequestHeader('Authorization', window.COPADO_TOKEN);
    try {
        xhttp.send(postData);
    } catch (excp) {
        errorHandler(excp, 'Network error');
    }
}

function escapeHtml(unsafe) {
    return unsafe
         .replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&#039;");
 }

function generateUrl(url, params) {
    var currentUrl = new URL(window.location.href);
	var FAKE_BASE_URL = 'https://t-o-b-e-r-e-m-o-v-e-d'; // needed for relative urls
    var url = new URL(url, FAKE_BASE_URL);
    url.searchParams.set('sfdc.tabName', currentUrl.searchParams.get("sfdc.tabName"));
    for(var k in params)
        url.searchParams.set(k, params[k]);
    return url.toString().replace(FAKE_BASE_URL, '');
}

function lockScreen(){
    console.log('locking');
    document.getElementById('screenLocker').style.display='block';
}

function unlockScreen(){
    document.getElementById('screenLocker').style.display='none';
}