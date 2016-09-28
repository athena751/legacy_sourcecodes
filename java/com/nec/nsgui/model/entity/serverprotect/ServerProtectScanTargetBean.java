/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.serverprotect;

/**
 * @author chenbc
 *
 */
public class ServerProtectScanTargetBean {
    private static final String cvsid = "@(#) $Id: ServerProtectScanTargetBean.java,v 1.2 2007/03/23 06:35:44 wanghb Exp $";
 
    private String shareName = "";
    private String writeCheck = "";
    private String readCheck = "";
    private String sharePath = "";
    
   
    /**
     * @return Returns the readCheck.
     */
    public String getReadCheck() {
        return readCheck;
    }
    /**
     * @param readCheck The readCheck to set.
     */
    public void setReadCheck(String readCheck) {
        this.readCheck = readCheck;
    }

    /**
     * @return Returns the shareName.
     */
    public String getShareName() {
        return shareName;
    }
    /**
     * @param shareName The shareName to set.
     */
    public void setShareName(String shareName) {
        this.shareName = shareName;
    }
    /**
     * @return Returns the writeCheck.
     */
    public String getWriteCheck() {
        return writeCheck;
    }
    /**
     * @param writeCheck The writeCheck to set.
     */
    public void setWriteCheck(String writeCheck) {
        this.writeCheck = writeCheck;
    }
 
    /**
     * @return Returns the sharePath.
     */
    public String getSharePath() {
        return sharePath;
    }
    /**
     * @param sharePath The sharePath to set.
     */
    public void setSharePath(String sharePath) {
        this.sharePath = sharePath;
    }
    
}
