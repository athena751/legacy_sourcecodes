/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicInterfaceChangeAction.java,v 1.5 2005/10/24 07:40:27 changhs Exp $ 
 */

package com.nec.nsgui.action.nic;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nic.NicHandler;
import com.nec.nsgui.model.entity.nic.NicInformationBean;

public class NicInterfaceChangeAction extends Action {
    private static final String cvsid = "@(#) $Id: NicInterfaceChangeAction.java,v 1.5 2005/10/24 07:40:27 changhs Exp $";

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String interfaceName = "";
        String from = "";
        interfaceName = (String) ((DynaActionForm) form).get("interfaceName");
        from = (String) ((DynaActionForm) form).get("nic_from4change");
        NSActionUtil.setSessionAttribute(request, "selectedInterface",
                interfaceName);
        NSActionUtil.setSessionAttribute(request, "nic_from4change", from);
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NSActionUtil.setSessionAttribute(request, "nodeNoConfirm", Integer
                .toString(nodeNo));
        NicInformationBean interfaceInfoSelf = NicHandler.getInterfaceInfo(
                interfaceName, nodeNo);
        NSActionUtil.setSessionAttribute(request, "interfaceSet",
                interfaceInfoSelf);
        if (NSActionUtil.isCluster(request)) {
            NicInformationBean interfaceInfoFriend;
            try {
                interfaceInfoFriend = NicHandler.getInterfaceInfo(
                        interfaceName, 1 - nodeNo);
                NSActionUtil.setSessionAttribute(request, "interfaceSetFriend",
                        interfaceInfoFriend);
            } catch (Exception ex) {
            }
        }
        /* modified by changhs for mail [nsgui-necas-sv4:10902]   2005/10/24
        String parentMtu = "";
        if (interfaceName.indexOf('.') >= 0) {
            NicInformationBean perentInfo = NicHandler.getInterfaceInfo(
                    interfaceName.substring(0, interfaceName.indexOf('.')),
                    nodeNo);
            parentMtu = perentInfo.getMtu();
        }
        NSActionUtil.setSessionAttribute(request, "parentMtu", parentMtu);
        */
        return mapping.findForward("success");
    }
}