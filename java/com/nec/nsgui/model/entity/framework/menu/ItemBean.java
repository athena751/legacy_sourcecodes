/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.framework.menu;

import java.util.Map;
import java.util.LinkedHashMap;

import com.nec.nsgui.model.entity.framework.FrameworkConst;
/**
 *
 */
public class ItemBean extends MenuBaseBean implements FrameworkConst {
    private static final String cvsid =
        "@(#) $Id: ItemBean.java,v 1.6 2007/08/29 02:13:12 liul Exp $";

    private Map hiddenMap = new LinkedHashMap();
    private String href = "";
    private String helpAnchor = "";
    private String licenseKey = "";
    private String hasLicense = "true";
    private String changeNode = BUTTON_ENABLE;
    private String selectExpgrp = BUTTON_DISABLE;
    private String targetType = TARGET_TYPE_NODE;
    private String userType = "";
    private String refHref = "";
    private String rpqKey="";
    private String machineSeries="";

    public ItemBean() {

    }
    public ItemBean(
        String msgKey,
        String detailMsgKey,
        String level,
        String machineType,
        String href,
        String helpAnchor,
        String licenseKey,
        String hasLicense,
        String changeNode,
        String selectExpgrp,
        String targetType,
        String userType,
        String refHref,
        String rpqKey,
        String machineSeries,
        Map hiddenMap) {
        super(msgKey, detailMsgKey, level, machineType);
        this.href = href;
        this.helpAnchor = helpAnchor;
        this.licenseKey = licenseKey;
        this.hasLicense = hasLicense;
        this.changeNode = changeNode;
        this.selectExpgrp = selectExpgrp;
        this.targetType = targetType;
        this.userType = userType;
        this.refHref = refHref;
        this.rpqKey = rpqKey;
        this.machineSeries = machineSeries;
        this.hiddenMap.putAll(hiddenMap);
    }

    public void addHiddenMap(String key, String value) {
        hiddenMap.put(key, value);
    }
    /**
     * @return
     */
    public String getChangeNode() {
        return changeNode;
    }

    /**
     * @return
     */
    public String getHelpAnchor() {
        return helpAnchor;
    }

    /**
     * @return
     */
    public String getHref() {
        return href;
    }

    /**
     * @return
     */
    public Map getHiddenMap() {
        return hiddenMap;
    }

    /**
     * @return
     */
    public String getLicenseKey() {
        return licenseKey;
    }

    /**
     * @return
     */
    public String getSelectExpgrp() {
        return selectExpgrp;
    }

    /**
     * @param string
     */
    public void setChangeNode(String string) {
        changeNode = string;
    }

    /**
     * @param string
     */
    public void setHelpAnchor(String string) {
        helpAnchor = string;
    }

    /**
     * @param string
     */
    public void setHref(String string) {
        href = string;
    }

    /**
     * @param map
     */
    public void setHiddenMap(Map map) {
        hiddenMap = map;
    }

    /**
     * @param string
     */
    public void setLicenseKey(String string) {
        licenseKey = string;
    }

    /**
     * @param string
     */
    public void setSelectExpgrp(String string) {
        selectExpgrp = string;
    }
    /**
     * 
     */
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (!super.equals(obj)) {
            return false;
        }
        ItemBean item = (ItemBean) obj;
        if (!(item.href.equals(href))
            || !(item.helpAnchor.equals(helpAnchor))
            || !(item.licenseKey.equals(licenseKey))
            || !(item.hasLicense.equals(hasLicense))
            || !(item.hiddenMap.equals(hiddenMap))
            || !(item.changeNode.equals(changeNode))
            || !(item.selectExpgrp.equals(selectExpgrp))
            || !(item.targetType.equals(targetType))
            || !(item.rpqKey.equals(rpqKey))
            || !(item.machineSeries.equals(machineSeries))) {
            return false;
        }
        return true;
    }
    /**
     * @return
     */
    public String getTargetType() {
        return targetType;
    }

    /**
     * @param string
     */
    public void setTargetType(String string) {
        targetType = string;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#clone()
     */
    public ItemBean getMyClone() {
        return new ItemBean(
            super.getMsgKey(),
            super.getDetailMsgKey(),
            super.getLevel(),
            super.getMachineType(),
            href,
            helpAnchor,
            licenseKey,
            hasLicense,
            changeNode,
            selectExpgrp,
            targetType,
            userType,
            refHref,
            rpqKey,
            machineSeries,
            hiddenMap);
    }

    public String getHasLicense() {
        return hasLicense;
    }
    
    public void setHasLicense(String hasLicense) {
        this.hasLicense = hasLicense;
    }
    public String getRefHref() {
        return refHref;
    }
    
    public void setRefHref(String refHref) {
        this.refHref = refHref;
    }
    
    public String getUserType() {
        return userType;
    }
    
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    /**
     * @return
     */
    public String getRpqKey() {
        return rpqKey;
    }

    /**
     * @param string
     */
    public void setRpqKey(String string) {
        rpqKey = string;
    }
    
    public String getMachineSeries() {
        return machineSeries;
    }

    public void setMachineSeries(String string) {
        this.machineSeries = string;
    }
    
}
