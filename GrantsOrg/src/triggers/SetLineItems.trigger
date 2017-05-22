trigger SetLineItems on Contract (after insert) {
    List<OrderItem> ord=new List<OrderItem>();
    
    OrderItem o=new OrderItem();
    
    for(Contract c:trigger.new){
        ord=[select id,orderId,grant_agreement__c from orderitem where orderId=:c.grant_application__c];
        for(OrderItem oi:ord){
            oi.grant_agreement__c=c.id;
            
        }
    }
    update ord;
}