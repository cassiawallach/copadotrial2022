public class AccountAutomations {
    Public static Account setDefaultDescription(Account a){
        If (a.Description != null) return a;
        Else {
            a.Description = 'Default description';
            return a;
        }
    }
    public static Account setDefaultBillingAddress(Account a){
        a.billingstreet = 'Amity, 6'; 
        a.billingstate = 'San Diego'; 
        a.billingpostalcode ='92109'; 
        return a;
    }
    public static Account setDefaultShippingAddress(Account a){
        a.shippingstreet = 'Amity, 6'; 
        a.shippingstate = 'San Diego';
        a.shippingpostalcode ='92109';
        return a;
    }
    public static Account setDefaultPhone(Account a) {
        a.Phone='8582724014';
        return a;
    }
    public static Account setDefaultURL(Account a) {
        a.website = 'www.copa.do.sd'; 
        return a;
    }
}