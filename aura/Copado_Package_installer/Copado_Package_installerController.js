({
	doInit : function(component, event, helper) {
		component.set("v.columnName",[
            {
                label : 'Release Version',
                fieldName : 'copado__Version__c',
                type : 'text',
                sortable : false
            },
            {
                label : 'Date',
                fieldName : 'copado__Planned_Date__c',
                type : 'text',
                sortable : false,
            },
            /*{
                label : 'Notes',
                fieldName : 'Documentation_Release_Notes__c',
                type : 'url',
                sortable : false,
                typeAttributes:{label:{fieldName:'Release_Note_text'},target:'_blank',disabled: {fieldName: 'isDisabled'},}
            },*/
            {
                type: "button", 
                label: 'Notes',
                sortable : true,
                fieldName: 'Release_Note_text',
                disabled:{fieldName: 'isDisabled'},
                value: {fieldName: 'Documentation_Release_Notes__c'},
                typeAttributes: {
                    label: {fieldName: 'Release_Note_text'},
                    value: {fieldName: 'Id'},
                    name: 'noteBtn',
                    variant: 'base',
                    disabled: {fieldName: 'isDisabled'},
                },
            }
        ]);
        helper.GetAllRelease(component, event, helper);
	},
    doSubmit : function(component, event, helper){
        var LatestReleaseRecord = component.get("v.LatestReleaseRecord");
        if(component.get("v.selectedValue")=='Production'){
            window.location.href = LatestReleaseRecord.Installation_Link_in_Production__c;
        }
        else if(component.get("v.selectedValue")=='Sandbox'){
            window.location.href = LatestReleaseRecord.Installation_Link_in_Sandbox__c;
        }
    },
    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        if(action.name=="noteBtn"){    
            window.open(row.Documentation_Release_Notes__c,'_blank');
        }
    }
    
})