/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.hosts;

import org.apache.struts.action.*;
import org.apache.struts.actions.*;


import javax.servlet.http.*;
import java.util.Vector;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.hosts.HostsActionConst;
import com.nec.nsgui.model.biz.hosts.HostsHandler;
import com.nec.nsgui.model.biz.base.NSException;
public final class HostsDirectEditAction extends DispatchAction implements HostsActionConst {

    private static final String cvsid =
        "@(#) $Id: HostsDirectEditAction.java,v 1.2 2007/05/29 09:25:50 wanghui Exp $";
    
    public ActionForward getFileContent(
            ActionMapping mapping,ActionForm form,
            HttpServletRequest request,HttpServletResponse response)
        throws Exception {
        int nodeNum = NSActionUtil.getCurrentNodeNo(request);
        DynaActionForm fileForm = (DynaActionForm)form;
        String fileContent = HostsHandler.readHostsFile(nodeNum);
        fileForm.set("fileContent",fileContent);
        Vector hostInfoVec = HostsHandler.getHostsInformation(nodeNum);
        if(hostInfoVec!=null && hostInfoVec.size()>=1 && ((String)hostInfoVec.get(0)).equals(HostsActionConst.RECOVERED)){
            NSActionUtil.setSessionAttribute(request,SESSION_DIRECTEDIT_DISACCORD,"true");
            NSActionUtil.setNoFailedAlert(request);
            NSActionUtil.setNotDisplayDetail(request);
            NSException ex = new NSException();
            ex.setErrorCode("0x13400003"); 
            throw ex;
        }else{
            String serviceRestart = (String)NSActionUtil.getSessionAttribute(request, 
                    HostsActionConst.SESSION_SERVICERESTART_ERROR);
            if(serviceRestart != null && !serviceRestart.equals("")) {
                NSException ex = new NSException();
                if(serviceRestart.equals("currentnode")){
                    ex.setErrorCode("0x13400006");
                }else{
                    ex.setErrorCode("0x13400007");
                }
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,null);
                throw ex;
            }
            NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_DIRECTEDIT_DISACCORD,"false");
        }
        return (mapping.findForward("listHostsFile"));
    }
    
    public ActionForward setToFile(
            ActionMapping mapping, ActionForm form,
            HttpServletRequest request,HttpServletResponse response)
        throws Exception{
        
        NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_DIRECTEDIT_NOWARNING,"true");
        int nodeNum = NSActionUtil.getCurrentNodeNo(request);
        DynaActionForm fileForm = (DynaActionForm)form;
        String content = (String)fileForm.get("fileContent");
        String result = "";
        try{
            result = HostsHandler.saveHostsFile(nodeNum,content);
            HostsHandler.restartServices(NSActionUtil.isCluster(request), nodeNum);
        }catch(NSException e){
            if(e.getErrorCode().equals(ERRCODE_WRITETO_OTHERNODE_ERROR)){
                
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SYNC_WRITE_FLAG,"error");
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_NODE_NUM,Integer.toString(nodeNum));
                return (mapping.findForward("setSuccess"));
            }else if(e.getErrorCode().equals(ERRCODE_SERVICERESTART_CURRENTNODE_ERROR)){
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,"currentnode");
                return (mapping.findForward("setSuccess"));
            }else if(e.getErrorCode().equals(ERRCODE_SERVICERESTART_PARTNERNODE_ERROR)){
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,"partnernode");
                return (mapping.findForward("setSuccess"));
            }else{
                throw e;
            }
        }
        if(result.equals(SYNC_WRITE_SUCCESS_NOGRARD)){
            NSActionUtil.setSuccess(request);
        }else if(result.equals(SYNC_WRITE_SUCCESS_GUARD)){
            NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SYNC_WRITE_FLAG,"guard");
        }
        return (mapping.findForward("setSuccess"));
        }
    }
