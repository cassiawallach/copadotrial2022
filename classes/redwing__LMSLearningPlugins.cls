/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LMSLearningPlugins {
    global LMSLearningPlugins() {

    }
global class LMSLearningPluginsException extends Exception {
}
global interface LearningPlugin {
    void launchItem(redwing.LMSLearningPlugins.LearningPluginLaunchContext param0);
    void loadItems(Map<Id,redwing.LMSLearningPlugins.LearningPluginLoadContext> param0);
    void validateItem(redwing.LMSLearningPlugins.LearningPluginValidationContext param0);
}
global class LearningPluginLaunchContext {
    global LearningPluginLaunchContext() {

    }
    global String getLaunchURL() {
        return null;
    }
    global Id getLearningAssignmentId() {
        return null;
    }
    global Id getLearningObjectId() {
        return null;
    }
    global String getOverrideLaunchURL() {
        return null;
    }
    global Map<String,String> getOverrideLaunchURLParams() {
        return null;
    }
    global Id getSectionItemId() {
        return null;
    }
    global Id getTrainingActivityId() {
        return null;
    }
    global void setOverrideLaunchURL(String overrideLaunchURL) {

    }
    global void setOverrideLaunchURLParams(Map<String,String> overrideLaunchURLParams) {

    }
}
global class LearningPluginLoadContext {
    global LearningPluginLoadContext() {

    }
    global Boolean getHideLaunch() {
        return null;
    }
    global String getLaunchLabel() {
        return null;
    }
    global Id getLearningAssignmentId() {
        return null;
    }
    global Id getLearningObjectId() {
        return null;
    }
    global Id getSectionItemId() {
        return null;
    }
    global Id getTrainingActivityId() {
        return null;
    }
    global void setHideLaunch(Boolean hideLaunch) {

    }
    global void setLaunchLabel(String launchLabel) {

    }
}
global class LearningPluginValidationContext {
    global LearningPluginValidationContext() {

    }
    global String getErrorMessage() {
        return null;
    }
    global Boolean getIsValid() {
        return null;
    }
    global Id getLearningAssignmentId() {
        return null;
    }
    global Id getLearningObjectId() {
        return null;
    }
    global Id getSectionItemId() {
        return null;
    }
    global Id getTrainingActivityId() {
        return null;
    }
    global void setErrorMessage(String errorMessage) {

    }
    global void setIsValid(Boolean isValid) {

    }
}
}
