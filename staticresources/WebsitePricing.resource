var copado = copado || {};
copado.pricelist = copado.pricelist || {};
copado.currency = copado.currency || {};
copado.pe = copado.pe || {};
copado.ee = copado.ee || {};
copado.ccm = copado.ccm || {};
copado.cbm = copado.cbm || {}; 

copado.currency.currencies = ['EUR', 'GBP', 'USD'];
copado.currency.activeCurrency = 'EUR';

copado.pricelist.pe = {};
copado.pricelist.ee = {};
copado.pricelist.ccm = {}; 
copado.pricelist.cbm = {};


copado.setValues = function(){
	var ac = copado.currency.activeCurrency;
	document.getElementById("pePrice").innerHTML = (copado.pricelist.pe[ac]/1).toLocaleString(ac,{ style:'currency', currency:ac});
	document.getElementById("eePrice").innerHTML = (copado.pricelist.ee[ac]/1).toLocaleString(ac,{ style:'currency', currency:ac});
	document.getElementById("ccmPrice").innerHTML = (copado.pricelist.ccm[ac]/1).toLocaleString(ac,{ style:'currency', currency:ac});
	document.getElementById("cbmPrice").innerHTML = (copado.pricelist.cbm[ac]/1).toLocaleString(ac,{ style:'currency', currency:ac});
};
copado.currency.changeCurrency = function(newValue){
	copado.currency.activeCurrency = newValue;
};
copado.loadPage = function(){
	var pesplit = copadoApp.pricelistPE.split(';'); //EUR:300
	for(var i=0; i<pesplit.length; i++){
		var kvp = pesplit[i].split(':');
		copado.pricelist.pe[kvp[0]] = kvp[1];
	}
    var eesplit = copadoApp.pricelistEE.split(';'); //EUR:300
	for(var i=0; i<eesplit.length; i++){
		var kvp = eesplit[i].split(':');
		copado.pricelist.ee[kvp[0]] = kvp[1];
	}
	var ccmSplit = copadoApp.pricelistCCM.split(';'); //EUR:300
	for(var i=0; i<ccmSplit.length; i++){
		var kvp = ccmSplit[i].split(':');
		copado.pricelist.ccm[kvp[0]] = kvp[1];
	}
	var cbmSplit = copadoApp.pricelistCBM.split(';'); //EUR:300
	for(var i=0; i<cbmSplit.length; i++){
		var kvp = cbmSplit[i].split(':');
		copado.pricelist.cbm[kvp[0]] = kvp[1];
	}
    copado.setValues();
};
