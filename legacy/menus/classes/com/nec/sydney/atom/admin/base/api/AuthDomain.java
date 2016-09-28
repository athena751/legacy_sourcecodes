/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

public abstract class AuthDomain extends Domain{
    public static final String	cvsid = "@(#) AuthDomain.java,v 1.6 2003/08/27 06:21:18 k-nishi Exp";
    
    public final static String AUTH_NIS    = "AuthNISDomain";
    public final static String AUTH_PWD    = "AuthPWDDomain";
    public final static String AUTH_SHR    = "AuthSHRDomain";
    public final static String AUTH_DMC    = "AuthDMCDomain";
    public final static String AUTH_ADS    = "AuthADSDomain";
    public final static String AUTH_LDAP   = "AuthLDAPDomain";
    public final static String AUTH_LDAPW  = "AuthLDAPWDomain";
    public final static String AUTH_LDAPU  = "AuthLDAPUDomain";
    public final static String AUTH_LDAPUW = "AuthLDAPUDomain4Win";
    public final static String AUTH_NISW   = "AuthNISDomain4Win";
    public final static String AUTH_PWDW   = "AuthPWDDomain4Win";

}
