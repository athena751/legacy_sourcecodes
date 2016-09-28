/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class NativeLDAPWDomain extends NativeLDAPDomain{
    private static final String	cvsid = "@(#) NativeLDAPWDomain.java,v 1.1 2003/08/27 06:37:21 k-nishi Exp";
    
    public NativeLDAPWDomain(){
	setType(TYPE_LDAPW);
    }
    
    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;

	NativeLDAPDomain ldap = (NativeLDAPWDomain)obj;
	if(ntdomain!=null
           && !ntdomain.equals("")
           && ntdomain.equals(ldap.getNTDomain()))
            return true;

        return false;
    }
}
