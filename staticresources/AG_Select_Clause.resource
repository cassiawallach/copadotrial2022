/**
    * @author ActionGrid
    * @version 1.00
    * @description Send a contract out for negotiation.
    *
    * @param kendoEntry      ActionGrid helper for Kendo UI modal entry forms.
    * @param kendoPopup      ActionGrid helper for Kendo UI model message windows.
    * @param sfdc            ActionGrid helper for Salesforce REST API's
*/
 
crmc.require(["KendoPopup", "sfdc" ], function(kendoPopup, sfdc) {
    crmc.addCustomAction({
        "itemID": "AG_Select_Clause",
        "isAvailable": function (context) {
            var isSelected = context.selectedRows.length == 1;
            var isAccessable = this.featureSecurity.getSetting(context.objectDescribe.name, this.itemID) !== false;
            var isCorrectObj = context.objectDescribe.name == "Contract";
            return isSelected && isAccessable && isCorrectObj;
        },
        "getLabel": function (context) {
          return "Select Clause Bundle";
        },
        "createSubmenuItems": function (context) {
          return [];
        },
        "click": function (context) {
            function processURL(){
                // var ids = [];
                // var page = window.location.href;
                // context.selectedRows.map(function(row) {
                //     ids.push(row.Id.substring(0,15));
                // });
                window.open("/apex/APXT_Redlining__apxt_selectClauseBundle?scontrolCaching=1&altid=" + context.selectedRows[0].Id, "_blank");
            }; 
            if(context.selectedRows.length > 5){
                var buttons = [{
                    label: "Yes",
                    click: function() {
                        processURL();
                    }
                },
                {
                    label: "No"
                }];
                kendoPopup.popupWithButtons("WARNING", "5 records are recommended because each item will show in a new tab. Do you want to continue?", buttons);
            }
            else{
                processURL();
            }
        }
    });
});