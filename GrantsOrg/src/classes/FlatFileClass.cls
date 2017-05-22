public class FlatFileClass
{
   
    ApexPages.StandardController control;
    public FlatFileClass(ApexPages.StandardController con)
    {
        control = con;
    }
       
    public String Id;
    public String Name;
    public Double Size;
    public Grants_Programs__c grp {get;set;}
    
    public FlatFileClass()
    {

    }

    public void fetch(String var)
    {
     //   Id = Apexpages.currentpage().getparameters().get('id');
        grp = [SELECT Name, Program_Fund_Size__c, Program_ID__c FROM Grants_Programs__c WHERE ID =: var];
        Name = grp.Name;
        Size = grp.Program_Fund_Size__c;
        id = grp.Program_ID__c;
        
        Document d=new Document();
        d.FolderId=UserInfo.getUserId();
        String myfile ='Flat File : ' +Name;
        d.Name = myfile;
        String myContent ='Program ID : ' +id+ ' \nProgram Name : '+Name+ ' \nProgram Fund Size : £ '+Size;
        d.Body = Blob.valueOf(myContent);
        d.ContentType = 'text/plain';
        d.Type = 'txt';
        insert d;
}

    }