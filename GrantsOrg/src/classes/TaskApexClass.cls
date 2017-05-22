public class TaskApexClass
{
public String task{get; set;}
public String who{get; set;}


ApexPages.StandardController control;
public TaskApexClass(ApexPages.StandardController con)
{
    control = con;
}

public List<SelectOption> gettasknames()
{
  List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption('--None--','--None--'));
  options.add(new SelectOption('Anti-Fraud','Anti-Fraud'));
  options.add(new SelectOption('Decision Communication','Decision Communication'));
  options.add(new SelectOption('Monitoring','Monitoring'));
  options.add(new SelectOption('Closure','Closure'));
  return options;
}


public List<SelectOption> getwhonames()
{
  List<SelectOption> options2 = new List<SelectOption>();
  options2.add(new SelectOption('--None--','--None--'));
  options2.add(new SelectOption('Grantee','Grantee'));
  options2.add(new SelectOption('Contact Person','Contact Person'));
  return options2;
}


//public String newgranteename{get; set;}
//public String grant{get; set;}

/*public void savename()
{
  Grantee__c newrec = new Grantee__c(Name=newgranteename, Grant_Type__c=grant);
  insert newrec;
  newgranteename=NULL;
  grant=NULL;
  

  //Grantee__c newrec2 = new Grantee__c(Grant_Type__c=grant);
  //insert newrec2;
  //grant=NULL;
}

*/


/*

public String newpicklistvalue{get; set;}

public void saverec()
{
  Grant__c newrec = new Grant__c(Name=newpicklistvalue);
  insert newrec;
  newpicklistvalue=NULL;
}

*/

}