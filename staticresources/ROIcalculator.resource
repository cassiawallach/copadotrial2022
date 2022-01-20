var copado = copado || {};
//var sfRemoting = sfRemoting || {};
copado.pricelist = copado.pricelist || {};
copado.currency = copado.currency || {};
copado.stats = copado.stats || {};
copado.results = copado.results || {};
copado.ee = copado.ee || {};
copado.cbm = copado.cbm || {}; 

copado.currency.currencies = ['EUR', 'GBP', 'USD'];
copado.currency.activeCurrency = 'USD';

copado.pricelist.ee = {};
copado.pricelist.cbm = {};

//Calculation variables
copado.stats.eeUsers = 0;			
copado.stats.hourlyResourceCost = 75;	//Suggested USD resource cost.
copado.stats.sprints = 6; 	 			//Sprints per quarter
copado.stats.timeSavings_EE = 7;  		//Time saving per sprint/license
copado.stats.syncTime_WithoutCBM = 0;	//Per org
copado.stats.syncTime_WithCBM = 0;		//Per org
copado.stats.syncOrgs = 5;


//Calculated values 
copado.results.EE_QuarterlyTotalTimeSavings = 0;
copado.results.net_QuarterlyProductivityIncrease = 0;
copado.results.EE_YearLicenseCosts = 0;
copado.results.CBM_YearLicenseCosts = 0;
copado.results.CBM_MonthlyTotalTimeSavings = 0;
copado.results.CBM_MonthlyNetProductivityIncrease = 0;
copado.results.CBM_LicensesRequired = 5;


copado.getValues = function(){
	var s = copado.stats;
	s.eeUsers = document.getElementById("eeUsers").value;
	s.sprints = document.getElementById("SprintsPerQuarter").value;
	s.timeSavings_EE = document.getElementById("TimeSavedPerSprintUser").value;
	s.hourlyResourceCost = document.getElementById("hourlyResourceCost").value;
	s.syncTime_WithoutCBM = document.getElementById("syncTime_WithoutCBM").value;
	s.syncTime_WithCBM = document.getElementById("syncTime_WithCBM").value;
	s.syncOrgs = document.getElementById("syncOrgs").value;
}
copado.setValues = function(){
	var r = copado.results;
    var ac = copado.currency.activeCurrency;
	document.getElementById("EE_QuarterlyTotalTimeSavings").innerHTML = r.EE_QuarterlyTotalTimeSavings.toFixed(0)+' hours';
	document.getElementById("EE_YearlyTotalTimeSavings").innerHTML = (r.EE_QuarterlyTotalTimeSavings*4).toFixed(0)+' hours';
	
	document.getElementById("net_QuarterlyProductivityIncrease").innerHTML = r.net_QuarterlyProductivityIncrease.toLocaleString(ac,{ style:'currency', currency:ac});
	document.getElementById("net_YearlyProductivityIncrease").innerHTML = (r.net_QuarterlyProductivityIncrease*4).toLocaleString(ac,{ style:'currency', currency:ac});
	
	document.getElementById("EE_YearlyLicenseCosts").innerHTML = r.EE_YearLicenseCosts.toLocaleString(ac,{ style:'currency', currency:ac});
	document.getElementById("EE_QuarterlyLicenseCosts").innerHTML = (r.EE_YearLicenseCosts/4).toLocaleString(ac,{ style:'currency', currency:ac});

	document.getElementById("CBM_LicensesRequired").innerHTML = r.CBM_LicensesRequired;
	document.getElementById("CBM_YearLicenseCosts").innerHTML = r.CBM_YearLicenseCosts.toLocaleString(ac,{ style:'currency', currency:ac});
	document.getElementById("CBM_MonthlyLicenseCosts").innerHTML = (r.CBM_YearLicenseCosts/12).toLocaleString(ac,{ style:'currency', currency:ac});

	document.getElementById("CBM_MonthlyTotalTimeSavings").innerHTML = r.CBM_MonthlyTotalTimeSavings.toFixed(0)+' hours';
	document.getElementById("CBM_YearlyTotalTimeSavings").innerHTML = (12*r.CBM_MonthlyTotalTimeSavings).toFixed(0)+' hours';

	document.getElementById("CBM_MonthlyNetProductivityIncrease").innerHTML = r.CBM_MonthlyNetProductivityIncrease.toLocaleString(ac,{ style:'currency', currency:ac});
    document.getElementById("CBM_YearlyNetProductivityIncrease").innerHTML = (12*r.CBM_MonthlyNetProductivityIncrease).toLocaleString(ac,{ style:'currency', currency:ac});
};
copado.stats.updateCBMsyncTime = function(value){
	var s = copado.stats;
	s.syncTime_WithoutCBM = value;
	s.syncTime_WithCBM = (s.syncTime_WithoutCBM/100)*10;
	document.getElementById("syncTime_WithCBM").value = s.syncTime_WithCBM;
};
copado.stats.updateCBMlicensesRequired = function(value){
	var s = copado.stats;
	var r = copado.results;
	s.syncOrgs = value;
	r.CBM_LicensesRequired = (s.syncOrgs<5)?5:s.syncOrgs;
	document.getElementById("CBM_LicensesRequired").innerHTML = r.CBM_LicensesRequired;
};
copado.currency.changeCurrency = function(newValue){
	copado.currency.activeCurrency = newValue;
};
copado.loadPage = function(){
	var eesplit = copadoApp.pricelistEE.split(';'); //EUR:3600
	for(var i=0; i<eesplit.length; i++){
		var kvp = eesplit[i].split(':');
		copado.pricelist.ee[kvp[0]] = kvp[1];
	}
	var cbmSplit = copadoApp.pricelistCBM.split(';'); //EUR:3600
	for(var i=0; i<cbmSplit.length; i++){
		var kvp = cbmSplit[i].split(':');
		copado.pricelist.cbm[kvp[0]] = kvp[1];
	}
};
copado.calculateROI_EE = function(){
	var c = copado.ee;
	var s = copado.stats;
	var r = copado.results;
	r.EE_YearLicenseCosts = copado.pricelist.ee[copado.currency.activeCurrency] * s.eeUsers * 12;
	r.EE_QuarterlyTotalTimeSavings = s.eeUsers * s.timeSavings_EE;
	r.net_QuarterlyProductivityIncrease = (s.hourlyResourceCost * r.EE_QuarterlyTotalTimeSavings * s.sprints) - (r.EE_YearLicenseCosts/4);
};
copado.calculateROI_CBM = function(){
	var s = copado.stats;
	var r = copado.results;
	if(s.syncOrgs<5){
		alert('The minimum order level for Branch Management is 5 licenses.');
		return false;
	}
	r.CBM_YearLicenseCosts = (copado.pricelist.cbm[copado.currency.activeCurrency]) * copado.results.CBM_LicensesRequired * 12;
	r.CBM_MonthlyTotalTimeSavings = (s.syncTime_WithoutCBM - s.syncTime_WithCBM) * s.syncOrgs;
	r.CBM_MonthlyNetProductivityIncrease = r.CBM_MonthlyTotalTimeSavings * s.hourlyResourceCost - (r.CBM_YearLicenseCosts/12);
};
copado.doCalculations = function(){
	copado.getValues();
	copado.calculateROI_EE();
	copado.calculateROI_CBM();
	copado.setValues();
};