public with sharing class YourClass
{   
    public class CustomAccount
    {
        public String accountName {get; set;}
    }

    public List <CustomAccount> customAccounts {get; set;}

    public YourClass()
    {
        customAccounts = new List <CustomAccount> ();
    }

    public void addNewRecord()
    {
        CustomAccount customAccount = new CustomAccount();
        customAccounts.add(customAccount);
    }

    public void insertAccounts()
    {
        List <Account> accounts = new List <Account> ();

        for (CustomAccount customAccount : customAccounts)
        {
            Account account = new Account();
            account.Name = customAccount.accountName;
            accounts.add(account);
        }

        insert accounts;
    }
}