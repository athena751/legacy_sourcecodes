/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base;



import java.util.*;

import com.nec.sydney.atom.admin.base.*;

import com.nec.sydney.net.soap.*;

public class SoapRpsInteger extends SoapResponse implements NasConstants 

{


    private static final String     cvsid = "@(#) $Id: SoapRpsInteger.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";


    private Integer intType;

    public SoapRpsInteger()
    {
        intType    = new Integer(0);
    }
    public int getInt()
    {
        return intType.intValue();
    }
    public void setInt(int i_actualObj)
    {
        intType    = new Integer(i_actualObj);
    }
}
