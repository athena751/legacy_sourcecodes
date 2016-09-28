/*
 *      Copyright (c) 2004-2005 NEC Corporation
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
public class CifsShareAccessLogBean {
    private static final String cvsid =
        "@(#) $Id: CifsShareAccessLogBean.java,v 1.2 2005/09/08 00:11:55 key Exp $";

    private String alogEnable = "no";
    private String[] successLoggingItems = {
    };
    private String[] errorLoggingItems = {
    };
    private String shareExist = "no";
    public static final String SPLITER = ":";

    public String getAlogEnable() {
        return alogEnable;
    }

    public String[] getErrorLoggingItems() {
        return errorLoggingItems;
    }

    public String[] getSuccessLoggingItems() {
        return successLoggingItems;
    }

    public void setAlogEnable(String string) {
        alogEnable = string;
    }

    public void setErrorLoggingItems(String[] strings) {
        errorLoggingItems = retrieveArray(strings);
    }

    public void setSuccessLoggingItems(String[] strings) {
        successLoggingItems = retrieveArray(strings);
    }
    
    private String[] retrieveArray(String[] strings){
        if (strings != null && strings.length == 1) {
            if (strings[0].equals("")) {
                return null;
            } else {
                return strings[0].split(SPLITER);
            }
        }
        return strings;
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

}
