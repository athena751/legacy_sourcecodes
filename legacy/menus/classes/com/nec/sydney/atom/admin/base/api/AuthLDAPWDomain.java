/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class AuthLDAPWDomain extends AuthLDAPDomain{
    private static final String	cvsid = "@(#) AuthLDAPWDomain.java,v 1.1 2003/08/27 06:32:50 k-nishi Exp";    
    public AuthLDAPWDomain(){
	setType(TYPE_LDAPW);
    }
}
