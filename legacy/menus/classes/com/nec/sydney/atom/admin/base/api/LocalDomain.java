/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

import com.nec.sydney.net.soap.*;
import java.util.*;

public class LocalDomain extends SoapResponse{
    private static final String	cvsid = "@(#) LocalDomain.java,v 1.6 2003/09/08 09:05:26 k-nishi Exp";
    
    private String localdomainname;
    private String security;
    private Vector netbios;

    public static final String SECURITY_SHR = "SHR";
    public static final String SECURITY_DMC = "DMC";
    public static final String NATIVE_SHR   = "SHR";
    public static final String NATIVE_DMC   = "DMC";
    public static final String NATIVE_USER  = "USER";
    
    public LocalDomain(){
	localdomainname = new String();
	security = new String();
	netbios = new Vector();
    }

    public void setLocalDomainName(String domainname){
        localdomainname = domainname;
    }

    public String getLocalDomainName(){ 
        return localdomainname; 
    }

    public void setSecurity(String security){
	this.security = security;
    }

    public String getSecurity(){
        return security; 
    }

    public void setNetbios(String nt){
	if(nt!=null && !nt.equals("")){
	    boolean found = false;
	    Iterator it = netbios.iterator();
	    while(it.hasNext()){
		if(nt.equals((String)it.next()))
		    found = true;
	    }
	    if(!found)
		netbios.add(nt);
	}
    }

    public void setNetbios(Vector nt){
        netbios = nt;
    }
    public Vector getNetbios(){ 
        return netbios; 
    }

    public boolean isNull(){
	if(localdomainname==null || localdomainname.equals("")){
	    return true;
        }
	return false;
    }
}
