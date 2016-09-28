/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.lvm;

import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.volume.LVMHandler;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.NSMessageDriver;

import javax.servlet.http.HttpSession;

public class LVMMoveBean extends AbstractJSPBean implements NasConstants,
    NSExceptionMsg{

    public static final String cvsid =
           "@(#) $Id: LVMMoveBean.java,v 1.2307 2008/04/19 15:06:20 xingyh Exp $";
    
    private int srcNode; //modify by liuyq
    //Member Method
    public LVMMoveBean(){        
    } 

    public void beanProcess() throws Exception {
        srcNode = Integer.parseInt(request.getParameter("node"));
        String radio =request.getParameter("radioButton");
        HttpSession session = request.getSession();
        /// modify by liuyq 
        String[] strArray = radio.split(",");
        String lvName = strArray[0];
        ///add by liuyq end 
        
        try{
            LVMHandler.moveLV(lvName, srcNode);
        }catch (NSException e){
            if (e.getErrorCode().startsWith("0x1080006")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,
                    "nas_lvm/alert/diskarrayErr4Move"));
                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp")
                    + "?cluster=true&fromPage=fromMove");
                return;
            }else if (e.getErrorCode().endsWith("0x1080002b")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,
                    "common/alert/failed"));
                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp") 
                + "?cluster=true&fromPage=fromMove");
                return;
            }else if (e.getErrorCode().endsWith("0x10800027")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,
                    "common/alert/failed") + "\\r\\n" + NSMessageDriver.
                    getInstance().getMessage(session, "nas_lvm/lvmMove/hasMount"));
                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp") 
                + "?cluster=true&fromPage=fromMove");
                return;
            } else if (e.getErrorCode().endsWith("0x12400095")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n" +
                             NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/vgpaircheck_failed"));
                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp") + "?cluster=true&fromPage=fromMove");
                return;
            }else if (e.getErrorCode().endsWith("0x12400094")){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n" +
                        NSMessageDriver.getInstance().getMessage(session, "nas_lvm/alert/move_paired"));
                response.sendRedirect(response.encodeRedirectURL("LVMError.jsp") + "?cluster=true&fromPage=fromMove");
                return;
            }else{
                throw e;
            }
        }
        super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        response.sendRedirect(response.encodeRedirectURL("LVMList.jsp") + "?cluster=" + "true");
    }
}