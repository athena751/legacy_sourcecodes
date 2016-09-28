/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.nfs;

/**
 *
 */
public class LogInfoBean {
    private static final String cvsid =
        "@(#) $Id: LogInfoBean.java,v 1.1 2004/11/23 06:58:17 het Exp $";

    private String fileName = "";
    private String fileSize = "";
    private String fileSizeUnit = "";
    private String generationNum = "";
    private String collectionCycle = "";
    private String userAuth = "no";

    public LogInfoBean() {

    }

    /**
     * @return
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * @return
     */
    public String getFileSize() {
        return fileSize;
    }

    /**
     * @return
     */
    public String getFileSizeUnit() {
        return fileSizeUnit;
    }

    /**
     * @return
     */
    public String getGenerationNum() {
        return generationNum;
    }

    /**
     * @return
     */
    public String getUserAuth() {
        return userAuth;
    }

    /**
     * @param string
     */
    public void setFileName(String string) {
        fileName = string;
    }

    /**
     * @param string
     */
    public void setFileSize(String string) {
        fileSize = string;
    }

    /**
     * @param string
     */
    public void setFileSizeUnit(String string) {
        fileSizeUnit = string;
    }

    /**
     * @param string
     */
    public void setGenerationNum(String string) {
        generationNum = string;
    }

    /**
     * @param string
     */
    public void setUserAuth(String string) {
        userAuth = string;
    }

    /**
     * @return
     */
    public String getCollectionCycle() {
        return collectionCycle;
    }

    /**
     * @param string
     */
    public void setCollectionCycle(String string) {
        collectionCycle = string;
    }

}
