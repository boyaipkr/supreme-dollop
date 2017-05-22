Trigger OnetoOne on Employee__c (Before Insert)
{
    set<id> userids = new set<id>();
    set<id> existuserids = new set<id>();
    for(Employee__c obj : Trigger.new)
       userids.add(obj.Related_to_User__c); //custom user lookup field name
    
    for(Employee__c obj : [select Related_to_User__c from Employee__c where Related_to_User__c in : userids])
       existuserids.add(obj.Related_to_User__c);

    for(Employee__c obj : Trigger.new)
    {
       if(existuserids.contains(obj.Related_to_User__c))
        {
            obj.adderror('Error saving record! This user is already associated with another existing record!');
        }
   }
}