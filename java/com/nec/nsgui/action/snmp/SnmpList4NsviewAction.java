/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.snmp;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.model.biz.base.*;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.snmp.SnmpCmdHandler;
import com.nec.nsgui.model.entity.snmp.SnmpListBean;

/**
 *
 */
public class SnmpList4NsviewAction extends SnmpAction{
    private static final String cvsid = "@(#) $Id: SnmpList4NsviewAction.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
            
    public ActionForward displayList(
            ActionMapping mapping,
            ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        clearSession(request);
        HashMap infoHash = SnmpCmdHandler.getSnmpList(false);
        
        NSException nsep = (NSException) infoHash.get("exception");
        if(nsep != null) {
            String exceptionCode = nsep.getErrorCode();
            if(exceptionCode.equals(ERRCODE_INFORECOVERY) || exceptionCode.equals(ERRCODE_RECOVERYCONVERTFAILED)){
            	nsep.setErrorCode(ERRCODE_INFORECOVERY4NSVIEW);
            }else if(exceptionCode.equals(ERRCODE_CONVERTFAILED) || exceptionCode.equals(ERRCODE_USER) || exceptionCode.equals(ERRCODE_COMMUNITY) || exceptionCode.equals(ERRCODE_COMMUNITY_USER) || exceptionCode.equals(ERRCODE_USER_IPTABLE) || exceptionCode.equals(ERRCODE_COMMUNITY_IPTABLE) || exceptionCode.equals(ERRCODE_COMMUNITY_USER_IPTABLE)){
                nsep.setErrorCode(ERRCODE_COMMON4NSVIEW);
            }
        }
        
        HashMap errorHash = new HashMap();
        errorHash.put(ERRCODE_INFORECOVERY4NSVIEW, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
                for(int i = 0; i < 2; i ++ ){
                    SnmpListBean snmpInfoList = (SnmpListBean)((HashMap)info).get("snmpInfoList"+Integer.toString(i) );
                    NSActionUtil.setSessionAttribute( request,"contact"+snmpInfoList.getNodeNo(),snmpInfoList.getContact() );
                    NSActionUtil.setSessionAttribute( request,"location"+snmpInfoList.getNodeNo(),snmpInfoList.getLocation() );
                    NSActionUtil.setSessionAttribute( request,"communityList"+snmpInfoList.getNodeNo(), snmpInfoList.getCommunityList() );
                    NSActionUtil.setSessionAttribute( request,"userList"+snmpInfoList.getNodeNo(), snmpInfoList.getUserList() );
                }
            }
        });
        
        errorHash.put(ERRCODE_COMMON4NSVIEW, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
                request.setAttribute("contact",SnmpListBean.getContact());
                request.setAttribute("location",SnmpListBean.getLocation());
                request.setAttribute("communityList", SnmpListBean.getCommunityList());
                request.setAttribute("userList", SnmpListBean.getUserList());
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        
        exceptionHandler(request,infoHash,errorHash,new NormalProcessor(){
            public void processNormal(Object info)throws Exception{
                SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
                request.setAttribute("contact",SnmpListBean.getContact());
                request.setAttribute("location",SnmpListBean.getLocation());
                request.setAttribute("communityList", SnmpListBean.getCommunityList());
                request.setAttribute("userList", SnmpListBean.getUserList());
            }
        });
		
        return mapping.findForward("displayList");   
    }
    
}
