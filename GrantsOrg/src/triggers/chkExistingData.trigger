trigger chkExistingData on Interested_Grantees__c (before insert, before update) {
	List<Interested_Grantees__c> intGrantee = new List<Interested_Grantees__c>();
    Integer grntCount;
    
    Try{    
	    intGrantee = trigger.new;
	    Interested_Grantees__c grantee = intGrantee.get(0);
	        
	    String mailID = grantee.Email_Id__c;
	    String fullName = grantee.Full_Name__c;
	    
	    grntCount = [select count() from Interested_Grantees__c where Email_Id__c=:mailID and Full_Name__c=:fullName];
	    
	    
	    if(grntCount>0){
	    	System.Debug('Error on the way');
	    	grantee.addError('Already Existing');
	    }
	    
    }catch (System.exception e){
		    	
    }
	
}