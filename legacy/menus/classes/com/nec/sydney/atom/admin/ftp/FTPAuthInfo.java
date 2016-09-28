
/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: FTPAuthInfo.java,v 1.2302 2004/11/12 02:42:09 liq Exp $";
 */
 
package    com.nec.sydney.atom.admin.ftp;

public class FTPAuthInfo {
    private static final String     cvsid = "@(#) $Id: FTPAuthInfo.java,v 1.2302 2004/11/12 02:42:09 liq Exp $";
    String authDBType;
   
    String nisNetwork;
    String nisDomain;
    String nisServer;
    
    String ludbName;
  
    String pdcDomain;
    String pdcName;
    String bdcName;
    
    String ldapServer;
    String ldapBaseDN;
    String ldapMethod;
    String ldapBindName;
    String ldapBindPasswd;
    String ldapUseTls;
    String ldapCertFile;
    String ldapCertDir;
    String ldapUserInput;
    private String userFilter = "";
    private String groupFilter = "";
    private String utoa;

    public FTPAuthInfo() {
        this.authDBType = "";
        this.nisNetwork = "";
        this.nisDomain = "";
        this.nisServer = "";
        this.ludbName = "";
        this.pdcDomain = "";
        this.pdcName = "";
        this.bdcName = "";
        this.ldapServer = "";
        this.ldapBaseDN = "";
        this.ldapMethod = "";
        this.ldapBindName = "";
        this.ldapBindPasswd = "";
        this.ldapUseTls = "";
        this.ldapCertFile = "";
        this.ldapCertDir = "";
        this.ldapUserInput = "";
        this.utoa = "n";
    }

    public String getUtoa(){
        return utoa;
    }
    
    public void setUtoa(String utoa){
        this.utoa = utoa;
    }
    
    public String getUserFilter(){
        return userFilter;
    }
    
    public void setUserFilter(String userFilter){
        this.userFilter = userFilter;
    }

    public String getGroupFilter(){
        return groupFilter;
    }
    
    public void setGroupFilter(String groupFilter){
        this. groupFilter = groupFilter;
    }
    
    public void setAuthDBType(String authDBType) {
        this.authDBType = authDBType; 
    }
    
    public void setNisNetwork(String nisNetwork) {
        this.nisNetwork = nisNetwork; 
    }
    
    public void setNisDomain(String nisDomain) {
        this.nisDomain = nisDomain; 
    }
    
    public void setNisServer(String nisServer) {
        this.nisServer = nisServer; 
    }
    
    public void setLudbName(String ludbName) {
        this.ludbName = ludbName; 
    }
    
    public void setPdcDomain(String pdcDomain) {
        this.pdcDomain = pdcDomain; 
    }
    
    public void setPdcName(String pdcName) {
        this.pdcName = pdcName; 
    }
    
    public void setBdcName(String bdcName) {
        this.bdcName = bdcName; 
    }
    
    public void setLdapServer(String ldapServer) {
        this.ldapServer = ldapServer; 
    }
    
    public void setLdapBaseDN(String ldapBaseDN) {
        this.ldapBaseDN = ldapBaseDN; 
    }
    
    public void setLdapMethod(String ldapMethod) {
        this.ldapMethod = ldapMethod; 
    }
    
    public void setLdapBindName(String ldapBindName) {
        this.ldapBindName = ldapBindName; 
    }
    
    public void setLdapBindPasswd(String ldapBindPasswd) {
        this.ldapBindPasswd = ldapBindPasswd; 
    }
    
    public void setLdapUseTls(String ldapUseTls) {
        this.ldapUseTls = ldapUseTls; 
    }
    
    public void setLdapCertFile(String ldapCertFile) {
        this.ldapCertFile = ldapCertFile; 
    }
    
    public void setLdapCertDir(String ldapCertDir) {
        this.ldapCertDir = ldapCertDir; 
    }
    
    public String getAuthDBType() {
        return (this.authDBType); 
    }
    
    public String getNisNetwork() {
        return (this.nisNetwork); 
    }
    
    public String getNisDomain() {
        return (this.nisDomain); 
    }
    
    public String getNisServer() {
        return (this.nisServer); 
    }
    
    public String getLudbName() {
        return (this.ludbName); 
    }
    
    public String getPdcDomain() {
        return (this.pdcDomain); 
    }
    
    public String getPdcName() {
        return (this.pdcName); 
    }
    
    public String getBdcName() {
        return (this.bdcName); 
    }
    
    public String getLdapServer() {
        return (this.ldapServer); 
    }
    
    public String getLdapBaseDN() {
        return (this.ldapBaseDN); 
    }
    
    public String getLdapMethod() {
        return (this.ldapMethod); 
    }
    
    public String getLdapBindName() {
        return (this.ldapBindName); 
    }
    
    public String getLdapBindPasswd() {
        return (this.ldapBindPasswd); 
    }
    
    public String getLdapUseTls() {
        return (this.ldapUseTls); 
    }
    
    public String getLdapCertFile() {
        return (this.ldapCertFile); 
    }
    
    public String getLdapCertDir() {
        return (this.ldapCertDir); 
    }
    public String getLdapUserInput(){
        return (this.ldapUserInput);
    }
    public void setLdapUserInput(String ldapUserInput){
        this.ldapUserInput = ldapUserInput;
    }
	public String toString() {

		String sep = "\\r\\n";//System.getProperty("line.separator");

		StringBuffer buffer = new StringBuffer();
		buffer.append(sep);
		buffer.append("authDBType = ");
		buffer.append(authDBType);
		buffer.append(sep);
		buffer.append("nisNetwork = ");
		buffer.append(nisNetwork);
		buffer.append(sep);
		buffer.append("nisDomain = ");
		buffer.append(nisDomain);
		buffer.append(sep);
		buffer.append("nisServer = ");
		buffer.append(nisServer);
		buffer.append(sep);
		buffer.append("ludbName = ");
		buffer.append(ludbName);
		buffer.append(sep);
		buffer.append("pdcDomain = ");
		buffer.append(pdcDomain);
		buffer.append(sep);
		buffer.append("pdcName = ");
		buffer.append(pdcName);
		buffer.append(sep);
		buffer.append("bdcName = ");
		buffer.append(bdcName);
		buffer.append(sep);
		buffer.append("ldapServer = ");
		buffer.append(ldapServer);
		buffer.append(sep);
		buffer.append("ldapBaseDN = ");
		buffer.append(ldapBaseDN);
		buffer.append(sep);
		buffer.append("ldapMethod = ");
		buffer.append(ldapMethod);
		buffer.append(sep);
		buffer.append("ldapBindName = ");
		buffer.append(ldapBindName);
		buffer.append(sep);
		buffer.append("ldapBindPasswd = ");
		buffer.append(ldapBindPasswd);
		buffer.append(sep);
		buffer.append("ldapUseTls = ");
		buffer.append(ldapUseTls);
		buffer.append(sep);
		buffer.append("ldapCertFile = ");
		buffer.append(ldapCertFile);
		buffer.append(sep);
		buffer.append("ldapCertDir = ");
		buffer.append(ldapCertDir);
		buffer.append(sep);
		buffer.append("ldapUserInput = ");
		buffer.append(ldapUserInput);
		buffer.append(sep);
		
		return buffer.toString();
	}

    
}