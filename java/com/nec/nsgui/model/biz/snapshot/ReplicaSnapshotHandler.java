/*
 *      Copyright (c) 2008-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.snapshot;

import java.util.ArrayList;
import java.util.List;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.entity.snapshot.SnapshotInfoBean;
import com.nec.nsgui.model.entity.snapshot.SnapshotAreaBean;


/**
 * 
 */
public class ReplicaSnapshotHandler {
    private static final String cvsid = "@(#) $Id: ReplicaSnapshotHandler.java,v 1.2 2009/01/13 11:26:56 xingyh Exp $";

    // constant for command
    private static final String SNAPSHOT_GETSNAP_PL = 
        "/opt/nec/nsadmin/bin/snap_getSnap.pl";

    private static final String SNAPSHOT_DELSNAP_PL = 
        "/opt/nec/nsadmin/bin/snap_deleteReplicaSnapshot.pl";
    
    private static final String SNAPSHOT_GETAREA_PL = 
        "/opt/nec/nsadmin/bin/snap_getArea.pl";    

    /**
     * getSnapshotInfoList
     * 
     * @param mountPoint
     * @param nodeNo
     * @return
     * @throws Exception
     */
    public static List getSnapshotInfoList(
        String mountPoint,
        int nodeNo) throws Exception {
        ArrayList<SnapshotInfoBean> snapInfoList = new ArrayList<SnapshotInfoBean>();
        
        // execute cmd
        String[] cmds = {
                CmdExecBase.CMD_SUDO, 
                SNAPSHOT_GETSNAP_PL, 
                mountPoint};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        String[] stdout = cmdResult.getStdout();
        
        // set bean property then add to list
        for (String lineTmp:stdout) {
            if (lineTmp == null) {
                continue;
            }
            lineTmp = lineTmp.trim();
            if ("".equals(lineTmp)) {
                continue;
            }
            String[] valueArrs = lineTmp.split("\\s+");
            if (valueArrs.length != 4) {
                continue;
            }
            SnapshotInfoBean snapBean = new SnapshotInfoBean();
            snapBean.setName(valueArrs[0]);
            snapBean.setCreateTime(valueArrs[1] + " " + valueArrs[2]);
            snapBean.setStatus(valueArrs[3]);
            snapInfoList.add(snapBean);
        }
        
        return snapInfoList;
    }
    
    public static void deleteSnapshot(
        String mountPoint,
        String delSnapshotNames,
        int nodeNo) throws Exception {

        String[] cmds = {
                CmdExecBase.CMD_SUDO, 
                SNAPSHOT_DELSNAP_PL, 
                mountPoint,
                delSnapshotNames};
        CmdExecBase.execCmd(cmds, nodeNo);

    }

    public static List getSnapshotArea(String mountPoint, int nodeNo) throws Exception {

            String[] cmds = {
                    CmdExecBase.CMD_SUDO, 
                    SNAPSHOT_GETAREA_PL, 
                    mountPoint};
            NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
            String[] stdout = cmdResult.getStdout();
            // set bean property then add to list
            return NSBeanUtil.createBeanList("com.nec.nsgui.model.entity.snapshot.SnapshotAreaBean", stdout);
   }    
}
