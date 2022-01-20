public class AccountACVPopuplateSchedullerCron {
    
    public AccountACVPopuplateSchedullerCron(){
        AccountACVPopuplateScheduller ctrl = new AccountACVPopuplateScheduller ();
        system.schedule('Account ACV Field Popuplate1'+System.now(), '0 0 0/2 ? * * *', ctrl);
    }
}