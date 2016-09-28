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

public class SyslogCifsSearchInfoBean {
    private static final String cvsid =
            "@(#) $Id: SyslogCifsSearchInfoBean.java,v 1.1 2004/11/21 08:13:44 baiwq Exp $";

    private String encoding;


    /**
     * @return
     */
    public String getEncoding() {
        return encoding;
    }

    /**
     * @param string
     */
    public void setEncoding(String string) {
        encoding = string;
    }

}

