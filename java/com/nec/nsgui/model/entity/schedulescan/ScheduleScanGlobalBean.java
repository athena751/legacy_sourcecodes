/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.schedulescan;

/**
 * @author chenjc
 * 
 */
public class ScheduleScanGlobalBean {
    public static final String cvsid = "@(#) $Id: ScheduleScanGlobalBean.java,v 1.1 2008/05/08 09:04:25 chenbc Exp $";

    public String selectedInterfaces="";

    public String selectedUsers="";

    public String scanServer="";

    /**
     * 
     * @return
     */
    public String getScanServer() {
        return scanServer;
    }

    /**
     * 
     * @param scanServer
     */
    public void setScanServer(String scanServer) {
        this.scanServer = scanServer;
    }

    /**
     * 
     * @return
     */
    public String getSelectedInterfaces() {
        return selectedInterfaces;
    }

    /**
     * 
     * @param selectedInterfaces
     */
    public void setSelectedInterfaces(String selectedInterfaces) {
        this.selectedInterfaces = selectedInterfaces;
    }

    /**
     * 
     * @return
     */
    public String getSelectedUsers() {
        return selectedUsers;
    }

    /**
     * 
     * @param selectedUsers
     */
    public void setSelectedUsers(String selectedUsers) {
        this.selectedUsers = selectedUsers;
    }

}
