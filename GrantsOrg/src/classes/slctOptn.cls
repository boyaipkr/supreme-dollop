public class slctOptn{
    public String strInOutputText{get;set;}
    public String selectedPkVal{get;set;}

    public void callApex(){
        strInOutputText = selectedPkVal;
    }
    
    public list<selectOption> getVar(){
        list<selectOption> optn=new list<selectOption>();
        list<Account> acnt=new list<Account>();
        string str='select name from account  order by name asc limit 100';
        acnt=database.query(str);
        for(Account a:acnt)
            optn.add(new selectoption(a.name,a.name));
        
        return optn;
    }
}