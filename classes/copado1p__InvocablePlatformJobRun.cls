/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InvocablePlatformJobRun {
    global InvocablePlatformJobRun() {

    }
    @InvocableMethod(label='Run Platform Job' description='Executes the Platform Job')
    global static void runPlatformJob(List<copado1p.InvocablePlatformJobRun.InvocableVariables> variables) {

    }
global class InvocableVariables {
    @InvocableVariable(label='JSON Parameters' required=false)
    global String jsonparams;
    @InvocableVariable(label='Platform Job Id' required=true)
    global Id platformJobId;
    global InvocableVariables() {

    }
}
}
