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

public class ClusterNode implements NasConstants
{

    private static final String     cvsid = "@(#) $Id: ClusterNode.java,v 1.2300 2003/11/24 00:54:39 nsadmin Exp $";

    private String nodeNo;
    private String nodeName;
    private String nodeIP;
    private String nodeMask;

    public ClusterNode()
    {
        nodeNo = null;
        nodeName = null;
        nodeIP = null;
        nodeMask = null;
    }

    public String getNo()
    {
        return nodeNo;
    }
    public String getName()
    {
        return nodeName;
    }
    public String getIP()
    {
        return nodeIP;
    }
    public String getMask()
    {
        return nodeMask;
    }

    public void setNo(String no)
    {
        nodeNo = no;
    }
    public void setIP(String ip)
    {
        nodeIP = ip;
    }
    public void setName(String name)
    {
        nodeName = name;
    }
    public void setMask(String mask)
    {
        nodeMask = mask;
    }
}
