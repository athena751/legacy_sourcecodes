/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

/**
 *
 */
public class GraphInfoBean {
    private static final String cvsid =
               "@(#) $Id: GraphInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private String targetId = "";
    private String nickName = "";
    private String graphTableHtml = "";
    private String hasDownloadButton = "false";
    private int periodNeedShow;
    /**
     * @return
     */
    public String getGraphTableHtml() {
        return graphTableHtml;
    }

    /**
     * @return
     */
    public String getHasDownloadButton() {
        return hasDownloadButton;
    }

    /**
     * @return
     */
    public String getNickName() {
        return nickName;
    }

    /**
     * @param string
     */
    public void setGraphTableHtml(String string) {
        graphTableHtml = string;
    }

    /**
     * @param string
     */
    public void setHasDownloadButton(String string) {
        hasDownloadButton = string;
    }

    /**
     * @param string
     */
    public void setNickName(String string) {
        nickName = string;
    }

    /**
     * @return
     */
    public int getPeriodNeedShow() {
        return periodNeedShow;
    }

    /**
     * @param i
     */
    public void setPeriodNeedShow(int i) {
        periodNeedShow = i;
    }

    /**
     * @return
     */
    public String getTargetId() {
        return targetId;
    }

    /**
     * @param string
     */
    public void setTargetId(String string) {
        targetId = string;
    }

}
