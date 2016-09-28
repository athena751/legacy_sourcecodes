/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.syslog;

/**
 *
 */

public class SyslogCategoryInfoBean {
    private static final String cvsid =
            "@(#) $Id: SyslogCategoryInfoBean.java,v 1.1 2004/11/21 08:13:44 baiwq Exp $";

    private String category = "";
    private String categoryLabel = "";
    private String keyword = "";

    
    /**
     * @return
     */
    public String getCategory() {
        return category;
    }

    /**
     * @return
     */
    public String getKeyword() {
        return keyword;
    }

    /**
     * @param string
     */
    public void setCategory(String string) {
        category = string;
    }

    /**
     * @param string
     */
    public void setKeyword(String string) {
        keyword = string;
    }

    /**
     * @return
     */
    public String getCategoryLabel() {
        return categoryLabel;
    }

    /**
     * @param string
     */
    public void setCategoryLabel(String string) {
        categoryLabel = string;
    }

}

