/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.system.NasManager;
import com.nec.nsgui.model.biz.system.NodeManager;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.framework.NodeInfoBean;
import com.nec.nsgui.model.entity.system.Cluster;
import com.nec.nsgui.model.entity.system.Ipsan;
import com.nec.nsgui.model.entity.system.Nas;

/**
 *
 */
public class ControllerModel implements FrameworkConst {
    private static final String cvsid =
            "@(#) $Id: ControllerModel.java,v 1.8 2008/03/21 12:35:48 chenjc Exp $";
    private static ControllerModel _instance = null;
    public static final String SCRIPT_POST_LOGIN_PL = "/bin/menu_postlogin.pl";
    
    String machineType = "";
    String machineSeries = "";
    NodeInfoBean node0Info = new NodeInfoBean();
    NodeInfoBean node1Info = new NodeInfoBean();
    
    /**
     * get infomation of node and machine type.
     */
    private ControllerModel() throws Exception {
        NodeManager nm = NodeManager.getInstance();
        Collection clusterednases = nm.getClusteredNasMap().values();
        Collection singlenases = nm.getSingleNodeNasMap().values();
        Collection nasipsans = nm.getComplexNasMap().values();
        Iterator singlenasesIt = singlenases.iterator();
        Iterator clusterednasesIt = clusterednases.iterator();
        Iterator nasipsansIt = nasipsans.iterator();
        if (singlenasesIt.hasNext()) {
            Nas nas = (Nas) singlenasesIt.next();
            String nodeId = nas.getId();
            String target = createTargetStr(nodeId,null,TARGET_TYPE_NAS);
            setNodeInfo(nodeId, 0, target, target);
        } else if (clusterednasesIt.hasNext()) {
            Cluster cluster = (Cluster) clusterednasesIt.next();
            String adminId = cluster.getId();
            List nodeIDs = cluster.getNodeId();
            setClusterNodes(nodeIDs, adminId, TARGET_TYPE_NAS);
        } else if (nasipsansIt.hasNext()) {
            Ipsan cluster = (Ipsan) nasipsansIt.next();
            String adminId = cluster.getId();
            List nodeIDs = cluster.getNodeId();
            setClusterNodes(nodeIDs, adminId, TARGET_TYPE_NASIPSAN);
        }
        String[] cmds = {SUDO_COMMAND,System.getProperty("user.home")+SCIRPT_GET_MACHINE_TYPE }; 
        NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds,null);
        machineType = (cmdResult.getStdout())[0];
        
        String[] cmds_series = {SUDO_COMMAND,System.getProperty("user.home")+SCIRPT_GET_MACHINE_SERIES }; 
        NSCmdResult cmdResult_series = CmdExecBase.localExecCmd(cmds_series,null);
        machineSeries = (cmdResult_series.getStdout())[0];
    }

    /**
     * set one node Info
     * @param nodeId
     * @param group
     * @param target
     * @param adminTarget
     */
    private void setNodeInfo(
        String nodeId,
        int group,
        String target,
        String adminTarget) {
        if (group == 0) {
            node0Info.setAdminTarget(adminTarget);
            node0Info.setGroup(group);
            node0Info.setNodeId(nodeId);
            node0Info.setTarget(target);
        } else if (group == 1) {
            node1Info.setAdminTarget(adminTarget);
            node1Info.setGroup(group);
            node1Info.setNodeId(nodeId);
            node1Info.setTarget(target);
        }
    }
    /**
     * create a target.
     * @param nodeId
     * @param adminId
     * @param type
     * @return
     */
    private String createTargetStr(
        String nodeId,
        String adminId,
        String type) {
        //create a cluster target.
        if (nodeId == null) {
            return TARGET_SEPARATOR_CLUSTER
                + adminId
                + TARGET_SEPARATOR_TYPE
                + type;
        //carete a singlenode target
        } else if (adminId == null) {
            return nodeId + TARGET_SEPARATOR_TYPE + type;
        //create a cluster node target
        } else {
            return nodeId
                + TARGET_SEPARATOR_CLUSTER
                + adminId
                + TARGET_SEPARATOR_TYPE
                + type;
        }

    }
    /**
     * set infos for cluster nodes
     * @param nodeIds
     * @param adminId
     * @param type
     * @throws Exception
     */
    private void setClusterNodes(List nodeIds, String adminId, String type)
        throws Exception {
        String adminTarget = createTargetStr(null, adminId, type);
        for (int i = 0; i <= 1; i++) {
            String nodeId = (String) nodeIds.get(i);
            int nodeNo =
                NasManager.getInstance().getServerById(nodeId).getMyNode();
            String nodeTarget = createTargetStr(nodeId, adminId, type);
            setNodeInfo(nodeId, nodeNo, nodeTarget, adminTarget);
        }

    }

    /**
     * get one node info
     * @param nodeNumber
     * @return
     */
    public NodeInfoBean getNodeInfo(int nodeNumber) {
        return (nodeNumber == 0) ? node0Info : node1Info;
    }
    /**
     * 
     * @return
     */
    public String getMachineType() {
        return machineType;
    }
    
    public String getMachineSeries() {
        return machineSeries;
    }
    public static void postLogin() throws Exception {
        String[] cmds_postLogin = {SUDO_COMMAND,System.getProperty("user.home")+SCRIPT_POST_LOGIN_PL }; 
        CmdExecBase.localExecCmd(cmds_postLogin,null);
    }
    /**
     * 
     * @return
     * @throws Exception
     */
    public static ControllerModel getInstance() throws Exception {
        if (_instance == null) {
            _instance = new ControllerModel();
        }
        return _instance;
    }
    


}
