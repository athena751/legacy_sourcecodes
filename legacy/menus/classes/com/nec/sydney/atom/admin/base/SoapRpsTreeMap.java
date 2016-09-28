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

public class SoapRpsTreeMap extends SoapResponse 
{

    private static final String     cvsid = "@(#) $Id: SoapRpsTreeMap.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";


    private TreeMap treeMap;
    public SoapRpsTreeMap()
    {
        treeMap=new TreeMap();
    }
    public TreeMap getTreeMap()
    {
        return treeMap;
    }
    public void setTreeMap(TreeMap map)
    {
        treeMap=map;
    }
}
