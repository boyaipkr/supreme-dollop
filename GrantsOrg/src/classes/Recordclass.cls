public class Recordclass
{
ApexPages.StandardController control;
public Recordclass(ApexPages.StandardController con)
{
    control = con;
}


public List<selectOption> getRecordTypes() {
        List<selectOption> options = new List<selectOption>(); 
//new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); 
//add the first option of '- None -' in case the user doesn't
// want to select a value or in case no values are
// returned from query below
        for(Recordtype record : [SELECT Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Order']) { 
//query for Record types records 
            options.add(new selectOption(record.id, record.Name)); 
//for all records found - add them to the picklist options
        }
        return options; //return the picklist options
}


public String selectedrecordtype{get;set;}
}