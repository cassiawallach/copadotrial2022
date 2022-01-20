/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RichTextViewerCtrl extends redwing.LMSBaseCtrl {
    global List<redwing.RichTextViewerCtrl.RichTextContentWrapper> contents {
        get;
        set;
    }
    global redwing__RichText__c richText {
        get;
        set;
    }
    global RichTextViewerCtrl(String aid) {

    }
    global System.PageReference markCompleted() {
        return null;
    }
global class RichTextContentWrapper {
    global redwing__RichText_Content__c content {
        get;
        set;
    }
    global String embeddedVideoHeight {
        get;
        set;
    }
    global String embeddedVideoURL {
        get;
        set;
    }
    global String embeddedVideoWidth {
        get;
        set;
    }
    global RichTextContentWrapper() {

    }
}
}
