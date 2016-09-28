/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

public interface ILDAPDomain{
    public static final String	cvsid = "@(#) $Id: ILDAPDomain.java,v 1.2301 2004/08/24 14:22:22 liq Exp $";
    public static final String TYPE_SIMPLE = "SIMPLE";
    public static final String TYPE_MD5 = "DIGEST-MD5";
    public static final String TYPE_ANON = "Anonymous";
    public static final String TYPE_CRAM = "CRAM-MD5";
    public static final String TLS_YES = "yes";
    public static final String TLS_NO  = "no";
    public static final String CATYPE_NOSPECIFY = "no";
    public static final String CATYPE_FILE = "file";
    public static final String CATYPE_DIR = "dir";

    public void setServerName(String name);
    public void setDistinguishedName(String name);
    public void setAuthenticateType(String type);
    public void setTLS(String tls);
    public void setAuthenticateID(String id);
    public void setAuthenticatePasswd(String passwd);
    public void setCA(String ca);
    public void setCAType(String type);
    public String getServerName();
    public String getDistinguishedName();
    public String getAuthenticateType();
    public String getTLS();
    public String getAuthenticateID();
    public String getAuthenticatePasswd();
    public String getCA();
    public String getCAType();
}
