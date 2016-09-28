/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.framework;

/**
 *
 */
public class NodeInfoBean {
    private static final String cvsid = "@(#) $Id: NodeInfoBean.java,v 1.1 2004/07/14 01:24:14 het Exp $";
    public String adminTarget = "";
    public String target = "";
    public String nodeId = "";
    public int group = 0;
     
    /**
     * @return
     */
    public String getAdminTarget() {
        return adminTarget;
    }

    /**
     * @return
     */
    public int getGroup() {
        return group;
    }

    /**
     * @return
     */
    public String getNodeId() {
        return nodeId;
    }

    /**
     * @return
     */
    public String getTarget() {
        return target;
    }

    /**
     * @param string
     */
    public void setAdminTarget(String string) {
        adminTarget = string;
    }

    /**
     * @param string
     */
    public void setGroup(int i) {
        group = i;
    }

    /**
     * @param string
     */
    public void setNodeId(String string) {
        nodeId = string;
    }

    /**
     * @param string
     */
    public void setTarget(String string) {
        target = string;
    }

}
