/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class NativeLDAPUDomain extends NativeLDAPDomain{
    private static final String	cvsid = "@(#) NativeLDAPUDomain.java,v 1.1 2003/08/27 06:35:51 k-nishi Exp";    
    
    public NativeLDAPUDomain(){
	setType(TYPE_LDAPU);
    }
    
    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;

	NativeLDAPDomain ldap = (NativeLDAPUDomain)obj;
	if(network!=null
	   && !network.equals("")
           && network.equals(ldap.getNetwork()))
            return true;
	
	return false;
    }
}
