/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

abstract public class NativeLDAPDomain extends NativeDomain implements ILDAPDomain{
    private static final String     cvsid = "@(#) $Id: NativeLDAPDomain.java,v 1.2302 2004/11/12 02:35:17 caoyh Exp $";
    private String serverName         = "";
    private String distinguishedName  = "";
    private String authenticateType   = "";
    private String TLS                = "";
    private String authenticateID     = "";
    private String authenticatePasswd = "";
    private String CA                 = "";
    private String CAType             = "no";
    private String userFilter = "";
    private String groupFilter = "";

    public NativeLDAPDomain(){
    }

    private String utoa="n";

    public String getUtoa(){
        return utoa;
    }
    public void setUtoa(String utoa){
        this. utoa = utoa;
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

    public void setServerName(String name){
	serverName = name;
    }

    public void setDistinguishedName(String name){
	distinguishedName = name;
    }

    public void setAuthenticateType(String type){
	authenticateType = type;
    }

    public void setTLS(String tls){
	TLS = tls;
    }

    public void setAuthenticateID(String id){
	authenticateID = id;
    }

    public void setAuthenticatePasswd(String passwd){
	authenticatePasswd = passwd;
    }

    public void setCA(String ca){
	CA = ca;
    }

    public void setCAType(String type){
        this.CAType = type;
    }

    public String getServerName(){
	return serverName;
    }

    public String getDistinguishedName(){
	return distinguishedName;
    }

    public String getAuthenticateType(){
	return authenticateType;
    }

    public String getTLS(){
	return TLS;
    }

    public String getAuthenticateID(){
	return authenticateID;
    }

    public String getAuthenticatePasswd(){
	return authenticatePasswd;
    }

    public String getCA(){
	return CA;
    }

    public String getCAType(){
        return CAType;
    }

}
