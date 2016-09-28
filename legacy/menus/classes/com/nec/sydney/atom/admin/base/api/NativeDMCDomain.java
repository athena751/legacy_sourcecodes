/*
 *      Copyright (c) 2002 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */


package com.nec.sydney.atom.admin.base.api;

public class NativeDMCDomain extends NativeDomain{
private static final String	cvsid = "@(#) NativeDMCDomain.java,v 1.3 2003/08/27 06:25:33 k-nishi Exp";    
    //    private String ntdomain;

    public NativeDMCDomain(){
	setType(TYPE_DMC);    
    }

    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;

	NativeDMCDomain dmc = (NativeDMCDomain)obj;
	if(!ntdomain.equals(dmc.getNTDomain()))
	    return false;

	return true;
    }
}
