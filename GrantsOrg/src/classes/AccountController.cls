public without sharing class AccountController {
    public Account account{get; set;}
    public AccountController(){
        account = new Account();
    }
    
    public void save(){
        upsert account;
    }
}