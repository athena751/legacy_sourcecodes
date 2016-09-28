/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class NativeLDAPUDomain4Win extends NativeLDAPDomain{
    private static final String	cvsid = "@(#) NativeLDAPUDomain4Win.java,v 1.1 2003/08/27 06:36:39 k-nishi Exp";
    public NativeLDAPUDomain4Win(){
	setType(TYPE_LDAPUW);
    }
    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;

	NativeLDAPDomain ldap = (NativeLDAPUDomain4Win)obj;
	if(ntdomain!=null
	   && !ntdomain.equals("")
           && ntdomain.equals(ldap.getNTDomain()))
            return true;
	
	return false;
    }
}
