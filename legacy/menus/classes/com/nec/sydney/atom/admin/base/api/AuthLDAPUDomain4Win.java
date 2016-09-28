/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class AuthLDAPUDomain4Win extends AuthLDAPDomain{
    private static final String	cvsid = "@(#) AuthLDAPUDomain4Win.java,v 1.1 2003/08/27 06:32:05 k-nishi Exp";    
    public AuthLDAPUDomain4Win(){
	setType(TYPE_LDAPUW);
    }
}
