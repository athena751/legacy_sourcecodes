/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.statis;

import java.util.HashSet;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;

/**
 *  
 */
public class RRDGraphHandler {

    private static final String cvsid =
        "@(#) $Id: RRDGraphHandler.java,v 1.7 2007/03/07 05:33:49 zhangjun Exp $";
    private static String SCRIPT_CLUSTER_CHECK_NODE_STATUS =
        "/bin/cluster_checkStatus.pl";

    private static final String SCRIPT_GET_GROUP_NUMBER =
        "/bin/statis_getGroupNo.pl";

    private static final String SCRIPT_GET_LVM_LIST =
        "/bin/statis_getLvmList.pl";
    
    private static final String SCRIPT_GETRRD_MAXDATA =
        "/bin/statis_getRRD_maxdata.pl";

    private static final String SCRIPT_GETONERRD_MAXDATA =
        "/bin/statis_getOneRRD_maxdata.pl";

    private static final String SCRIPT_GET_FIP_NODE_NUMBER =
        "/bin/statis_getFIPNodeNumber.sh";
    
    private static final String SCRIPT_CHECK_CLUSTER_STATUS =
        "/bin/cluster_checkStatus.pl";

    public static final String SCIRPT_GET_CIFS_COMPUTER_INFO =
        "/bin/statis_getCifsComputerInfo.pl";
    
    public static int getGroupNoByTargetID(String targetID) throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_GROUP_NUMBER,
                targetID };
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, true);
        if (result.getStdout().length == 0) {
            return 0;
        }
        return Integer.parseInt(result.getStdout()[0]);
    }

    public static HashSet getLvmSetByGroupNo(int groupNo) throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_LVM_LIST,
                Integer.toString(groupNo)};
        NSCmdResult result =
            CmdExecBase.execCmdInServiceNode(cmds, null, groupNo, true);
        HashSet lvmSet = new HashSet();
        String[] stdout = result.getStdout();
        int length = stdout.length;
        for (int i = 0; i < length; i++) {
            lvmSet.add(stdout[i]);
        }
        return lvmSet;
    }

    public static String getMaxByTarget(
        String targetID,
        String startTime,
        String endTime,
        int sampleInterval,
        String collectionID,
        String watchItemID,
        String isInvestGraph,
        String isFilter
        )
        throws Exception {

        String[] cmds =
            {
                System.getProperty("user.home") + SCRIPT_GETRRD_MAXDATA,
                targetID,
                collectionID,
                watchItemID,
                startTime,
                endTime,
                Integer.toString(sampleInterval),
                isInvestGraph,
                isFilter};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null);
        if (result.getExitValue() != 0 || result.getStdout().length == 0) {
            return "0";
        }
        return result.getStdout()[0];
    }
    public static String getMaxByTarget(
        String targetID,
        String startTime,
        String endTime,
        int sampleInterval,
        String collectionID,
        String watchItemID,
        String isInvestGraph,
        String isFilter,
        String computerName)
        throws Exception {

        String[] cmds =
            {
                System.getProperty("user.home") + SCRIPT_GETRRD_MAXDATA,
                targetID,
                collectionID,
                watchItemID,
                startTime,
                endTime,
                Integer.toString(sampleInterval),
                isInvestGraph,
                isFilter,
                computerName};
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null);
        if (result.getExitValue() != 0 || result.getStdout().length == 0) {
            return "0";
        }
        return result.getStdout()[0];
    }
    public static String getOneRRDMaxByTarget(
        String targetID,
        String startTime,
        String endTime,
        int sampleInterval,
        String collectionID,
        String watchItemID,
        String isInvestGraph,
        String subItemId)
        throws Exception {

        String[] cmds =
            {
                System.getProperty("user.home") + SCRIPT_GETONERRD_MAXDATA,
                targetID,
                collectionID,
                watchItemID,
                startTime,
                endTime,
                Integer.toString(sampleInterval),
                isInvestGraph,
                subItemId };
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null);
        if (result.getExitValue() != 0 || result.getStdout().length == 0) {
            return "0";
        }
        return result.getStdout()[0];
    }
    public static String getAdminNodeNum() throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_FIP_NODE_NUMBER };
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, true);
        return result.getStdout()[0];
    }
    public static String checkStatus() throws Exception{
        String[] checkCmds = { CmdExecBase.CMD_SUDO, System.getProperty("user.home")+SCRIPT_CHECK_CLUSTER_STATUS };
        NSCmdResult result = CmdExecBase.localExecCmd(checkCmds, null);
        int exitValue = result.getExitValue();
        if(exitValue==3){
             return "abnormal";
        }else{
            return "normal";
        }        
    }
    public static String[] getComputerInfo(int group, String exportGroup, boolean doWhenMaintance)
        throws Exception {
        String[] cmds ={ CmdExecBase.CMD_SUDO,
            System.getProperty("user.home") + SCIRPT_GET_CIFS_COMPUTER_INFO,
            Integer.toString(group),
            exportGroup};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group, true, doWhenMaintance);
        return cmdResult.getStdout();
    }
}