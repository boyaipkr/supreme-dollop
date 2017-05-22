public class myClass2{

        public string out1{get;set;}
        public list<decimal> capitals{get;set;}
        public list<decimal> revenues{get;set;}
        
        public myClass2(){
            out1='Hello';
            capitals=new list<decimal>(4);
            revenues=new list<decimal>(4);
            for(integer i=0;i<4;i++){
                capitals[i]=revenues[i]=i;
            }
        }
        public void mySave(){
           out1=String.valueOf(capitals[1]);
          //this line should display value entered in second input text in place of 'Hello'
        }
}