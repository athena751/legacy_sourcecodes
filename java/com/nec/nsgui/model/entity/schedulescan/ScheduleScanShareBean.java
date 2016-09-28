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
 * 
 * @author hanhui
 *
 */

public class ScheduleScanShareBean {
    private static final String cvsid = "@(#) $Id: ScheduleScanShareBean.java,v 1.1 2008/05/08 09:04:25 chenbc Exp $";
    private String shareName = "";
    private String sharePath = "";
    
    /**
     * @return Returns the shareName.
     */
    public String getShareName() {
        return shareName;
    }
    /**
     * @param shareName:The shareName to set.
     */
    public void setShareName(String shareName) {
        this.shareName = shareName;
    }
    
    /**
     * @return Returns the sharePath.
     */
    public String getSharePath() {
        return sharePath;
    }
    /**
     * @param sharePath: The sharePath to set.
     */
    public void setSharePath(String sharePath) {
        this.sharePath = sharePath;
    }

}
