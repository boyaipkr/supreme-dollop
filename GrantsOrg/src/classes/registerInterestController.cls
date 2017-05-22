public class registerInterestController {
    
    public registerInterestController(ApexPages.StandardSetController control){}
    public registerInterestController(){}

    public static String interestParty = '';    
    public String mailId{get;set;}
    public String fullName{get;set;}
    public String outputString{get;set;}
        
    public void saveandmail(){
        Try{
            Interested_Grantees__c intGrnt = new Interested_Grantees__c();
            intGrnt.Email_Id__c = mailId;
            intGrnt.Full_Name__c = fullName;
            intGrnt.Programme_Name__c = interestParty;
            insert intGrnt;
            outputString = 'Interest Registered!!!';
            System.debug(outputString);
        }catch ( system.Exception e) {
            outputString = 'Registration Failed!!!';
        }
    }
    
    @RemoteAction
    public static string setPrg(String prgName){
       	interestParty = prgName;
        system.debug('Value for parties - ' + interestParty);
       	return 'successful';
    }    
}