({
    doInit : function(component, event, helper) {
        component.set("v.columnName",[
            {
                label : 'User Name',
                fieldName : 'UserName',
                type : 'text',
                sortable : false
            },
            {
                label : 'Registered Date',
                fieldName : 'RegisterDate',
                type : 'text',
                sortable : false,
            },
            {
                label : 'Playground Status',
                fieldName : 'PlaygroundStatus',
                type : 'text',
                sortable : false,
                cellAttributes: {
                    class: {
                        fieldName: "PlagroundStatusClass"                    
                    },
                    iconName: {
                        fieldName: "PlagroundStatusIconName"
                    }
                }
            }
        ]);
        component.set("v.PlaygorudColumns",[
            {
                label : 'Playground Name',
                fieldName : 'playgroundUrl',
                type : 'url',
                sortable : false,
                typeAttributes:{label:{fieldName:'playgroundName'},target:'_blank'}
            },
            {
                label : 'Status',
                fieldName : 'Status__c',
                type : 'text',
                sortable : false
            }
            ]);
        component.set("v.APEX_Response_Of_prerequistiteItems",[]);
        component.set("v.DefaultcolumnName",component.get("v.columnName"));
        helper.GetEvents(component, event, helper);
    },
    handleChangeEvent : function(component, event, helper){
        if(event.getSource().get("v.value")!=''){
            helper.getClasses(component,event,helper,event.getSource().get("v.value"));
        }
    },
    handleApplyFilter: function(component, event, helper){
        if(component.get("v.EventSelectedValue")!=''){
            if(component.get("v.ILTClassSelectedValue")!=''){
                var columnName = component.get("v.DefaultcolumnName");
                var ILTClassesList = [];
                var TableData = [];
                var columnValue='';
                var UserIds=[];
                var APEX_Response = component.get("v.APEX_Response");
                var ILTEventList = component.get("v.ILTEventList");
                ILTClassesList = APEX_Response[0].ILTClasses;
                if(APEX_Response[0].AcademyCertificationPrograms){
                    var CertificatePrograms = [];
                    APEX_Response[0].AcademyCertificationPrograms.forEach(function(Program){
                        var Data ={
                            label : Program.Name,
                            fieldName : Program.Name.replace(" ", "_").replace(" ", "_")+'_Certificate',
                            type : 'text',
                            sortable : false,
                            cellAttributes: {
                                class: {
                                    fieldName: Program.Name.replace(" ", "_").replace(" ", "_")+"_showClass"
                                },
                                iconName: {
                                    fieldName: Program.Name.replace(" ", "_").replace(" ", "_")+"_displayIconName"
                                }
                            }
                        };
                        if(!component.get("v.columnSet")){
                            CertificatePrograms.push(Program.Id);
                            columnName.push(Data);
                        }
                    });
                    component.set("v.columnSet",true);
                    component.set("v.CertificatePrograms",CertificatePrograms);                    
                    component.set("v.columnName",columnName);
                }
                if(ILTClassesList.length>0){
                    ILTClassesList.forEach(function(Class){
                        if(Class.Id==component.get("v.ILTClassSelectedValue")){
                            ILTEventList.forEach(function(event){
                                if(event.Id==component.get("v.EventSelectedValue")){
                                    helper.getPrerequisiteItems(component,event,helper,event.redwing__Learning__c);
                                }
                            });
                            if(Class.redwing__ILT_Rosters__r){
                                var Roasters = Class.redwing__ILT_Rosters__r;
                                Roasters.forEach(function(Roaster){
                                    if(!UserIds.includes(Roaster.redwing__User__c)){
                                        UserIds.push(Roaster.redwing__User__c);
                                        columnValue='{';
                                        columnValue+='"UserId":"'+Roaster.redwing__User__c+'",';
                                        columnValue+='"UserName":"'+Roaster.redwing__User__r.Name+'",';
                                        columnValue+='"UserContactId":"",';
                                        if(Roaster.redwing__User__r.ContactId!=''){
                                            columnValue+='"UserContactId":"'+Roaster.redwing__User__r.ContactId+'",';
                                        }
                                        columnValue+='"RegisterDate":"'+Roaster.redwing__Registered_Date__c+'",';
                                        var SessionName = '';
                                        if(Roaster.hasOwnProperty("redwing__ILT_Session__r")){
                                            SessionName =Roaster.redwing__ILT_Session__r.Name; 
                                        }
                                        columnValue+='"SessionName":"'+SessionName+'",';
                                        APEX_Response[0].AcademyCertificationPrograms.forEach(function(Program){
                                            var ProgramName = Program.Name;
                                            ProgramName = ProgramName.replace(" ", "_").replace(" ", "_");
                                            //columnValue+='"'+ProgramName+'_Certificate":"false",';
                                            columnValue+='"'+ProgramName+'_showClass": "textdanger",';
                                            columnValue+='"'+ProgramName+'_displayIconName": "utility:close",';
                                        });
                                        var TempCertificates = APEX_Response[0].ContactIdWithListOfAcademy_CertificationMap[Roaster.redwing__User__r.ContactId];
                                        if(TempCertificates){
                                            TempCertificates.forEach(function(Certificate){
                                                APEX_Response[0].AcademyCertificationPrograms.forEach(function(Program){                                           
                                                    var ProgramName = Program.Name;
                                                    ProgramName = ProgramName.replace(" ", "_").replace(" ", "_");
                                                    //columnValue+='"'+ProgramName+'_Certificate":"false",';
                                                    //columnValue+='"'+ProgramName+'_showClass": "textdanger",';
                                                    //columnValue+='"'+ProgramName+'_displayIconName": "utility:close",';
                                                    if(Program.Id ==  Certificate.Certification_Program__c){
                                                        // columnValue+='"'+ProgramName+'_Certificate":"true",';
                                                        columnValue+='"'+ProgramName+'_showClass": "textsuccess",';
                                                        columnValue+='"'+ProgramName+'_displayIconName": "utility:check",';
                                                    }                                          
                                                });
                                            });
                                        }
                                        columnValue = columnValue.substring(0,columnValue.length-1);
                                        columnValue+='}';
                                        Roaster = JSON.parse(columnValue);
                                        TableData.push(Roaster);
                                    }
                                });
                            }
                        }
                    });
                }
                component.set("v.ILTClassesList",ILTClassesList);
                component.set("v.TableData",TableData);
            }
            else{
                alert('Please Select Class.')
            }
        }
        else{
            alert('Please Select Event.')
        }
    },
    handleReset : function(component, event, helper) {
        component.set("v.columnName",[
            {
                label : 'User Name',
                fieldName : 'UserName',
                type : 'text',
                sortable : false
            },
            {
                label : 'Registered Date',
                fieldName : 'RegisterDate',
                type : 'text',
                sortable : false,
            },
            {
                label : 'Playground Status',
                fieldName : 'PlaygroundStatus',
                type : 'text',
                sortable : false,
                cellAttributes: {
                    class: {
                        fieldName: "PlagroundStatusClass"                    
                    },
                    iconName: {
                        fieldName: "PlagroundStatusIconName"
                    }
                }
            }
        ]);
            helper.GetEvents(component, event, helper);
        component.set("v.TableData",[]);
        component.set("v.ILTClassesList",[]);
        component.set("v.EventSelectedValue",[]);
        component.set("v.ILTClassSelectedValue",[]);
        
    },
    handleRowAction : function(component, event, helper) {
        component.set('v.Isloaded',true);
        var TableData =component.get('v.TableData');
        var action = event.getParam('action');
        var row = event.getParam('row');
        var userPlaygroundList  = [];
        var APEX_Response_Of_Playgrounds = component.get("v.APEX_Response_Of_Playgrounds");
        console.log(APEX_Response_Of_Playgrounds);
        if(action.name=="NumberOfPlaygrounds"){
            if(row.NumberOfPlaygrounds>0){
                console.log('rowaction');
                console.log(row.UserContactId);
                var playgrounds = APEX_Response_Of_Playgrounds[0][row.UserContactId];
                playgrounds.forEach(function(playground){
                    playground.playgroundUrl = '/'+playground.Id;
                    playground.playgroundName = playground.Name;
                    userPlaygroundList.push(playground)
                });
                if(userPlaygroundList.length>0){
                    component.set("v.userPlaygroundList",userPlaygroundList);
                    component.set("v.isOpen", true); 
                }
            }
        }
    },
    
    closeModel : function(component, event, helper){
        component.set("v.isOpen", false);
    },
})