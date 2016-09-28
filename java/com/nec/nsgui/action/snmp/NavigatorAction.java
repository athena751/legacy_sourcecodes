/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.model.biz.snmp.SnmpCmdHandler;

/**
 *For navigator
 */
public class NavigatorAction extends Action{
    private static final String cvsid = "@(#) $Id: NavigatorAction.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
    
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        ArrayList navigatorList = SnmpCmdHandler.getSourceList();
        sortBySourceName(navigatorList);
        request.setAttribute("navigatorList",navigatorList);
        return mapping.findForward("display");
    }
    private void sortBySourceName (ArrayList the_list){
        Collections.sort(
            the_list, new Comparator(){
                public int compare(Object a, Object b){
                    String source_a = (String)a;
                    String source_b = (String)b;
                    return source_a.compareTo(source_b);
                }
            }
        );
    }
}