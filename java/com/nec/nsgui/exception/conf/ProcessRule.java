/*
 *      Copyright (c) 2004-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */
package com.nec.nsgui.exception.conf;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProcessRule {

    private static final String cvsid =
        "@(#) $Id: ProcessRule.java,v 1.3 2006/11/06 05:37:58 liy Exp $";
    private List errMsgList = new ArrayList();
    private Map dispatcherMap = new HashMap();
    private String errorCode = "";
    private String displayDetail = "";
    private String level="";
    
    public void addErrMsg(ErrorMessage em) {
        errMsgList.add(em);
    }
    public List getErrMsgList() {
        return errMsgList;
    }
    public void addDispatcher(Dispatcher dispatcher) {
        dispatcherMap.put(dispatcher.getSrcAction(), dispatcher);
    }
    public Dispatcher getDispatcher(String srcAction) {
        return (Dispatcher) dispatcherMap.get(srcAction);
    }
    public void setErrorCode(String errCode) {
        errorCode = errCode.toLowerCase();
    }
    public String getErrorCode() {
        return errorCode;
    }

    public boolean equals(Object ob) {
        if (ob == null) {
                   return false;
               }
        boolean result = true;

        ProcessRule prSrc = (ProcessRule) ob;
       
        if (!(prSrc.errorCode.equals(errorCode))
            || !(errMsgList.equals(prSrc.errMsgList))
            || !(dispatcherMap.equals(prSrc.dispatcherMap))) {
            result = false;
        }

        return result;

    }
    /**
        * @return
        */
       public String getDisplayDetail() {
           return displayDetail;
       }

       /**
        * @param string
        */
       public void setDisplayDetail(String string) {
           displayDetail = string;
       }
       /**
        * @return
        */
       public String getLevel() {
           return level;
       }

       /**
        * @param string
        */
       public void setLevel(String string) {
           level = string;
       }
}