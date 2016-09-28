
/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: FTPAuthSetBean.java,v 1.2305 2004/11/12 02:42:25 liq Exp $";
 */
 
package    com.nec.sydney.beans.ftp;
import     com.nec.sydney.framework.*;
import     com.nec.sydney.atom.admin.base.api.*;
import     com.nec.sydney.atom.admin.ftp.*;
import     com.nec.sydney.beans.base.*;
import     com.nec.sydney.beans.mapdcommon.MapdCommon;
import     java.util.*;

public class FTPAuthSetBean extends TemplateBean implements FTPConstants {
    private FTPAuthInfo authinfo = new FTPAuthInfo();
    private String authdbtype = "";
    private String hasLdapSam;
    private String getGroupNo(){
        String groupNo= (String)session.getAttribute("group");
        if(groupNo==null){
            groupNo="0";
        }
        return groupNo;
    }
    public void onDisplay() throws Exception{
        try{
            authinfo = FTPSOAPClient.getAuthInfo(super.target,getGroupNo());
            authdbtype = authinfo.getAuthDBType();
            hasLdapSam = MapdCommon.getHasLdapSam(super.target);
        }
        catch(Exception e){
            throw e;
        }
    }
    
   public Vector getDomains() throws Exception {
        List exportmap = 
            APISOAPClient.getALLExportRootInfo(super.target);
        Iterator itr = exportmap.iterator();
        Vector domains = new Vector();
        while (itr.hasNext()){
            ExportRoot exportRoot = (ExportRoot)itr.next();
            LocalDomain localDomain=exportRoot.getLocalDomain();
            if (!localDomain.isNull()){
                if (localDomain.getSecurity().equals("domain") || localDomain.getSecurity().equals("ads")){
                        domains.add(localDomain.getLocalDomainName());
                }
            }
        }
        return domains;
    }
    
    public String getAuthDBType() {
        return (authinfo.getAuthDBType()); 
    }
    
    public String getNisNetwork() {
        if(!authdbtype.equals(AUTH_DBTYPE_NIS)) return "";
        return (authinfo.getNisNetwork()); 

    }
    
    public String getNisDomain() {
        if(!authdbtype.equals(AUTH_DBTYPE_NIS)) return "";        
        return (authinfo.getNisDomain()); 

    }
    
    public String getNisServer() {
        if(!authdbtype.equals(AUTH_DBTYPE_NIS)) return "";                
        return (authinfo.getNisServer()); 
    }
    
    public String getLudbName() {
        if(!authdbtype.equals(AUTH_DBTYPE_PWD)) return "";
        return (authinfo.getLudbName()); 
    }
    
    public String getPdcDomain() {
        if(!authdbtype.equals(AUTH_DBTYPE_PDC)) return "";
        return (authinfo.getPdcDomain()); 
    }
    
    public String getPdcName() {
        if(!authdbtype.equals(AUTH_DBTYPE_PDC)) return "";
        return (authinfo.getPdcName()); 
    }
    
    public String getBdcName() {
        if(!authdbtype.equals(AUTH_DBTYPE_PDC)) return "";
        return (authinfo.getBdcName()); 
    }
    
    public String getLdapServer() {
        return (authinfo.getLdapServer()); 
    }
    
    public String getLdapBaseDN() {
        return (authinfo.getLdapBaseDN()); 
    }
    
    public String getLdapMethod() {
        return (authinfo.getLdapMethod()); 
    }
    
    public String getLdapBindName() {
        return (authinfo.getLdapBindName()); 
    }
    
    public String getLdapBindPasswd() {
        return (authinfo.getLdapBindPasswd()); 
    }
    
    public String getLdapUseTls() {
        return (authinfo.getLdapUseTls()); 
    }
    
    public String getLdapCertFile() {
        return (authinfo.getLdapCertFile()); 
    }
    public String getLdapCertDir() {
        return (authinfo.getLdapCertDir()); 
    }
    public String getLdapUserInput(){
      //  if(!authdbtype.equals(AUTH_DBTYPE_LDAP)) return "";
        return (authinfo.getLdapUserInput());
    }
    
    public String getLdapUserFilter() {
        return (authinfo.getUserFilter());
    }
    
    public String getLdapGroupFilter() {
        return (authinfo.getGroupFilter());
    }

    public String getHasLdapSam(){
        return hasLdapSam;
    }
    
    public String getUtoa() {
        return (authinfo.getUtoa()); 
    }


}