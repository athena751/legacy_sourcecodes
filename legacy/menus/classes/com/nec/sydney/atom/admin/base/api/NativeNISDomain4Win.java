/*
 *      Copyright (c) 2003 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

public class NativeNISDomain4Win extends NativeNISDomain{
    private static final String	cvsid = "@(#) NativeNISDomain4Win.java,v 1.1 2003/08/27 06:27:56 k-nishi Exp";    
    
    public NativeNISDomain4Win(){
	setType(TYPE_NISW);
    }

    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;

	NativeNISDomain4Win nis = (NativeNISDomain4Win)obj;
	if(ntdomain!=null
	   && !ntdomain.equals("")
           && ntdomain.equals(nis.getNTDomain()))
            return true;
	
	return false;
    }
}
