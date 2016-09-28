/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

public class AuthNISDomain extends AuthDomain{
    private static final String	cvsid = "@(#) AuthNISDomain.java,v 1.4 2003/08/27 06:22:34 k-nishi Exp";
    
    private String domainname;
    private String domainserver;

    public AuthNISDomain(){
	domainname = new String();
	domainserver = new String();
	setType(TYPE_NIS);
    }

    public void setDomainName(String domainname){
	this.domainname = domainname;
    }

    public String getDomainName(){ 
        return domainname; 
    }

    public void setDomainServer(String domainserver){
	this.domainserver = domainserver;
    }

    public String getDomainServer(){ 
        return domainserver; 
    }

    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;
	
	AuthNISDomain nis = (AuthNISDomain)obj;
	if(!nis.getDomainName().equals(domainname))
	    return false;
	if(!nis.getDomainServer().equals(domainserver))
	    return false;

	return true;
    }
}
