public class SendEmailAutoGen
{
    public void SendEmailAutoGenMethod(ID emailAddress)
    {
          // Step 1: Create a new Email
          
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

//      String emailAddr = myContact.Email;
//      String[] toAddresses = new String[] {emailAddress};
//      mail.setToAddresses(toAddresses);

    mail.setTargetObjectId(emailAddress);
    
      // Step 3: Set who the email is sent from
      mail.setReplyTo('judhajit.mandal@gauri.com');
      mail.setSenderDisplayName('Gauri Grants Team');
      
      mail.setBccSender(false);
      mail.setUseSignature(false);
      mail.setSaveAsActivity(false);
      EmailTemplate CurrentTemplate = [Select id,subject,body from EmailTemplate where name = 'GrAppl'];
      mail.setTemplateId(CurrentTemplate.Id);
      mail.setSubject(CurrentTemplate.Subject);
    
      // (Optional) Set list of people who should be CC'ed
      //List<String> ccTo = new List<String>();
      //ccTo.add('business@bankofnigeria.com');
      //mail.setCcAddresses(ccTo);

/*
      // Step 4. Set email contents - you can use variables!
      String body = 'Dear ' + fname1 + ', ';
      body += 'This is a sample mail that I am trying for the first time.';
      body += 'I write to request your cooperation in this ';
  */
      mail.setHtmlBody(CurrentTemplate.Body);
    

    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    

    }

}