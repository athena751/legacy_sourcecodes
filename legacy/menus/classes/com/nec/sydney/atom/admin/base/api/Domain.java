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

public abstract class Domain extends SoapResponse{
    public static final String	cvsid = "@(#) Domain.java,v 1.5 2003/09/11 05:41:51 k-nishi Exp";

    public static final String TYPE_NIS    = "NIS";
    public static final String TYPE_PWD    = "PWD";    
    public static final String TYPE_DMC    = "DMC";
    public static final String TYPE_ADS    = "ADS";
    public static final String TYPE_SHR    = "SHR";
    public static final String TYPE_LDAPU  = "LDU";
    public static final String TYPE_LDAPW  = "LDS";
    public static final String TYPE_LDAPUW = "LDUW";
    public static final String TYPE_NISW   = "NISW";
    public static final String TYPE_PWDW   = "PWDW";
    
    private String region         = "";
    protected String type         = "";
    protected String ntdomain     = "";
    protected String ntdomainName = "";
    protected String netbios      = "";
    
    public Domain(){
    }

    public void setRegion(String region){
	this.region = region;
    }

    public String getRegion(){
	return this.region;
    }

    public void setType(String type){
	this.type =type;
    }

    public String getType(){
	return this.type;
    }

    public void setNTDomain(String ntdomain){
        this.ntdomain = ntdomain;
	StringTokenizer st = new StringTokenizer(ntdomain,"+");

	if(st.countTokens()==1){
	    setNTDomainName(ntdomain);
	}else if(st.countTokens()==2){
	    setNTDomainName(st.nextToken());
	    setNetbios(st.nextToken());
	}
    }

    public String getNTDomain(){
        return this.ntdomain;
    }

    public void setNetbios(String netbios){
	this.netbios = netbios;
    }

    public void setNTDomainName(String name){
	this.ntdomainName = name;
    }

    public String getNetbios(){
	return netbios;
    }

    public String getNTDomainName(){
	return ntdomainName;
    }

    public boolean compare(Object obj){
	if(obj == null)
	    return false;
	if(obj.getClass() != getClass())
	    return false;

	return true;
    }
}
