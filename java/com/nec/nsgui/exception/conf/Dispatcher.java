/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */
package com.nec.nsgui.exception.conf;

import java.util.List;
import java.util.ArrayList;

public class Dispatcher {

    private static final String cvsid =
        "@(#) $Id: Dispatcher.java,v 1.1.1.1 2004/05/28 09:30:23 key Exp $";
    private List errMsgList = new ArrayList();
    private String srcAction = "";
    private String forward = "";

    public void addErrMsg(ErrorMessage msg) {
        errMsgList.add(msg);
    }
    public List getErrMsgList() {
        return errMsgList;
    }
    public void setSrcAction(String str) {
        srcAction = str;
    }
    public String getSrcAction() {
        return srcAction;
    }
    public void setForward(String str) {
        forward = str;
    }
    public String getForward() {
        return forward;
    }
    public boolean equals(Object ob) {
        if (ob == null) {
            return false;
        }
        Dispatcher dp = (Dispatcher) ob;
        boolean result = true;
        if (!(forward.equals(dp.forward))
            || !(srcAction.equals(dp.srcAction))
            || !(errMsgList.equals(dp.errMsgList))) {
            result = false;
     
        }
        return result;
    }

}