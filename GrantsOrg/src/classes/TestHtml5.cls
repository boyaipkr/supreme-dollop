public class TestHtml5{
    public string nm{get;set;}
    public string comments{get;set;}
    public string title{get;set;}
    
    public TestHtml5(){
       nm='abc';
       comments='sample comments ans some more text';
       title='Mr.';
    }
    public list<selectOption> getmyTitle(){
        list<selectoption> myList=new list<selectOption>();
        
        mylist.add(new selectOption('','--Select--'));
        mylist.add(new selectOption('Mr.','Mr.'));
        mylist.add(new selectOption('Mrs.','Mrs.'));
        mylist.add(new selectOption('Ms.','Ms.'));
        return myList;
    }
   
    
}