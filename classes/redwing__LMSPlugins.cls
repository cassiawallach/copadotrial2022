/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LMSPlugins {
    global LMSPlugins() {

    }
global class LMSPluginsException extends Exception {
}
global interface Learning {
    redwing.LMSPlugins.LearningConfig init();
}
global class LearningConfig {
    global String customVFDomain {
        get;
        set;
    }
    global String launchTarget {
        get;
        set;
    }
    global String launchURL {
        get;
        set;
    }
    global String learningVersionLookupField {
        get;
        set;
    }
    global String objectName {
        get;
        set;
    }
    global LearningConfig() {

    }
}
}
