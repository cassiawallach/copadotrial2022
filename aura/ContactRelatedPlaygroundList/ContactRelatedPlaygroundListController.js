({
	doInit : function(component, event, helper) {
		component.set("v.columnName",[
            {
                label : 'Playground Name',
                fieldName : 'playgroundURL',
                type : 'url',
                sortable : false,
                typeAttributes:{label:{fieldName:'Name'},target:'_blank'}
            },
            {
                label : 'Playground Created Date',
                fieldName : 'CreatedDate',
                type : 'date',
                sortable : false
            },
            {
                label : 'Status',
                fieldName : 'Status__c',
                type : 'text',
                sortable : false
            },
            {
                label : 'Org Id',
                fieldName : 'Org_Id__c',
                type : 'text',
                sortable : false
            }
           
        ]);
        
        helper.GetPlaygrounds(component, event, helper);
	}
})