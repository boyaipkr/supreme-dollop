public class jTestClass{
    public Date lastLoginDate{get;set;}
    public String lastLoginIp{get;set;}
    
    public string UserFullPhoto{get;set;}
    public string UserSmallPhoto{get;set;}
    public string LogoUrl{get;set;}

    
   
    public jTestClass(){
        User usr=[select id,SmallPhotoUrl,FullPhotoUrl,lastLoginDate from user where id=:userInfo.getUserId() limit 1];
        lastLoginDate=(usr.lastLoginDate).date();
        LoginHistory lh=[select sourceip from LoginHistory where userId=:usr.id order by loginTime DESC limit 1];
        lastLoginIp=lh.sourceIp;
        UserFullPhoto = usr.FullPhotoUrl;
        UserSmallPhoto = usr.SmallPhotoUrl;
        Document d = [SELECT id,name,url FROM Document WHERE name = :'garologotransparent' LIMIT 1];
        
        string strOrgId = UserInfo.getOrganizationId();
        LogoUrl = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+ '/servlet/servlet.ImageServer?id='+d.Id+'&oid=' + strOrgId;
        
    }
    
}