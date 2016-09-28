/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.ndmpv4;

public class NdmpInfoBean {
    private static final String cvsid =
        "@(#) $Id: NdmpInfoBean.java,v 1.4 2006/12/26 03:07:34 wanghui Exp $";
    
    private String defaultVersion = "4";
    private String[] ctrlConnectionIP;
    private String[] dataConnectionIP;    
    private String authorizedDMAIP= "";    
    private String password_ = "";
    private String hasSetPassword = "no";
    private String changePassword = "yes";
    private String dataConnectionIPV2 = "";
    private String backupSoftware = "";
    private String objectVersion = "";
    
       
    public String getAuthorizedDMAIP() {
        return authorizedDMAIP;
    }
    public void setAuthorizedDMAIP(String authorizedDMAIP) {
        this.authorizedDMAIP = authorizedDMAIP;
    }
    public String getChangePassword() {
        return changePassword;
    }
    public void setChangePassword(String changePassword) {
        this.changePassword = changePassword;
    }
    public String[] getCtrlConnectionIP() {
        return ctrlConnectionIP;
    }
    public void setCtrlConnectionIP(String[] ctrlConnectionIP) {
        this.ctrlConnectionIP = retrieveArray(ctrlConnectionIP, ",");
    }
    public String[] getDataConnectionIP() {
        return dataConnectionIP;
    }
    public void setDataConnectionIP(String[] dataConnectionIP) {
        this.dataConnectionIP = retrieveArray(dataConnectionIP, ",");
    }
    public String getDefaultVersion() {
        return defaultVersion;
    }
    public void setDefaultVersion(String defaultVersion) {
        this.defaultVersion = defaultVersion;
        setObjectVersion(defaultVersion);
    }
   
    public String getHasSetPassword() {
        return hasSetPassword;
    }
    public void setHasSetPassword(String hasSetPassword) {
        this.hasSetPassword = hasSetPassword;
    }
    
    public String getPassword_() {
        return password_;
    }
    public void setPassword_(String password_) {
        this.password_ = password_;
    }
   
    private String[] retrieveArray(String[] strings, String spliter){
        if (strings != null && strings.length == 1) {
            if (strings[0].equals("")) {
                return null;
            } else {
                return strings[0].split(spliter);
            }
        }
        return strings;
    }
    
    public String getDataConnectionIPV2() {
        return dataConnectionIPV2;
    }
    public void setDataConnectionIPV2(String dataConnectionIPV2) {
        this.dataConnectionIPV2 = dataConnectionIPV2;
    }
    
    public String getBackupSoftware() {
        return backupSoftware;
    }
    public void setBackupSoftware(String backupSoftware) {
        this.backupSoftware = backupSoftware;
    }
    public String getObjectVersion() {
        return objectVersion;
    }
    public void setObjectVersion(String objectVersion) {
        this.objectVersion = objectVersion;
    }
}
