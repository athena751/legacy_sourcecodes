/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework;

import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.entity.framework.FrameworkConst;

public class NSTimeout {

    private static final String cvsid = "@(#) $Id: NSTimeout.java,v 1.1 2005/10/19 00:55:53 fengmh Exp $";

    private String nsadminTimeout = null;

    private String nsviewTimeout = null;

    private static NSTimeout _instance = null;

    protected NSTimeout() {
        fresh();
        return;
    }

    public void fresh() {
        String nsadmin_timeout = "";
        String nsview_timeout = "";
        String nsview = "-?\\d+";
        String nsadmin = "\\d+";
        try {
            nsadmin_timeout = NSModelUtil.getValueByProperty(
                    FrameworkConst.PATH_OF_TIMEOUT_CONF,
                    FrameworkConst.NSADMIN_TIMEOUT);
        } catch (Exception ex) {
            nsadmin_timeout = Integer.toString(FrameworkConst.DEFAULT_NSGUI_TIMEOUT);
        }
        try {
            nsview_timeout = NSModelUtil.getValueByProperty(
                    FrameworkConst.PATH_OF_TIMEOUT_CONF,
                    FrameworkConst.NSVIEW_TIMEOUT);
        } catch (Exception ex) {
            nsview_timeout = Integer.toString(FrameworkConst.DEFAULT_NSGUI_TIMEOUT);
        }
        if (!nsadmin_timeout.matches(nsadmin)) {
            nsadmin_timeout = Integer.toString(FrameworkConst.DEFAULT_NSGUI_TIMEOUT);
        }
        if (!nsview_timeout.matches(nsview)) {
            nsview_timeout = Integer.toString(FrameworkConst.DEFAULT_NSGUI_TIMEOUT);
        }
        this.setNsadminTimeout(nsadmin_timeout);
        this.setNsviewTimeout(nsview_timeout);
    }

    public static NSTimeout getInstance()  {
        if (_instance == null) {
            _instance = new NSTimeout();
        }
        return _instance;
    }

    public String getNsadminTimeout() {
        return nsadminTimeout;
    }

    public void setNsadminTimeout(String nsadmin_timeout) {
        this.nsadminTimeout = nsadmin_timeout;
    }

    public String getNsviewTimeout() {
        return nsviewTimeout;
    }

    public void setNsviewTimeout(String nsview_timeout) {
        this.nsviewTimeout = nsview_timeout;
    }
}
