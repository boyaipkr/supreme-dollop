// Test Mail to each new Contact
trigger TestMail on Contact (before insert) {

/*
  // Step 0: Create a master list to hold the emails we'll send
  List<Messaging.SingleEmailMessage> mails = 
  new List<Messaging.SingleEmailMessage>();
  
  for (Contact myContact : Trigger.new) {
    if (myContact.Email != null && myContact.FirstName != null) {
      // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = 
      new Messaging.SingleEmailMessage();
    
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add(myContact.Email);
      mail.setToAddresses(sendTo);
    
      // Step 3: Set who the email is sent from
      mail.setReplyTo('judhajit.mandal@gauri.com');
      mail.setSenderDisplayName('Gauri Grants Team');
    
      // (Optional) Set list of people who should be CC'ed
      //List<String> ccTo = new List<String>();
      //ccTo.add('business@bankofnigeria.com');
      //mail.setCcAddresses(ccTo);

      // Step 4. Set email contents - you can use variables!
      mail.setSubject('TEST EMAIL');
      String body = 'Dear ' + myContact.FirstName + ', ';
      body += 'This is a sample mail that I am trying for the first time.';
      body += 'I write to request your cooperation in this ';
      mail.setHtmlBody(body);
    
      // Step 5. Add your email to the master list
      mails.add(mail);
    }
  }
  // Step 6: Send all emails in the master list
  Messaging.sendEmail(mails);
  
  */
}