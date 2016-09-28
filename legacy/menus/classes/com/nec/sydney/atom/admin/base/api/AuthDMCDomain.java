/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

public class AuthDMCDomain extends AuthDomain{
    private static final String	cvsid = "@(#) AuthDMCDomain.java,v 1.2 2002/02/01 08:44:24 k-nishi Exp";

    private String domainserver = "*";

    public AuthDMCDomain(){
       	setType(TYPE_DMC);
    }

    public void setDomainName(String domainname){
        super.setNTDomainName(domainname);
    }

    public String getDomainName(){
        return super.getNTDomainName();
    }

    public void setDomainServer(String domainserver){
	this.domainserver = domainserver;
    }

    public String getDomainServer(){ 
        return domainserver; 
    }

}
