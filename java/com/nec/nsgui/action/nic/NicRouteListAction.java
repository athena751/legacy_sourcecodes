/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicRouteListAction.java,v 1.4 2005/10/24 07:43:04 changhs Exp $
 */

package com.nec.nsgui.action.nic;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.nic.*;

import com.nec.nsgui.action.base.NSActionUtil;
import java.util.*;

public final class NicRouteListAction extends Action {

    /*
     * the action to get the routelists
     * forward to nicroutelisttop.jsp
     * throw Exception
     */
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NSActionUtil.removeSessionAttribute(request,"selectedInterface");        
        NicHandler routeHandler = new NicHandler();
        Vector routeList = routeHandler.getRouteList(false, nodeNo);
        request.setAttribute("routeList", routeList);  
        if (NSActionUtil.isCluster(request)){
            try {
                CmdExecBase.checkClusterStatus();
            }catch (Exception e){
                request.setAttribute("display4maintain", "true");
            }
        }
        return (mapping.findForward("listTop"));
    }
}