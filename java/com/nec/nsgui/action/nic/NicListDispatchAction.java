/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicListDispatchAction.java,v 1.5 2007/08/23 05:17:00 fengmh Exp $ 
 */

package com.nec.nsgui.action.nic;

import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.*;

import com.nec.nsgui.model.biz.nic.*;
import com.nec.nsgui.model.entity.nic.NicInformationBean;
import com.nec.nsgui.action.base.NSActionUtil;
import java.util.*;
import com.nec.nsgui.model.biz.base.CmdExecBase;

public class NicListDispatchAction extends DispatchAction {
    private static final String cvsid =
        "@(#) NicListDispatchAction.java,v 1.0 2005/06/21 07:16:49 dengyp Exp";
    /*
     *  the action to getAllNicList
     *  if successful redirect to niclist.jsp
     */
    
    private static boolean showAlert = false;
    public ActionForward getNicList(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);        
        NicHandler nicHandler = new NicHandler();
        Vector nicList = nicHandler.getNicList(0, nodeNo);
        request.setAttribute("nicList", nicList);
        String ignoreList = NicHandler.getIgnoreList(nodeNo);
        request.setAttribute("nic_ignoreList", ignoreList);
        if(showAlert == true){
            request.setAttribute("Alert4PartnerNode", "Alert");
            showAlert = false;
        }
        if (NSActionUtil.isCluster(request)){
            try {
                CmdExecBase.checkClusterStatus();
            }catch (Exception e){
                request.setAttribute("display4maintain", "true");
            }
        }
        return mapping.findForward("listTop");
    }

    /*
     *  the action to get the Admin interface
     *  if successful redirect to nicadminlist.jsp
     */
    public ActionForward getAdminTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NSActionUtil.removeSessionAttribute(request,"selectedInterface");        
        NicHandler nicHandler = new NicHandler();
        Vector adminList = nicHandler.getNicList(1, nodeNo);
        if(adminList != null){
            for(int i=0;i<adminList.size();i++){
                if(((NicInformationBean)adminList.get(i)).getNicName().equals("bond0:0")){
                    ((NicInformationBean)adminList.get(i)).setNicName("FIP");
                }                
            }
        }
        request.setAttribute("adminList", adminList);        
        return mapping.findForward("adminTop");
    }

    /*
     *  the nicDelete fucntion 
     *   to delete the specified interface
     *   if successful redirect to niclist.jsp
     */
    public ActionForward nicDelete(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        String interfaceName = request.getParameter("interfaceName").toString();        
        String ifdel = "";
        if(request.getParameter("ifdel")!=null){
            ifdel = request.getParameter("ifdel").toString();
        }        
        NSActionUtil.setSessionAttribute(
            request,
            "selectedInterface",
            interfaceName);
        NicHandler nicHandler = new NicHandler();
        nicHandler.nicDelete(interfaceName,ifdel,nodeNo); 
        if (NSActionUtil.isCluster(request) && ifdel.equals("-ex")) {
            NicInformationBean interfaceInfoFriend;
            try {
                interfaceInfoFriend = NicHandler.getInterfaceInfo(
                        interfaceName, 1 - nodeNo);
                if(interfaceInfoFriend.getNicName().equals(interfaceName)){
                    showAlert = true;
                }else{
                    NSActionUtil.setSuccess(request);
                }
            } catch (Exception ex) {
                NSActionUtil.setSuccess(request);
            }
        }else{
            NSActionUtil.setSuccess(request);
        }        
        return mapping.findForward("list");
    }  
}