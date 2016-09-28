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

public class SoapRpsBoolean extends SoapResponse implements NasConstants 

{


    private static final String     cvsid = "@(#) $Id: SoapRpsBoolean.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";


    private boolean flag;

    public SoapRpsBoolean()
    {
        flag=false;
    }
    public boolean getBoolean()
    {
        return flag;
    }
    public void setBoolean(boolean i_actualObj)
    {
        flag = i_actualObj;
    }
}
