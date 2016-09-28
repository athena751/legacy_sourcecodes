/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.hosts;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.hosts.HostsHandler;
import com.nec.nsgui.model.entity.hosts.HostsInfoBean;

/**
 *Actions for direct edit page
 */
public class HostsInfoDispatchAction
    extends DispatchAction
    implements HostsActionConst, NSActionConst {

    private static final String cvsid =
        "@(#) $Id: HostsInfoDispatchAction.java,v 1.2 2007/05/29 09:25:00 wanghui Exp $";

/*
 *  function: to get Hosts's user setting information.
 *  forward:
 *       recovered and nsadmin login : hostsinfo.jsp.
 *       no recovered or nsview login : hostsinfotop.jsp.
 */
    public ActionForward getHostsInformation(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        int nodeNO = NSActionUtil.getCurrentNodeNo(request);
        Vector hostInfoVec = HostsHandler.getHostsInformation(nodeNO);
        Vector Node0InfoVector = new Vector();
        Vector Node1InfoVector = new Vector();
        String hostsRecovery = "no";
        if (hostInfoVec.size() >= 1) {
            if (((String) hostInfoVec.get(0)).equals(HOSTS_RECOVERED)) {
                hostsRecovery = "yes";
                int NodeNoFlag = 0;
                for (int i = 1; i < hostInfoVec.size(); i++) {
                    try {
                        if (((String) hostInfoVec.get(i))
                            .startsWith(HOSTS_NODE0)) {
                            NodeNoFlag = 0;
                            continue;
                        } else if (
                            ((String) hostInfoVec.get(i)).startsWith(
                                HOSTS_NODE1)) {
                            NodeNoFlag = 1;
                            continue;
                        }
                        String[] strArray =
                            ((String) hostInfoVec.get(i)).split("\t");
                        HostsInfoBean tmpBean = new HostsInfoBean();
                        if (strArray.length == 2) {
                            tmpBean.setIpAddress(strArray[0]);
                            tmpBean.setHost(strArray[1]);
                        } else if (strArray.length == 3) {
                            tmpBean.setIpAddress(strArray[0]);
                            tmpBean.setHost(strArray[1]);
                            tmpBean.setAlias(strArray[2]);
                        }else{
                            continue;
                        }
                        if (NodeNoFlag == 0) {
                            Node0InfoVector.addElement(tmpBean);
                        } else {
                            Node1InfoVector.addElement(tmpBean);
                        }
                    } catch (Exception e) {
                    }
                }
            } else {
                for (int i = 0; i < hostInfoVec.size(); i++) {
                    try {
                        String[] strArray =
                            ((String) hostInfoVec.get(i)).split("\t");
                        HostsInfoBean tmpBean = new HostsInfoBean();
                        if (strArray.length == 2) {
                            tmpBean.setIpAddress(strArray[0]);
                            tmpBean.setHost(strArray[1]);
                        } else if (strArray.length == 3) {
                            tmpBean.setIpAddress(strArray[0]);
                            tmpBean.setHost(strArray[1]);
                            tmpBean.setAlias(strArray[2]);
                        }else{
                            continue;
                        }
                        Node0InfoVector.addElement(tmpBean);
                    } catch (Exception e) {
                    }
                }
            }
        }

        NSActionUtil.setSessionAttribute(
            request,
            "hostsInfoNode0",
            Node0InfoVector);
        NSActionUtil.setSessionAttribute(
            request,
            "hostsInfoNode1",
            Node1InfoVector);
        NSActionUtil.setSessionAttribute(
            request,
            "isHostsRecovery",
            hostsRecovery);
        if (hostsRecovery.equals("no")) {
            String serviceRestart = (String)NSActionUtil.getSessionAttribute(request, 
                    HostsActionConst.SESSION_SERVICERESTART_ERROR);
            if(serviceRestart != null && !serviceRestart.equals("")) {
                NSException ex = new NSException();
                if(serviceRestart.equals("currentnode")){
                    ex.setErrorCode("0x13400004");
                }else{
                    ex.setErrorCode("0x13400005");
                }
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,null);
                throw ex;
            }
            return mapping.findForward("infoTop");
        } else {
            NSActionUtil.setNoFailedAlert(request);
            NSActionUtil.setNotDisplayDetail(request);
            NSException ex = new NSException();
            if(!NSActionUtil.isNsview(request)){          
                ex.setErrorCode("0x13400001");
            }else{
                ex.setErrorCode("0x13400002");
            }            
            throw ex;
        }
    }
    
/*
 *  Function: apply node0's setting.
 *  Forward:  As the getHostsInformation(). 
 */
    public ActionForward applyNode0toNode1(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        HostsHandler.apply(0); 
        try{
            //restart services of node1, and don't need to restart services of node0;
            HostsHandler.restartServices(false, 1);
        }catch(NSException e){
            int nodeNO = NSActionUtil.getCurrentNodeNo(request);
            if (nodeNO == 0) {//when current node is not the node need to change
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,"partnernode");
            } else {//when current node is the node need change
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,"currentnode");
            }
            return getHostsInformation(mapping, form, request, response);
        }       
        NSActionUtil.setSuccess(request);
        return getHostsInformation(mapping, form, request, response);       
    }

    /*
     *  Function: apply node1's setting.
     *  Forward:  As the getHostsInformation(). 
     */
     
    public ActionForward applyNode1toNode0(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        HostsHandler.apply(1);
        try{
            //restart services of node0, and don't need to restart services of node1;
            HostsHandler.restartServices(false, 0);
        }catch(NSException e){
            int nodeNO = NSActionUtil.getCurrentNodeNo(request);
            if (nodeNO == 0) {//when current node is the node need to change
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,"currentnode");
            } else {//when current node is not the node need change
                NSActionUtil.setSessionAttribute(request,HostsActionConst.SESSION_SERVICERESTART_ERROR,"partnernode");
            }
            return getHostsInformation(mapping, form, request, response);
        }        
        NSActionUtil.setSuccess(request);
        return getHostsInformation(mapping, form, request, response);       
    }
}
