global with sharing class remotingController {
	
    global static String interestParty = '';

    global remotingController(ApexPages.StandardSetController control){}
    
    @RemoteAction
    global static string setPrg(String prgName){
       	interestParty = prgName;
        system.debug('Value for parties - ' + interestParty);
       	return 'successful';
    }
}