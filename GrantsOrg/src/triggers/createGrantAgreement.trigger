trigger createGrantAgreement on Order (before update) {
        List <contract> clist=new List <contract>();
        List<Attachment> at1=new List<Attachment>();
        contract c = new contract();
        
    for(Order o:trigger.new)
    {
        if(o.Status == 'Released')
        {
        c.AccountId=o.AccountId;
        c.Status='Agreement Available';
        c.Grant_Application__c=o.Id;
        c.outcomes__c=o.outcomes__c;
        c.startdate=o.effectivedate;
        c.contact__c=o.contact_person_name__c;
        
        
        o.awarded_amount__c=o.requested_amount__c;
        
        clist.add(c);
        
        
        //add Attachment to agreement
        
        at1=[select name,body,parentId from Attachment where parentId=:o.Id];
        
        }
        
        insert clist;
        o.Agreement__c=c.Id;
        
        if(at1.size()>0){
            List<attachment> at2=new List<Attachment>();
            for(Attachment a:at2){
                a.parentId=o.agreement__c;
                at2.add(a);
            }
            
            //executed only if attachments are found in application (Order)
            Insert at2;
        }   
    }
    
            
}