public class myController{
    public string myStr{get;set;}
    public string selectedVal{get;set;}
    public string outText{get;set;}
    
    public list<Account> acnt;
    public list<sObject> obj{get;set;}
    
    public List<SelectOption> getOpn(){
        List<SelectOption> optns=new List<SelectOption>();
        string query='select name from account order by name asc limit 15';
        acnt=Database.query(query);
        optns.add(new SelectOption('-1','--Select Option--'));
        for(Account ac:acnt){
            optns.add(new SelectOption(ac.Name,ac.Name));
        }
        return optns;
    }
   public String callFn()
    {
        outText=selectedVal;
        return outText;
    }
    
    public myController(){
    /*    myStr=null;
        selectedVal=null;
 */   }
    public PageReference redr(){  
       PageReference pageRef= new PageReference('/Apex/test_pg2');
       pageRef.setRedirect(false);        
       return pageRef;      
    }
    
    public void testQuery(){
        string ac='Gauri';
        string acStr='select id from account where name=:ac limit 10';
        acnt=database.query(acStr);
        acStr=acnt[0].id;
        string str='select name, phone, (select name from account where name =:ac) as acNm from contact where contact.account.id=:acStr';
        obj=database.query(str);
    }
}