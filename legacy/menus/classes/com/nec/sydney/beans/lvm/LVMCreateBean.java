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
import com.nec.nsgui.model.entity.volume.LVMInfoBean;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.NSMessageDriver;

public class LVMCreateBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMCreateBean.java,v 1.2308 2005/11/18 00:56:34 liuyq Exp $";

    public LVMCreateBean(){}

    public void beanProcess() throws Exception {
        boolean is1Node = NSActionUtil.isOneNodeSirius(request);
        HttpSession session = request.getSession();
        LVMInfoBean lvmInfo = new LVMInfoBean();
        String lvtype = request.getParameter("type");
        String node=request.getParameter("activeNode");
        String isCluster = null;
        String name=request.getParameter("name");
        name = NSMessageDriver.getInstance().getMessage(session, "nas_lvm/LVMCreateShow/lvm_prefix") + name;
        String disk=request.getParameter("selectedLdPath");
        String striped = request.getParameter("striping");
        if(striped == null || !striped.equals("true")){
            striped = "false";    
        }
        int nodeNum = 0;
        if (is1Node){
            node = "0";
            nodeNum = 0;
        }
        
        lvmInfo.setLvName(name);
        lvmInfo.setLdList(disk);
        lvmInfo.setStriping(striped);
        
        isCluster = "false";
        
        if(lvtype.equals("cluster")) {
            isCluster = "true";
            nodeNum = node.equals("0") ? 0 : 1;
        }
        
        try {
            LVMHandler.createLV(lvmInfo , nodeNum);
        } catch(NSException e) {
           if(e.getErrorCode().equals("0x10800020")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                                + NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/pv_exist"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMCreateShow.jsp") + "?defaultNode=" + node + "&lvtype="+lvtype);
                return;
            }else if (e.getErrorCode().equals("0x10800022")) {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                                + NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/lv_max"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?cluster="+isCluster+"&fromPage=fromCreate");
                return;
            }else if (e.getErrorCode().startsWith("0x1080006")) {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/diskarrayErr4Create"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?cluster="+isCluster+"&fromPage=fromCreate");
                return;
            } else {
                throw e;
            }
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        super.response.sendRedirect(super.response.encodeRedirectURL("LVMList.jsp") + "?cluster=" + isCluster);
    }
}