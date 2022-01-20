({    
    GetFeaturedUser : function(component, event, helper){
        var action = component.get("c.GetFeaturedUsers");
        action.setParams({
            UserId : component.get("v.featuredUserId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
                var APEX_Response = response.getReturnValue();
                if(APEX_Response.length>0){
                    /*var UserIndex = helper.generateRandomNumber(component, event, helper,APEX_Response.length);
                    if(UserIndex<APEX_Response.length){
                        component.set("v.UserDetail",APEX_Response[parseInt(UserIndex)]);
                        component.set("v.IsShow",true);
                    }*/
                    var currentUrl = window.location.href;
       
                    component.set("v.userProfileUrl",currentUrl.split("/s/")[0]+"/"+component.get("v.featuredUserId"));
                    component.set("v.UserDetail",APEX_Response[0]);
                    component.set("v.IsShow",true);
                }
            }
            else{
                console.log('Apex error:: '+JSON.stringify(response.getError()));
            }
        });       
        $A.enqueueAction(action);
    },
    generateRandomNumber : function(component, event, helper,numberLength){
        var StrNumber = numberLength.toString();
        StrNumber = StrNumber.length;
        var randMulti ='';
        for(var i=0;i<StrNumber;i++){
            randMulti += '9'; 
        }
        randMulti = parseInt(randMulti);
        for(var i=0;i<=50000;i++){
            var randNumber = parseInt(Math.random()*randMulti);
            if(randNumber<=numberLength){
                return randNumber;
                exit();
            }
        }
    }
    
})