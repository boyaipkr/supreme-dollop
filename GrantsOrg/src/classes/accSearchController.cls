public with sharing class accSearchController{
    public list <account> acc {get;set;}
    public string searchString {get;set;}
    public accSearchController(ApexPages.StandardController controller){
    }
    public void search(){
        string searchQuery='select name,id from account where name like \'%'+searchString+'%\' Limit 20';
        acc=Database.query(searchQuery);
    }
    public void clear(){
        acc.clear();
    }
}