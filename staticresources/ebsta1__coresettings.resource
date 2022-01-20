function CoreData() {
     
};

//
// DataService URL
CoreData.prototype.ServiceUrl = function() {
    return "https://secure1.ebsta-webservices.com"; 
};

//Namespace for Package. Secure1 Release.
CoreData.prototype.Namespace = function() {
    return "1";
};

var core = new CoreData();