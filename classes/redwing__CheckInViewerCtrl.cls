/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CheckInViewerCtrl extends redwing.LMSBaseCtrl {
    global redwing__Learning_Assignment__c assignment {
        get;
    }
    global redwing__CheckIn__c checkin {
        get;
        set;
    }
    global String checkInLatitude {
        get;
    }
    global String checkInLongitude {
        get;
    }
    global String checkInMileRadius {
        get;
    }
    global String googleMapsAPIKey {
        get;
        set;
    }
    global redwing__Learning__c learning {
        get;
        set;
    }
    global CheckInViewerCtrl(String aid) {

    }
    @RemoteAction
    global static String doCancel(String assignmentId) {
        return null;
    }
    @RemoteAction
    global static String doCheckIn(String assignmentId, Double latitude, Double longitude) {
        return null;
    }
}
