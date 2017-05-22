public class OutcomeClass{

    public string outcomes{get;set;}
    public string name{get;set;}
    public id appId{get;set;} 
    
    
    public OutcomeClass(){
        appId='801280000004DGy';
        Order ord=new Order();
        ord=[select outcomes__c,name from order where id=:appId];
        outcomes=ord.outcomes__c;
        name=ord.name;
    }
    public void updateOutcomes(){
        Order ord1=new Order(id=appId,outcomes__c=outcomes);
        update ord1;
    }
    public void newFunction(){
        name='Something new';
    }
}