/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QuizViewerCtrl extends redwing.LMSBaseCtrl {
    global redwing__Learning_Assignment__c assignment {
        get;
    }
    global String assignmentMaxTime {
        get;
    }
    global redwing__Question_Line__c finishQuestionLine {
        get;
        set;
    }
    global Boolean hasMessages {
        get;
    }
    global Boolean isEnableNavigator {
        get;
        set;
    }
    global Boolean isEnableProgressBar {
        get;
        set;
    }
    global Boolean isRenderCountdown {
        get;
    }
    global String lightningMessage {
        get;
        set;
    }
    global Integer progress {
        get;
    }
    global List<Id> qlNavigation;
    global List<Id> qlOrder {
        get;
        set;
    }
    global redwing__Question_Line__c questionLine {
        get;
        set;
    }
    global Map<Id,List<redwing.QuizViewerCtrl.QuestionWrapper>> questionWrappersByQLineIds {
        get;
        set;
    }
    global redwing__Quiz__c quiz {
        get;
        set;
    }
    global List<redwing.QuizItem> quizItemList {
        get;
        set;
    }
    global Id selectedQuestionLine {
        get;
        set;
    }
    global Boolean showDoneButton {
        get;
    }
    global Boolean showNextButton {
        get;
    }
    global Boolean showPreviousButton {
        get;
    }
    global Boolean showStartButton {
        get;
    }
    global redwing__Question_Line__c startQuestionLine {
        get;
        set;
    }
    global QuizViewerCtrl(String aid) {

    }
    global System.PageReference clearResponses(Boolean updateProgress) {
        return null;
    }
    global System.PageReference done() {
        return null;
    }
    global System.PageReference forceDone() {
        return null;
    }
    global System.PageReference initializeQuestions() {
        return null;
    }
    global System.PageReference moveTo() {
        return null;
    }
    global System.PageReference next() {
        return null;
    }
    global System.PageReference nextNoSave() {
        return null;
    }
    global System.PageReference previous() {
        return null;
    }
    global System.PageReference previousNoSave() {
        return null;
    }
global class QuestionWrapper {
    global Boolean isResponse {
        get;
        set;
    }
    global String textQuestion {
        get;
        set;
    }
    global QuestionWrapper(redwing__Question__c question) {

    }
}
}
