/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.framework;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.framework.ControllerModel;
import com.nec.nsgui.model.biz.framework.menu.NSMenuFactory;
import com.nec.nsgui.model.entity.framework.menu.NSMenusBean;

public class MenuAction extends DispatchAction {
    private static final String cvsid = "@(#) $Id: MenuAction.java,v 1.3 2005/06/13 07:56:21 liuyq Exp $";

    public ActionForward display(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        NSMenusBean NSMenus = NSMenuFactory.createNSMenusInstance(NSActionUtil
                .getCurUserName(request));
        String machineType = ControllerModel.getInstance().getMachineType();
        request.setAttribute("menu", NSMenus);
        request.setAttribute("machineType", machineType);
        return mapping.findForward("display");
    }

public ActionForward siteMapDisplay(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        NSMenusBean NSMenus = NSMenuFactory.createNSMenusInstance(NSActionUtil
                .getCurUserName(request));
        request.setAttribute("menu", NSMenus);
        return mapping.findForward("siteMapDisplay");
    }}
