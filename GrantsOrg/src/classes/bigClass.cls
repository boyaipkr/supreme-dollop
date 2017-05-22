public class bigClass{
    //formId var
    public string formId{get;set;}
    
    //first page variables
    public string usr{get;set;}
    public string pass{get;set;}
    public string emailId{get;set;}
    public string mobNo{get;set;}
    public string orgNm{get;set;}
    public string output{get;set;}    //to fire Js methods from apex class
    
    //tab page variables
    public string tab{get;set;}
    public string[] outcomes{get;set;} // re-enabled on 27th Jan 2016, use of formData.outcomes__c rescinded
    
    public blob file{get;set;}
    public string fileName{get;set;} //added for file upload
   
    
    public date dob{get;set;}       // stores date_of_birth__c( contactPerson)
    public date startDate{get;set;} //stores project_start_date (Grnt Prgrm)
    public date endDate{get;set;}   // stores project_end_date (Grnt Prgrm)
    public list<decimal> capitals{get;set;}    //stores capital values of fundTab
    public list<decimal> revenues{get;set;}    // stores revenue values of fundTab
    public list<integer> iterator{get;set;}    //used to iterate capital and revenue index
    public string outTxt{get;set;} // this is for showing error message on bigHome page
       
    //object variables
    public list<Grants_Programs__c> prgrm{get;set;}
    public Application_Form__c formData{get;set;}
    
    //added by Boyai on 06.05.2015 to disable Org and Contact fields for existing customers
    public boolean fieldDisabled{get;set;}
    public string stlyeCapRevClass{get;set;}
    
    //id variables
    private string acntId; 
    private string cntctId;
    private string appId;     //set public for bigMsg page.
    public string appNo{get;set;}
    private boolean capitalCreated;

    
    
    //constructor
    public bigClass(){
        usr=pass=emailId=null; //just for being sure.
        formData=new Application_Form__c();
        tab='orgTab';           //sets visible tab on bigHome page
        startDate=date.today();
        capitalCreated=false;
        fieldDisabled=false;
        stlyeCapRevClass='hide';
        
        //initializing outcomes to null.
        
        outcomes=new list<string>(3); 
        for(integer i=0;i<3;i++)
            outcomes[i]='';
        
    }
    
    
    //to authenticate login credentials
    public pageReference login(){
       
        usr=String.escapeSingleQuotes(usr);
        pass=String.escapeSingleQuotes(pass);
        if(String.isEmpty(usr) || string.isEmpty(pass))
            output='Error: Empty Fields!!';
        else{
            output='';           
            list<Grantee_User__c> g=new list<Grantee_User__c>();
            string strQuery='select id,user_Account__c,application_form__c from Grantee_User__c where name=:usr and password__c=:pass limit 1';
            system.debug('boyai some value - ' + usr);
            g=Database.query(strQuery);
           //need to safeguard form from SQLInjection
        
            output='<script> loginFail1(); </script>';   
            if(g.isEMPTY()){
                output='Error: Login failed!';
            }
            else{
                if(String.ISNOTEMPTY(g[0].user_Account__c))
                    tab='projectTab';   
                aftrLogin();
                pageReference pr=new PageReference('/Apex/bigHome');
                pr.setRedirect(false);
                return pr;
            }
        }
        return null;
    }
    public void aftrLogin(){
        Grantee_User__c g=new Grantee_User__c();
        g=[select user_Account__r.Id, Application_form__r.id from Grantee_User__c where name=:usr and password__c=:pass limit 1];
        if( String.ISEMPTY(g.Application_form__c) && String.ISEMPTY(g.user_Account__c) ){
            //condn 1. do nothing. let page simply redirect to webForm
            formData.id=acntId=cntctId=null;
            
        }
        else if( String.ISNOTEMPTY(g.Application_form__c) && String.ISEMPTY(g.user_Account__c) ){
            //condn 2. fetch formData id.
            formId=formData.id=g.Application_form__c;
            cntctId=acntId=null;
            
            fetchFormData();   
        }
        else if(String.ISEMPTY(g.Application_form__c) && String.ISNOTEMPTY(g.user_Account__c)){
            //condn 3. it means user is submitting another application.
            acntId=g.user_Account__c;
            formData.id=null;
            
            fetchAccountData();
            fetchContactData();
            
            //added by Boyai - fields should be disabled
            fieldDisabled = true;
            
            disableTabs();
        }
        else if(String.ISNOTEMPTY(g.Application_form__c) && String.ISNOTEMPTY(g.user_Account__c)){
            //condn 4. user is applying for multiple programs using intermediate save;
            acntId=g.user_Account__c;
            cntctId=getContactId(acntId);    //function call.
            formId=formData.Id=g.Application_form__c;
            
            fetchFormData();
            
            //added by Boyai - fields should be disabled
            fieldDisabled = true;
            
            disableTabs();
        }
        else{
            //any other erreneous situation. 
        } 
    }
    private string getContactId(string acntId){
        contact con=new Contact();
        con=[select id from contact where accountId=:acntId limit 1];
        return con.id;
    }
    public pageReference chkLogin(){ //for trial purpose
        if(String.ISEMPTY(usr)){
            outTxt='<script> redirect1(); </script>';/*
            pageReference pg=new PageReference('/Apex/BigPg');
               
            return pg;*/
        }
        else if(string.ISNOTEMPTY(formData.Organization_Name__c)){
            
        }
        return null;
        
    }
    
    private void disableTabs(){
        
    }    
    
    //logout function
    public pageReference logout(){
        acntId=cntctId=appId=formData.id=formId=usr=pass=orgNm=mobNo=emailId=null;
        pageReference pg=new PageReference('/Apex/bigPg');
        pg.setRedirect(true);
        return pg;
        /*this function truncates all public variables
         & redirects to login page */
    }
    public pageReference redirect2Login(){
        return new pageReference('/apex/bigPg');
    
    } 
    
    //register new email address and notify admin by sending an email
    public void register(){
        if(string.isEmpty(orgNm)||string.isEmpty(emailId)||string.isEmpty(mobNo))
            output='Error: Fill all 3 fields.';
        else{
            output='Registration details recorded.';
            sendEmail();
        }
    }
    
    
    //function to fetch program details on first page
    public void prgrmDetails(){
        string s='released';
        string strQuery='select name,Program_Description__c from Grants_Programs__c where status__c=:s order by name asc limit 100';
        prgrm=Database.query(strQuery);
    }
    
    //functions to fetch values from DB to webForms
    private void fetchAccountData(){
        Account acc=new Account();
        acc=[select name, grantee_type__c, Foundation_Year__c, AnnualRevenue, Charity_Number__c, DUNS_Number__c, Public_Services__c,
            address_line1__c, address_line2__c, city__c, state_province__c, zip_postal_code__c, country__c,
            phone, fax, website
            from Account
            where id=:acntId limit 1];
        
        formData.organization_name__c=acc.name;
        formData.organization_type__c=acc.grantee_type__c;
        formData.foundation_year__c=Integer.valueOf(acc.Foundation_Year__c);
        formData.annual_revenue__c=acc.AnnualRevenue;
        formData.Charity_Number__c=acc.Charity_Number__c;
        formData.DUNS_Number__c=acc.DUNS_Number__c;
        formData.Public_Services__c=acc.Public_Services__c;
        
        formData.address_line_1__c=acc.address_line1__c;
        formData.address_line_2__c=acc.address_line2__c;
        formData.city_town__c=acc.city__c;
        formData.state_province__c=acc.state_province__c;
        formData.zip_postal_code__c=acc.zip_postal_code__c;
        formData.country__c=acc.country__c;
        
        formData.phone__c=acc.phone;
        formData.fax__c=acc.fax;
        formData.website__c=acc.website;
        
        //acntId already fetched from Grantee User Object.    
    }
    private void fetchContactData(){
        Contact con=new Contact();
        con=[select id,firstName, lastName, title, date_of_birth__c,
                address_line1__c, address_line2__c, city__c, state_province__c, country__c, zip_postal_code__c,
                phone, mobilePhone, fax, email, preferred_language__c
                from Contact
                where Account.id=:acntId limit 1];
        
        formData.first_name__c=con.firstName;
        formData.last_name__c=con.lastName;
        formData.title__c=con.title;
        dob=con.date_of_birth__c;
        
        formData.cp_address_line_1__c=con.address_line1__c;
        formData.cp_address_line_2__c=con.address_line2__c;
        formData.cp_city_town__c=con.city__c;
        formData.cp_country__c=con.country__c;
        formData.cp_state_province__c=con.state_province__c;
        formData.cp_zip_postal_code__c=con.zip_postal_code__c;
        
        formData.cp_phone__c=con.phone;
        formData.cp_mobile__c=con.mobilephone;
        formData.cp_fax__c=con.fax;
        formData.cp_email__c=con.email;
        formData.preferred_language__c=con.preferred_language__c;
        
        cntctId=con.id;   
    }
    private void fetchFormData(){
        formData=[select organization_name__c, Annual_Revenue__c, Organization_type__c, Foundation_year__c, Charity_Number__c, DUNS_Number__c, Public_Services__c,
                Address_Line_1__c, Address_Line_2__c, City_Town__c, State_Province__c, Country__c, Zip_Postal_Code__c, Phone__c, fax__c, website__c,
                First_Name__c, Last_Name__c, Title__c, date_of_birth__c, cp_Address_line_1__c, cp_address_line_2__c, cp_city_town__c, cp_state_province__c,
                cp_country__c, cp_zip_postal_code__c, cp_phone__c, cp_mobile__c, cp_fax__c, cp_email__c,preferred_language__c,
                project_title__c, fund_program__c, project_details__c,
                project_start_date__c, project_end_date__c, capital_1__c, revenue_1__c,
                capital_2__c, revenue_2__c, capital_3__c, revenue_3__c, capital_4__c, revenue_4__c, capital_5__c, revenue_5__c,
                project_outcomes__c 
                    From Application_Form__c
                    Where id=:formData.id];
        
        formData.fund_program__c=getProgramId(formData.fund_program__c);
        dob=formData.date_of_birth__c;
        startDate=formData.project_start_date__c;
        endDate=formData.project_end_date__c;
        
        
        
        if(string.ISNOTEMPTY(formData.project_outcomes__c)){
            if(formData.project_outcomes__c.contains('\n\n')){
                outcomes=formData.project_outcomes__c.split('\\n\\n',-2);
            }
            else{
                outcomes[0]=formData.project_outcomes__c;
            }
        }
        
        if(formData.capital_5__c>0){
            generateFields(5);
        }
        else if(formData.capital_4__c>0){
            generateFields(4);
        }
        else if(formData.capital_3__c>0){
            generateFields(3);
        }
        else if(formData.capital_2__c>0){
            generateFields(2);
        }
        else if(formData.capital_1__c>0){
            generateFields(1);
        }
        else{
            capitalCreated=false;
        }
        
        if(capitalCreated){
            stlyeCapRevClass='unhide';
            fetchCapital();
        }
    }
    public list<selectoption> getcountryNm(){
        list<selectoption> myList=new list<selectOption>();
        
        mylist.add(new selectOption('','--Select--'));
        Schema.DescribeFieldResult fieldResult = Account.Country__c.getDescribe();   
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();   
        for(Schema.picklistEntry f:ple)   
        {   
            myList.add(new selectOption(f.getLabel(),f.getValue()));                   
        }   
        return myList;
    }
    public list<selectOption> getmyTitle(){
        list<selectoption> myList=new list<selectOption>();
        
        mylist.add(new selectOption('','--Select--'));
        mylist.add(new selectOption('Mr.','Mr.'));
        mylist.add(new selectOption('Mrs.','Mrs.'));
        mylist.add(new selectOption('Ms.','Ms.'));
        return myList;
    }
    public list<selectOption> getorg(){
        List<SelectOption> myList=new List<SelectOption>();   
        myList.add(new selectOption('','--Select--'));   
        Schema.DescribeFieldResult fieldResult = Account.Grantee_Type__c.getDescribe();   
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();   
        for(Schema.picklistEntry f:ple)   
        {   
            myList.add(new selectOption(f.getLabel(),f.getValue()));                   
        }   
        return myList;
    }
    /*
    public list<selectOption> getorgSub(){
        list<selectoption> myList=new list<selectOption>();
        
        mylist.add(new selectOption('','--Select--'));
        Schema.DescribeFieldResult fieldResult = Account.GranteeSubType__c.getDescribe();   
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();   
        for(Schema.picklistEntry f:ple)   
        {   
            myList.add(new selectOption(f.getLabel(),f.getValue()));                   
        }   
        return myList;
    }
    */
    public list<selectOption>getprefLang(){
        list<selectOption> myList=new list<selectOption>();
        
        Schema.DescribeFieldResult fieldResult=Contact.Preferred_Language__c.getDescribe();
        list<Schema.picklistEntry> ple=fieldResult.getPicklistValues();
        for(Schema.picklistEntry f:ple){
            myList.add(new selectOption(f.getLabel(),f.getValue()));
        }
        return myList;
    
    }
    public list<selectOption> getprojects(){
        list<selectOption> myList=new list<selectOption>();
        string s='released';
        string strQuery='select id,name from Grants_programs__c where status__c=:s order by name asc limit 100';
        list<Grants_Programs__c> prgrm=new list<Grants_Programs__c>();
        
        prgrm=Database.query(strQuery);
        myList.add(new selectOption('','--Select--'));
        for(Grants_Programs__c p:prgrm)
            myList.add(new selectOption(p.id,p.name));
        
        return myList;
    }
    public list<selectOption> getpublicServices(){
        list<selectOption> myList=new list<selectOption>();
        
        Schema.describeFieldResult fieldResult=Account.Public_services__c.getDescribe();
        list<schema.picklistentry> ple=fieldResult.getPickListValues();
                
        mylist.add(new selectOption('','--Select--'));
        for(schema.pickListEntry f:ple)
            myList.add(new selectOption(f.getLabel(),f.getValue()));
        
        return myList;
    }
    
    //function to dynamically generate table for capital and revenue
    public void getDates(){
        integer m=startDate.monthsBetween(endDate);
        integer yr=(m/12)+(math.mod(m,12)>0?1:0);
        
        stlyeCapRevClass='unhide';
        
        if(math.mod(m,12)==0 && startDate.day()<endDate.day())
            yr++;
        if(string.isEmpty(formData.id)){
            if(startDate<Date.Today())
                outTxt='Error: Invalid project start date';
            else if(startDate>=Date.Today() && endDate<=startDate)
                outTxt='Error: Invalid project end date';
            else{
                outTxt='';
                generateFields(yr);
            }
        }
        else{
            if(endDate<date.Today())
                outTxt='Error: Invalid project end date';
            else{
                outTxt='';
                generateFields(yr);
            }
        }
    }
    public boolean getDates1(){
        if(endDate==null)
            return true;    
        integer m=startDate.monthsBetween(endDate);
        integer yr=(m/12)+(math.mod(m,12)>0?1:0);
        if(startDate<Date.today())
            outTxt='Invalid Project start Date';
        else if(startDate>=Date.Today() && (endDate<=startDate))
            outTxt='Invalid Project End Date';
        else{
            outTxt='';
            return true;
        }
        return false;
    }
    
    
    //functions to save partial data
    
    public void saveFormDetail(){
        if(String.ISEMPTY(formData.id)){
            if(getDates1())
                insertFormDetail();
            
             if(String.ISNOTEMPTY(formId)){
                linkUser2App();
            } 
        }
        else{
            if(getDates1())
                updateFormDetail();
        }
    }
   
        
    //finctions to navigate between tabs
    public void next(){
        if(tab=='orgTab')
            tab='comTab';
        else if(tab=='comTab')
            tab='contactTab';
        else if(tab=='contactTab')
            tab='projectTab';
        else if(tab=='projectTab')
            tab='fundTab';
        else if(tab=='fundTab')
            tab='outcomesTab';
        else if(tab=='outcomesTab')
            tab='decTab';
        else
            tab='orgTab';     
    }
    public void back(){
        if(tab=='comTab')
            tab='orgTab';
        else if(tab=='contactTab')
            tab='comTab';
        else if(tab=='projectTab')
            tab='contactTab';
        else if(tab=='fundTab')
            tab='projectTab';
        else if(tab=='outcomesTab')
            tab='fundTab';
        else if(tab=='decTab')
            tab='outcomesTab';
        else
            tab='orgTab';
    }
    
    
    //final submit (actual record creation)
    public pageReference submit(){
        if(String.isEmpty(usr)){
            outTxt='<script> alert("Usr credentials not found"); </script>';
            return null;
        }
        else{     
            if(String.ISEMPTY(acntId))
                createGrantee();
            if(String.ISEMPTY(cntctId))
                createContact();  
                  
            createApplication();
         
            removeAppId();
            
            uploadFile();
            
            return new pageReference('/Apex/bigMsg');  
        }
              
    }
        
        
    
    //private functions in approx alphabetic order
    private void createGrantee(){    //executed when data filled in one go and application data not saved.
        Account acc=new Account();
       acc.name=formData.organization_name__c;
       acc.grantee_type__c=formData.Organization_type__c;
       acc.AnnualRevenue=formData.annual_revenue__c;
       acc.YearStarted=String.valueOf(formData.foundation_year__c);
       acc.Charity_Number__c=formData.Charity_Number__c;
       acc.DUNS_Number__c=formData.DUNS_Number__c;
       acc.public_Services__c=formData.public_Services__c;
       
       acc.Address_line1__c=formData.Address_line_1__c;
       acc.Address_Line2__c=formData.Address_Line_2__c;
       acc.city__c=formData.City_Town__c;
       acc.state_province__c=formData.state_province__c;
       acc.country__c=formData.country__c;
       acc.zip_postal_code__c=formData.zip_postal_code__c;
       acc.Phone=formData.phone__c;
       acc.fax=formData.fax__c;
       acc.website=formData.website__c;
       
       insert acc;    
       acntId=acc.id;
       
       Grantee_User__c g=new Grantee_User__c();
       g=[select id,user_Account__c from Grantee_User__c where name=:usr limit 1];
       if(String.ISEMPTY(g.user_Account__c))
           g.user_Account__c=acntId;
       update g;
    }
    private void createApplication(){
        Order ord=new Order();
        
        ord.name=formData.project_title__c;
        ord.status='Draft';
        ord.Program_Name_2__c=formData.fund_program__c;
        ord.EffectiveDate=startDate;
        ord.EndDate=endDate;
        ord.AccountId=acntId;
        ord.Contact_Person_Name__c=cntctId;
        
        
        
        ord.outcomes__c='';
        
        for(integer i=0;i<3;i++)
           ord.outcomes__c+=outcomes[i]+'\n\n';
        
        
        insert ord;
        appId=ord.id;
        getAppNumber(appId);
        
        createLineItem();
    }
    
    private void createContact(){
         Contact con=new Contact();
        
        con.title=formData.title__c;
        con.firstName=formData.first_name__c;
        con.lastName=formData.last_name__c;
        con.date_of_birth__c=dob;
        con.AccountId=acntId;
        con.Address_line1__c=formData.cp_Address_line_1__c;
        con.Address_Line2__c=formData.cp_Address_Line_2__c;
        con.City__c=formData.cp_City_Town__c;
        con.state_province__c=formData.cp_state_province__c;
        con.country__c=formData.cp_country__c;
        con.zip_postal_code__c=formData.cp_zip_postal_code__c;
        con.phone=formData.cp_phone__c;
        con.mobilePhone=formData.cp_mobile__c;
        con.fax=formData.cp_fax__c;
        con.Internet_User__c=true;
        con.email=formData.cp_email__c;
        con.preferred_language__c=formData.preferred_language__c;
        
        Insert con;
        cntctId=con.id;
    }
    private void createLineItem(){
        PriceBook2 pb = [select Id from Pricebook2 where isStandard=true];
        Order ord=new Order();
        ord=[select id,Pricebook2Id from Order where id=:appId];
        ord.Pricebook2Id=pb.id;
        update ord;
        
        integer n=capitals.size();
        string yr; // for using it in for loop for Year 1/Year 2......
        priceBookEntry pbe=new priceBookEntry();
        for(integer i=0;i<n;i++){
            yr='Year '+string.valueOf(i+1);
            pbe=[select id,product2Id,priceBook2Id,UnitPrice from priceBookEntry where priceBook2Id=:pb.id and name=:yr limit 1];
            
            orderItem ordItm1=new orderItem();
            orderItem ordItm2=new orderItem();
            
            ordItm1.priceBookEntryId=pbe.id;
            ordItm1.OrderId=ord.id;
            ordItm1.Quantity=1;
            ordItm1.Description='Capital';
            ordItm1.unitPrice=capitals[i];
            ordItm1.serviceDate=startDate;
            insert ordItm1;
            
            ordItm2.priceBookEntryId=pbe.id;
            ordItm2.OrderId=ord.id;
            ordItm2.Quantity=1;
            ordItm2.Description='Revenue';
            ordItm2.unitPrice=revenues[i];
            ordItm2.serviceDate=startDate;
            insert ordItm2;
        }
    }
    
    private void copyCapitalNdRevenue(application_form__c app){
        integer  n=capitals.size();
        
        if(n>=1){
            app.capital_1__c=capitals[0];
            app.revenue_1__c=revenues[0];
        }
        if(n>=2){
            app.capital_2__c=capitals[1];
            app.revenue_2__c=revenues[1];
        }
        if(n>=3){
            app.capital_3__c=capitals[2];
            app.revenue_3__c=revenues[2];
        }
        if(n>=4){
            app.capital_4__c=capitals[3];
            app.revenue_4__c=revenues[3];
        }
        if(n>=5){
            app.capital_5__c=capitals[4];
            app.revenue_5__c=revenues[4];
        }
    }    
    private void fetchCapital(){
        integer n=capitals.size();
        if(n>=1){
            capitals[0]=formData.capital_1__c;
            revenues[0]=formData.revenue_1__c;
        }
        if(n>=2){
            capitals[1]=formData.capital_2__c;
            revenues[1]=formData.revenue_2__c;
        }
        if(n>=3){
            capitals[2]=formData.capital_3__c;
            revenues[2]=formData.revenue_3__c;
        }
        if(n>=4){
            capitals[3]=formData.capital_4__c;
            revenues[3]=formData.revenue_4__c;
        }
        if(n>=5){
            capitals[4]=formData.capital_5__c;
            revenues[4]=formData.revenue_5__c;
        }
    }
    private void getAppNumber(string appId){
        Order ord=new Order();
        ord=[select id,orderNumber from order where id=:appId limit 1];
        appNo=ord.OrderNumber;
    }
    
    private string getProgramName(){
        if(String.ISNOTEMPTY(formData.fund_program__c)){
            Grants_Programs__c gp=new Grants_Programs__c();
            gp=[select name from grants_programs__c where id=:formData.fund_program__c limit 1];
            return gp.name;
        }
        else
            return '';
    }
    
    
    private string getOutcomes(){
        String str='';
        for(integer i=0;i<3;i++)
           str+=outcomes[i]+'\n\n';
        return str;
    }
    
    private string getProgramId(string pNm){
        if(String.ISNOTEMPTY(pNm)){
            Grants_Programs__c gp=new Grants_Programs__c();
            gp=[select id from Grants_Programs__c where name=:pNm limit 1];
            return gp.id;
        }
        else
            return '';
        
    
    }
    private void generateFields(integer yr){
        capitalCreated=true;
        capitals=new list<decimal>(yr);
        revenues=new list<decimal>(yr);
        iterator=new list<integer>(yr);
        
        for(integer i=0;i<yr;i++){
            capitals[i]=revenues[i]=0;
            iterator[i]=i;
        }
        
    }

    private void insertFormDetail(){
        Application_Form__c app=new Application_Form__c();
           
        app.organization_name__c=formData.organization_name__c;
        app.Annual_Revenue__c=formData.Annual_Revenue__c;
        app.Organization_type__c=formData.Organization_type__c;
        app.Foundation_year__c=formData.Foundation_year__c;
        app.Charity_Number__c=formData.Charity_Number__c;
        app.DUNS_Number__c=formData.DUNS_Number__c;
        app.Public_Services__c=formData.Public_Services__c;
           
        app.Address_Line_1__c=formData.Address_Line_1__c;
        app.Address_Line_2__c=formData.Address_Line_2__c;
        app.City_Town__c=formData.City_Town__c;
        app.State_Province__c=formData.State_Province__c;
        app.Country__c=formData.Country__c;
        app.Zip_Postal_Code__c=formData.Zip_Postal_Code__c;
        app.Phone__c=formData.Phone__c;
        app.fax__c=formData.fax__c;
        app.website__c=formData.website__c;
           
        app.First_Name__c=formData.First_Name__c;
        app.Last_Name__c=formData.Last_Name__c;
        app.Title__c=formData.Title__c;
        app.date_of_birth__c=dob;    //public var
           
        app.cp_Address_line_1__c=formData.cp_Address_line_1__c;
        app.cp_address_line_2__c=formData.cp_address_line_2__c;
        app.cp_city_town__c=formData.cp_city_town__c;
        app.cp_state_province__c=formData.cp_state_province__c;
        app.cp_country__c=formData.cp_country__c;
        app.cp_zip_postal_code__c=formData.cp_zip_postal_code__c;
        app.cp_phone__c=formData.cp_phone__c;
        app.cp_mobile__c=formData.cp_mobile__c;
        app.cp_fax__c=formData.cp_fax__c;
        app.cp_email__c=formData.cp_email__c;
        app.preferred_language__c=formData.preferred_language__c;
           
        app.project_title__c=formData.project_title__c;
        app.fund_program__c=getProgramName();        //function call
        app.project_details__c=formData.project_details__c;
           
        app.project_start_date__c=startDate;    //public var
        app.project_end_date__c=endDate;        //public var
                   
        app.project_outcomes__c=getOutcomes(); 
    
        
        
        if(capitalCreated)
            copyCapitalNdRevenue(app);   
           
        Insert app;
        
        formId=formData.id=app.id;
    
    
    }
    private void linkUser2App(){
        Grantee_User__c g=new Grantee_User__c();
        if(string.ISNOTEMPTY(usr)){
            g=[select id from Grantee_User__c where name=:usr];
            g.Application_Form__c=formId;
            try{
                update g;
            }catch(DMLException e){
                System.Debug('Error in linking grantee user with application form.');
            }
        }    
        
    
    }
    private void removeAppId(){
        Grantee_User__c g=new Grantee_User__c();
        if(string.ISNOTEMPTY(usr))
            g=[select application_form__c from Grantee_User__c where name=:usr limit 1];
        if(String.ISNOTEMPTY(g.application_form__c)){
            g.application_form__c=null;
            update g;
        }
           
    }
    private void sendEmail(){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string r='boyai.pukhrambam@gauri.com';
         String[] toAddresses = new String[] {r};
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Gauri Grants Team');
        mail.setSubject('new Registration');
        String body = 'Organization Name: '+orgNm+'<br/> Mobile No: '+mobNo+'<br/> Email Id: '+emailId;
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        emailId=mobNo=orgNm=null;
    }
    
    private void updateFormDetail(){
        Application_form__c app=new Application_Form__c();
        app=[select id
            from Application_Form__c where id=:formData.id];
        
        app.organization_name__c=formData.organization_name__c;
        app.Annual_Revenue__c=formData.Annual_Revenue__c;
        app.Organization_type__c=formData.Organization_type__c;
        app.Foundation_year__c=formData.Foundation_year__c;
        app.Charity_Number__c=formData.Charity_Number__c;
        app.DUNS_Number__c=formData.DUNS_Number__c;
        app.Public_Services__c=formData.Public_Services__c;
           
        app.Address_Line_1__c=formData.Address_Line_1__c;
        app.Address_Line_2__c=formData.Address_Line_2__c;
        app.City_Town__c=formData.City_Town__c;
        app.State_Province__c=formData.State_Province__c;
        app.Country__c=formData.Country__c;
        app.Zip_Postal_Code__c=formData.Zip_Postal_Code__c;
        app.Phone__c=formData.Phone__c;
        app.fax__c=formData.fax__c;
        app.website__c=formData.website__c;
           
        app.First_Name__c=formData.First_Name__c;
        app.Last_Name__c=formData.Last_Name__c;
        app.Title__c=formData.Title__c;
        app.date_of_birth__c=dob;
           
        app.cp_Address_line_1__c=formData.cp_Address_line_1__c;
        app.cp_address_line_2__c=formData.cp_address_line_2__c;
        app.cp_city_town__c=formData.cp_city_town__c;
        app.cp_state_province__c=formData.cp_state_province__c;
        app.cp_country__c=formData.cp_country__c;
        app.cp_zip_postal_code__c=formData.cp_zip_postal_code__c;
        app.cp_phone__c=formData.cp_phone__c;
        app.cp_mobile__c=formData.cp_mobile__c;
        app.cp_fax__c=formData.cp_fax__c;
        app.cp_email__c=formData.cp_email__c;
        app.preferred_language__c=formData.preferred_language__c;
           
        app.project_title__c=formData.project_title__c;
        app.fund_program__c=getProgramName();
        app.project_details__c=formData.project_details__c;
           
        app.project_start_date__c=startDate;
        app.project_end_date__c=endDate;
        app.capital_1__c=formData.capital_1__c;
        app.revenue_1__c=formData.revenue_1__c;
           
        app.project_outcomes__c=getOutcomes();    
     
       
        
        if(capitalCreated)
            copyCapitalNdRevenue(app); 
        
        update app;
    }
    
    private void uploadFile(){
        if(file!=null && fileName!=null){
            Attachment a=new Attachment();
            a.body=file;
            a.name=fileName;
            a.ParentId=appId;
            
            insert a;
        }
    }
}