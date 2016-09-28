/*
 *      Copyright (c) 2001-2005 NEC Corporation
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

public class LVMExtendBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMExtendBean.java,v 1.2304 2005/11/18 09:42:41 liuyq Exp $";

    public void beanProcess() throws Exception {
        HttpSession session = request.getSession();
        String lvtype = request.getParameter("lvtype");
        String lv = super.request.getParameter("lvname");
        String disk = super.request.getParameter("selectedLdPath");
        String node = request.getParameter("node");
        String isCluster = "false";
        int nodeNum = 0;
        try {
            boolean is1Node =NSActionUtil.isOneNodeSirius(request);
            if (is1Node){
                node = "0";
            }
            if(lvtype.equals("cluster")) {
                isCluster = "true";
                nodeNum = node.equals("0") ? 0 : 1;
            }
            String isStriped = request.getParameter("striping");
            if(isStriped == null){
                isStriped = "false";
            }
            LVMHandler.extendLV(lv, disk, isStriped, nodeNum);
        }catch (NSException e){
            if (e.getErrorCode().startsWith("0x1080006")) {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/diskarrayErr4Extend"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?fromPage=fromExtend&cluster="
                                            + (lvtype.equals("cluster")?"true":"false"));
                return;
            }else{
                throw e;
            }
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        super.response.sendRedirect(super.response.encodeRedirectURL("LVMList.jsp")+"?cluster=" + isCluster);
    }
}
