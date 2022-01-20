({
    checkUserCertification : function(component, event, helper){
        var currentUrl = window.location.href;
        var month = new Array();
        month[0] = "January";
        month[1] = "February";
        month[2] = "March";
        month[3] = "April";
        month[4] = "May";
        month[5] = "June";
        month[6] = "July";
        month[7] = "August";
        month[8] = "September";
        month[9] = "October";
        month[10] = "November";
        month[11] = "December";
        console.clear();
        currentUrl = currentUrl.split('/s/')[0];
        var downloadCertificateLogoURL =currentUrl+ '/sfc/servlet.shepherd/document/download/';
        var downloadCertificateURL = '';
        var action = component.get("c.downloadCertificate");
        action.setCallback(this, function(response){            
            var state = response.getState();
            if(state==='SUCCESS'){
                var Certifications = [];
                var CertificationLogos = [];
                var apexResponse = response.getReturnValue();
                console.log(apexResponse);
                if(!apexResponse.IsError){
                    component.set("v.isShow",!apexResponse.IsError);
                    
                    var Academy_CertificationList = apexResponse.Academy_CertificationList;
                    console.clear();
                    console.log('Academy_CertificationList');
                    console.log(Academy_CertificationList);
                    Academy_CertificationList.forEach(function(record){
                        downloadCertificateURL = currentUrl+'/apex/CopadoCertificatePDFRenderer?CertificateId=';
                        var data={};
                        downloadCertificateURL += Math.floor(1000 + Math.random() * 9000)+helper.randomStringGenerator(5);
                        downloadCertificateURL += record.Certification_Program__c+helper.randomStringGenerator(9);
                        downloadCertificateURL += "&download="+Math.floor(1000 + Math.random() * 9000)+helper.randomStringGenerator(18);
                        if(record.hasOwnProperty('Certification_Program__r')){
                            data.CertificateName=record.Certification_Program__r.Name;
                            data.Status = record.Status__c;
                            var dt='';
                            let communityBadgeUrl = encodeURIComponent(currentUrl + '/BadgePreview?ty=badge&name=' + record.Certification_Program__r.Name.split(' ').join('_'));
                            if(record.Earned_Date__c!=""){
                                var dt = record.Earned_Date__c;
                                dt = dt.split('T')[0];
                                dt = dt.split("-");
                                
                            }
                            data.Earned_Date =month[parseInt(dt[1])-1] +" "+ dt[0];
                            if(record.Expiration_Date__c!=""){
                                dt = record.Expiration_Date__c;
                                dt = dt.split("-");
                            }
                            console.log( dt);
                            if(dt[1]<12){    
                                data.Expiration_Date =month[parseInt(dt[1])] +" "+ dt[0];
                            }
                            else if(dt[1]==12){    
                                data.Expiration_Date =month[0] +" "+ parseInt(parseInt(dt[0])+1);
                            }
                            
                            apexResponse.CertificateLogoList.forEach(function(logoRecord){
                                if(logoRecord.split("___")[0] == record.Certification_Program__r.Name){
                                    if(logoRecord.split("___")[1]!='No Preview'){
                                        data.isLogoDownloadIcon = true;
                                        data.CertificateLogoDownloadUrl = downloadCertificateLogoURL+logoRecord.split("___")[1]+'?operationContext=S1';
                                    }
                                    else{
                                        data.CertificateLogoDownloadUrl = $A.get('$Resource.NoImageAvailable');
                                    }
                                }
                            });

                            data.TwitterShareUrl = 'https://twitter.com/intent/tweet?url=' + communityBadgeUrl;
                            data.LinkedinShareUrl = 'https://www.linkedin.com/shareArticle?url=' + communityBadgeUrl;
                        }
                        data.CertificateDownloadUrl = downloadCertificateURL;
                        Certifications.push(data);
                    }); 
                    console.log(Certifications);
                    component.set("v.Certifications",Certifications);
                }
                else{
                    component.set("v.isShow",!apexResponse.IsError);
                }
            }
            else{
                console.log('error::'+JSON.stringify(response.getError()));
            }         
        });       
        $A.enqueueAction(action);
    },
    randomStringGenerator : function(length) {
        var result           = '';
        var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for ( var i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result;
    }
})