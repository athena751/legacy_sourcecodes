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

public class SoapRpsVector extends SoapResponse implements NasConstants 

{


    private static final String     cvsid = "@(#) $Id: SoapRpsVector.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";

    private Vector vector;

    public SoapRpsVector()
    {
        vector=new Vector();
    }
    public Vector getVector()
    {
        return vector;
    }
    public void setVector(Vector i_actualObj)
    {
        vector=i_actualObj;
    }
}
