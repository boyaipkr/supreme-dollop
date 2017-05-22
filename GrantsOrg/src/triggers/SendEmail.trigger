trigger SendEmail on Order (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert ){ 
            //helper class for single email but bulk messages
            EmailHelperTrigger.sendEmail(trigger.new);
        }
    }
}