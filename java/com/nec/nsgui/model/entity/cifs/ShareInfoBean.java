/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.cifs;

public class ShareInfoBean {
    private static final String cvsid = "@(#) $Id: ShareInfoBean.java,v 1.3 2007/03/23 07:10:03 chenbc Exp $";
    
    private String shareName;
    private String shareName_td;
    private String directory;
    private String comment;
    private String logging;
    private String fsType;
    private String connection;
    private String readOnly;
    private String shareInfo;//such as [shareName,fsType,directory]
    private String antiVirus = "";
    private String sharePurpose = "";

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

    /**
     * @return
     */
    public String getConnection() {
        return connection;
    }

    /**
     * @return
     */
    public String getFsType() {
        return fsType;
    }

    /**
     * @return
     */
    public String getShareInfo() {
        return shareInfo;
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
    public void setFsType(String string) {
        fsType = string;
    }

    /**
     * @param string
     */
    public void setShareInfo(String string) {
        shareInfo = string;
    }

    /**
     * @return
     */
    public String getReadOnly() {
        return readOnly;
    }

    /**
     * @param string
     */
    public void setReadOnly(String string) {
        readOnly = string;
    }

    public String getAntiVirus() {
        return antiVirus;
    }
    

    public void setAntiVirus(String antiVirus) {
        this.antiVirus = antiVirus;
    }

    public String getSharePurpose() {
        return sharePurpose;
    }
    

    public void setSharePurpose(String sharePurpose) {
        this.sharePurpose = sharePurpose;
    }
    
    

}
    