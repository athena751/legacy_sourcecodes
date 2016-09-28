/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.cifs;

public class ShareOptionBean {
    private static final String cvsid = "@(#) $Id: ShareOptionBean.java,v 1.10 2008/12/18 08:17:20 chenbc Exp $";
    
    private String shareName = "";
    private String connection = "no";
    private String directory = "";
    private String comment = "";
    private String readOnly = "no";
    private String writeList = "";
    private String settingPassword = "no";
    private String password_ = "";
    private String validUser_Group = "";
    private String invalidUser_Group = "";
    private String hostsAllow = "";
    private String hostsDeny = "";
    private String serverProtect = "no";
    private String userName = "";
    private String passwordChanged = "";
    private String shadowCopy = "no";
    private String oldshadowCopy = "";
    private String oldFileTimes = "yes";

    private String settingOperation = "";//[Add] or [Modify] share
    
    private String dirAccessControlAvailable = "no";

    private String shareExist = "no";
    private String antiVirusForShare = "yes";
    private String antiVirusForGlobal = "no";
    private String antiVirus = "no";
    
    //special share use only.
    private String browseable = "no";
    private String sharePurpose = "";
    private String directoryForRealtimeScan = "";
    private String validUserForRealtimeScan = "";
    private String[] validUserForBackup;
    private String allowHostForRealtimeScan = "";
    private String allowHostForBackup = "";
    
    private String validUserForScheduleScan = "";
    private String allowHostForScheduleScan = "";
    //end for special share use only.

    private String pseudoABE = "no";
    private String fsType    = "";
    
    public String getFsType() {
        return fsType;
    }


    public void setFsType(String fsType) {
        this.fsType = fsType;
    }


    public String getAllowHostForScheduleScan() {
        return allowHostForScheduleScan;
    }


    public void setAllowHostForScheduleScan(String allowHostForScheduleScan) {
        this.allowHostForScheduleScan = allowHostForScheduleScan;
    }


    public String getValidUserForScheduleScan() {
        return validUserForScheduleScan;
    }


    public void setValidUserForScheduleScan(String validUserForScheduleScan) {
        this.validUserForScheduleScan = validUserForScheduleScan;
    }


    public String getAllowHostForBackup() {
        return allowHostForBackup;
    }
    

    public void setAllowHostForBackup(String allowHostForBackup) {
        this.allowHostForBackup = allowHostForBackup;
    }
    

    public String getAllowHostForRealtimeScan() {
        return allowHostForRealtimeScan;
    }
    

    public void setAllowHostForRealtimeScan(String allowHostForRealtimeScan) {
        this.allowHostForRealtimeScan = allowHostForRealtimeScan;
    }

    
    public String getDirectoryForRealtimeScan() {
        return directoryForRealtimeScan;
    }
    

    public void setDirectoryForRealtimeScan(String directoryForRealtimeScan) {
        this.directoryForRealtimeScan = directoryForRealtimeScan;
    }
    

    public String[] getValidUserForBackup() {
        return validUserForBackup;
    }
    

    public void setValidUserForBackup(String[] validUserForBackup) {
        this.validUserForBackup = validUserForBackup;
    }
    

    public String getValidUserForRealtimeScan() {
        return validUserForRealtimeScan;
    }
    

    public void setValidUserForRealtimeScan(String validUserForRealtimeScan) {
        this.validUserForRealtimeScan = validUserForRealtimeScan;
    }
    

    /**
     * @return
     */
    public String getComment() {
        return comment;
    }

    /**
     * @return
     */
    public String getConnection() {
        return connection;
    }

    /**
     * @return
     */
    public String getDirectory() {
        return directory;
    }

    /**
     * @return
     */
    public String getHostsAllow() {
        return hostsAllow;
    }

    /**
     * @return
     */
    public String getHostsDeny() {
        return hostsDeny;
    }

    /**
     * @return
     */
    public String getInvalidUser_Group() {
        return invalidUser_Group;
    }

    /**
     * @return
     */
    public String getPassword_() {
        return password_;
    }

    /**
     * @return
     */
    public String getReadOnly() {
        return readOnly;
    }

    /**
     * @return
     */
    public String getServerProtect() {
        return serverProtect;
    }

    /**
     * @return
     */
    public String getSettingPassword() {
        return settingPassword;
    }

    /**
     * @return
     */
    public String getShareName() {
        return shareName;
    }

    /**
     * @return
     */
    public String getUserName() {
        return userName;
    }

    /**
     * @return
     */
    public String getPasswordChanged() {
        return passwordChanged;
    }

    /**
     * @return
     */
    public String getValidUser_Group() {
        return validUser_Group;
    }

    /**
     * @return
     */
    public String getWriteList() {
        return writeList;
    }

    /**
     * @param string
     */
    public void setComment(String string) {
        comment = string;
    }

    /**
     * @param string
     */
    public void setPasswordChanged(String string) {
        passwordChanged = string;
    }

    /**
     * @param string
     */
    public void setConnection(String string) {
        connection = string;
    }

    /**
     * @param string
     */
    public void setDirectory(String string) {
        directory = string;
    }

    /**
     * @param string
     */
    public void setHostsAllow(String string) {
        hostsAllow = string;
    }

    /**
     * @param string
     */
    public void setHostsDeny(String string) {
        hostsDeny = string;
    }

    /**
     * @param string
     */
    public void setInvalidUser_Group(String string) {
        invalidUser_Group = string;
    }

    /**
     * @param string
     */
    public void setPassword_(String string) {
        password_ = string;
    }

    /**
     * @param string
     */
    public void setReadOnly(String string) {
        readOnly = string;
    }

    /**
     * @param string
     */
    public void setServerProtect(String string) {
        serverProtect = string;
    }

    /**
     * @param string
     */
    public void setSettingPassword(String string) {
        settingPassword = string;
    }

    /**
     * @param string
     */
    public void setShareName(String string) {
        shareName = string;
    }

    /**
     * @param string
     */
    public void setUserName(String string) {
        userName = string;
    }

    /**
     * @param string
     */
    public void setValidUser_Group(String string) {
        validUser_Group = string;
    }

    /**
     * @param string
     */
    public void setWriteList(String string) {
        writeList = string;
    }

    /**
     * @return
     */
    public String getOldshadowCopy() {
        return oldshadowCopy;
    }

    /**
     * @return
     */
    public String getShadowCopy() {
        return shadowCopy;
    }

    /**
     * @param string
     */
    public void setOldshadowCopy(String string) {
        oldshadowCopy = string;
    }

    /**
     * @param string
     */
    public void setShadowCopy(String string) {
        shadowCopy = string;
    }

    /**
     * @return
     */
    public String getSettingOperation() {
        return settingOperation;
    }

    /**
     * @param string
     */
    public void setSettingOperation(String string) {
        settingOperation = string;
    }

    /**
     * @return
     */
    public String getDirAccessControlAvailable() {
        return dirAccessControlAvailable;
    }

    /**
     * @param string
     */
    public void setDirAccessControlAvailable(String string) {
        dirAccessControlAvailable = string;
    }
    /**
     * @return
     */
    public String getShareExist() {
        return shareExist;
    }

    /**
     * @param string
     */
    public void setShareExist(String string) {
        shareExist = string;
    }

    public String getOldFileTimes() {
        return oldFileTimes;
    }
    

    public void setOldFileTimes(String oldFileTimes) {
        this.oldFileTimes = oldFileTimes;
    }

    public String getBrowseable() {
        return browseable;
    }
    

    public void setBrowseable(String browseable) {
        this.browseable = browseable;
    }

    public String getSharePurpose() {
        return sharePurpose;
    }
    

    public void setSharePurpose(String sharePurpose) {
        this.sharePurpose = sharePurpose;
    }

    public String getAntiVirus() {
        return antiVirus;
    }
    


    public void setAntiVirus(String antiVirus) {
        this.antiVirus = antiVirus;
    }
    


    public String getAntiVirusForGlobal() {
        return antiVirusForGlobal;
    }
    


    public void setAntiVirusForGlobal(String antiVirusForGlobal) {
        this.antiVirusForGlobal = antiVirusForGlobal;
    }
    


    public String getAntiVirusForShare() {
        return antiVirusForShare;
    }
    


    public void setAntiVirusForShare(String antiVirusForShare) {
        this.antiVirusForShare = antiVirusForShare;
    }
    

    public String getPseudoABE() {
        return pseudoABE;
    }


    public void setPseudoABE(String pseudoABE) {
        this.pseudoABE = pseudoABE;
    }
    
    
}
    