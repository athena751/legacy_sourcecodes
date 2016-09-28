/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class NativeADSDomain extends NativeDomain{
    private static final String	cvsid = "@(#) $Id: NativeADSDomain.java,v 1.1 2004/01/07 00:49:32 wangli Exp $";

    private String dnsDomain = "";
    private String kdcServer = "";

    public NativeADSDomain(){
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
    public boolean compare(Object obj){
		if(!super.compare(obj))
			return false;

		NativeADSDomain ads = (NativeADSDomain)obj;
		if(!ntdomain.equals(ads.getNTDomain()))
			return false;
		return true;
    }
}
