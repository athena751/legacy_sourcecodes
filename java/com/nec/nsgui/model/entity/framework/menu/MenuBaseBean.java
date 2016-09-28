/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.framework.menu;

/**
 *base info class of menu item,gategory,subgategory
 */
public class MenuBaseBean {
    private static final String cvsid =
        "@(#) $Id: MenuBaseBean.java,v 1.2 2004/07/14 14:06:32 het Exp $";

    private String msgKey = "";
    private String detailMsgKey = "";
    private String level = "0";
    private String machineType = "";
    /**
     * 
     */
    public MenuBaseBean() {

    }
    /**
     * 
     */
    public MenuBaseBean(
        String msgKey,
        String detailMsgKey,
        String level,
        String machineType) {
        this.msgKey = msgKey;
        this.detailMsgKey = detailMsgKey;
        this.level = level;
        this.machineType = machineType;
    }
    /**
     * getDetailMesgKey
     * @return detailMesgKey
     */
    public String getDetailMsgKey() {
        return detailMsgKey;
    }

    /**
     * getLevel
     * @return level
     */
    public String getLevel() {
        return level;
    }

    /**
     * getMachineType
     * @return machineType
     */
    public String getMachineType() {
        return machineType;
    }

    /**
     * getMsgKey
     * @return msgKey
     */
    public String getMsgKey() {
        return msgKey;
    }

    /**
     * setDetailMesgKey
     * @param string DetailMesgKey
     */
    public void setDetailMsgKey(String string) {
        detailMsgKey = string;
    }

    /**
     * setLevel
     * @param string Level
     */
    public void setLevel(String string) {
        level = string;
    }

    /**
     * setMachineType
     * @param string machineType
     */
    public void setMachineType(String string) {
        machineType = string;
    }

    /**
     * setMsgKey
     * @param string msgKey
     */
    public void setMsgKey(String string) {
        msgKey = string;
    }
    /**
     * 
     */
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }

        MenuBaseBean nsMenuBase = (MenuBaseBean) obj;
        if (!(nsMenuBase.msgKey.equals(msgKey))
            || !(nsMenuBase.detailMsgKey.equals(detailMsgKey))
            || !(nsMenuBase.level.equals(level))
            || !(nsMenuBase.machineType.equals(machineType))) {
            return false;
        }
        return true;
    }

}
