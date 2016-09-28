/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class AuthADSDomain extends AuthDomain{
    private static final String	cvsid = "@(#) $Id: AuthADSDomain.java,v 1.1 2004/01/07 00:49:32 wangli Exp $";

    private String dnsDomain = "";
    private String kdcServer = "";

    public AuthADSDomain(){
       	setType(TYPE_ADS);
    }

    public void setDNSDomain(String dom){
        dnsDomain = dom;
    }

    public String getDNSDomain(){
        return dnsDomain;
    }

    public void setKDCServer(String svr){
		kdcServer = svr;
    }

    public String getKDCServer(){ 
        return kdcServer; 
    }

}
