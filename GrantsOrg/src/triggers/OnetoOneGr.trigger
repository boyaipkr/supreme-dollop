Trigger OnetoOneGr on Application__c (Before Insert)
{
    set<id> userids = new set<id>();
    set<id> existuserids = new set<id>();
    for(Application__c obj : Trigger.new)
       userids.add(obj.Select_Grant_Application__c); //custom user lookup field name
    
    for(Application__c obj : [select Select_Grant_Application__c from Application__c where Select_Grant_Application__c in : userids])
       existuserids.add(obj.Select_Grant_Application__c);

    for(Application__c obj : Trigger.new)
    {
       if(existuserids.contains(obj.Select_Grant_Application__c))
        {
            obj.adderror('Error saving record! This application is already associated with existing Decision Case!');
        }
   }
}