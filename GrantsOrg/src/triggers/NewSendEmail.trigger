trigger NewSendEmail on Order (after insert) {

    Order ord = trigger.new[0]; 
  String[] toAddresses = new String[] {ord.EmailCopy__c}; 
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

  mail.setTargetObjectId(ord.Contact_ID__c);
  mail.setWhatId(ord.Id);
  
  mail.setSenderDisplayName('DO NOT REPLY');
  //mail.setReplyTo('grmsupport@gauri.com');
  mail.setUseSignature(false);
  mail.setBccSender(false);
  mail.setSaveAsActivity(true);

 if (Trigger.isInsert) { 
    
          EmailTemplate et=[Select id from EmailTemplate where Name=:'GrAppl'];
          mail.setTemplateId(et.id);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
   }

}