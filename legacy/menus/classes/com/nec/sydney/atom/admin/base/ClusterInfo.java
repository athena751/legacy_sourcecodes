/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base;

import com.nec.sydney.atom.admin.base.*;
import java.util.*;

public class ClusterInfo implements NasConstants
{

	private static final String     cvsid = "@(#) $Id: ClusterInfo.java,v 1.2300 2003/11/24 00:54:39 nsadmin Exp $";


    private ClusterNode myNode;
    private String FIP;
    private String FMask;
    private Vector otherNodes;
    private boolean status;

    public ClusterInfo()
    {
        otherNodes = new Vector();
        myNode = new ClusterNode();
        status = true;
    }

    public String getMyNo()
    {
        return myNode.getNo();
    }
    public String getMyIP()
    {
        return myNode.getIP();
    }
    public String getMyName()
    {
        return myNode.getName();
    }
    public String getMyMask()
    {
        return myNode.getMask();
    }
    public String getFIP()
    {
        return FIP;
    }
    public String getFMask()
    {
        return FMask;
    }
    public Vector getOtherNodes()
    {
        return otherNodes;
    }

    public void setMyNo(String no)
    {
        myNode.setNo(no);
    }

    public void setMyName(String name)
    {
        myNode.setName(name);
    }
    public void setMyIP(String ip)
    {
        myNode.setIP(ip);
    }
    public void setMyMask(String mask)
    {
        myNode.setMask(mask);
    }
    public void setOtherNodes(Vector nodes)
    {
        otherNodes = nodes;
    }
    public void addANode (ClusterNode node)
    {
        otherNodes.add(node);
    }
    public void setFIP(String ip)
    {
        FIP = ip;
    }
    public void setFMask(String mask)
    {
        FMask = mask;
    }

    public boolean isCluster()
    {
        return status;
    }
    public void setIsCluster(boolean is)
    {
        status = is;
    }
}