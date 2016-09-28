/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.lvm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.volume.LVMHandler;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.NSMessageDriver;
import java.util.*;

import javax.servlet.http.HttpSession;

public class LVMRemoveBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg {
    public static final String cvsid =
            "@(#) $Id: LVMRemoveBean.java,v 1.2307 2008/04/19 15:07:41 xingyh Exp $";

    //Member Method
    public LVMRemoveBean(){        
    } 
    
    public void beanProcess() throws Exception {
        HttpSession session = request.getSession();
        String lvtype = request.getParameter ("lvtype");
        String node = request.getParameter("node");
        String parameter =request.getParameter("radioButton");
        StringTokenizer st = new StringTokenizer(parameter,",");
        String lvName=st.nextToken();
        int nodeNum = 0;
        String isCluster = "false";
        try {
            boolean is1Node = NSActionUtil.isOneNodeSirius(request);
            if (is1Node){
                node = "0";
            }
            if(lvtype.equals("cluster")){
                isCluster = "true";
                nodeNum = node.equals("0") ? 0 : 1;
            }
            LVMHandler.deleteLV(lvName, nodeNum);
        }catch (NSException e){
            if (e.getErrorCode().startsWith("0x1080006")) {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/diskarrayErr4Remove"));
                super.response.sendRedirect(super.response.encodeRedirectURL("LVMError.jsp") 
                                            + "?fromPage=fromDestory&cluster=" + isCluster);
                return;
            }else if(e.getErrorCode().equals("0x10800027")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")
                                    +"\\r\\n"+NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/hasmount"));
                                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp") 
                                                      + "?fromPage=fromDestory&cluster=" + isCluster);
                                return;
                
            }else if(e.getErrorCode().equals("0x12400095")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")
                        +"\\r\\n"+NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/vgpaircheck_failed"));
                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp") + "?fromPage=fromDestory&cluster=" + isCluster);
                return;
            }else if(e.getErrorCode().equals("0x12400094")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/remove_paired"));
                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp") + "?fromPage=fromDestory&cluster=" + isCluster);
                return;
            }else{
                throw e;
            }
        }

        try{
            VolumeHandler.deleteRRDFile(lvName , VolumeActionConst.VOLUME_NAS_LV_IO , nodeNum);
            VolumeHandler.deleteRRDFile(lvName , VolumeActionConst.VOLUME_FILE_SYSTEM , nodeNum);
            VolumeHandler.deleteRRDFile(lvName , VolumeActionConst.VOLUME_FILE_SYSTEM_QUANTITY , nodeNum);
        } catch (Exception eee) {
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        response.sendRedirect(response.encodeRedirectURL("LVMList.jsp") + "?cluster=" + isCluster);
    }
}