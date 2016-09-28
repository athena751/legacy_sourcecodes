/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.base;

public class ClusterUtil {
    private static final String cvsid =
        "@(#) $Id: ClusterUtil.java,v 1.6 2007/04/26 05:09:00 fengmh Exp $";

    private int myNodeNo = -1;
    private String node0IP = null;
    private String node1IP = null;
    private String FIP = null;
    private boolean isCluster = false;
    private static ClusterUtil _instance = null;

    private static boolean isRegisterd = false;

    private static String SCRIPT_GET_CLUSTER_INFO =
        "/home/nsadmin/bin/cluster_getClusterInfo.pl";
    private static String SCRIPT_SYNC_FILE =
        "/home/nsadmin/bin/cluster_syncfile.pl";
    private static String SCRIPT_GET_MY_STATUS =
        "/home/nsadmin/bin/cluster_getMyStatus.pl";

    private ClusterUtil() throws Exception {
        getClusterInfo();
    }
    private void getClusterInfo() throws Exception {
        String[] cmds = { CmdExecBase.CMD_SUDO, SCRIPT_GET_CLUSTER_INFO };
        NSCmdResult ret = CmdExecBase.localExecCmd(cmds, null);
        if (ret.getExitValue() != 0) { // not registered cluster node!
            myNodeNo = -1;
            isRegisterd = false;
            return;
        }
        isRegisterd = true; // registered or single node!
        String[] output = ret.getStdout();
        if (output == null || output.length == 0) {
            myNodeNo = -1; //has not output, is single Node!
            isCluster = false;
            return;
        }
        isCluster = true; // has output , is cluster!
        for (int i = 0; i < output.length; i++) {
            if (output[i] != null && !output[i].trim().equals("")) {
                String[] tmp = output[i].trim().split("=");
                if (tmp.length > 1) {
                    if (tmp[0].trim().toUpperCase().equals("MYNODE")) {
                        myNodeNo = Integer.parseInt(tmp[1].trim());
                    } else if (tmp[0].trim().toUpperCase().equals("FIPADDR")) {
                        FIP = tmp[1].trim();
                    } else if (tmp[0].trim().toUpperCase().equals("IPADDR1")) {
                        node1IP = tmp[1].trim();
                    } else if (tmp[0].trim().toUpperCase().equals("IPADDR0")) {
                        node0IP = tmp[1].trim();
                    }
                }
            }
        }
    }
    static public ClusterUtil getInstance() throws Exception {
        if (_instance == null) {
            _instance = new ClusterUtil();
        }
        if (_instance != null && !isRegisterd){
            _instance.getClusterInfo();
        }
        return _instance;
    }
    public String getMyFriendIP() {
        if (!isCluster) {
            return null;
        }
        return (myNodeNo == 0) ? node1IP : node0IP;
    }

    public String getNode0IP() {
        if (!isCluster) {
            return null;
        }
        return node0IP;
    }
    public String getNode1IP() {
        if (!isCluster) {
            return null;
        }
        return node1IP;
    }

    public String getMyNodeIP() {
        if (!isCluster) {
            return null;
        }
        return (myNodeNo == 0) ? node0IP : node1IP;
    }
    public String getFIP() {
        return isCluster ? FIP : null;
    }
    public int getMyNodeNo() {
        return myNodeNo;
    }
    public boolean isCluster() {
        return isCluster;
    }
    public void remoteSync(String[] files) throws Exception {
        remoteSync(files, myNodeNo);
    }
    public void remoteSync(String[] files, int destNodeNo) throws Exception {
        if (!isCluster) {
            return;
        }
        String[] cmds;
        for (int i = 0; i < files.length; i++) {
            if (destNodeNo == myNodeNo) {
                cmds =
                    new String[] {
                        CmdExecBase.CMD_SUDO,
                        SCRIPT_SYNC_FILE,
                        files[i],
                        "toMyNode" };
                CmdExecBase.execCmd(cmds);
            } else {
                cmds =
                    new String[] {
                        CmdExecBase.CMD_SUDO,
                        SCRIPT_SYNC_FILE,
                        files[i],
                        "fromMyNode" };
                CmdExecBase.execCmd(cmds);
            }
        }
    }
    public static void main(String[] args) {
    }
    
    public static String getMyStatus ()throws Exception{
        String cmds[] = {CmdExecBase.CMD_SUDO, SCRIPT_GET_MY_STATUS};
        NSCmdResult ret = CmdExecBase.localExecCmd(cmds, null,true);
        return ret.getStdout()[0];
    }
}
