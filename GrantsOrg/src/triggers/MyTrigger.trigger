trigger MyTrigger on SurveyQuestionResponse__c (after insert) {

 /*       set<id> userids = new set<id>();
        set<id> existuserids = new set<id>();
        
        for(SurveyQuestionResponse__c obj : Trigger.new)
        userids.add(obj.Response__c);
        
        for(Survey_Option__c obj1 : [SELECT Id, Name FROM Survey_Option__c])
        existuserids.add(obj1.Name);
        
        for(Integer i=0; i< existuserids.size(); i++)
        {
                for(SurveyQuestionResponse__c obj : Trigger.new)
                obj.Surv_Option__c = 'hello';
                
        }
        */
        
/*        List<Survey_Option__c> so = [SELECT Id, Name FROM Survey_Option__c WHERE Survey_ID__c=: surveyId];
        List<SurveyQuestionResponse__c> sqr = [SELECT Response__c FROM SurveyQuestionResponse__c];
        
        for(sqr : Trigger.new)
        {
        if(s.Response__c == so.Name)
        {
            
        }
        } */
}