({
    GetEvents : function(component, event, helper){
        var action = component.get("c.getAllILTEvents");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                component.set("v.ILTEventList",response.getReturnValue());
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
    },
    getClasses : function(component, event, helper,eventId){
        var action = component.get("c.GetILTCLassesByEventId");
        action.setParams({
            eventId: eventId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var APEX_Response = response.getReturnValue();
                component.set("v.APEX_Response",APEX_Response);
                component.set("v.ILTClassesList",APEX_Response.ILTClasses);
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
    },
    
    getPrerequisiteItems : function(component, event, helper,ILTEventLearningId){
        var columnName = component.get("v.columnName");
        var NewcolumnNames = [];
        var UserIds=[];
        var action = component.get("c.getPrerequistiteItemsByLearningId");
        action.setParams({
            ILTEventLearningId :  ILTEventLearningId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var APEX_Response = response.getReturnValue();
                component.set("v.APEX_Response_Of_prerequistiteItems",APEX_Response);
                APEX_Response.Prerequisite_Items.forEach(function(item){
                    var columnName ='';
                    var words = item.Name;
                    words = words.split(" ");
                    words.forEach(function(NameWord){
                        columnName+=NameWord+'_';
                    });
                    columnName = columnName.substring(0,columnName.length-1);
                    var Data ={
                        label : item.Name,
                        fieldName : 'Item_'+columnName,
                        type : 'text',
                        sortable : false,
                        cellAttributes: {
                            class: {
                                fieldName: columnName.replace(" ", "_").replace(" ", "_")+"_Item_showClass"
                            },
                            iconName: {
                                fieldName: columnName.replace(" ", "_").replace(" ", "_")+"_Item_displayIconName"
                            }
                        }
                    };
                    NewcolumnNames.push(Data);
                });
                var TempColumns = [];
                columnName.forEach(function(col){
                    if(!col.fieldName.includes("Item_")){
                        TempColumns.push(col);
                    }
                });
                if(NewcolumnNames.length>0){
                    NewcolumnNames.forEach(function(NewCol){
                        TempColumns.push(NewCol);
                    });
                }
                component.set("v.columnName",TempColumns);
                var columnValue='';
                var NewTableData = [];
                var TableData = component.get("v.TableData");               
                TableData.forEach(function(record){
                    if(record.UserId!=''){
                        UserIds.push(record.UserId);
                    }
                    var recordString =JSON.stringify(record);
                    recordString = recordString.substring(0,recordString.length-1)+',';
                    APEX_Response.Prerequisite_Items.forEach(function(PrerequistiteItem){
                        var columnNameString ='';
                        var words = PrerequistiteItem.Name;
                        words = words.split(" ");
                        words.forEach(function(NameWord){
                            columnNameString+=NameWord+'_';
                        });
                        columnNameString = columnNameString.substring(0,columnNameString.length-1);
                        //columnValue+='"'+ProgramName+'_Certificate":"false",';
                        recordString+='"'+columnNameString+'_Item_showClass": "textdanger",';
                        recordString+='"'+columnNameString+'_Item_displayIconName": "utility:close",';
                    });
                    APEX_Response.AchievementAssignmentList.forEach(function(AchievementAssignment){
                        if(AchievementAssignment.UserId==record.UserId){
                            var columnNameString ='';
                            var words = AchievementAssignment.PrerequisiteName;
                            words = words.split(" ");
                            words.forEach(function(NameWord){
                                columnNameString+=NameWord+'_';
                            });
                            columnNameString = columnNameString.substring(0,columnNameString.length-1);
                            //columnValue+='"'+ProgramName+'_Certificate":"false",';
                            recordString+='"'+columnNameString+'_Item_showClass": "textsuccess",';
                            recordString+='"'+columnNameString+'_Item_displayIconName": "utility:check",';
                        }
                    });
                    recordString = recordString.substring(0,recordString.length-1);
                    recordString+='}';
                    var Data = JSON.parse(recordString);
                    NewTableData.push(Data);
                });                
                component.set("v.TableData",NewTableData);
                if(UserIds.length>0){
                    helper.getUserPlaygroundsList(component,event,helper,UserIds,NewTableData);
                }
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
        
    },   
    getUserPlaygroundsList : function(component,event,helper,UserIds,TableData){
        var action = component.get("c.getPlaygroundsListByUserIds");
        action.setParams({
            UserIdsString :  JSON.stringify(UserIds)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var APEX_Response = response.getReturnValue();
                component.set("v.APEX_Response_Of_Playgrounds",APEX_Response);
                TableData.forEach(function(record){
                    record.PlagroundStatusClass = 'textdanger';
                        record.PlagroundStatusIconName = 'utility:close';
                    if(typeof(APEX_Response[record.UserId])!=='undefined'){
                        var playgroundList = APEX_Response[record.UserId];
                        playgroundList.forEach(function(playground){
                            if(playground.Status__c=='Activated'){
                                record.PlagroundStatusClass = 'textsuccess';
                                record.PlagroundStatusIconName = 'utility:check';
                            } 
                        });
                    } 
                    else{
                        record.NumberOfPlaygrounds = 0;
                    }
                });
                component.set("v.TableData",TableData);
                component.set("v.isShow",true);
                component.set('v.Isloaded',false);
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
                component.set('v.Isloaded',false);
            }
        });       
        $A.enqueueAction(action);
        
    }
})