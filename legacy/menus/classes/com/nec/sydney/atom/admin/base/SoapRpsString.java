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

public class SoapRpsString extends SoapResponse implements NasConstants 

{


    private static final String     cvsid = "@(#) $Id: SoapRpsString.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";

    private String string;
    private String[] stringArray;

    public SoapRpsString()
    {
        string=new String();
    }
    public String getString()
    {
        return string;
    }
    public void setString(String i_actualObj)
    {
        string=i_actualObj;
    }
    public String[] getStringArray()
    {
        return stringArray;    
    }
    public void setStringArray(String[] i_actualObj)
    {
        stringArray    = i_actualObj;
    }
}
