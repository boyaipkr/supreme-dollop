public class myClass{
       public date d1{get;set;}
       public date d2{get;set;}
       public string out1{get;set;}
       public list<decimal> capitals{get;set;}
       public list<decimal> revenues{get;set;}
       public list<integer> iterator{get;set;}
       
       public string usr{get;set;}
       public string pass{get;set;}
       
       public string mail{get;set;}
        
       public myClass(){
           out1='Hello';
       }
       
       public void getYear(){
           integer m=d1.monthsBetween(d2);
           integer yr=(m/12)+(math.mod(m,12)>0?1:0);
           generateFields(yr);
       }
       public void generateFields(integer yr){
           capitals=new list<decimal>(yr);
           revenues=new list<decimal>(yr);
           iterator=new list<integer>(yr);
           for(integer i=0;i<yr;i++){
               capitals[i]=revenues[i]=0;
               iterator[i]=i;
           }
           out1=string.valueOf(yr);
       }
       public void getValues(){
           out1=string.valueOf(capitals[1]+revenues[1]);
       
       }
       public void mailCheck(){
           out1=mail;
       }
}