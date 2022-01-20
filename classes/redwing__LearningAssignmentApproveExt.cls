/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LearningAssignmentApproveExt extends redwing.LMSBaseCtrl {
    global String approverNotes {
        get;
        set;
    }
    global redwing__Learning_Assignment__c assignment {
        get;
    }
    global String latestImageAttachment {
        get;
    }
    global String lightningString {
        get;
        set;
    }
    global List<redwing.RatingItem> ratings {
        get;
        set;
    }
    global LearningAssignmentApproveExt(Id recordId) {

    }
    global System.PageReference approveAssignment() {
        return null;
    }
    global System.PageReference rejectAssignment() {
        return null;
    }
}
