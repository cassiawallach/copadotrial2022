/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TaskViewerCtrl extends redwing.LMSBaseCtrl {
    global redwing__Learning_Assignment__c assignment {
        get;
    }
    global String assignmentComments {
        get;
        set;
    }
    global Attachment attachment {
        get;
        set;
    }
    global String externalResourceURL {
        get;
    }
    global String latestImageAttachment {
        get;
    }
    global redwing__Task__c task {
        get;
        set;
    }
    global Boolean taskCompleted {
        get;
    }
    global Boolean taskInReview {
        get;
    }
    global TaskViewerCtrl(String aid) {

    }
    global Boolean getIsTaskValidForReset() {
        return null;
    }
    global System.PageReference markCompleted() {
        return null;
    }
    global System.PageReference markCompleted(String approvalPage) {
        return null;
    }
    global System.PageReference resetTask() {
        return null;
    }
}
