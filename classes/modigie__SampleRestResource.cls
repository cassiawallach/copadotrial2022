/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/AccountService/*')
global class SampleRestResource {
    global SampleRestResource() {

    }
    @HttpPost
    global static String createNewAccount(String Name) {
        return null;
    }
    @HttpDelete
    global static String deleteAccountById() {
        return null;
    }
    @HttpGet
    global static List<Account> getAccounts() {
        return null;
    }
    @HttpPut
    global static String updateAccount(String Id, String NewName) {
        return null;
    }
}
