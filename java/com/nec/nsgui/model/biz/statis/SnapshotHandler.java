/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.statis;

import java.util.ArrayList;
import java.util.HashMap;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.biz.system.NasManager;
import com.nec.nsgui.model.entity.statis.DeviceInfoBean;

/**
 *
 */
public class SnapshotHandler {
    private static final String cvsid =
        "@(#) $Id: SnapshotHandler.java,v 1.2 2005/10/20 14:26:49 zhangj Exp $";
    public static final String SCRIPT_STATIS_GETFILESYSTEMINFO =
        "/bin/statis_getFilesystemInfo.pl",
        PERL_ARGUMENT_DISK = "-d",
        PERL_ARGUMENT_INODE = "-i";

    public static HashMap getDeviceList(String watchItemID, String sTargetID)
        throws Exception {
        String[] cmds = {
        };
        if (watchItemID.equalsIgnoreCase(WatchItemDef.Disk_Used_Rate)) {
            String[] cmds1 =
                {
                    System.getProperty("user.home")
                        + SCRIPT_STATIS_GETFILESYSTEMINFO,
                    PERL_ARGUMENT_DISK,
                    };
            cmds = cmds1;
        } else if (
            watchItemID.equalsIgnoreCase(WatchItemDef.Inode_Used_Rate)) {
            String[] cmds2 =
                {
                    System.getProperty("user.home")
                        + SCRIPT_STATIS_GETFILESYSTEMINFO,
                    PERL_ARGUMENT_INODE,
                    };
            cmds = cmds2;
        }
        return getDeviceInformation(cmds, watchItemID, sTargetID);
    }

    public static HashMap getOneDevice(
        String watchItemID,
        String sTargetID,
        String sDeviceID)
        throws Exception {
        String[] cmds = {
        };
        if (watchItemID.equalsIgnoreCase(WatchItemDef.Disk_Used_Rate)) {
            String[] cmds1 =
                {
                    System.getProperty("user.home")
                        + SCRIPT_STATIS_GETFILESYSTEMINFO,
                    PERL_ARGUMENT_DISK,
                    sDeviceID };
            cmds = cmds1;
        } else if (
            watchItemID.equalsIgnoreCase(WatchItemDef.Inode_Used_Rate)) {
            String[] cmds2 =
                {
                    System.getProperty("user.home")
                        + SCRIPT_STATIS_GETFILESYSTEMINFO,
                    PERL_ARGUMENT_INODE,
                    sDeviceID };
            cmds = cmds2;
        }
        return getDeviceInformation(cmds, watchItemID, sTargetID);
    }
    private static HashMap getDeviceInformation(
        String cmds[],
        String watchItemID,
        String targetId)
        throws Exception {
        HashMap result = new HashMap();
        NSCmdResult cmdResult = new NSCmdResult();
        int nodeNo =
            NasManager.getInstance().getServerById(targetId).getMyNode();
        try {
            cmdResult = CmdExecBase.execCmdForce(cmds, nodeNo, true);
        } catch (NSException e) {
            if (e.getErrorCode().equals("0x10000006")) {
                result.put("exitValue", "2");
                return result;
            } else {
                throw e;
            }
        }

        int exitValue = cmdResult.getExitValue();
        result.put("exitValue", (new Integer(exitValue)).toString());

        String[] tempArray = cmdResult.getStdout();
        String[] dataArray = tempArray[0].split(" ");
        ArrayList tmpList = new ArrayList();

        for (int i = 1; i < dataArray.length; i = i + 6) {
            DeviceInfoBean di = new DeviceInfoBean();
            di.setSMountPoint(NSModelUtil.hStr2Str(dataArray[i]).trim());
            di.setTotal(Double.parseDouble(dataArray[i + 1]));
            di.setUsed(Double.parseDouble(dataArray[i + 2]));
            di.setSType(dataArray[i + 3]);
            di.setSDevice(dataArray[i + 4]);
            di.setUsedRate(getRoundValue(Double.parseDouble(dataArray[i + 5])));
            if (watchItemID.equalsIgnoreCase(WatchItemDef.Disk_Used_Rate)) {
                di.setTotal(getRoundValue(di.getTotal()));
                di.setUsed(getRoundValue(di.getUsed()));
            }
            di.setAvailable(di.getTotal() - di.getUsed());
            if (watchItemID.equalsIgnoreCase(WatchItemDef.Disk_Used_Rate)) {
                di.setAvailable(getRoundValue(di.getAvailable()));
            }
            tmpList.add(di);
        }
        result.put("deviceList", tmpList);
        return result;
    }

    private static double getRoundValue(double the_value) {
        return Math.round(the_value * 10) / 10.0;
    }
}