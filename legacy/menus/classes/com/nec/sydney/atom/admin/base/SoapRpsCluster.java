/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

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

public class SoapRpsCluster extends SoapResponse implements NasConstants 
{


	private static final String     cvsid = "@(#) $Id: SoapRpsCluster.java,v 1.2300 2003/11/24 00:54:40 nsadmin Exp $";


    private ClusterInfo cluster;

    public SoapRpsCluster()
    {
        cluster=new ClusterInfo();
    }
    public ClusterInfo getCluster()
    {
        return cluster;
    }
    public void setCluster(ClusterInfo i_cluster)
    {
        cluster=i_cluster;
    }
}

