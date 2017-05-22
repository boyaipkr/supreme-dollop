public class getUser{

    public String cId { get; set; }
    public string outTxt{get;set;}
    public string appNm{get;set;}
    public string usr{get;set;} //get value frm vf page
    public string pass{get;set;} //get value frm vf page
    public string myStr{get;set;}
    
    public list<Grantee_User__c> myUser{get;set;}
    public list<Account> acnt{get;set;}
    public list<Contact> myCntct{get;set;}
    public list<Order> myApp{get;set;}
    
    //Constructor
    public getUser(){
        myStr='admin';
    }
    
    
    //check Login
    
    public pageReference chkLogin(){
        if(string.ISEMPTY(myStr)){
            pageReference pr=new pageReference('/Apex/a_Login');
            pr.setRedirect(true);
            return pr;
        }
        return null;
            
    }
    
    //Button functions start here..........
    
    public void saveList(){
        Grantee_User__c user=new Grantee_User__c();
        user.name=usr;
        user.password__c=pass;
        insert user; //DML operation
        user.clear();
    }
    public pageReference search(){
        usr='admin';
        pass='admin';
        
        string searchQuery='select id,name,password__c,user_Account__c from Grantee_User__c where name=:usr  limit 10';
        myUser=Database.query(searchQuery);
        
        myStr=myUser[0].user_Account__c;
        searchQuery='select id,email from contact where contact.account.id =:myStr limit 1';
        myCntct=Database.query(searchQuery);
        cId=myCntct[0].id;
        
        if(String.isNotBlank(myStr))
            return redrHome();
        else
            return null;
               
    }    
    public void dlt(){
        delete myUser;
    }
    
    
    
    //Database query functions start here..........
    
    public void getAccount(){
        string searchQuery='select name, grantee_status__c, grantee_type__c, granteeSubType__c, AnnualRevenue, YearStarted, Address_Line1__c,'+
        +' Address_Line2__c, city__c, state_province__c,country__c, zip_postal_code__c,'+
        ' phone, fax, website from account where id =:myStr limit 1';
        acnt=Database.query(searchQuery);
        
    }
    public void getContact(){
       string searchQuery='select name,contact.account.name,contact.owner.name,'+
           'contact_status__c,date_of_birth__c, address_line1__c,address_line2__c,city__c,state_province__c,zip_postal_code__c,'+
           'country__c,phone,mobilePhone,fax,internet_user__c,Email from contact where contact.Account.id=:myStr limit 1';
       
       myCntct=Database.query(searchQuery);
    }
    public void getApplication(){
    
    }
    
    
    
    // page Redirect functions start here....................
    
    public pageReference redrHome(){
        pageReference pr=new PageReference('/Apex/a_Home');
        pr.setRedirect(false);
        return pr;
    }
    
    public PageReference redrAccount(){  
       PageReference pageRef= new PageReference('/Apex/a_Account');
               
       return pageRef;      
    }
    public pagereference redrCntct(){
        PageReference pr=new PageReference('/apex/a_Contact');
        pr.setRedirect(false);
        return pr;
    }
    public PageReference redrApplication(){
        PageReference pr=new PageReference('/Apex/a_Application');
        return pr;
    }
    
    
    //selectOption functions here..........
    
    public list<selectoption> getappNms(){
        list<selectoption> myList=new list<selectoption>();
        list<order> ordr=new list<order>();

        string str='select id,OrderNumber from Order where Order.Account.id=:myStr limit 10';
        ordr=database.query(str);
        
        myList.add(new selectoption ('','--Select--'));
        for(Order o:ordr)
            myList.add(new selectoption(o.id,o.OrderNumber));
            
        return myList;
    }
    
    //function to copy selectOption value to output text...
    
    public void getAppDetail(){
        outTxt=appNm;
        string str='select id,OrderNumber,Order.Account.Name,Name,Grantee_Status__c,'+
            'Application_Record_type__c,Order.Contact_Person_Name__r.Name,Order.Program_Name_2__r.Name,'+
            'Contact_Person_Status__c,EffectiveDate,Order.Owner.Name,End_Date__c,Agreement__c,Grant_Amount__c,'+
            'status,Order.Decision_Case__r.Subject,Order.Outcomes__c from Order where id=:outTxt limit 10';
        
        myApp=database.query(str);
    }
    
}