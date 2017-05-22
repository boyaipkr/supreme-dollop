public class myClass1{

        public string out1{get;set;}
        public date d1{get;set;}
        public date d2{get;set;}
        public string tab{get;set;} //to set visible tab
        public list<decimal> capitals{get;set;}
        public list<decimal> revenues{get;set;}
        public list<integer> iterator{get;set;}
        
        public myClass1(){
            out1='No way';
            
        }
        public void goDynamic(){
           integer m=d1.monthsBetween(d2);
           integer yr=(m/12)+math.mod(m,12)>0?1:0;
           
           
           capitals=new list<decimal>(yr);
           revenues=new list<decimal>(yr);
           iterator=new list<integer>(yr);
           for(integer i=0;i<yr;i++){
                capitals[i]=revenues[i]=10+i;
                iterator.add(i);
            }
        }
}