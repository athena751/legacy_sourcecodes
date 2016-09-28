/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

import java.util.StringTokenizer;

public abstract class NativeDomain extends Domain{
    public static final String	cvsid = "@(#) NativeDomain.java,v 1.7 2003/08/27 06:26:00 k-nishi Exp";
    
    public final static String NATIVE_NIS    = "NativeNISDomain";
    public final static String NATIVE_PWD    = "NativePWDDomain";
    public final static String NATIVE_SHR    = "NativeSHRDomain";
    public final static String NATIVE_DMC    = "NativeDMCDomain";
    public final static String NATIVE_ADS    = "NativeADSDomain";
    public final static String NATIVE_LDAPW  = "NativeLDAPWDomain";
    public final static String NATIVE_LDAPU  = "NativeLDAPUDomain";
    public final static String NATIVE_LDAPUW = "NativeLDAPUDomain4Win";
    public final static String NATIVE_NISW   = "NativeNISDomain4Win";
    public final static String NATIVE_PWDW   = "NativePWDDomain4Win";

    protected String network;
    
    public NativeDomain(){
	network = new String();
    }

    public void setNetwork(String network){
	this.network = network;
    }

    public String getNetwork(){
	return network;
    }
}
