/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.cifs;

/**
 *
 */
public class CifsGlobalInfoBean {
    private static final String cvsid =
        "@(#) $Id: CifsGlobalInfoBean.java,v 1.5 2007/08/23 03:41:35 fengmh Exp $";

    private String encryptPasswords = "no";
    private String ldapAnonymous = "no";
    private String[] allInterfaces;
    private String[] allInterfacesLabel;
    private String[] interfaces;
    private String serverString = "";
    private String deadtime = "0";
    private String validUsers = "";
    private String invalidUsers = "";
    private String hostsAllow = "";
    private String hostsDeny = "";
    private String alogFile = "";
    private String canReadLog = "no";
    private String[] successLoggingItems;
    private String[] errorLoggingItems;
    private String logFileInRightArea = "yes";
    private String antiVirusForGlobal = "no";
    private String reasonForNoInterface = "";
    
    private String dirAccessControlAvailable = "no";

    public static final String SPLITER = ":";

    public String[] getAllInterfaces() {
        return allInterfaces;
    }

    public String[] getAllInterfacesLabel() {
        return allInterfacesLabel;
    }

    public String getAlogFile() {
        return alogFile;
    }

    public String getCanReadLog() {
        return canReadLog;
    }

    public String getDeadtime() {
        return deadtime;
    }

    public String getEncryptPasswords() {
        return encryptPasswords;
    }

    public String[] getErrorLoggingItems() {
        return errorLoggingItems;
    }

    public String getHostsAllow() {
        return hostsAllow;
    }

    public String getHostsDeny() {
        return hostsDeny;
    }

    public String[] getInterfaces() {
        return interfaces;
    }

    public String getInvalidUsers() {
        return invalidUsers;
    }

    public String getLdapAnonymous() {
        return ldapAnonymous;
    }

    public String getServerString() {
        return serverString;
    }

    public String[] getSuccessLoggingItems() {
        return successLoggingItems;
    }

    public String getValidUsers() {
        return validUsers;
    }

    public void setAllInterfaces(String[] strings) {
        allInterfaces = retrieveArray(strings, "\\s+");
    }

    public void setAllInterfacesLabel(String[] strings) {
        allInterfacesLabel = retrieveArray(strings, "\\s+");
    }

    public void setAlogFile(String string) {
        alogFile = string;
    }

    public void setCanReadLog(String string) {
        canReadLog = string;
    }

    public void setDeadtime(String string) {
        deadtime = string;
    }

    public void setEncryptPasswords(String string) {
        encryptPasswords = string;
    }

    public void setErrorLoggingItems(String[] strings) {
        errorLoggingItems = retrieveArray(strings, SPLITER);
    }

    public void setHostsAllow(String string) {
        hostsAllow = string;
    }

    public void setHostsDeny(String string) {
        hostsDeny = string;
    }

    public void setInterfaces(String[] strings) {
        interfaces = retrieveArray(strings, "\\s+");
    }

    public void setInvalidUsers(String string) {
        invalidUsers = string;
    }

    public void setLdapAnonymous(String string) {
        ldapAnonymous = string;
    }

    public void setServerString(String string) {
        serverString = string;
    }

    public void setSuccessLoggingItems(String[] strings) {
        successLoggingItems = retrieveArray(strings, SPLITER);
    }

    public void setValidUsers(String string) {
        validUsers = string;
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
    public String getLogFileInRightArea() {
        return logFileInRightArea;
    }

    /**
     * @param string
     */
    public void setLogFileInRightArea(String string) {
        logFileInRightArea = string;
    }

    public String getAntiVirusForGlobal() {
        return antiVirusForGlobal;
    }
    

    public void setAntiVirusForGlobal(String antiVirusForGlobal) {
        this.antiVirusForGlobal = antiVirusForGlobal;
    }

    /**
     * @return Returns the reasonForNoInterface.
     */
    public String getReasonForNoInterface() {
        return reasonForNoInterface;
    }

    /**
     * @param reasonForNoInterface The reasonForNoInterface to set.
     */
    public void setReasonForNoInterface(String reasonForNoInterface) {
        this.reasonForNoInterface = reasonForNoInterface;
    }
    

}
