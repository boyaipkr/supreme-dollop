public with sharing class EmailHelperTrigger {
    //static method
    public static List<Order> sendEmail(List<Order> ords) {

        //query on template object
        EmailTemplate et=[Select id from EmailTemplate where name=:'GrAppl'];

        //list of emails
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        //loop
        for(Order o : ords){

            //check for Account
            if(o.EmailCopy__c != null){

                //initiallize messaging method
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                
                Contact c = [select Email from Contact where Id=:o.Contact_Person_Name__r.Id];

                //set object Id
                singleMail.setTargetObjectId(c.Id);
                
                //set What Id
                singleMail.setWhatId(o.Account.Id);

                //set template Id
                singleMail.setTemplateId(et.Id);

                //flag to false to stop inserting activity history
                singleMail.setSaveAsActivity(false);

                //add mail
                emails.add(singleMail);
            }
        }

        //send mail
        Messaging.sendEmail(emails);

        return ords;
    }
}