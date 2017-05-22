public with sharing class tstController {

    @RemoteAction
    public static string testER(String vsdf){
        system.debug('Tayai... Tayai.... Again!!!');
        return 'Remoteer';
    }	
    
}