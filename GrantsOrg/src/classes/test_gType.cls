public with sharing class test_gType{
     public string type{get;set;}
     public string subType{get;set;}
    public list<Account> gList{get;set;}
 
    public test_gType(){
    }
    public list<selectOption> getList(){
        list<selectOption> myList = new List<selectOption>();
        string strQuery='Select Grantee_Type__c, GranteeSubType__c from Account';
        gList=Database.query(strQuery);
        for(Account a:gList)
            myList.add(new selectOption(a.Grantee_Type__c,a.Grantee_Type__c));
        return myList;
    }
     
}