/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class NativePWDDomain4Win extends NativePWDDomain{
    private static final String	cvsid = "@(#) NativePWDDomain4Win.java,v 1.1 2003/08/27 06:39:26 k-nishi Exp";    
    
    public NativePWDDomain4Win(){
	setType(TYPE_PWDW);
    }

    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;

	NativePWDDomain4Win pwd = (NativePWDDomain4Win)obj;
	if(ntdomain!=null
	   && !ntdomain.equals("")
           && ntdomain.equals(pwd.getNTDomain()))
            return true;
	
	return false;
    }
}
