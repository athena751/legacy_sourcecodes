/*
 *      Copyright (c) 2002 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

public class NativeSHRDomain extends NativeDomain{
    private static final String	cvsid = "@(#) NativeSHRDomain.java,v 1.3 2003/08/27 06:28:30 k-nishi Exp";    

    public NativeSHRDomain(){
	setType(TYPE_SHR);    
    }

    public boolean compare(Object obj){
	if(!super.compare(obj))
	    return false;

	NativeSHRDomain shr = (NativeSHRDomain)obj;
	if(!ntdomain.equals(shr.getNTDomain()))
	    return false;
	
	return true;
    }
}
