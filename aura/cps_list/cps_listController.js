({
    doInit: function(component, event, helper) {
		const items = component.get('v.items');
        const headings = [];
        
        for (const key in items[0]) {
            if (!items[0].hasOwnProperty(key)) {
                continue;
            }
            
        	headings.push(key);    
        }
        
        component.set('v.headings', headings);
	},
	itemsChange: function(component, event, helper) {
        
	}
})