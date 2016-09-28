/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.lvm;

import javax.servlet.http.HttpSession;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.volume.LVMHandler;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.NSMessageDriver;

public class LVMManageBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMManageBean.java,v 1.2304 2008/04/19 15:03:47 xingyh Exp $";

    public void beanProcess() throws Exception {        
        String isCluster = super.request.getParameter("iscluster");
        String lvname = super.request.getParameter("lvname");
        String disks = super.request.getParameter("disks");
        String node = super.request.getParameter("activeNode");
        int nodeNum = 0;
        HttpSession session = request.getSession();
        String targetUrl ;
        try {
            boolean is1Node =NSActionUtil.isOneNodeSirius(request);
            if (is1Node){
                node = "0";
            }
            if(isCluster.equals("true")) {
                nodeNum = node.equals("0") ? 0 : 1;
            }
            LVMHandler.manageLV(lvname, nodeNum);
        }catch (NSException e){
            if (e.getErrorCode().startsWith("0x1080006")) {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/diskarrayErr4Manage"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?fromPage=fromManage&cluster=" + isCluster);
                return;
            }else if (e.getErrorCode().equals("0x10800028")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/cfstabErr4Manage"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?fromPage=fromManage&cluster=" + isCluster);
                return;
            }else if (e.getErrorCode().equals("0x12400096")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/vgpaircheck_failed_partner"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?fromPage=fromManage&cluster=" + isCluster);
                return;
            }else if (e.getErrorCode().equals("0x12400094")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/manage_paired"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?fromPage=fromManage&cluster=" + isCluster);
                return;
            }else{
                throw e;
            }
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        super.response.sendRedirect(super.response.encodeRedirectURL("LVMList.jsp")+"?cluster=" + isCluster);
    }
}
