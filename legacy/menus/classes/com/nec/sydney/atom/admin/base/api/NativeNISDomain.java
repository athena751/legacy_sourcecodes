/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

public class NativeNISDomain extends NativeDomain{
    private static final String	cvsid = "@(#) NativeNISDomain.java,v 1.5 2003/08/27 06:27:07 k-nishi Exp";
    
    private String domainname   = "";
    private String domainserver = "";

    public NativeNISDomain(){
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
	
	NativeNISDomain nd = (NativeNISDomain)obj;
	if(!domainname.equals(nd.getDomainName()))
	    return false;
	if(!domainserver.equals(nd.getDomainServer()))
	    return false;
	if(!network.equals(nd.getNetwork()))
	    return false;
	return true;
    }

    public boolean isInvalidNISDomain(Object obj){
	if(obj == null)
	    return false;
	if(obj instanceof NativeNISDomain){
	    NativeNISDomain nis = (NativeNISDomain)obj;
	    if(domainname.equals(nis.getDomainName())
	       && !domainserver.equals(nis.getDomainServer()))
		return true;
	}
	return false;
    }
}

