/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicLinkDownConfigAction.java,v 3.2 2005/06/13 02:01:04 wanghui Exp
 *      
 */

package com.nec.nsgui.action.nic;

import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.nic.NicHandler;
import com.nec.nsgui.model.entity.nic.NicLinkDownInfoBean;
public class NicLinkDownConfigAction extends DispatchAction {
    private static final String cvsid =
        "@(#) NicLinkDownConfigAction.java,v 1.0 2005/06/21 07:16:49 wanghui Exp";
    
    private NicLinkDownInfoBean getLinkDownInfo(int nodeNum)throws Exception{
         NicLinkDownInfoBean linkdownInfo = NicHandler.getLinkDownInfo(nodeNum);
         return linkdownInfo;
    }
    
    public ActionForward getLinkdownInfo4View(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicLinkDownInfoBean linkdownInfo = new NicLinkDownInfoBean();
        try {
            linkdownInfo = getLinkDownInfo(nodeNo);            
        }catch(NSException e) {
            if(e.getErrorCode().equals("0x13800004")){                
                NSActionUtil.setSessionAttribute(request, "linkdown_hasSet", "no");
                NSActionUtil.setSessionAttribute(request, "linkdownInfo", linkdownInfo);
                return (mapping.findForward("linkdownInfo"));
            }else {
                throw e;
            }
        }
       
        if(linkdownInfo.getIgnoreList().equals("") || linkdownInfo.getIgnoreList() == null){
            linkdownInfo.setIgnoreList("&nbsp;");
        } else {
            String[] ifs = NicHandler.getInterface4Linkdown(nodeNo);  
            String[] interfaceArray = ifs[0].split(",");                            
            String[] ipArray = ifs[1].split(",");
            String[] ignoreArray =linkdownInfo.getIgnoreList().split(",");
            Hashtable iftable = new Hashtable();
            for(int i = 0; i < interfaceArray.length; i++) {
                iftable.put(interfaceArray[i], ipArray[i]);
            }
            for(int i = 0; i < ignoreArray.length; i++){
                String ip = (String)(iftable.get(ignoreArray[i]));   
               if(ip != null){ 
                   ignoreArray[i]=ignoreArray[i]+"("+ip+")";
                   
               } else {
                   ignoreArray[i]=ignoreArray[i]+"(--)";
               }
            }
            
            StringBuffer ignoreSb = new StringBuffer();
            for(int i = 0; i < ignoreArray.length; i++){
                if( i == 0){
                    ignoreSb.append(ignoreArray[i]);
                }else {
                    ignoreSb.append("<br>" + ignoreArray[i]);
                }
                    
            }            
            linkdownInfo.setIgnoreList(ignoreSb.toString());           
        }
        
        NSActionUtil.setSessionAttribute(request, "linkdownInfo", linkdownInfo);
        NSActionUtil.setSessionAttribute(request, "linkdown_hasSet", "yes");
        return mapping.findForward("linkdownInfo");
    }
    
    public ActionForward getLinkdownInfo4Set(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        String[] ifs = new String[2];
        try{
            ifs = NicHandler.getInterface4Linkdown(nodeNo);            
            NicLinkDownInfoBean LinkDownInfoBean = getLinkDownInfo(nodeNo);
            ((NicLinkDownInfoBean)form).setTakeOver(LinkDownInfoBean.getTakeOver()); 
            ((NicLinkDownInfoBean)form).setBondDown(LinkDownInfoBean.getBondDown());
            ((NicLinkDownInfoBean)form).setCheckInterval(LinkDownInfoBean.getCheckInterval());
            ((NicLinkDownInfoBean)form).setIgnoreList(LinkDownInfoBean.getIgnoreList());
        } catch(NSException e){
            if(e.getErrorCode().equals("0x13800004")){
                NSActionUtil.setSessionAttribute(request, "interfaces", ifs[0]);
                NSActionUtil.setSessionAttribute(request, "ipAddress", ifs[1]);
                return (mapping.findForward("linkdownConfigTop"));
            }else {
                throw e;
            }
        }
        NSActionUtil.setSessionAttribute(request, "interfaces", ifs[0]);
        NSActionUtil.setSessionAttribute(request, "ipAddress", ifs[1]);
        return mapping.findForward("linkdownConfigTop");
        
    } 

    public ActionForward setLinkdownInfo(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicLinkDownInfoBean linkdownInfo =(NicLinkDownInfoBean)form;
        NicHandler.setLinkDownInfo(nodeNo, linkdownInfo);        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("linkdownConfig");
    }

}
