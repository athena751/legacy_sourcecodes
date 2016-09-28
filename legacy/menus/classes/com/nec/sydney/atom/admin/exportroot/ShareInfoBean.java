/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.atom.admin.exportroot;

public class ShareInfoBean {
    private static final String cvsid = "@(#) $Id: ShareInfoBean.java,v 1.1 2004/09/01 04:13:55 xiaocx Exp $";
    
    private String shareName;
    private String shareName_td;
    private String directory;
    private String comment;
    private String logging;
    

    /**
     * @return
     */
    public String getComment() {
        return comment;
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
    public String getLogging() {
        return logging;
    }

    /**
     * @return
     */
    public String getShareName() {
        return shareName;
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
    public void setDirectory(String string) {
        directory = string;
    }

    /**
     * @param string
     */
    public void setLogging(String string) {
        logging = string;
    }

    /**
     * @param string
     */
    public void setShareName(String string) {
        shareName = string;
    }

    /**
     * @return
     */
    public String getShareName_td() {
        return shareName_td;
    }

    /**
     * @param string
     */
    public void setShareName_td(String string) {
        shareName_td = string;
    }

}
    