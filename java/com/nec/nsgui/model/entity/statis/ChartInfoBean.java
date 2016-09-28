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

public class ChartInfoBean {
    private static final String cvsid =
            "@(#) $Id: ChartInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private String targetId = "";
    private String nickName = "";
    private String graphTableHtml = "";
    private String returnValue = "";


    /**
     * @return
     */
    public String getGraphTableHtml() {
        return graphTableHtml;
    }

    /**
     * @return
     */
    public String getNickName() {
        return nickName;
    }

    /**
     * @return
     */
    public String getReturnValue() {
        return returnValue;
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
    public void setGraphTableHtml(String string) {
        graphTableHtml = string;
    }

    /**
     * @param string
     */
    public void setNickName(String string) {
        nickName = string;
    }

    /**
     * @param string
     */
    public void setReturnValue(String string) {
        returnValue = string;
    }

    /**
     * @param string
     */
    public void setTargetId(String string) {
        targetId = string;
    }

}