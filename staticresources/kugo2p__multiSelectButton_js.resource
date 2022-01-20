	function showOptions(elemId) {
		//debugger;

		var elem = document.getElementById(elemId);
    	elem.classList.remove('slds-is-close');
    	elem.classList.add('slds-is-open');

    	//return false;
	}

	function hideOptions(elemId) {
		//debugger;

		setTimeout(function() {
			var elem = document.getElementById(elemId);
			elem.classList.remove('slds-is-open');
	    	elem.classList.add('slds-is-close');
	    }, 1000);

    	//return false;
	}	
