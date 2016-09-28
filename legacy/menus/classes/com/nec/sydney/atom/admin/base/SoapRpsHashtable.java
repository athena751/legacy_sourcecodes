/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base;

import com.nec.sydney.net.soap.*;
import java.util.*;

public class SoapRpsHashtable extends SoapResponse 
{

    private static final String     cvsid = "@(#) $Id: SoapRpsHashtable.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";


    private Hashtable hash;
    public SoapRpsHashtable()
    {
        hash=new Hashtable();
    }
    public Hashtable getHash()
    {
        return hash;
    }
    public void setHash(Hashtable h)
    {
        hash=h;
    }
}
