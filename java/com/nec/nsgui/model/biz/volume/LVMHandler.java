/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.volume;

import java.util.Vector;
import java.util.*;

import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.entity.volume.LVMInfoBean;

/**
 * @author yttx
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class LVMHandler {
    public static final String cvsid =
        "@(#) $Id: LVMHandler.java,v 1.2 2005/11/18 00:54:21 liuyq Exp $";

    public static String LVM_CREATE_PL = "/home/nsadmin/bin/lvm_createLV.pl";
    public static String LVM_DELETE_PL = "/home/nsadmin/bin/lvm_deleteLV.pl";
    public static String LVM_EXTEND_PL = "/home/nsadmin/bin/lvm_extendLV.pl";
    public static String LVM_MANAGE_PL = "/home/nsadmin/bin/lvm_manageLV.pl";
    public static String LVM_MOVE_PL = "/home/nsadmin/bin/lvm_moveLV.pl";
    public static String LVM_LIST_PL = "/home/nsadmin/bin/lvm_list.pl";

    public static Vector getLVList(boolean refer) throws Exception {
        String[] cmds = { "sudo", LVM_LIST_PL, refer ? "1" : "0" };
        NSCmdResult result = CmdExecBase.execCmd(cmds, 0);

        String seperateLine =
            "----------------------------------------------------";
        Vector v = new Vector();
        v.addAll(java.util.Arrays.asList(result.getStdout()));
        v.remove(v.size() - 1);

        int index1 = v.indexOf(seperateLine);
        int index2 = v.lastIndexOf(seperateLine);
        List list1 = v.subList(0, index1);
        List list2 = v.subList(index1 + 1, index2);
        List list3 = v.subList(index2 + 1, v.size());

        Vector retnVec = new Vector();
        String[] tmpAry = {};

        retnVec.add(
            NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.volume.LVMInfoBean",
                (String[]) (list1.toArray(tmpAry))));
        retnVec.add(
            NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.volume.LVMInfoBean",
                (String[]) (list2.toArray(tmpAry))));
        retnVec.add(
            NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.volume.LVMInfoBean",
                (String[]) (list3.toArray(tmpAry))));
        return retnVec;
    }

    public static void createLV(LVMInfoBean lvmInfo, int nodeNo)
        throws Exception {
        String[] cmds =
            {
                "sudo",
                LVM_CREATE_PL,
                lvmInfo.getLvName(),
                lvmInfo.getLdList(),
                lvmInfo.getStriping()};
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    public static void extendLV(String lvName, String ldList, String isStriped, int nodeNo)
        throws Exception {
        String cmd = LVM_EXTEND_PL;
        String[] cmds = { "sudo", cmd, lvName, ldList, isStriped};
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    public static void deleteLV(String lvName, int nodeNo) throws Exception {
        String[] cmds = { "sudo", LVM_DELETE_PL, lvName };
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    public static void manageLV(String lvName, int nodeNo) throws Exception {
        String[] cmds = { "sudo", LVM_MANAGE_PL, lvName };
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    public static void moveLV(String lvName, int nodeNo) throws Exception {
        String[] cmds = { "sudo", LVM_MOVE_PL, lvName };
        CmdExecBase.execCmd(cmds, nodeNo);
    }
}
