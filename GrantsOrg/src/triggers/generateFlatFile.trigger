trigger generateFlatFile on Grants_Programs__c (after update) {
      
      for(Grants_Programs__c gr : Trigger.new)
      {
          if(gr.Status__c == 'Released')
          {
              FlatFileClass s = new FlatFileClass();
              s.fetch(gr.Id);
          }
      }
}