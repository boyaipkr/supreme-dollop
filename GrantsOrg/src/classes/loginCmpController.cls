public class loginCmpController {
	
    public string password{get;set;}
    public string usrid{get;set;}
    public string output{get;set;}
    
    
    public pageReference checkLogin(){
        String usr = String.escapeSingleQuotes(usrid);
        String pwd = String.escapeSingleQuotes(password);
        
        List<Grantee_User__c> g = new List<Grantee_User__c>();
        g = Database.query('select name, password__c from Grantee_User__c where name=:usr and password__c=:pwd limit 1');
        
        if(g.size()==0){
            output = 'Login Failed!!!!';
            system.debug(output);
        }else{
            output = 'Login Succesful!!!!';
            system.debug(output);
        }
        
        return null;
    }
}